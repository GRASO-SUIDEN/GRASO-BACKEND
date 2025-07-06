import { Request, Response, NextFunction } from 'express';
import path from 'path';
import fs from 'fs';
import { userService } from '../services/userService';
import { ApiResponse, PaginationQuery } from '../types/api.types';
import { CreateUserDto, UpdateUserDto, LoginDto, ChangePasswordDto } from '../types/user.types';
import { logger } from '../config/logger';

export class UserController {
  async register(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
    try {
      const userData: CreateUserDto = req.body;
      const user = await userService.createUser(userData);

      res.status(201).json({
        success: true,
        message: 'User created successfully',
        data: user.getPublicProfile(),
      });
    } catch (error) {
      next(error);
    }
  }

  async login(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
    try {
      const { email, password }: LoginDto = req.body;

      const user = await userService.getUserByEmail(email);
      if (!user) {
        res.status(401).json({
          success: false,
          message: 'Invalid credentials',
        });
        return;
      }

      const isValidPassword = await user.comparePassword(password);
      if (!isValidPassword) {
        res.status(401).json({
          success: false,
          message: 'Invalid credentials',
        });
        return;
      }

      res.json({
        success: true,
        message: 'Login successful',
        data: user.getPublicProfile(),
      });
    } catch (error) {
      next(error);
    }
  }

  async getProfile(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const user = await userService.getUserById(id);

      if (!user) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        });
        return;
      }

      res.json({
        success: true,
        message: 'User profile fetched successfully',
        data: user.getPublicProfile(),
      });
    } catch (error) {
      next(error);
    }
  }

  async getAllUsers(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
    try {
      const query: PaginationQuery = req.query;
      const result = await userService.getAllUsers(query);

      res.json({
        success: true,
        message: 'Users fetched successfully',
        data: result.data.map((user) => user.getPublicProfile()),
        ...result.pagination,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateProfile(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const updateData: UpdateUserDto = req.body;

      const updatedUser = await userService.updateUser(id, updateData);

      if (!updatedUser) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        });
        return;
      }

      res.json({
        success: true,
        message: 'Profile updated successfully',
        data: updatedUser.getPublicProfile(),
      });
    } catch (error) {
      next(error);
    }
  }

  async changePassword(
    req: Request,
    res: Response<ApiResponse>,
    next: NextFunction
  ): Promise<void> {
    try {
      const { id } = req.params;
      const { oldPassword, newPassword }: ChangePasswordDto = req.body;

      const user = await userService.getUserByEmail(''); // Get user with password
      const userWithPassword = await userService.getUserById(id);

      if (!userWithPassword) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        });
        return;
      }

      // We need to get user with password field
      const userWithPass = await userService.getUserByEmail(userWithPassword.email);
      if (!userWithPass) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        });
        return;
      }

      const isValidPassword = await userWithPass.comparePassword(oldPassword);
      if (!isValidPassword) {
        res.status(400).json({
          success: false,
          message: 'Current password is incorrect',
        });
        return;
      }

      await userService.changePassword(id, newPassword);

      res.json({
        success: true,
        message: 'Password updated successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  async uploadProfilePicture(
    req: Request,
    res: Response<ApiResponse>,
    next: NextFunction
  ): Promise<void> {
    try {
      if (!req.file) {
        res.status(400).json({
          success: false,
          message: 'No file uploaded',
        });
        return;
      }

      const { id } = req.params;
      const user = await userService.getUserById(id);

      if (!user) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        });
        return;
      }

      // Delete old profile picture if it exists
      if (user.profilePicture) {
        const oldPicturePath = path.join(process.cwd(), user.profilePicture);
        if (fs.existsSync(oldPicturePath)) {
          fs.unlinkSync(oldPicturePath);
        }
      }

      const profilePicturePath = `/uploads/profiles/${req.file.filename}`;
      const updatedUser = await userService.updateProfilePicture(id, profilePicturePath);

      res.json({
        success: true,
        message: 'Profile picture updated successfully',
        data: {
          profilePicture: profilePicturePath,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  async deleteAccount(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const user = await userService.getUserById(id);

      if (!user) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        });
        return;
      }

      // Delete profile picture if it exists
      if (user.profilePicture) {
        const picturePath = path.join(process.cwd(), user.profilePicture);
        if (fs.existsSync(picturePath)) {
          fs.unlinkSync(picturePath);
        }
      }

      await userService.deleteUser(id);

      res.json({
        success: true,
        message: 'User account deleted successfully',
      });
    } catch (error) {
      next(error);
    }
  }
}

export const userController = new UserController();
