import { parse as csvParse } from 'csv-parse/sync';

export interface CsvRecord {
  /** 1-based line number in the CSV file */
  lineNumber: number;
  /** Raw string values from the CSV row */
  fields: Record<string, string>;
}

export interface ParseResult {
  headers: string[];
  records: CsvRecord[];
  errors: ParseError[];
}

export interface ParseError {
  line: number;
  message: string;
}

/** Expected CSV headers in order (preserving original typos for backward compatibility) */
export const EXPECTED_HEADERS = [
  'Name of Bar/Restaurant',
  'Best Contact Email',
  'Street',
  'Latitute',  // Intentional typo preserved from original CSV
  'Longitute', // Intentional typo preserved from original CSV
  'Happy Hour Days',
  'Happy Hour Times',
  'Price Of Cheapest Beer',
  'Price Of Cheapest Wine',
  '2F1?',
  'Notes',
  'Description for Featured Happy Hour'
] as const;

/**
 * Parse CSV content into structured records with line numbers.
 * The CSV is expected to have:
 * - Row 1: Empty (per bars.csv structure)
 * - Row 2: Headers
 * - Row 3: Empty
 * - Row 4+: Data rows
 * 
 * @param content Raw CSV file content
 * @returns ParseResult with headers, records, and any parse errors
 */
export function parseCSV(content: string): ParseResult {
  const errors: ParseError[] = [];
  const lines = content.split(/\r?\n/);
  
  // Handle empty file
  if (lines.length === 0 || (lines.length === 1 && lines[0].trim() === '')) {
    return { headers: [], records: [], errors: [{ line: 1, message: 'Empty CSV file' }] };
  }

  // Find the header row (row 2, 0-indexed line 1)
  // The CSV structure has empty row 1, headers at row 2, empty row 3, data from row 4
  const headerLineIndex = 1;
  
  if (lines.length < 2) {
    return { headers: [], records: [], errors: [{ line: 1, message: 'CSV file must have at least a header row' }] };
  }

  // Parse headers
  let headers: string[];
  try {
    const headerParsed = csvParse(lines[headerLineIndex], {
      skip_empty_lines: false,
      relax_column_count: true
    }) as string[][];
    
    if (!headerParsed.length || !headerParsed[0].length) {
      return { headers: [], records: [], errors: [{ line: 2, message: 'Header row is empty' }] };
    }
    
    headers = headerParsed[0];
  } catch (e) {
    return { 
      headers: [], 
      records: [], 
      errors: [{ line: 2, message: `Failed to parse header row: ${e instanceof Error ? e.message : 'Unknown error'}` }] 
    };
  }

  // Validate headers match expected
  const headerValidation = validateHeaders(headers);
  if (headerValidation) {
    errors.push({ line: 2, message: headerValidation });
  }

  // Parse data rows (starting from line 4, 0-indexed line 3)
  const records: CsvRecord[] = [];
  
  for (let i = 3; i < lines.length; i++) {
    const line = lines[i];
    const lineNumber = i + 1; // Convert to 1-based
    
    // Skip completely empty lines
    if (line.trim() === '' || line.split(',').every(cell => cell.trim() === '')) {
      continue;
    }

    try {
      const parsed = csvParse(line, {
        skip_empty_lines: false,
        relax_column_count: true
      }) as string[][];
      
      if (parsed.length > 0 && parsed[0].length > 0) {
        const rowData = parsed[0];
        
        // Check column count
        if (rowData.length !== headers.length) {
          errors.push({ 
            line: lineNumber, 
            message: `Row has ${rowData.length} columns, expected ${headers.length}` 
          });
        }

        // Create record with field mapping
        const fields: Record<string, string> = {};
        headers.forEach((header, idx) => {
          fields[header] = rowData[idx] ?? '';
        });

        records.push({ lineNumber, fields });
      }
    } catch (e) {
      errors.push({ 
        line: lineNumber, 
        message: `CSV parse error: ${e instanceof Error ? e.message : 'Unknown error'}` 
      });
    }
  }

  return { headers, records, errors };
}

/**
 * Validate that headers match expected columns
 */
function validateHeaders(headers: string[]): string | null {
  const normalizedHeaders = headers.map(h => h.trim());
  const normalizedExpected = EXPECTED_HEADERS.map(h => h.trim());

  for (const expected of normalizedExpected) {
    if (!normalizedHeaders.includes(expected)) {
      return `Missing required header column: "${expected}"`;
    }
  }

  return null;
}
