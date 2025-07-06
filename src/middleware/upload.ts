import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { Request, Response, NextFunction } from 'express';
import { config } from '../config/app';
import { ApiResponse } from '../types/api.types';

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
