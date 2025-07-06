#!/bin/bash

# TypeScript Profile Settings API Setup Script
# This script creates a complete Express.js API project structure with TypeScript

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${PURPLE}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=====================================#{NC}"
    echo -e "${BLUE}  TypeScript Profile Settings API${NC}"
    echo -e "${BLUE}=====================================#{NC}"
}

# Check if Node.js and TypeScript are installed
check_prerequisites() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    print_message "Node.js and npm are installed ✓"
}

# Create project directory structure following best practices
create_project_structure() {
    local project_name="profile-settings-api"
    
    if [ $# -eq 1 ]; then
        project_name=$1
    fi
    
    print_message "Creating project directory: $project_name"
    
    if [ -d "$project_name" ]; then
        print_warning "Directory $project_name already exists. Do you want to continue? (y/n)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_message "Setup cancelled."
            exit 0
        fi
    fi
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Create comprehensive directory structure
    mkdir -p {src/{config,controllers,middleware,models,routes,types,utils,services,validators},dist,uploads/{profiles,temp},tests/{unit,integration,fixtures},docs,scripts,logs}
    
    print_message "Project structure created ✓"
}

# Initialize npm project with TypeScript
init_npm_project() {
    print_message "Initializing npm project with TypeScript..."
    
    cat > package.json << 'EOF'
{
  "name": "profile-settings-api",
  "version": "1.0.0",
  "description": "TypeScript Profile Settings API with Express.js and MongoDB",
  "main": "dist/server.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/server.js",
    "dev": "ts-node-dev --respawn --transpile-only src/server.ts",
    "dev:debug": "ts-node-dev --inspect --respawn --transpile-only src/server.ts",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/**/*.ts",
    "lint:fix": "eslint src/**/*.ts --fix",
    "format": "prettier --write src/**/*.ts",
    "type-check": "tsc --noEmit",
    "seed": "ts-node src/scripts/seed.ts",
    "clean": "rimraf dist",
    "prebuild": "npm run clean && npm run lint",
    "docker:build": "docker build -t profile-api .",
    "docker:run": "docker-compose up -d"
  },
  "keywords": ["typescript", "express", "mongodb", "api", "profile", "crud"],
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.0.3",
    "bcryptjs": "^2.4.3",
    "multer": "^1.4.5-lts.1",
    "cors": "^2.8.5",
    "dotenv": "^16.0.3",
    "helmet": "^6.1.5",
    "express-rate-limit": "^6.7.0",
    "joi": "^17.9.1",
    "jsonwebtoken": "^9.0.0",
    "morgan": "^1.10.0",
    "compression": "^1.7.4",
    "express-validator": "^6.15.0",
    "winston": "^3.8.2",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.0",
    "reflect-metadata": "^0.1.13"
  },
  "devDependencies": {
    "@types/node": "^18.15.11",
    "@types/express": "^4.17.17",
    "@types/bcryptjs": "^2.4.2",
    "@types/multer": "^1.4.7",
    "@types/cors": "^2.8.13",
    "@types/joi": "^17.2.3",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/morgan": "^1.9.4",
    "@types/compression": "^1.7.2",
    "@types/jest": "^29.5.1",
    "@types/supertest": "^2.0.12",
    "typescript": "^5.0.4",
    "ts-node": "^10.9.1",
    "ts-node-dev": "^2.0.0",
    "jest": "^29.5.0",
    "ts-jest": "^29.1.0",
    "supertest": "^6.3.3",
    "eslint": "^8.39.0",
    "@typescript-eslint/eslint-plugin": "^5.59.0",
    "@typescript-eslint/parser": "^5.59.0",
    "prettier": "^2.8.8",
    "rimraf": "^5.0.0",
    "nodemon": "^2.0.22"
  },
  "engines": {
    "node": ">=16.0.0",
    "npm": ">=8.0.0"
  }
}
EOF
    
    print_message "package.json created ✓"
}

# Create TypeScript configuration
create_typescript_config() {
    print_message "Creating TypeScript configuration..."
    
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noImplicitThis": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "allowSyntheticDefaultImports": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "baseUrl": "./src",
    "paths": {
      "@/*": ["*"],
      "@/config/*": ["config/*"],
      "@/controllers/*": ["controllers/*"],
      "@/middleware/*": ["middleware/*"],
      "@/models/*": ["models/*"],
      "@/routes/*": ["routes/*"],
      "@/types/*": ["types/*"],
      "@/utils/*": ["utils/*"],
      "@/services/*": ["services/*"],
      "@/validators/*": ["validators/*"]
    }
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "tests"
  ]
}
EOF
    
    # TypeScript config for tests
    cat > tsconfig.test.json << 'EOF'
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "types": ["jest", "node"]
  },
  "include": [
    "src/**/*",
    "tests/**/*"
  ]
}
EOF
    
    print_message "TypeScript configuration created ✓"
}

# Create ESLint and Prettier configuration
create_linting_config() {
    print_message "Creating linting and formatting configuration..."
    
    cat > .eslintrc.js << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    project: './tsconfig.json',
  },
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    '@typescript-eslint/recommended-requiring-type-checking',
  ],
  rules: {
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/no-unsafe-assignment': 'warn',
    '@typescript-eslint/no-unsafe-member-access': 'warn',
    '@typescript-eslint/no-unsafe-call': 'warn',
    'prefer-const': 'error',
    'no-var': 'error',
  },
  env: {
    node: true,
    es6: true,
  },
};
EOF
    
    cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false
}
EOF
    
    cat > .eslintignore << 'EOF'
