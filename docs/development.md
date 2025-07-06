# 💻 Development Guide

Comprehensive guide for setting up and contributing to the Profile Settings API project.

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Development Setup](#-development-setup)
- [Project Architecture](#-project-architecture)
- [Development Workflow](#-development-workflow)
- [Code Standards](#-code-standards)
- [Testing](#-testing)
- [Debugging](#-debugging)
- [Performance](#-performance)
- [Troubleshooting](#-troubleshooting)

## 🔧 Prerequisites

### Required Software

1. **Node.js** (v16 or higher)
   ```bash
   # Check version
   node --version
   
   # Install via Node Version Manager (recommended)
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   nvm install 18
   nvm use 18
   ```

2. **npm** (comes with Node.js)
   ```bash
   # Check version
   npm --version
   
   # Update npm if needed
   npm install -g npm@latest
   ```

3. **MongoDB** (local development)
   ```bash
   # macOS with Homebrew
   brew tap mongodb/brew
   brew install mongodb-community
   brew services start mongodb-community
   
   # Ubuntu/Debian
   sudo apt-get install -y mongodb
   sudo systemctl start mongod
   sudo systemctl enable mongod
   
   # Windows
   # Download from https://www.mongodb.com/try/download/community
   ```

4. **Git**
   ```bash
   # Check version
   git --version
   
   # Configure git (if not done already)
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### Recommended Tools

- **VS Code** with extensions:
  - TypeScript Hero
  - ESLint
  - Prettier
  - REST Client
  - MongoDB for VS Code
- **Postman** or **Insomnia** for API testing
- **MongoDB Compass** for database visualization

## 🚀 Development Setup

### 1. Clone and Install

```bash
# Clone the repository
git clone https://github.com/yourusername/profile-settings-api.git
cd profile-settings-api

# Install dependencies
npm install

# Copy environment file
cp .env.example .env
```

### 2. Environment Configuration

Edit `.env` file with your settings:

```bash
# Development Configuration
NODE_ENV=development
PORT=3000

# Database
MONGODB_URI=mongodb://localhost:27017/profile_db

# Authentication
JWT_SECRET=your-development-secret-key-change-this
JWT_EXPIRE=30d

# Logging
LOG_LEVEL=debug

# File Upload (Development)
MAX_FILE_SIZE=5242880  # 5MB
UPLOAD_PATH=uploads/profiles
```

### 3. Database Setup

```bash
# Start MongoDB (if not running)
# macOS
brew services start mongodb-community

# Linux
sudo systemctl start mongod

# Verify connection
mongosh mongodb://localhost:27017/profile_db

# Seed database with sample data
npm run seed
```

### 4. Start Development Server

```bash
# Start with hot reload
npm run dev

# Start with debugging
npm run dev:debug

# Verify API is running
curl http://localhost:3000/api/health
```

## 🏗️ Project Architecture

### Layered Architecture

```
┌─────────────────┐
│   Routes        │  HTTP routing and middleware
├─────────────────┤
│   Controllers   │  Request/Response handling
├─────────────────┤
│   Services      │  Business logic
├─────────────────┤
│   Models        │  Data access and validation
├─────────────────┤
│   Database      │  MongoDB with Mongoose
└─────────────────┘
```

### Directory Structure Explained

```
src/
├── config/              # Configuration management
│   ├── app.ts          # Application settings
│   ├── database.ts     # Database connection
│   └── logger.ts       # Logging configuration
├── controllers/         # HTTP request handlers
│   └── userController.ts
├── middleware/          # Express middleware
│   ├── errorHandler.ts # Global error handling
│   ├── rateLimiter.ts  # Rate limiting
│   ├── upload.ts       # File upload handling
│   └── validation.ts   # Request validation
├── models/             # Database models
│   └── User.ts         # User schema and methods
├── routes/             # API route definitions
│   ├── index.ts        # Main router
│   └── userRoutes.ts   # User-specific routes
├── services/           # Business logic layer
│   └── userService.ts  # User operations
├── types/              # TypeScript definitions
│   ├── api.types.ts    # API interfaces
│   ├── express.types.ts # Express extensions
│   ├── user.types.ts   # User interfaces
│   └── index.ts        # Type exports
├── utils/              # Utility functions
│   ├── asyncHandler.ts # Async error wrapper
│   └── fileHelper.ts   # File operations
├── validators/         # Input validation schemas
│   └── userValidator.ts
└── server.ts           # Application entry point
```

### Data Flow

```
1. Request → Routes → Middleware → Controller
2. Controller → Service → Model
3. Model → Database → Model
4. Model → Service → Controller
5. Controller → Response
```

## 🔄 Development Workflow

### 1. Feature Development

```bash
# Create feature branch
git checkout -b feature/user-profile-search

# Make changes...
# Add files
git add .

# Commit with conventional commits
git commit -m "feat: add user search functionality"

# Push to remote
git push origin feature/user-profile-search

# Create pull request
```

### 2. Code Quality Checks

```bash
# Type checking
npm run type-check

# Linting
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Run tests
npm test

# Check test coverage
npm run test:coverage
```

### 3. Adding New Endpoints

**Step 1: Define Types**
```typescript
// src/types/user.types.ts
export interface UpdateUserStatusDto {
  isActive: boolean;
  reason?: string;
}
```

**Step 2: Add Validation**
```typescript
// src/validators/userValidator.ts
export const updateUserStatusSchema = Joi.object<UpdateUserStatusDto>({
  isActive: Joi.boolean().required(),
  reason: Joi.string().optional().max(200)
});
```

**Step 3: Service Method**
```typescript
// src/services/userService.ts
async updateUserStatus(id: string, statusData: UpdateUserStatusDto): Promise<IUser | null> {
  return await User.findByIdAndUpdate(
    id, 
    { isActive: statusData.isActive },
    { new: true, runValidators: true }
  );
}
```

**Step 4: Controller Method**
```typescript
// src/controllers/userController.ts
async updateUserStatus(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { id } = req.params;
    const statusData: UpdateUserStatusDto = req.body;
    
    const user = await userService.updateUserStatus(id, statusData);
    
    if (!user) {
      res.status(404).json({
        success: false,
        message: 'User not found'
      });
      return;
    }
    
    res.json({
      success: true,
      message: 'User status updated successfully',
      data: user.getPublicProfile()
    });
  } catch (error) {
    next(error);
  }
}
```

**Step 5: Add Route**
```typescript
// src/routes/userRoutes.ts
router.put('/:id/status', 
  validateBody(updateUserStatusSchema), 
  userController.updateUserStatus
);
```

**Step 6: Write Tests**
```typescript
// tests/unit/userController.test.ts
describe('PUT /api/users/:id/status', () => {
  it('should update user status successfully', async () => {
    const response = await request(app.app)
      .put(`/api/users/${userId}/status`)
      .send({ isActive: false, reason: 'Account suspended' })
      .expect(200);
      
    expect(response.body.success).toBe(true);
    expect(response.body.data.isActive).toBe(false);
  });
});
```

## 📏 Code Standards

### TypeScript Guidelines

**✅ Good - Explicit types**
```typescript
interface CreateUserRequest {
  firstName: string;
  lastName: string;
  email: string;
}

async function createUser(data: CreateUserRequest): Promise<IUser> {
  // Implementation
}
```

**❌ Bad - Any types**
```typescript
async function createUser(data: any): Promise<any> {
  // Implementation
}
```

### Error Handling

**✅ Proper Error Handling:**
```typescript
try {
  const user = await userService.createUser(userData);
  res.status(201).json({
    success: true,
    data: user.getPublicProfile()
  });
} catch (error) {
  next(error); // Pass to error middleware
}
```

### File Naming Conventions

```
# Files and directories
camelCase for files: userController.ts
kebab-case for directories: user-management/
PascalCase for classes: UserService.ts
```

### Import/Export Patterns

```typescript
// ✅ Good - Named exports for utilities
export const validateEmail = (email: string): boolean => { ... };
export const hashPassword = (password: string): Promise<string> => { ... };

// ✅ Good - Default export for main classes
export default class UserService { ... }
export { UserService };
```

## 🧪 Testing

### Testing Strategy

**Unit Tests** - Test individual functions
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@test.com',
        password: 'password123'
      };
      
      const user = await userService.createUser(userData);
      
      expect(user.email).toBe(userData.email);
      expect(user.password).not.toBe(userData.password); // Should be hashed
    });
  });
});
```

**Integration Tests** - Test complete API endpoints
```typescript
describe('POST /api/users/register', () => {
  it('should register new user', async () => {
    const response = await request(app)
      .post('/api/users/register')
      .send(validUserData)
      .expect(201);
    
    expect(response.body.success).toBe(true);
  });
});
```

### Running Tests

```bash
# Run all tests
npm test

# Run specific test file
npm test -- userController.test.ts

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm run test:coverage

# View coverage report
open coverage/lcov-report/index.html
```

## 🐛 Debugging

### VS Code Debugging

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug API",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/src/server.ts",
      "env": {
        "NODE_ENV": "development"
      },
      "runtimeArgs": [
        "-r", "ts-node/register",
        "-r", "tsconfig-paths/register"
      ],
      "sourceMaps": true,
      "restart": true,
      "console": "integratedTerminal"
    }
  ]
}
```

### Debugging Techniques

**Logging**
```typescript
import { logger } from '../config/logger';

// Different log levels
logger.debug('Debug information', { userId, requestData });
logger.info('User registered successfully', { email: user.email });
logger.warn('Invalid login attempt', { email, ip: req.ip });
logger.error('Database connection failed', error);
```

**Database Query Debugging**
```typescript
// Enable Mongoose debugging
mongoose.set('debug', true);

// Custom query logging
userSchema.pre('save', function() {
  logger.debug('Saving user', { userId: this._id, email: this.email });
});
```

## ⚡ Performance

### Database Optimization

**Indexing**
```typescript
// User model indexes
userSchema.index({ email: 1 }, { unique: true });
userSchema.index({ isActive: 1 });
userSchema.index({ 'firstName': 1, 'lastName': 1 });

// Text search index
userSchema.index({
  firstName: 'text',
  lastName: 'text',
  email: 'text',
  occupation: 'text'
});
```

**Query Optimization**
```typescript
// ✅ Good - Select only needed fields
const users = await User.find({ isActive: true })
  .select('firstName lastName email occupation')
  .limit(10);

// ❌ Bad - Loading all fields
const users = await User.find({ isActive: true }).limit(10);
```

### Memory Management

```typescript
// Memory monitoring middleware
app.use((req: Request, res: Response, next: NextFunction) => {
  res.on('finish', () => {
    if (Math.random() < 0.01) { // 1% sampling
      const usage = process.memoryUsage();
      logger.info('Memory usage', {
        rss: `${Math.round(usage.rss / 1024 / 1024)} MB`,
        heapUsed: `${Math.round(usage.heapUsed / 1024 / 1024)} MB`
      });
    }
  });
  next();
});
```

## 🔧 Troubleshooting

### Common Issues

**MongoDB Connection Issues**
```bash
# Check if MongoDB is running
ps aux | grep mongod

# Check connection
mongosh mongodb://localhost:27017/profile_db

# Restart MongoDB
# macOS
brew services restart mongodb-community

# Linux
sudo systemctl restart mongod
```

**TypeScript Path Mapping Issues**
```bash
# Install tsconfig-paths
npm install --save-dev tsconfig-paths

# Update package.json
"dev": "ts-node-dev -r tsconfig-paths/register --respawn --transpile-only src/server.ts"
```

**Port Already in Use**
```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev
```

**File Upload Issues**
```bash
# Check upload directory permissions
ls -la uploads/

# Create directory if missing
mkdir -p uploads/profiles

# Fix permissions
chmod 755 uploads/profiles
```

### Getting Help

1. **Check logs** in `logs/` directory
2. **Enable debug logging** with `LOG_LEVEL=debug`
3. **Use MongoDB Compass** to inspect database
4. **Check GitHub issues** for known problems
5. **Create minimal reproduction** for bug reports

---

For more information, see the [main documentation](../README.md) or [API reference](api.md).
