import { Request } from 'express';
import { IUser } from './user.types';

export interface AuthenticatedRequest extends Request {
  user?: IUser;
}