dist/
node_modules/
coverage/
*.js
EOF
    
    print_message "Linting configuration created ✓"
}

# Create types definitions
create_types() {
    print_message "Creating TypeScript type definitions..."
    
    cat > src/types/user.types.ts << 'EOF'
import { Document } from 'mongoose';

export interface IUser extends Document {
  firstName: string;
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
EOF
    
    cat > src/types/api.types.ts << 'EOF'
export interface ApiResponse<T = any> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
}

export interface PaginationQuery {
  page?: number;
  limit?: number;
  sort?: string;
  search?: string;
}

export interface PaginationResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    pages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}
EOF
    
    cat > src/types/express.types.ts << 'EOF'
import { Request } from 'express';
import { IUser } from './user.types';

export interface AuthenticatedRequest extends Request {
  user?: IUser;
}
EOF
    
    cat > src/types/index.ts << 'EOF'
export * from './user.types';
export * from './api.types';
export * from './express.types';
EOF
    
    print_message "Type definitions created ✓"
}

# Create database configuration
create_config() {
    print_message "Creating configuration files..."
    
    cat > src/config/database.ts << 'EOF'
import mongoose from 'mongoose';
import { logger } from './logger';

export const connectDatabase = async (): Promise<void> => {
  try {
    const mongoUri = process.env.MONGODB_URI || 'mongodb://localhost:27017/profile_db';
    
    await mongoose.connect(mongoUri, {
      bufferCommands: false,
    });
    
    logger.info(`MongoDB Connected: ${mongoose.connection.host}`);
  } catch (error) {
    logger.error('Database connection error:', error);
    process.exit(1);
  }
};

export const disconnectDatabase = async (): Promise<void> => {
  try {
    await mongoose.disconnect();
    logger.info('MongoDB Disconnected');
  } catch (error) {
    logger.error('Database disconnection error:', error);
  }
};

// Handle connection events
mongoose.connection.on('connected', () => {
  logger.info('Mongoose connected to MongoDB');
});

mongoose.connection.on('error', (err) => {
  logger.error('Mongoose connection error:', err);
});

mongoose.connection.on('disconnected', () => {
  logger.info('Mongoose disconnected');
});

// Close connection on app termination
process.on('SIGINT', async () => {
  await disconnectDatabase();
  process.exit(0);
});
EOF
    
    cat > src/config/logger.ts << 'EOF'
import winston from 'winston';
import path from 'path';

const logFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.json()
);

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: logFormat,
  defaultMeta: { service: 'profile-api' },
  transports: [
    new winston.transports.File({
      filename: path.join('logs', 'error.log'),
      level: 'error',
    }),
    new winston.transports.File({
      filename: path.join('logs', 'combined.log'),
    }),
  ],
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    })
  );
}
EOF
    
    cat > src/config/app.ts << 'EOF'
export const config = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  mongoUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/profile_db',
  jwtSecret: process.env.JWT_SECRET || 'your-super-secret-jwt-key',
  jwtExpire: process.env.JWT_EXPIRE || '30d',
  bcryptRounds: 12,
  maxFileSize: 5 * 1024 * 1024, // 5MB
  allowedImageTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
  rateLimitWindow: 15 * 60 * 1000, // 15 minutes
  rateLimitMax: 100, // requests per window
};
EOF
    
    print_message "Configuration files created ✓"
}

# Create User model with TypeScript
create_user_model() {
    print_message "Creating User model..."
    
    cat > src/models/User.ts << 'EOF'
import mongoose, { Schema } from 'mongoose';
import bcrypt from 'bcryptjs';
import { IUser } from '@/types/user.types';
import { config } from '@/config/app';

const userSchema = new Schema<IUser>(
  {
    firstName: {
      type: String,
      required: [true, 'First name is required'],
      trim: true,
      maxlength: [50, 'First name cannot exceed 50 characters'],
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
  if (!this.isModified('password')) return next();

  try {
    const salt = await bcrypt.genSalt(config.bcryptRounds);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error as Error);
  }
});

// Method to compare password
userSchema.methods.comparePassword = async function (
  candidatePassword: string
): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

// Method to get public profile
userSchema.methods.getPublicProfile = function () {
  const userObject = this.toObject();
  delete userObject.password;
  return userObject;
};

// Index for performance
userSchema.index({ email: 1 });
userSchema.index({ isActive: 1 });

export const User = mongoose.model<IUser>('User', userSchema);
EOF
    
    print_message "User model created ✓"
}

# Create services layer
create_services() {
    print_message "Creating services layer..."
    
    cat > src/services/userService.ts << 'EOF'
import { User } from '@/models/User';
import { CreateUserDto, UpdateUserDto, IUser } from '@/types/user.types';
import { PaginationQuery, PaginationResponse } from '@/types/api.types';
import { logger } from '@/config/logger';

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
      return await User.findOne({ email }).select('+password');
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
EOF
    
    print_message "Services layer created ✓"
}

