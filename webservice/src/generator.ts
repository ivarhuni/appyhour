import * as fs from 'node:fs';
import * as path from 'node:path';
import { type Bar } from './schemas/bar.js';

/**
 * BarsCollection - the format for /data/bars.json
 */
export interface BarsCollection {
  generated_at: string;
  count: number;
  bars: Bar[];
}

/**
 * Generate JSON files from validated bars
 * - /data/bars.json - all bars collection
 * - /data/bars/{n}.json - individual bar files
 */
export function generateJSON(bars: Bar[], outputDir: string): void {
  // Ensure directories exist
  const barsDir = path.join(outputDir, 'bars');
  fs.mkdirSync(outputDir, { recursive: true });
  fs.mkdirSync(barsDir, { recursive: true });

  // Generate bars.json collection
  const collection: BarsCollection = {
    generated_at: new Date().toISOString(),
    count: bars.length,
    bars: bars.sort((a, b) => a.id - b.id) // Sort by ID for deterministic output
  };

  fs.writeFileSync(
    path.join(outputDir, 'bars.json'),
    JSON.stringify(collection, null, 2),
    'utf-8'
  );

  // Generate individual bar files
  for (const bar of bars) {
    fs.writeFileSync(
      path.join(barsDir, `${bar.id}.json`),
      JSON.stringify(bar, null, 2),
      'utf-8'
    );
  }
}

/**
 * Generate bars.json content without writing to disk
 */
export function generateBarsJSON(bars: Bar[]): string {
  const collection: BarsCollection = {
    generated_at: new Date().toISOString(),
    count: bars.length,
    bars: bars.sort((a, b) => a.id - b.id)
  };
  return JSON.stringify(collection, null, 2);
}
