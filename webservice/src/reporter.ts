import { type ValidationResult } from './schemas/validation-result.js';
import { type ErrorCode } from './schemas/validation-error.js';

/**
 * Human-friendly fix instructions for each error code
 */
const FIX_INSTRUCTIONS: Record<string, string> = {
  MISSING_HEADER: 'Ensure the CSV has all required column headers in row 2',
  MISSING_REQUIRED: 'Fill in this required field with a valid value',
  INVALID_EMAIL: 'Enter a valid email address like name@example.com',
  INVALID_COORDINATE: 'Enter a valid number (latitude: -90 to 90, longitude: -180 to 180)',
  INVALID_PRICE: 'Enter a non-negative whole number (e.g., 500)',
  INVALID_BOOLEAN: 'Enter either "Yes" or "No"',
  MALFORMED_ROW: 'Check for missing or extra commas, or unquoted commas in values',
  PARSE_ERROR: 'Check for unclosed quotes or other CSV formatting issues',
  INVALID_TIME_FORMAT: 'Enter times in HH:MM - HH:MM format (e.g., 15:00 - 17:00)'
};

/**
 * Generate JSON error report
 */
export function generateErrorReport(result: ValidationResult): string {
  return JSON.stringify(result, null, 2);
}

/**
 * Generate HTML error report for human readability
 */
export function generateHTMLReport(result: ValidationResult): string {
  const statusEmoji = result.valid ? '✅' : '❌';
  const statusText = result.valid ? 'All Clear!' : `${result.error_count} Error${result.error_count !== 1 ? 's' : ''} Found`;
  
  const errorsHtml = result.errors.length > 0 
    ? `
    <table>
      <thead>
        <tr>
          <th>Line</th>
          <th>Field</th>
          <th>Error</th>
          <th>Value</th>
          <th>How to Fix</th>
        </tr>
      </thead>
      <tbody>
        ${result.errors.map(error => `
        <tr>
          <td>${error.line}</td>
          <td>${error.field ?? '—'}</td>
          <td><code>${error.code}</code><br>${escapeHtml(error.message)}</td>
          <td><code>${escapeHtml(error.value ?? '—')}</code></td>
          <td>${FIX_INSTRUCTIONS[error.code] ?? 'Check the field value'}</td>
        </tr>`).join('')}
      </tbody>
    </table>`
    : '<p class="success">No errors found! 🎉</p>';

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CSV Validation Results</title>
  <style>
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
      background: #f5f5f5;
      color: #333;
    }
    h1 { margin-top: 0; }
    .status {
      padding: 1rem;
      border-radius: 8px;
      margin-bottom: 2rem;
      font-size: 1.25rem;
    }
    .status.valid { background: #d4edda; color: #155724; }
    .status.invalid { background: #f8d7da; color: #721c24; }
    .summary { margin-bottom: 1rem; color: #666; }
    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 0.75rem;
      text-align: left;
      border-bottom: 1px solid #eee;
    }
    th { background: #f8f9fa; font-weight: 600; }
    tr:last-child td { border-bottom: none; }
    tr:hover { background: #f8f9fa; }
    code {
      background: #e9ecef;
      padding: 0.2rem 0.4rem;
      border-radius: 4px;
      font-size: 0.9em;
    }
    .success {
      text-align: center;
      padding: 2rem;
      background: white;
      border-radius: 8px;
      font-size: 1.25rem;
    }
    .timestamp { color: #999; font-size: 0.875rem; }
  </style>
</head>
<body>
  <h1>🍺 Happy Hour CSV Validation</h1>
  
  <div class="status ${result.valid ? 'valid' : 'invalid'}">
    ${statusEmoji} ${statusText}
  </div>
  
  <p class="summary">
    <strong>${result.valid_row_count}</strong> valid bar${result.valid_row_count !== 1 ? 's' : ''} • 
    <strong>${result.error_count}</strong> error${result.error_count !== 1 ? 's' : ''}
  </p>
  
  ${errorsHtml}
  
  <p class="timestamp">Generated: ${result.generated_at}</p>
</body>
</html>`;
}

/**
 * Escape HTML special characters
 */
function escapeHtml(str: string): string {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}