# Create validators
create_validators() {
    print_message "Creating validators..."
    
    cat > src/validators/userValidator.ts << 'EOF'
import Joi from 'joi';
import { CreateUserDto, UpdateUserDto, LoginDto, ChangePasswordDto } from '@/types/user.types';

export const createUserSchema = Joi.object<CreateUserDto>({
  firstName: Joi.string().required().trim().max(50),
  lastName: Joi.string().required().trim().max(50),
  email: Joi.string().email().required().lowercase().trim(),
  occupation: Joi.string().optional().trim().max(100),
  description: Joi.string().optional().trim().max(500),
  phoneNumber: Joi.string().optional().trim().pattern(/^[\+]?[1-9][\d]{0,15}$/),
  website: Joi.string().optional().trim().uri(),
  password: Joi.string().min(6).required(),
});

export const updateUserSchema = Joi.object<UpdateUserDto>({
  firstName: Joi.string().optional().trim().max(50),
  lastName: Joi.string().optional().trim().max(50),
  email: Joi.string().email().optional().lowercase().trim(),
  occupation: Joi.string().optional().trim().max(100),
  description: Joi.string().optional().trim().max(500),
  phoneNumber: Joi.string().optional().trim().pattern(/^[\+]?[1-9][\d]{0,15}$/),
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
EOF
    
    print_message "Validators created ✓"
}

# Create middleware
create_middleware() {
    print_message "Creating middleware..."
    
    # Validation middleware
    cat > src/middleware/validation.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';
import { ApiResponse } from '@/types/api.types';

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
EOF
    
    # Upload middleware
    cat > src/middleware/upload.ts << 'EOF'
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { Request, Response, NextFunction } from 'express';
import { config } from '@/config/app';
import { ApiResponse } from '@/types/api.types';

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = 'uploads/profiles';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  },
});

const upload = multer({
  storage,
  limits: {
    fileSize: config.maxFileSize,
  },
  fileFilter: (req, file, cb) => {
    if (config.allowedImageTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'));
    }
  },
});

export const uploadProfilePicture = upload.single('profilePicture');

export const handleMulterError = (
  err: any,
  req: Request,
  res: Response<ApiResponse>,
  next: NextFunction
): void => {
  if (err instanceof multer.MulterError) {
    if (err.code === 'LIMIT_FILE_SIZE') {
      res.status(400).json({
        success: false,
        message: 'File size too large. Maximum size is 5MB.',
      });
      return;
    }
  }

  if (err.message === 'Only image files are allowed!') {
    res.status(400).json({
      success: false,
      message: 'Only image files are allowed for profile pictures.',
    });
    return;
  }

  next(err);
};
EOF
    
    # Error handler middleware
    cat > src/middleware/errorHandler.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import mongoose from 'mongoose';
import { logger } from '@/config/logger';
import { ApiResponse } from '@/types/api.types';

export const errorHandler = (
  err: any,
  req: Request,
  res: Response<ApiResponse>,
  next: NextFunction
): void => {
  let error = { ...err };
  error.message = err.message;

  // Log error
  logger.error(err);

  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    const message = 'Resource not found';
    error = { message, statusCode: 404 };
  }

  // Mongoose duplicate key
  if (err.code === 11000) {
    const message = 'Duplicate field value entered';
    error = { message, statusCode: 400 };
  }

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors).map((val: any) => val.message).join(', ');
    error = { message, statusCode: 400 };
  }

  res.status(error.statusCode || 500).json({
    success: false,
    message: error.message || 'Server Error',
  });
};

export const notFound = (req: Request, res: Response<ApiResponse>): void => {
  res.status(404).json({
    success: false,
    message: 'Route not found',
  });
};
EOF
    
    # Rate limiting middleware
    cat > src/middleware/rateLimiter.ts << 'EOF'
import rateLimit from 'express-rate-limit';
import { config } from '@/config/app';

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
EOF
    
    print_message "Middleware created ✓"
}

