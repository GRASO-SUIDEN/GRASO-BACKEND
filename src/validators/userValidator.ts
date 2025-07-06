import Joi from 'joi';
import { CreateUserDto, UpdateUserDto, LoginDto, ChangePasswordDto } from '../types/user.types';
// Ensure that UpdateUserDto includes 'walletAddress' property in its definition

export const createUserSchema = Joi.object<CreateUserDto>({
  firstName: Joi.string().required().trim().max(50),
  walletAddress: Joi.string()
    .required()
    .trim()
    .max(66)
    .pattern(/^(0x)?[0-9a-fA-F]{40}$/),
  lastName: Joi.string().required().trim().max(50),
  email: Joi.string().email().required().lowercase().trim(),
  occupation: Joi.string().optional().trim().max(100),
  description: Joi.string().optional().trim().max(500),
  phoneNumber: Joi.string()
    .optional()
    .trim()
    .pattern(/^[\+]?[1-9][\d]{0,15}$/),
  website: Joi.string().optional().trim().uri(),
  password: Joi.string().min(6).required(),
});

export const updateUserSchema = Joi.object<UpdateUserDto>({
  firstName: Joi.string().optional().trim().max(50),
  walletAddress: Joi.string()
    .optional()
    .trim()
    .max(66)
    .pattern(/^(0x)?[0-9a-fA-F]{40}$/),
  lastName: Joi.string().optional().trim().max(50),
  email: Joi.string().email().optional().lowercase().trim(),
  occupation: Joi.string().optional().trim().max(100),
  description: Joi.string().optional().trim().max(500),
  phoneNumber: Joi.string()
    .optional()
    .trim()
    .pattern(/^[\+]?[1-9][\d]{0,15}$/),
  website: Joi.string().optional().trim().uri(),
});

export const loginSchema = Joi.object<LoginDto>({
  email: Joi.string().email().required().lowercase().trim(),
  password: Joi.string().required(),
});

export const changePasswordSchema = Joi.object<ChangePasswordDto>({
  oldPassword: Joi.string().required(),
  newPassword: Joi.string().min(6).required(),
});

export const paginationSchema = Joi.object({
  page: Joi.number().integer().min(1).optional(),
  limit: Joi.number().integer().min(1).max(100).optional(),
  sort: Joi.string().optional(),
  search: Joi.string().optional().trim(),
});
