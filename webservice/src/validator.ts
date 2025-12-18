import { type CsvRecord, type ParseError } from './parser.js';
import { type Bar, barSchema } from './schemas/bar.js';
import { 
  type ValidationError, 
  createValidationError,
  type ErrorCode 
} from './schemas/validation-error.js';
import { 
  type ValidationResult, 
  createValidationResult 
} from './schemas/validation-result.js';

/** CSV column names mapped to Bar field names */
const FIELD_MAPPING: Record<string, keyof Bar> = {
  'Name of Bar/Restaurant': 'name',
  'Best Contact Email': 'email',
  'Street': 'street',
  'Latitute': 'latitude',
  'Longitute': 'longitude',
  'Happy Hour Days': 'happy_hour_days',
  'Happy Hour Times': 'happy_hour_times',
  'Price Of Cheapest Beer': 'cheapest_beer_price',
  'Price Of Cheapest Wine': 'cheapest_wine_price',
  '2F1?': 'two_for_one',
  'Notes': 'notes',
  'Description for Featured Happy Hour': 'description'
};

/** Required fields that cannot be empty */
const REQUIRED_FIELDS = [
  'Name of Bar/Restaurant',
  'Best Contact Email',
  'Street',
  'Latitute',
  'Longitute',
  'Happy Hour Days',
  'Happy Hour Times',
  'Price Of Cheapest Beer',
  'Price Of Cheapest Wine',
  '2F1?',
  'Notes'
];

/** Human-friendly error messages with fix instructions */
const ERROR_MESSAGES: Record<ErrorCode, { message: string; fix: string }> = {
  MISSING_HEADER: {
    message: 'Required header column is missing',
    fix: 'Ensure the CSV has all required column headers in row 2'
  },
  MISSING_REQUIRED: {
    message: 'Required field is empty',
    fix: 'Fill in this required field with a valid value'
  },
  INVALID_EMAIL: {
    message: 'Invalid email format',
    fix: 'Enter a valid email address like name@example.com'
  },
  INVALID_COORDINATE: {
    message: 'Invalid coordinate value',
    fix: 'Enter a valid number (latitude: -90 to 90, longitude: -180 to 180)'
  },
  INVALID_PRICE: {
    message: 'Invalid price value',
    fix: 'Enter a non-negative whole number (e.g., 500)'
  },
  INVALID_BOOLEAN: {
    message: 'Invalid yes/no value',
    fix: 'Enter either "Yes" or "No"'
  },
  MALFORMED_ROW: {
    message: 'Row has incorrect number of columns',
    fix: 'Check for missing or extra commas, or unquoted commas in values'
  },
  PARSE_ERROR: {
    message: 'CSV parsing error',
    fix: 'Check for unclosed quotes or other CSV formatting issues'
  },
  INVALID_TIME_FORMAT: {
    message: 'Invalid time format',
    fix: 'Enter times in HH:MM - HH:MM format (e.g., 15:00 - 17:00)'
  }
};

export interface ValidateOptions {
  /** Include parse errors in result */
  includeParseErrors?: boolean;
}

export interface ValidateResult {
  result: ValidationResult;
  validBars: Bar[];
}

/**
 * Validate CSV records and return validation result with valid bars
 */
export function validateRecords(
  records: CsvRecord[],
  parseErrors: ParseError[] = [],
  options: ValidateOptions = {}
): ValidateResult {
  const errors: ValidationError[] = [];
  const validBars: Bar[] = [];

  // Convert parse errors to validation errors
  if (options.includeParseErrors !== false) {
    for (const parseError of parseErrors) {
      errors.push(createValidationError(
        parseError.line,
        null,
        'PARSE_ERROR',
        `${ERROR_MESSAGES.PARSE_ERROR.message}: ${parseError.message}`,
        null
      ));
    }
  }

  // Validate each record
  for (const record of records) {
    const rowErrors = validateRecord(record);
    
    if (rowErrors.length === 0) {
      // All validations passed, transform to Bar
      const bar = transformToBar(record, validBars.length + 1);
      if (bar) {
        validBars.push(bar);
      }
    } else {
      errors.push(...rowErrors);
    }
  }

  return {
    result: createValidationResult(errors, validBars.length),
    validBars
  };
}

/**
 * Validate a single CSV record
 */