# Create controllers
create_controllers() {
    print_message "Creating controllers..."
    
    cat > src/controllers/userController.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import path from 'path';
import fs from 'fs';
import { userService } from '@/services/userService';
import { ApiResponse, PaginationQuery } from '@/types/api.types';
import { CreateUserDto, UpdateUserDto, LoginDto, ChangePasswordDto } from '@/types/user.types';
import { logger } from '@/config/logger';

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
        data: result.data.map(user => user.getPublicProfile()),
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

  async changePassword(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
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

  async uploadProfilePicture(req: Request, res: Response<ApiResponse>, next: NextFunction): Promise<void> {
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
EOF
    
    print_message "Controllers created ✓"
}

# Create routes
create_routes() {
    print_message "Creating routes..."
    
    cat > src/routes/userRoutes.ts << 'EOF'
import { Router } from 'express';
import { userController } from '@/controllers/userController';
import { validateBody, validateQuery } from '@/middleware/validation';
import { uploadProfilePicture, handleMulterError } from '@/middleware/upload';
import { authLimiter } from '@/middleware/rateLimiter';
import {
  createUserSchema,
  updateUserSchema,
  loginSchema,
  changePasswordSchema,
  paginationSchema,
} from '@/validators/userValidator';

const router = Router();

// Authentication routes
router.post('/register', authLimiter, validateBody(createUserSchema), userController.register);
router.post('/login', authLimiter, validateBody(loginSchema), userController.login);

// Profile routes
router.get('/:id', userController.getProfile);
router.get('/', validateQuery(paginationSchema), userController.getAllUsers);
router.put('/:id', validateBody(updateUserSchema), userController.updateProfile);
router.put(
  '/:id/password',
  validateBody(changePasswordSchema),
  userController.changePassword
);
router.put(
  '/:id/profile-picture',
  uploadProfilePicture,
  handleMulterError,
  userController.uploadProfilePicture
);
router.delete('/:id', userController.deleteAccount);

export default router;
EOF
    
    cat > src/routes/index.ts << 'EOF'
import { Router } from 'express';
import userRoutes from './userRoutes';

const router = Router();

// Health check endpoint
router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'API is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// API routes
router.use('/users', userRoutes);

export default router;
EOF
    
    print_message "Routes created ✓"
}

# Create main server file
create_server_file() {
    print_message "Creating main server file..."
    
    cat > src/server.ts << 'EOF'
import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import compression from 'compression';
import { config } from '@/config/app';
import { connectDatabase } from '@/config/database';
import { logger } from '@/config/logger';
import { generalLimiter } from '@/middleware/rateLimiter';
import { errorHandler, notFound } from '@/middleware/errorHandler';
import routes from '@/routes';

// Load environment variables
import dotenv from 'dotenv';
dotenv.config();

class App {
  public app: express.Application;

  constructor() {
    this.app = express();
    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeErrorHandling();
  }

  private initializeMiddlewares(): void {
    // Security middleware
    this.app.use(helmet());
    this.app.use(cors());
    
    // Compression middleware
    this.app.use(compression());
    
    // Logging middleware
    if (config.nodeEnv !== 'test') {
      this.app.use(morgan('combined'));
    }
    
    // Rate limiting
    this.app.use('/api/', generalLimiter);
    
    // Body parsing middleware
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));
    
    // Serve static files
    this.app.use('/uploads', express.static('uploads'));
  }

  private initializeRoutes(): void {
    this.app.use('/api', routes);
  }

  private initializeErrorHandling(): void {
    this.app.use(notFound);
    this.app.use(errorHandler);
  }

  public async start(): Promise<void> {
    try {
      // Connect to database
      await connectDatabase();
      
      // Start server
      this.app.listen(config.port, () => {
        logger.info(`Server running on port ${config.port}`);
        logger.info(`Environment: ${config.nodeEnv}`);
      });
    } catch (error) {
      logger.error('Failed to start server:', error);
      process.exit(1);
    }
  }
}

// Start the application
const app = new App();

if (require.main === module) {
  app.start().catch((error) => {
    logger.error('Application startup error:', error);
    process.exit(1);
  });
}

export default app;
EOF
    
    print_message "Server file created ✓"
}

# Create utilities
create_utilities() {
    print_message "Creating utility functions..."
    
    cat > src/utils/fileHelper.ts << 'EOF'
import fs from 'fs';
import path from 'path';
import { logger } from '@/config/logger';

export class FileHelper {
  static ensureDirectoryExists(dirPath: string): void {
    if (!fs.existsSync(dirPath)) {
      fs.mkdirSync(dirPath, { recursive: true });
    }
  }

  static deleteFile(filePath: string): void {
    try {
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        logger.info(`File deleted: ${filePath}`);
      }
    } catch (error) {
      logger.error(`Error deleting file: ${filePath}`, error);
    }
  }

  static getFileExtension(filename: string): string {
    return path.extname(filename).toLowerCase();
  }

  static isValidImageExtension(filename: string): boolean {
    const validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return validExtensions.includes(this.getFileExtension(filename));
  }

  static generateUniqueFilename(originalname: string): string {
    const ext = path.extname(originalname);
    const name = path.basename(originalname, ext);
    const timestamp = Date.now();
    const random = Math.round(Math.random() * 1e9);
    return `${name}-${timestamp}-${random}${ext}`;
  }
}
EOF
    
    cat > src/utils/asyncHandler.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';

type AsyncFunction = (req: Request, res: Response, next: NextFunction) => Promise<any>;

export const asyncHandler = (fn: AsyncFunction) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};
EOF
    
    print_message "Utilities created ✓"
}

# Create configuration files
create_config_files() {
    print_message "Creating configuration files..."
    
    # Environment variables
    cat > .env << 'EOF'
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/profile_db
JWT_SECRET=your-super-secret-jwt-key-here-change-in-production
JWT_EXPIRE=30d
LOG_LEVEL=info
EOF
    
    # Environment example
    cat > .env.example << 'EOF'
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/profile_db
JWT_SECRET=your-super-secret-jwt-key-here-change-in-production
JWT_EXPIRE=30d
LOG_LEVEL=info
EOF
    
    # Gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Build output
dist/
build/

# Uploads
uploads/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# TypeScript
*.tsbuildinfo

# Testing
.nyc_output
EOF
    
    print_message "Configuration files created ✓"
}

# Create test files
create_tests() {
    print_message "Creating test files..."
    
    # Jest configuration
    cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts: 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/server.ts',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  moduleNameMapping: {
    '^@/(.*): '<rootDir>/src/$1',
  },
};
EOF
    
    # Test setup
    cat > tests/setup.ts << 'EOF'
import { MongoMemoryServer } from 'mongodb-memory-server';
import mongoose from 'mongoose';

let mongoServer: MongoMemoryServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  await mongoose.connect(mongoUri);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

afterEach(async () => {
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    const collection = collections[key];
    await collection.deleteMany({});
  }
});
EOF
    
    # User controller tests
    cat > tests/unit/userController.test.ts << 'EOF'
import request from 'supertest';
import app from '../../src/server';
import { User } from '../../src/models/User';

