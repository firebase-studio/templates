import { z } from 'zod';

export const HNItemSchema = z.object({
  id: z.number(),
  title: z.string(),
  points: z.number().nullable(),
  user: z.string().nullable(),
  time: z.number(),
  time_ago: z.string(),
  comments_count: z.number(),
  type: z.string(),
  url: z.string(),
  domain: z.string().optional(),
});

export const HNItemsSchema = z.array(HNItemSchema);
