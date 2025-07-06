import fs from 'fs';
import path from 'path';
import { logger } from '../config/logger';

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