describe('User Controller', () => {
  describe('POST /api/users/register', () => {
    it('should register a new user successfully', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
      };

      const response = await request(app.app)
        .post('/api/users/register')
        .send(userData)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.email).toBe(userData.email);
      expect(response.body.data.password).toBeUndefined();
    });

    it('should not register user with invalid email', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'invalid-email',
        password: 'password123',
      };

      const response = await request(app.app)
        .post('/api/users/register')
        .send(userData)
        .expect(400);

      expect(response.body.success).toBe(false);
    });

    it('should not register user with duplicate email', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
      };

      // Create first user
      await request(app.app)
        .post('/api/users/register')
        .send(userData)
        .expect(201);

      // Try to create duplicate
      const response = await request(app.app)
        .post('/api/users/register')
        .send(userData)
        .expect(500);

      expect(response.body.success).toBe(false);
    });
  });

  describe('POST /api/users/login', () => {
    beforeEach(async () => {
      const user = new User({
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
      });
      await user.save();
    });

    it('should login with valid credentials', async () => {
      const response = await request(app.app)
        .post('/api/users/login')
        .send({
          email: 'john@example.com',
          password: 'password123',
        })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.email).toBe('john@example.com');
    });

    it('should not login with invalid credentials', async () => {
      const response = await request(app.app)
        .post('/api/users/login')
        .send({
          email: 'john@example.com',
          password: 'wrongpassword',
        })
        .expect(401);

      expect(response.body.success).toBe(false);
    });
  });
});
EOF
    
    # Add mongodb-memory-server dependency for tests
    cat >> package.json.tmp << 'EOF'
{
  "devDependencies": {
    "mongodb-memory-server": "^8.12.2"
  }
}
EOF
    
    # Merge the mongodb-memory-server dependency
    node -e "
      const fs = require('fs');
      const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      const additional = JSON.parse(fs.readFileSync('package.json.tmp', 'utf8'));
      pkg.devDependencies = { ...pkg.devDependencies, ...additional.devDependencies };
      fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
    " 2>/dev/null || echo "Note: Could not automatically add mongodb-memory-server dependency"
    
    rm -f package.json.tmp
    
    print_message "Test files created ✓"
}

# Create seed script
create_seed_script() {
    print_message "Creating seed script..."
    
    cat > src/scripts/seed.ts << 'EOF'
import 'reflect-metadata';
import dotenv from 'dotenv';
import { connectDatabase, disconnectDatabase } from '@/config/database';
import { User } from '@/models/User';
import { logger } from '@/config/logger';
import { CreateUserDto } from '@/types/user.types';

dotenv.config();

const users: CreateUserDto[] = [
  {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    occupation: 'Software Developer',
    description: 'Passionate full-stack developer with 5 years of experience',
    phoneNumber: '+1234567890',
    website: 'https://johndoe.com',
    password: 'password123',
  },
  {
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane@example.com',
    occupation: 'UI/UX Designer',
    description: 'Creative designer focused on user experience',
    phoneNumber: '+1987654321',
    website: 'https://janesmith.design',
    password: 'password123',
  },
  {
    firstName: 'Mike',
    lastName: 'Johnson',
    email: 'mike@example.com',
    occupation: 'Product Manager',
    description: 'Strategic product manager with expertise in agile development',
    phoneNumber: '+1122334455',
    website: 'https://mikejohnson.io',
    password: 'password123',
  },
];

const seedDatabase = async (): Promise<void> => {
  try {
    await connectDatabase();
    logger.info('Connected to MongoDB');

    // Clear existing users
    await User.deleteMany({});
    logger.info('Cleared existing users');

    // Create new users
    for (const userData of users) {
      const user = new User(userData);
      await user.save();
      logger.info(`Created user: ${user.email}`);
    }

    logger.info('Database seeded successfully');
    await disconnectDatabase();
    process.exit(0);
  } catch (error) {
    logger.error('Error seeding database:', error);
    await disconnectDatabase();
    process.exit(1);
  }
};

seedDatabase();
EOF
    
    print_message "Seed script created ✓"
}

