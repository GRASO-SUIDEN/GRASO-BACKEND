import { Document } from 'mongoose';

export interface IUser extends Document {
  firstName: string;
  walletAddress: string;
  lastName: string;
  email: string;
  occupation?: string;
  description?: string;
  phoneNumber?: string;
  website?: string;
  password: string;
  profilePicture?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
  comparePassword(candidatePassword: string): Promise<boolean>;
  getPublicProfile(): Omit<IUser, 'password'>;
}

export interface CreateUserDto {
  firstName: string;
  walletAddress: string;
  lastName: string;
  email: string;
  occupation?: string;
  description?: string;
  phoneNumber?: string;
  website?: string;
  password: string;
}

export interface UpdateUserDto {
  firstName?: string;
  walletAddress?: string;
  lastName?: string;
  email?: string;
  occupation?: string;
  description?: string;
  phoneNumber?: string;
  website?: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface ChangePasswordDto {
  oldPassword: string;
  newPassword: string;
}
