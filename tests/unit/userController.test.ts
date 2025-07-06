import request from 'supertest';
import app from '../../src/server';
import { User } from '../../src/models/User';
import { describe, it, beforeEach } from 'node:test';

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
      await request(app.app).post('/api/users/register').send(userData).expect(201);

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
function expect(actual: any) {
  return {
    toBe(expected: any) {
      if (actual !== expected) {
        throw new Error(`Expected ${actual} to be ${expected}`);
      }
    },
    toBeUndefined() {
      if (actual !== undefined) {
        throw new Error(`Expected ${actual} to be undefined`);
      }
    },
  };
}
// No implementation is needed here.
