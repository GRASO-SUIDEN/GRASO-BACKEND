import rateLimit from 'express-rate-limit';
import { config } from '../config/app';

export const createRateLimiter = (windowMs?: number, max?: number) =>
  rateLimit({
    windowMs: windowMs || config.rateLimitWindow,
    max: max || config.rateLimitMax,
    message: {
      success: false,
      message: 'Too many requests from this IP, please try again later.',
    },
    standardHeaders: true,
    legacyHeaders: false,
  });

export const authLimiter = createRateLimiter(15 * 60 * 1000, 5); // 5 requests per 15 minutes
export const generalLimiter = createRateLimiter(); // Default rate limit