# Create Heroku deployment files
create_heroku_files() {
    print_message "Creating Heroku deployment files..."
    
    # Procfile for Heroku
    cat > Procfile << 'EOF'
web: npm start
EOF
    
    # Heroku deployment script
    cat > scripts/deploy-heroku.sh << 'EOF'
#!/bin/bash
# Heroku deployment script

set -e

echo "🚀 Deploying to Heroku..."

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI not found. Please install it first:"
    echo "   https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Login check
if ! heroku auth:whoami &> /dev/null; then
    echo "🔐 Please login to Heroku first:"
    heroku login
fi

# Get app name
read -p "Enter your Heroku app name (or press Enter to create new): " app_name

if [ -z "$app_name" ]; then
    echo "📱 Creating new Heroku app..."
    heroku create
    app_name=$(heroku info | grep "Web URL" | sed 's/.*\/\///' | sed 's/\.heroku.*//')
else
    echo "📱 Using existing app: $app_name"
    heroku git:remote -a $app_name
fi

# Set environment variables
echo "⚙️ Setting environment variables..."
heroku config:set NODE_ENV=production -a $app_name
heroku config:set JWT_SECRET=$(openssl rand -base64 32) -a $app_name
heroku config:set JWT_EXPIRE=30d -a $app_name
heroku config:set LOG_LEVEL=info -a $app_name

# Prompt for MongoDB Atlas URI
echo "🗄️ MongoDB Atlas setup required..."
echo "   1. Create account at https://cloud.mongodb.com"
echo "   2. Create cluster and get connection string"
echo "   3. Replace <password> with your database user password"
read -p "Enter your MongoDB Atlas URI: " mongo_uri

if [ ! -z "$mongo_uri" ]; then
    heroku config:set MONGODB_URI="$mongo_uri" -a $app_name
else
    echo "⚠️ MongoDB URI not set. You'll need to set it manually:"
    echo "   heroku config:set MONGODB_URI='your-atlas-uri' -a $app_name"
fi

# Deploy
echo "🚀 Deploying application..."
git add .
git commit -m "Deploy to Heroku" --allow-empty
git push heroku main

# Open app
echo "✅ Deployment complete!"
heroku open -a $app_name
echo "📊 View logs: heroku logs --tail -a $app_name"
echo "⚙️ Manage app: https://dashboard.heroku.com/apps/$app_name"
EOF

    # App.json for Heroku app setup
    cat > app.json << 'EOF'
{
  "name": "Profile Settings API",
  "description": "TypeScript Profile Settings API with Express.js and MongoDB",
  "repository": "https://github.com/yourusername/profile-settings-api",
  "logo": "https://cdn.worldvectorlogo.com/logos/nodejs-icon.svg",
  "keywords": ["node", "typescript", "express", "mongodb", "api"],
  "image": "heroku/nodejs",
  "stack": "heroku-20",
  "buildpacks": [
    {
      "url": "heroku/nodejs"
    }
  ],
  "env": {
    "NODE_ENV": {
      "description": "Node environment",
      "value": "production"
    },
    "JWT_SECRET": {
      "description": "Secret key for JWT tokens",
      "generator": "secret"
    },
    "JWT_EXPIRE": {
      "description": "JWT token expiration time",
      "value": "30d"
    },
    "MONGODB_URI": {
      "description": "MongoDB Atlas connection string",
      "required": true
    },
    "LOG_LEVEL": {
      "description": "Logging level",
      "value": "info"
    }
  },
  "formation": {
    "web": {
      "quantity": 1,
      "size": "free"
    }
  },
  "addons": [
    {
      "plan": "papertrail:choklad",
      "as": "PAPERTRAIL"
    }
  ],
  "scripts": {
    "postdeploy": "npm run seed"
  }
}
EOF
    
    # GitHub Actions for CI/CD (optional)
    mkdir -p .github/workflows
    cat > .github/workflows/heroku-deploy.yml << 'EOF'
name: Deploy to Heroku

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build TypeScript
      run: npm run build
    
    - name: Deploy to Heroku
      uses: akhileshns/heroku-deploy@v3.12.12
      with:
        heroku_api_key: ${{secrets.HEROKU_API_KEY}}
        heroku_app_name: ${{secrets.HEROKU_APP_NAME}}
        heroku_email: ${{secrets.HEROKU_EMAIL}}
        buildpack: "heroku/nodejs"
EOF
    
    print_message "Heroku deployment files created ✓"
}

