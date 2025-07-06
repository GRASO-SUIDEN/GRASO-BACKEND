import { User } from '../models/User';
import { CreateUserDto, UpdateUserDto, IUser } from '../types/user.types';
import { PaginationQuery, PaginationResponse } from '../types/api.types';
import { logger } from '../config/logger';
export class UserService {
  async createUser(userData: CreateUserDto): Promise<IUser> {
    try {
      const existingUser = await User.findOne({ email: userData.email });
      if (existingUser) {
        throw new Error('User with this email already exists');
      }

      const user = new User(userData);
      await user.save();
      return user;
    } catch (error) {
      logger.error('Error creating user:', error);
      throw error;
    }
  }

  async getUserById(id: string): Promise<IUser | null> {
    try {
      return await User.findById(id);
    } catch (error) {
      logger.error('Error fetching user by ID:', error);
      throw error;
    }
  }

  async getUserByEmail(email: string): Promise<IUser | null> {
    try {
      return await User.findOne({ email }).select('+password').lean();
    } catch (error) {
      logger.error('Error fetching user by email:', error);
      throw error;
    }
  }

  async getAllUsers(query: PaginationQuery): Promise<PaginationResponse<IUser>> {
    try {
      const { page = 1, limit = 10, sort = '-createdAt', search } = query;
      const skip = (page - 1) * limit;

      let filter: any = { isActive: true };
      if (search) {
        filter = {
          ...filter,
          $or: [
            { firstName: { $regex: search, $options: 'i' } },
            { lastName: { $regex: search, $options: 'i' } },
            { email: { $regex: search, $options: 'i' } },
            { occupation: { $regex: search, $options: 'i' } },
          ],
        };
      }

      const [users, total] = await Promise.all([
        User.find(filter).skip(skip).limit(limit).sort(sort),
        User.countDocuments(filter),
      ]);

      const pages = Math.ceil(total / limit);

      return {
        data: users,
        pagination: {
          page,
          limit,
          total,
          pages,
          hasNext: page < pages,
          hasPrev: page > 1,
        },
      };
    } catch (error) {
      logger.error('Error fetching users:', error);
      throw error;
    }
  }

  async updateUser(id: string, updateData: UpdateUserDto): Promise<IUser | null> {
    try {
      if (updateData.email) {
        const existingUser = await User.findOne({
          email: updateData.email,
          _id: { $ne: id },
        });
        if (existingUser) {
          throw new Error('Email is already in use by another user');
        }
      }

      return await User.findByIdAndUpdate(id, updateData, {
        new: true,
        runValidators: true,
      });
    } catch (error) {
      logger.error('Error updating user:', error);
      throw error;
    }
  }

  async updateProfilePicture(id: string, profilePicture: string): Promise<IUser | null> {
    try {
      return await User.findByIdAndUpdate(
        id,
        { profilePicture },
        { new: true, runValidators: true }
      );
    } catch (error) {
      logger.error('Error updating profile picture:', error);
      throw error;
    }
  }

  async changePassword(id: string, newPassword: string): Promise<void> {
    try {
      const user = await User.findById(id).select('+password');
      if (!user) {
        throw new Error('User not found');
      }

      user.password = newPassword;
      await user.save();
    } catch (error) {
      logger.error('Error changing password:', error);
      throw error;
    }
  }

  async deleteUser(id: string): Promise<void> {
    try {
      await User.findByIdAndDelete(id);
    } catch (error) {
      logger.error('Error deleting user:', error);
      throw error;
    }
  }
}

export const userService = new UserService();
