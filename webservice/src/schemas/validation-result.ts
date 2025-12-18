import { z } from 'zod';
import { validationErrorSchema, type ValidationError } from './validation-error.js';

/**
 * ValidationResult schema - aggregated validation result
 * Based on contracts/validation-result.schema.json
 */
export const validationResultSchema = z.object({
  generated_at: z.string().datetime(),
  valid: z.boolean(),
  error_count: z.number().int().nonnegative(),
  valid_row_count: z.number().int().nonnegative(),
  errors: z.array(validationErrorSchema)
});

export type ValidationResult = z.infer<typeof validationResultSchema>;

/**
 * Create a validation result object
 */
export function createValidationResult(
  errors: ValidationError[],
  validRowCount: number
): ValidationResult {
  return {
    generated_at: new Date().toISOString(),
    valid: errors.length === 0,
    error_count: errors.length,
    valid_row_count: validRowCount,
    errors
  };
}
