import mongoose, { Schema, Document } from 'mongoose';
import bcrypt from 'bcryptjs';

// Define the interface for User document
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

// Create the schema
const userSchema = new Schema<IUser>(
  {
    firstName: {
      type: String,
      required: [true, 'First name is required'],
      trim: true,
      maxlength: [50, 'First name cannot exceed 50 characters'],
    },
    walletAddress: {
      type: String,
      required: [true, 'Wallet address is required'],
      trim: true,
      maxlength: [66, 'Wallet address cannot exceed 66 characters'],
      minlength: [66, 'Wallet address cannot be less than 66 characters'],
      // match: [/^0x[a-fA-F0-9]{40}$/, 'Please provide a valid wallet address'],
    },
    lastName: {
      type: String,
      required: [true, 'Last name is required'],
      trim: true,
      maxlength: [50, 'Last name cannot exceed 50 characters'],
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
      match: [/^[^\s@]+@[^\s@]+\.[^\s@]+$/, 'Please provide a valid email address'],
    },
    occupation: {
      type: String,
      trim: true,
      maxlength: [100, 'Occupation cannot exceed 100 characters'],
    },
    description: {
      type: String,
      trim: true,
      maxlength: [500, 'Description cannot exceed 500 characters'],
    },
    phoneNumber: {
      type: String,
      trim: true,
      match: [/^[\+]?[1-9][\d]{0,15}$/, 'Please provide a valid phone number'],
    },
    website: {
      type: String,
      trim: true,
      match: [/^https?:\/\/.+/, 'Please provide a valid website URL'],
    },
    password: {
      type: String,
      required: [true, 'Password is required'],
      minlength: [6, 'Password must be at least 6 characters long'],
      select: false,
    },
    profilePicture: {
      type: String,
      default: null,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// Hash password before saving
userSchema.pre('save', async function (next) {
  // Only hash the password if it has been modified (or is new)
  if (!this.isModified('password')) return next();

  try {
    const salt = await bcrypt.genSalt(12);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error as Error);
  }
});

// Method to compare password - using function declaration to avoid TypeScript issues
userSchema.methods.comparePassword = function (candidatePassword: string): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

// Method to get public profile - using function declaration
userSchema.methods.getPublicProfile = function () {
  const userObject = this.toObject();
  delete userObject.password;
  return userObject;
};

// Create indexes for better performance
userSchema.index({ email: 1 });
userSchema.index({ isActive: 1 });
userSchema.index({ createdAt: -1 });

// Text search index for search functionality
userSchema.index({
  firstName: 'text',
  walletAddress: 'text',
  lastName: 'text',
  email: 'text',
  occupation: 'text',
  description: 'text',
});

// Create and export the model
export const User = mongoose.model<IUser>('User', userSchema);

// Default export for easier importing
export default User;
