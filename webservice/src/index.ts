#!/usr/bin/env node

import * as fs from 'node:fs';
import * as path from 'node:path';
import { parseCSV } from './parser.js';
import { validateRecords, getErrorFix } from './validator.js';
import { generateJSON } from './generator.js';
import { generateErrorReport, generateHTMLReport } from './reporter.js';

const WEBSERVICE_DIR = path.dirname(new URL(import.meta.url).pathname);
const ROOT_DIR = path.resolve(WEBSERVICE_DIR, '..');
const CSV_PATH = path.join(ROOT_DIR, 'bars.csv');
const OUTPUT_DIR = path.join(ROOT_DIR, 'public');
const STATIC_DIR = path.join(ROOT_DIR, 'static');

interface RunOptions {
  csvPath?: string;
  outputDir?: string;
}

/**
 * Main CLI entry point
 */
async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const command = args[0] ?? 'build';

  console.log(`🍺 Happy Hour CSV Pipeline`);
  console.log(`   Command: ${command}`);
  console.log('');

  switch (command) {
    case 'validate':
      await runValidate();
      break;
    case 'generate':
      await runGenerate();
      break;
    case 'build':
      await runBuild();
      break;
    default:
      console.error(`Unknown command: ${command}`);
      console.log('Usage: npm run [validate|generate|build]');
      process.exit(1);
  }
}

/**
 * Validate CSV and output results to console
 */
async function runValidate(options: RunOptions = {}): Promise<boolean> {
  const csvPath = options.csvPath ?? CSV_PATH;
  
  console.log(`📄 Reading: ${csvPath}`);
  
  if (!fs.existsSync(csvPath)) {
    console.error(`❌ CSV file not found: ${csvPath}`);
    process.exit(1);
  }

  const content = fs.readFileSync(csvPath, 'utf-8');
  const parseResult = parseCSV(content);
  
  console.log(`📊 Parsed ${parseResult.records.length} data rows`);

  const { result, validBars } = validateRecords(
    parseResult.records, 
    parseResult.errors,
    { includeParseErrors: true }
  );

  // Output summary
  console.log('');
  if (result.valid) {
    console.log(`✅ Validation PASSED`);
    console.log(`   ${validBars.length} valid bars`);
  } else {
    console.log(`❌ Validation FAILED`);
    console.log(`   ${result.error_count} errors found`);
    console.log(`   ${validBars.length} valid bars`);
    console.log('');
    console.log('Errors:');
    for (const error of result.errors) {
      const fieldInfo = error.field ? ` [${error.field}]` : '';
      console.log(`  Line ${error.line}${fieldInfo}: ${error.message}`);
      console.log(`    💡 Fix: ${getErrorFix(error.code as any)}`);
    }
  }

  return result.valid;
}

/**
 * Generate JSON output from CSV
 */
async function runGenerate(options: RunOptions = {}): Promise<void> {
  const csvPath = options.csvPath ?? CSV_PATH;
  const outputDir = options.outputDir ?? OUTPUT_DIR;
  
  console.log(`📄 Reading: ${csvPath}`);
  
  if (!fs.existsSync(csvPath)) {
    console.error(`❌ CSV file not found: ${csvPath}`);
    process.exit(1);
  }

  const content = fs.readFileSync(csvPath, 'utf-8');
  const parseResult = parseCSV(content);
  const { result, validBars } = validateRecords(
    parseResult.records, 
    parseResult.errors,
    { includeParseErrors: true }
  );

  // Always generate error report
  console.log(`📝 Generating error report...`);
  const errorsDir = path.join(outputDir, 'errors');
  fs.mkdirSync(errorsDir, { recursive: true });
  
  const errorJson = generateErrorReport(result);
  fs.writeFileSync(path.join(errorsDir, 'errors.json'), errorJson, 'utf-8');
  
  const errorHtml = generateHTMLReport(result);
  fs.writeFileSync(path.join(errorsDir, 'index.html'), errorHtml, 'utf-8');
  console.log(`   ✓ ${errorsDir}/`);

  // Generate JSON data if we have valid bars
  if (validBars.length > 0) {
    console.log(`📦 Generating JSON data...`);
    const dataDir = path.join(outputDir, 'data');
    generateJSON(validBars, dataDir);
    console.log(`   ✓ ${dataDir}/bars.json`);
    console.log(`   ✓ ${dataDir}/bars/*.json (${validBars.length} files)`);
  } else {
    console.log(`⚠️  No valid bars to generate`);
  }

  // Copy static files
  console.log(`📁 Copying static files...`);
  copyStaticFiles(STATIC_DIR, outputDir);
}

/**
 * Copy static files from static/ to output directory
 */
function copyStaticFiles(srcDir: string, destDir: string): void {
  if (!fs.existsSync(srcDir)) {
    return;
  }
  
  const files = fs.readdirSync(srcDir);
  for (const file of files) {
    const srcPath = path.join(srcDir, file);
    const destPath = path.join(destDir, file);
    const stat = fs.statSync(srcPath);
    
    if (stat.isDirectory()) {
      fs.mkdirSync(destPath, { recursive: true });
      copyStaticFiles(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
      console.log(`   ✓ ${file}`);
    }
  }
}

/**
 * Full build: validate + generate
 */
async function runBuild(): Promise<void> {
  const isValid = await runValidate();
  console.log('');
  await runGenerate();

  // Exit with error if validation failed
  if (!isValid) {
    console.log('');
    console.log('⚠️  Build completed with validation errors');
    console.log('   Error report published to /errors/');
    process.exit(1);
  }

  console.log('');
  console.log('✨ Build completed successfully!');
}

// Run main
main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
