import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';
import { ApiResponse } from '../types/api.types';

export const validateBody = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response<ApiResponse>, next: NextFunction): void => {
    const { error } = schema.validate(req.body);

    if (error) {
      res.status(400).json({
        success: false,
        message: error.details[0].message,
      });
      return;
    }

    next();
  };
};

export const validateQuery = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response<ApiResponse>, next: NextFunction): void => {
    const { error } = schema.validate(req.query);

    if (error) {
      res.status(400).json({
        success: false,
        message: error.details[0].message,
      });
      return;
    }

    next();
  };
};