# Create documentation
create_documentation() {
    print_message "Creating documentation..."
    
    cat > README.md << 'EOF'
# TypeScript Profile Settings API

A comprehensive REST API for managing user profiles built with TypeScript, Express.js, and MongoDB.

## Features

- 🚀 **TypeScript** - Type-safe development
- 🔐 **Authentication** - User registration and login
- 👤 **Profile Management** - Complete CRUD operations
- 📁 **File Upload** - Profile picture management
- ✅ **Validation** - Request validation with Joi
- 🛡️ **Security** - Helmet, CORS, Rate limiting
- 📝 **Logging** - Winston logger integration
- 🧪 **Testing** - Jest with supertest
- 🐳 **Docker** - Container support
- 📚 **Documentation** - Comprehensive API docs

## Prerequisites

- Node.js (v16 or higher)
- MongoDB (v4 or higher)
- npm or yarn

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Copy environment variables:
   ```bash
   cp .env.example .env
   ```

4. Update the `.env` file with your configuration
5. Start MongoDB service
6. Build and run the application:
   ```bash
   npm run build
   npm start
   ```

## Development

Start development server with hot reload:
```bash
npm run dev
```

Run with debugging:
```bash
npm run dev:debug
```

## Testing

Run all tests:
```bash
npm test
```

Run tests in watch mode:
```bash
npm run test:watch
```

Generate coverage report:
```bash
npm run test:coverage
```

## Code Quality

Lint code:
```bash
npm run lint
```

Fix linting issues:
```bash
npm run lint:fix
```

Format code:
```bash
npm run format
```

Type checking:
```bash
npm run type-check
```

## API Endpoints

### Authentication
- `POST /api/users/register` - Register a new user
- `POST /api/users/login` - Login user

### Profile Management
- `GET /api/users/:id` - Get user profile
- `GET /api/users` - Get all users (with pagination and search)
- `PUT /api/users/:id` - Update user profile
- `PUT /api/users/:id/password` - Change password
- `PUT /api/users/:id/profile-picture` - Upload profile picture
- `DELETE /api/users/:id` - Delete user account

### Health Check
- `GET /api/health` - API health status

## Project Structure

```
src/
├── config/           # Configuration files
├── controllers/      # Request handlers
├── middleware/       # Custom middleware
├── models/          # Database models
├── routes/          # Route definitions
├── services/        # Business logic
├── types/           # TypeScript type definitions
├── utils/           # Utility functions
├── validators/      # Request validators
└── server.ts        # Main application file
```

## Environment Variables

- `NODE_ENV` - Environment (development/production)
- `PORT` - Server port (default: 3000)
- `MONGODB_URI` - MongoDB connection string
- `JWT_SECRET` - JWT secret key
- `JWT_EXPIRE` - JWT expiration time
- `LOG_LEVEL` - Logging level

## Heroku Deployment

Deploy to Heroku:
```bash
./scripts/deploy-heroku.sh
```

Or manually:
```bash
# Install Heroku CLI and login
heroku login

# Create Heroku app
heroku create your-app-name

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI=your-atlas-connection-string
heroku config:set JWT_SECRET=your-secret-key

# Deploy
git push heroku main
```

Monitor your app:
```bash
heroku logs --tail
heroku ps
heroku open
```

## Database Seeding

Populate database with sample data:
```bash
npm run seed
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run linting and tests
6. Submit a pull request

## License

MIT License
EOF
    
    # API Documentation
    cat > docs/api.md << 'EOF'
# API Documentation

## Base URL
`http://localhost:3000/api`

## Response Format

All responses follow this format:
```typescript
interface ApiResponse<T = any> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
}
```

## Authentication

### Register User
**POST** `/users/register`

Request body:
```typescript
{
  firstName: string;
  lastName: string;
  email: string;
  occupation?: string;
  description?: string;
  phoneNumber?: string;
  website?: string;
  password: string;
}
```

Response:
```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "id": "...",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "occupation": "Software Developer",
    "description": "Passionate developer",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.com",
    "profilePicture": null,
    "isActive": true,
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  }
}
```

### Login User
**POST** `/users/login`

Request body:
```typescript
{
  email: string;
  password: string;
}
```

## Profile Management

### Get User Profile
**GET** `/users/:id`

Response:
```json
{
  "success": true,
  "data": {
    "id": "...",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "occupation": "Software Developer",
    "description": "Passionate developer",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.com",
    "profilePicture": "/uploads/profiles/profile-123456789.jpg",
    "isActive": true,
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  }
}
```

### Get All Users
**GET** `/users?page=1&limit=10&sort=-createdAt&search=john`

Query parameters:
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10, max: 100)
- `sort` (optional): Sort field (default: -createdAt)
- `search` (optional): Search term

Response:
```json
{
  "success": true,
  "data": [...],
  "page": 1,
  "limit": 10,
  "total": 25,
  "pages": 3,
  "hasNext": true,
  "hasPrev": false
}
```

### Update Profile
**PUT** `/users/:id`

Request body:
```typescript
{
  firstName?: string;
  lastName?: string;
  email?: string;
  occupation?: string;
  description?: string;
  phoneNumber?: string;
  website?: string;
}
```

### Change Password
**PUT** `/users/:id/password`

Request body:
```typescript
{
  oldPassword: string;
  newPassword: string;
}
```

### Upload Profile Picture
**PUT** `/users/:id/profile-picture`

Form data:
- `profilePicture`: Image file (max 5MB, jpg/png/gif/webp)

Response:
```json
{
  "success": true,
  "message": "Profile picture updated successfully",
  "data": {
    "profilePicture": "/uploads/profiles/profile-123456789.jpg"
  }
}
```

### Delete Account
**DELETE** `/users/:id`

Response:
```json
{
  "success": true,
  "message": "User account deleted successfully"
}
```

## Error Codes

- `400` - Bad Request (validation errors)
- `401` - Unauthorized (invalid credentials)
- `404` - Not Found (resource not found)
- `429` - Too Many Requests (rate limit exceeded)
- `500` - Internal Server Error

## Rate Limiting

- General API: 100 requests per 15 minutes per IP
- Authentication endpoints: 5 requests per 15 minutes per IP

## File Upload

Supported image formats:
- JPEG (.jpg, .jpeg)
- PNG (.png)
- GIF (.gif)
- WebP (.webp)

Maximum file size: 5MB
EOF
    
    print_message "Documentation created ✓"
}

# Install dependencies
install_dependencies() {
    print_message "Installing dependencies..."
    
    if command -v npm &> /dev/null; then
        npm install
        print_success "Dependencies installed successfully ✓"
    else
        print_warning "npm not found. Please run 'npm install' manually."
    fi
}

