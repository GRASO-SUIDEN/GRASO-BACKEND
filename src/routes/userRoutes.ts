import { Router } from 'express';
import { userController } from '../controllers/userController';
import { validateBody, validateQuery } from '../middleware/validation';
import { uploadProfilePicture, handleMulterError } from '../middleware/upload';
import { authLimiter } from '../middleware/rateLimiter';
import {
  createUserSchema,
  updateUserSchema,
  loginSchema,
  changePasswordSchema,
  paginationSchema,
} from '../validators/userValidator';

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