function validateRecord(record: CsvRecord): ValidationError[] {
  const errors: ValidationError[] = [];
  const { lineNumber, fields } = record;

  // Check required fields
  for (const csvField of REQUIRED_FIELDS) {
    const value = fields[csvField]?.trim() ?? '';
    if (value === '') {
      errors.push(createValidationError(
        lineNumber,
        csvField,
        'MISSING_REQUIRED',
        `${ERROR_MESSAGES.MISSING_REQUIRED.message}: ${csvField}`,
        value || null
      ));
    }
  }

  // Validate email format
  const email = fields['Best Contact Email']?.trim();
  if (email && !validateEmail(email)) {
    errors.push(createValidationError(
      lineNumber,
      'Best Contact Email',
      'INVALID_EMAIL',
      ERROR_MESSAGES.INVALID_EMAIL.message,
      email
    ));
  }

  // Validate coordinates
  const lat = fields['Latitute']?.trim();
  if (lat && !validateLatitude(lat)) {
    errors.push(createValidationError(
      lineNumber,
      'Latitute',
      'INVALID_COORDINATE',
      `${ERROR_MESSAGES.INVALID_COORDINATE.message}: latitude must be between -90 and 90`,
      lat
    ));
  }

  const lng = fields['Longitute']?.trim();
  if (lng && !validateLongitude(lng)) {
    errors.push(createValidationError(
      lineNumber,
      'Longitute',
      'INVALID_COORDINATE',
      `${ERROR_MESSAGES.INVALID_COORDINATE.message}: longitude must be between -180 and 180`,
      lng
    ));
  }

  // Validate prices
  const beerPrice = fields['Price Of Cheapest Beer']?.trim();
  if (beerPrice && !validatePrice(beerPrice)) {
    errors.push(createValidationError(
      lineNumber,
      'Price Of Cheapest Beer',
      'INVALID_PRICE',
      ERROR_MESSAGES.INVALID_PRICE.message,
      beerPrice
    ));
  }

  const winePrice = fields['Price Of Cheapest Wine']?.trim();
  if (winePrice && !validatePrice(winePrice)) {
    errors.push(createValidationError(
      lineNumber,
      'Price Of Cheapest Wine',
      'INVALID_PRICE',
      ERROR_MESSAGES.INVALID_PRICE.message,
      winePrice
    ));
  }

  // Validate boolean field (2F1?)
  const twoForOne = fields['2F1?']?.trim();
  if (twoForOne && !validateBoolean(twoForOne)) {
    errors.push(createValidationError(
      lineNumber,
      '2F1?',
      'INVALID_BOOLEAN',
      ERROR_MESSAGES.INVALID_BOOLEAN.message,
      twoForOne
    ));
  }

  // Validate time format
  const times = fields['Happy Hour Times']?.trim();
  if (times && !validateTimeFormat(times)) {
    errors.push(createValidationError(
      lineNumber,
      'Happy Hour Times',
      'INVALID_TIME_FORMAT',
      ERROR_MESSAGES.INVALID_TIME_FORMAT.message,
      times
    ));
  }

  return errors;
}

/**
 * Transform a valid CSV record to a Bar object
 */
function transformToBar(record: CsvRecord, id: number): Bar | null {
  const { fields } = record;

  try {
    const bar: Bar = {
      id,
      name: fields['Name of Bar/Restaurant']?.trim() ?? '',
      email: fields['Best Contact Email']?.trim() ?? '',
      street: fields['Street']?.trim() ?? '',
      latitude: parseFloat(fields['Latitute']?.trim() ?? '0'),
      longitude: parseFloat(fields['Longitute']?.trim() ?? '0'),
      happy_hour_days: fields['Happy Hour Days']?.trim() ?? '',
      happy_hour_times: fields['Happy Hour Times']?.trim() ?? '',
      cheapest_beer_price: parseInt(fields['Price Of Cheapest Beer']?.trim() ?? '0', 10),
      cheapest_wine_price: parseInt(fields['Price Of Cheapest Wine']?.trim() ?? '0', 10),
      two_for_one: (fields['2F1?']?.trim().toLowerCase() ?? 'no') === 'yes',
      notes: fields['Notes']?.trim() ?? '',
      description: fields['Description for Featured Happy Hour']?.trim() || null
    };

    // Validate against schema
    const result = barSchema.safeParse(bar);
    if (result.success) {
      return result.data;
    }
    return null;
  } catch {
    return null;
  }
}

// Field validators
function validateEmail(email: string): boolean {
  // Basic email regex matching RFC 5322 basic
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

function validateLatitude(lat: string): boolean {
  const num = parseFloat(lat);
  return !isNaN(num) && num >= -90 && num <= 90;
}

function validateLongitude(lng: string): boolean {
  const num = parseFloat(lng);
  return !isNaN(num) && num >= -180 && num <= 180;
}

function validatePrice(price: string): boolean {
  const num = parseInt(price, 10);
  return !isNaN(num) && num >= 0 && Number.isInteger(num);
}

function validateBoolean(value: string): boolean {
  const normalized = value.toLowerCase();
  return normalized === 'yes' || normalized === 'no';
}

function validateTimeFormat(time: string): boolean {
  return /^\d{2}:\d{2}\s*-\s*\d{2}:\d{2}$/.test(time);
}

/**
 * Get error fix instruction for a given error code
 */
export function getErrorFix(code: ErrorCode): string {
  return ERROR_MESSAGES[code]?.fix ?? 'Check the field value and try again';
}
