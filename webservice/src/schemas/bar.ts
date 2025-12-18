import { z } from 'zod';

/**
 * Bar schema - validates a single bar/restaurant record
 * Based on data-model.md and contracts/bar.schema.json
 */
export const barSchema = z.object({
  id: z.number().int().positive(),
  name: z.string().min(1, 'Name is required').max(200, 'Name must be 200 characters or less'),
  email: z.string().email('Invalid email format'),
  street: z.string().min(1, 'Street address is required'),
  latitude: z.number().min(-90, 'Latitude must be between -90 and 90').max(90, 'Latitude must be between -90 and 90'),
  longitude: z.number().min(-180, 'Longitude must be between -180 and 180').max(180, 'Longitude must be between -180 and 180'),
  happy_hour_days: z.string().min(1, 'Happy hour days is required'),
  happy_hour_times: z.string().regex(
    /^\d{2}:\d{2}\s*-\s*\d{2}:\d{2}$/,
    'Times must be in HH:MM - HH:MM format (24-hour)'
  ),
  cheapest_beer_price: z.number().int('Price must be a whole number').nonnegative('Price cannot be negative'),
  cheapest_wine_price: z.number().int('Price must be a whole number').nonnegative('Price cannot be negative'),
  two_for_one: z.boolean(),
  notes: z.string(),
  description: z.string().nullable()
});

export type Bar = z.infer<typeof barSchema>;

/**
 * Input schema for parsing raw CSV values before type coercion
 */
export const barInputSchema = z.object({
  name: z.string(),
  email: z.string(),
  street: z.string(),
  latitude: z.string(),
  longitude: z.string(),
  happy_hour_days: z.string(),
  happy_hour_times: z.string(),
  cheapest_beer_price: z.string(),
  cheapest_wine_price: z.string(),
  two_for_one: z.string(),
  notes: z.string(),
  description: z.string().optional()
});

export type BarInput = z.infer<typeof barInputSchema>;
