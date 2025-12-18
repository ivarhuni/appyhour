import { z } from 'zod';

/** Error codes matching validation-error.schema.json */
export type ErrorCode = 
  | 'MISSING_HEADER'
  | 'MISSING_REQUIRED'
  | 'INVALID_EMAIL'
  | 'INVALID_COORDINATE'
  | 'INVALID_PRICE'
  | 'INVALID_BOOLEAN'
  | 'MALFORMED_ROW'
  | 'PARSE_ERROR'
  | 'INVALID_TIME_FORMAT';

/**
 * ValidationError schema - represents a single validation error
 * Based on contracts/validation-error.schema.json
 */
export const validationErrorSchema = z.object({
  line: z.number().int().positive(),
  field: z.string().nullable(),
  code: z.enum([
    'MISSING_HEADER',
    'MISSING_REQUIRED',
    'INVALID_EMAIL',
    'INVALID_COORDINATE',
    'INVALID_PRICE',
    'INVALID_BOOLEAN',
    'MALFORMED_ROW',
    'PARSE_ERROR',
    'INVALID_TIME_FORMAT'
  ]),
  message: z.string(),
  value: z.string().nullable()
});

export type ValidationError = z.infer<typeof validationErrorSchema>;

/**
 * Create a validation error object
 */
export function createValidationError(
  line: number,
  field: string | null,
  code: ErrorCode,
  message: string,
  value: string | null = null
): ValidationError {
  return { line, field, code, message, value };
}