# Create utility scripts
create_scripts() {
    print_message "Creating utility scripts..."
    
    # Development script
    cat > scripts/dev.sh << 'EOF'
#!/bin/bash
# Development setup script

set -e

echo "🚀 Setting up development environment..."

# Check if MongoDB is running
if ! pgrep -x "mongod" > /dev/null; then
    echo "📦 Starting MongoDB..."
    if command -v systemctl &> /dev/null; then
        sudo systemctl start mongod
    elif command -v brew &> /dev/null; then
        brew services start mongodb-community
    else
        echo "⚠️  Please start MongoDB manually"
    fi
fi

# Install dependencies if not present
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run linting
echo "🔍 Running linting..."
npm run lint

# Start development server
echo "🎯 Starting development server..."
npm run dev
EOF
    
    # Production script
    cat > scripts/prod.sh << 'EOF'
#!/bin/bash
# Production setup script

set -e

echo "🚀 Setting up production environment..."

# Build the application
echo "🔨 Building application..."
npm run build

# Start with Docker
echo "🐳 Starting with Docker..."
docker-compose up --build -d

echo "✅ Application started in production mode"
echo "🌐 API available at: http://localhost:3000"
echo "❤️  Health check: http://localhost:3000/api/health"
EOF
    
    # Test script
    cat > scripts/test.sh << 'EOF'
#!/bin/bash
# Testing script

set -e

echo "🧪 Running tests..."

# Type checking
echo "🔍 Type checking..."
npm run type-check

# Linting
echo "🔍 Linting..."
npm run lint

# Run tests
echo "🧪 Running unit tests..."
npm run test

# Coverage report
echo "📊 Generating coverage report..."
npm run test:coverage

echo "✅ All tests passed!"
EOF
    
    # Setup script
    cat > scripts/setup.sh << 'EOF'
#!/bin/bash
# Initial setup script

set -e

echo "🚀 Initial project setup..."

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Create log directory
echo "📁 Creating directories..."
mkdir -p logs

# Copy environment file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating environment file..."
    cp .env.example .env
    echo "⚠️  Please update .env with your configuration"
fi

# Build the project
echo "🔨 Building project..."
npm run build

echo "✅ Setup complete!"
echo "📖 Run 'npm run dev' to start development server"
echo "📚 Check README.md for more information"
EOF
    
    # Make scripts executable
    chmod +x scripts/*.sh
    
    print_message "Utility scripts created ✓"
}

# Main execution function
main() {
    print_header
    
    # Check prerequisites
    check_prerequisites
    
    # Get project name from user input
    project_name="profile-settings-api"
    if [ $# -eq 1 ]; then
        project_name=$1
    else
        read -p "Enter project name (default: profile-settings-api): " input_name
        if [ ! -z "$input_name" ]; then
            project_name=$input_name
        fi
    fi
    
    # Create project
    create_project_structure "$project_name"
    init_npm_project
    create_typescript_config
    create_linting_config
    create_types
    create_config
    create_user_model
    create_services
    create_validators
    create_middleware
    create_controllers
    create_routes
    create_server_file
    create_utilities
    create_config_files
    create_tests
    create_seed_script
    create_heroku_files
    create_documentation
    create_scripts
    
    # Install dependencies
    install_dependencies
    
    print_header
    print_success "🎉 TypeScript Profile Settings API project created successfully!"
    echo ""
    echo -e "${BLUE}Project location:${NC} $(pwd)"
    echo -e "${BLUE}Language:${NC} TypeScript"
    echo ""
    echo -e "${BLUE}🚀 Quick start:${NC}"
    echo "  1. Update .env with your configuration"
    echo "  2. Start MongoDB: sudo systemctl start mongod"
    echo "  3. Run development server: npm run dev"
    echo "  4. API will be available at: http://localhost:3000"
    echo ""
    echo -e "${BLUE}📦 Available commands:${NC}"
    echo "  npm run dev          - Start development server with hot reload"
    echo "  npm run build        - Build TypeScript to JavaScript"
    echo "  npm start            - Start production server"
    echo "  npm test             - Run tests"
    echo "  npm run test:watch   - Run tests in watch mode"
    echo "  npm run lint         - Lint TypeScript code"
    echo "  npm run lint:fix     - Fix linting issues"
    echo "  npm run format       - Format code with Prettier"
    echo "  npm run seed         - Seed database with sample data"
    echo ""
    echo -e "${BLUE}🚀 Heroku deployment:${NC}"
    echo "  ./scripts/deploy-heroku.sh  - Deploy to Heroku"
    echo "  heroku logs --tail          - Monitor logs"
    echo "  heroku ps                   - Check dyno status"
    echo ""
    echo -e "${BLUE}📋 Before deploying:${NC}"
    echo "  1. Create MongoDB Atlas account (https://cloud.mongodb.com)"
    echo "  2. Install Heroku CLI (https://devcenter.heroku.com/articles/heroku-cli)"
    echo "  3. Run: heroku login"
    echo "  4. Run: ./scripts/deploy-heroku.sh"
    echo ""
    echo -e "${BLUE}🛠️  Utility scripts:${NC}"
    echo "  ./scripts/setup.sh       - Initial project setup"
    echo "  ./scripts/dev.sh         - Setup and start development"
    echo "  ./scripts/prod.sh        - Start production with Docker"
    echo "  ./scripts/test.sh        - Run complete test suite"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo "  README.md                - Project documentation"
    echo "  docs/api.md              - API documentation"
    echo ""
    echo -e "${GREEN}🎯 Project Features:${NC}"
    echo "  ✅ TypeScript with strict mode"
    echo "  ✅ Express.js with security middleware"
    echo "  ✅ MongoDB with Mongoose ODM"
    echo "  ✅ Complete CRUD operations"
    echo "  ✅ File upload handling"
    echo "  ✅ Request validation with Joi"
    echo "  ✅ Comprehensive error handling"
    echo "  ✅ Testing with Jest"
    echo "  ✅ Linting with ESLint"
    echo "  ✅ Code formatting with Prettier"
    echo "  ✅ Docker support"
    echo "  ✅ Winston logging"
    echo "  ✅ Rate limiting"
    echo ""
    echo -e "${GREEN}Happy coding with TypeScript! 🚀${NC}"
}

# Run main function with all arguments
main "$@"