import { describe, it, expect } from 'vitest';
import { parseCSV } from '../../src/parser.js';
import { validateRecords } from '../../src/validator.js';
import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const fixturesDir = path.join(__dirname, '..', 'fixtures');

describe('CSV Parser', () => {
  it('should parse valid CSV with bars data', () => {
    const content = fs.readFileSync(path.join(__dirname, '../..', 'bars.csv'), 'utf-8');
    const result = parseCSV(content);
    
    expect(result.records.length).toBe(5);
    expect(result.errors.length).toBe(0);
    expect(result.headers).toContain('Name of Bar/Restaurant');
  });

  it('should handle empty CSV file (no data rows)', () => {
    const content = fs.readFileSync(path.join(fixturesDir, 'empty.csv'), 'utf-8');
    const result = parseCSV(content);
    
    expect(result.records.length).toBe(0);
    expect(result.headers).toContain('Name of Bar/Restaurant');
  });

  it('should handle non-ASCII characters (Icelandic names)', () => {
    const content = fs.readFileSync(path.join(fixturesDir, 'icelandic.csv'), 'utf-8');
    const result = parseCSV(content);
    
    expect(result.records.length).toBe(1);
    expect(result.records[0].fields['Name of Bar/Restaurant']).toBe('Bjórgarðurinn - Íslensku Öl');
    expect(result.records[0].fields['Street']).toBe('Þórunnartún 1');
  });

  it('should detect malformed rows (wrong column count)', () => {
    const content = fs.readFileSync(path.join(fixturesDir, 'malformed.csv'), 'utf-8');
    const result = parseCSV(content);
    
    expect(result.errors.length).toBeGreaterThan(0);
    expect(result.errors[0].message).toContain('columns');
  });
});

describe('Validator', () => {
  it('should validate all bars from real CSV', () => {
    const content = fs.readFileSync(path.join(fixturesDir, '../..', 'bars.csv'), 'utf-8');
    const parseResult = parseCSV(content);
    const { result, validBars } = validateRecords(parseResult.records, parseResult.errors);
    
    expect(result.valid).toBe(true);
    expect(validBars.length).toBe(5);
    expect(result.error_count).toBe(0);
  });

  it('should handle empty CSV gracefully', () => {
    const content = fs.readFileSync(path.join(fixturesDir, 'empty.csv'), 'utf-8');
    const parseResult = parseCSV(content);
    const { result, validBars } = validateRecords(parseResult.records, parseResult.errors);
    
    expect(result.valid).toBe(true);
    expect(validBars.length).toBe(0);
    expect(result.valid_row_count).toBe(0);
  });

  it('should validate Icelandic characters correctly', () => {
    const content = fs.readFileSync(path.join(fixturesDir, 'icelandic.csv'), 'utf-8');
    const parseResult = parseCSV(content);
    const { result, validBars } = validateRecords(parseResult.records, parseResult.errors);
    
    expect(result.valid).toBe(true);
    expect(validBars.length).toBe(1);
    expect(validBars[0].name).toBe('Bjórgarðurinn - Íslensku Öl');
  });

  it('should report errors for malformed rows', () => {
    const content = fs.readFileSync(path.join(fixturesDir, 'malformed.csv'), 'utf-8');
    const parseResult = parseCSV(content);
    const { result } = validateRecords(parseResult.records, parseResult.errors);
    
    expect(result.valid).toBe(false);
    expect(result.error_count).toBeGreaterThan(0);
  });
});
