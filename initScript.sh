#!/bin/bash

# Script to create README.md for Profile Settings API

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Creating README.md${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

print_message "Creating main README.md file..."

cat > README.md << 'EOF'
# 🚀 Profile Settings API

A comprehensive **TypeScript REST API** for managing user profiles built with **Express.js**, **MongoDB**, and modern development practices. This API provides complete user profile management with authentication, file uploads, validation, and security features.

![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)
![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)
![Express](https://img.shields.io/badge/Express.js-4.18+-lightgrey.svg)
![MongoDB](https://img.shields.io/badge/MongoDB-6+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 📋 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [API Endpoints](#-api-endpoints)
- [Project Structure](#-project-structure)
- [Documentation](#-documentation)
- [Development](#-development)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### 🔐 **Authentication & Security**
- ✅ User registration and login
- ✅ Password hashing with bcrypt (12 rounds)
- ✅ Input validation and sanitization
- ✅ Rate limiting (prevents abuse)
- ✅ CORS protection
- ✅ Security headers with Helmet

### 👤 **Profile Management**
- ✅ Complete CRUD operations for user profiles
- ✅ Profile picture upload with validation
- ✅ Search functionality across user data
- ✅ Pagination for large datasets
- ✅ Soft delete capabilities

### 🛠️ **Developer Experience**
- ✅ **TypeScript** with strict type checking
- ✅ **ESLint** and **Prettier** for code quality
- ✅ **Jest** testing framework with coverage
- ✅ **Hot reload** development server
- ✅ Comprehensive error handling
- ✅ Structured logging with Winston

### 🚀 **Production Ready**
- ✅ **Heroku** deployment configuration
- ✅ **MongoDB Atlas** integration
- ✅ Environment-based configuration
- ✅ Health check endpoints
- ✅ Graceful shutdown handling

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v16 or higher) - [Download](https://nodejs.org/)
- **npm** (comes with Node.js)
- **MongoDB** (local) or **MongoDB Atlas** account - [Setup Guide](https://docs.mongodb.com/manual/installation/)
- **Git** - [Download](https://git-scm.com/)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/profile-settings-api.git
   cd profile-settings-api
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment setup**
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit .env file with your configuration
   nano .env
   ```

4. **Configure environment variables**
   ```bash
   NODE_ENV=development
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/profile_db
   JWT_SECRET=your-super-secret-jwt-key-change-this
   JWT_EXPIRE=30d
   LOG_LEVEL=info
   ```

5. **Start MongoDB** (if using local installation)
   ```bash
   # On macOS with Homebrew
   brew services start mongodb-community
   
   # On Ubuntu/Debian
   sudo systemctl start mongod
   
   # On Windows
   net start MongoDB
   ```

6. **Build and start the application**
   ```bash
   # Development mode (with hot reload)
   npm run dev
   
   # Or build and start production mode
   npm run build
   npm start
   ```

7. **Verify installation**
   ```bash
   # Check if API is running
   curl http://localhost:3000/api/health
   
   # Expected response:
   # {"success":true,"message":"API is running","timestamp":"..."}
   ```

8. **Seed database with sample data** (optional)
   ```bash
   npm run seed
   ```

🎉 **Your API is now running at `http://localhost:3000`**

## 🔗 API Endpoints

### Authentication
- `POST /api/users/register` - Register new user
- `POST /api/users/login` - Login user

### Profile Management
- `GET /api/users/{id}` - Get user profile
- `GET /api/users` - Get all users (paginated, searchable)
- `PUT /api/users/{id}` - Update user profile
- `PUT /api/users/{id}/password` - Change password
- `PUT /api/users/{id}/profile-picture` - Upload profile picture
- `DELETE /api/users/{id}` - Delete user account

### System
- `GET /api/health` - API health check

> 📖 **Detailed API documentation:** [docs/api.md](docs/api.md)

## 📁 Project Structure

```
profile-settings-api/
├── 📁 src/                     # Source code
│   ├── 📁 config/             # Configuration files
│   │   ├── app.ts             # App configuration
│   │   ├── database.ts        # Database connection
│   │   └── logger.ts          # Logging configuration
│   ├── 📁 controllers/        # Request handlers
│   │   └── userController.ts  # User-related endpoints
│   ├── 📁 middleware/         # Custom middleware
│   │   ├── errorHandler.ts    # Error handling
│   │   ├── rateLimiter.ts     # Rate limiting
│   │   ├── upload.ts          # File upload handling
│   │   └── validation.ts      # Request validation
│   ├── 📁 models/             # Database models
│   │   └── User.ts            # User model with Mongoose
│   ├── 📁 routes/             # API routes
│   │   ├── index.ts           # Main router
│   │   └── userRoutes.ts      # User routes
│   ├── 📁 services/           # Business logic
│   │   └── userService.ts     # User operations
│   ├── 📁 types/              # TypeScript definitions
│   │   ├── api.types.ts       # API response types
│   │   ├── express.types.ts   # Express extensions
│   │   ├── index.ts           # Type exports
│   │   └── user.types.ts      # User-related types
│   ├── 📁 utils/              # Utility functions
│   │   ├── asyncHandler.ts    # Async error handling
│   │   └── fileHelper.ts      # File operations
│   ├── 📁 validators/         # Request validators
│   │   └── userValidator.ts   # User validation schemas
│   └── server.ts              # Main application entry
├── 📁 tests/                  # Test files
│   ├── 📁 unit/              # Unit tests
│   └── setup.ts              # Test configuration
├── 📁 docs/                  # Documentation
├── 📁 scripts/               # Utility scripts
├── 📁 uploads/               # File uploads (development)
├── 📁 logs/                  # Application logs
├── 📄 package.json           # Dependencies & scripts
├── 📄 tsconfig.json          # TypeScript configuration
├── 📄 .eslintrc.js           # ESLint configuration
├── 📄 .prettierrc            # Prettier configuration
├── 📄 Procfile               # Heroku deployment
└── 📄 README.md              # This file
```

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [API Documentation](docs/api.md) | Complete API endpoint reference with examples |
| [Development Guide](docs/development.md) | Development setup, tools, and best practices |
| [Deployment Guide](docs/deployment.md) | Heroku deployment and production setup |
| [Architecture Overview](docs/architecture.md) | System design and technology decisions |
| [Testing Guide](docs/testing.md) | Testing strategies and examples |
| [Contributing](docs/contributing.md) | Guidelines for contributing to the project |

## 💻 Development

### Available Scripts

```bash
# Development
npm run dev          # Start development server with hot reload
npm run dev:debug    # Start with debugging enabled

# Building
npm run build        # Compile TypeScript to JavaScript
npm run clean        # Remove build artifacts

# Code Quality
npm run lint         # Check code with ESLint
npm run lint:fix     # Fix ESLint issues automatically
npm run format       # Format code with Prettier
npm run type-check   # TypeScript type checking

# Testing
npm test             # Run all tests
npm run test:watch   # Run tests in watch mode
npm run test:coverage # Generate coverage report

# Database
npm run seed         # Populate database with sample data

# Production
npm start            # Start production server
```

### Development Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and test**
   ```bash
   npm run dev        # Start development server
   npm run lint       # Check code quality
   npm test           # Run tests
   ```

3. **Commit and push**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   git push origin feature/your-feature-name
   ```

4. **Create pull request**

> 📖 **Detailed development guide:** [docs/development.md](docs/development.md)

## 🧪 Testing

This project uses **Jest** with **Supertest** for comprehensive testing:

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode (during development)
npm run test:watch

# Run specific test file
npm test -- userController.test.ts
```

### Test Structure
- **Unit tests**: Test individual functions and methods
- **Integration tests**: Test complete API endpoints
- **Database tests**: Use in-memory MongoDB for isolation

> 📖 **Detailed testing guide:** [docs/testing.md](docs/testing.md)

## 🚀 Deployment

### Heroku Deployment

1. **Install Heroku CLI**
   ```bash
   # macOS
   brew tap heroku/brew && brew install heroku
   
   # Other platforms: https://devcenter.heroku.com/articles/heroku-cli
   ```

2. **Login and deploy**
   ```bash
   heroku login
   ./scripts/deploy-heroku.sh
   ```

3. **Set up MongoDB Atlas**
   - Create account at [MongoDB Atlas](https://cloud.mongodb.com)
   - Create cluster and get connection string
   - Set environment variable: `heroku config:set MONGODB_URI="your-atlas-uri"`

### Environment Variables for Production

```bash
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=$(openssl rand -base64 32)
heroku config:set MONGODB_URI="mongodb+srv://user:pass@cluster.mongodb.net/dbname"
heroku config:set LOG_LEVEL=info
```

> 📖 **Complete deployment guide:** [docs/deployment.md](docs/deployment.md)

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Run tests** (`npm test`)
5. **Commit your changes** (`git commit -m 'feat: add amazing feature'`)
6. **Push to the branch** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

### Code Style

- Use **TypeScript** with strict type checking
- Follow **ESLint** and **Prettier** configurations
- Write **tests** for new features
- Update **documentation** for API changes

> 📖 **Detailed contributing guide:** [docs/contributing.md](docs/contributing.md)

## 🔧 Troubleshooting

### Common Issues

**Cannot connect to MongoDB:**
```bash
# Check if MongoDB is running
sudo systemctl status mongod  # Linux
brew services list | grep mongodb  # macOS

# Start MongoDB
sudo systemctl start mongod  # Linux
brew services start mongodb-community  # macOS
```

**Port already in use:**
```bash
# Find process using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev
```

**TypeScript path mapping issues:**
```bash
# Install tsconfig-paths
npm install --save-dev tsconfig-paths

# Update dev script in package.json
"dev": "ts-node-dev -r tsconfig-paths/register --respawn --transpile-only src/server.ts"
```

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Express.js](https://expressjs.com/) - Fast, unopinionated web framework
- [MongoDB](https://www.mongodb.com/) - NoSQL database
- [Mongoose](https://mongoosejs.com/) - MongoDB object modeling
- [TypeScript](https://www.typescriptlang.org/) - Typed JavaScript
- [Jest](https://jestjs.io/) - Testing framework

## 📞 Support

- 📧 **Email**: your-email@example.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/profile-settings-api/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/profile-settings-api/discussions)

---

**Made with ❤️ by [Your Name](https://github.com/yourusername)**
EOF

print_message "README.md created successfully! ✅"
echo ""
echo -e "${BLUE}📁 File created:${NC} README.md"
echo -e "${GREEN}🎯 Features:${NC}"
echo "  ✅ Complete project overview"
echo "  ✅ Quick start guide"
echo "  ✅ API endpoints summary"
echo "  ✅ Project structure"
echo "  ✅ Development workflow"
echo "  ✅ Deployment instructions"
echo "  ✅ Troubleshooting section"




# 



#!/bin/bash

# Script to create docs/api.md for Profile Settings API

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Creating API Documentation${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

print_message "Creating docs directory..."
mkdir -p docs

print_message "Creating API documentation file..."

cat > docs/api.md << 'EOF'
# 📡 API Documentation

Complete reference for the Profile Settings API endpoints, request/response formats, and examples.

## 📋 Table of Contents

- [Base Information](#-base-information)
- [Authentication](#-authentication)
- [Profile Management](#-profile-management)
- [Error Handling](#-error-handling)
- [Rate Limiting](#-rate-limiting)
- [Examples](#-examples)

## 🌐 Base Information

### Base URL
```
Development: http://localhost:3000/api
Production:  https://your-app-name.herokuapp.com/api
```

### Response Format
All API responses follow this consistent format:

```typescript
interface ApiResponse<T = any> {
  success: boolean;       // Indicates if request was successful
  message: string;        // Human-readable message
  data?: T;              // Response data (if applicable)
  error?: string;        // Error details (if applicable)
}
```

### Content Types
- **Request**: `application/json` (except file uploads)
- **Response**: `application/json`
- **File Upload**: `multipart/form-data`

## 🔐 Authentication

### Register New User

**Endpoint:** `POST /users/register`

**Description:** Creates a new user account with profile information.

**Request Body:**
```typescript
{
  firstName: string;        // Required, max 50 characters
  lastName: string;         // Required, max 50 characters  
  email: string;           // Required, valid email format
  password: string;        // Required, minimum 6 characters
  occupation?: string;     // Optional, max 100 characters
  description?: string;    // Optional, max 500 characters
  phoneNumber?: string;    // Optional, international format
  website?: string;        // Optional, valid URL format
}
```

**Example Request:**
```bash
curl -X POST http://localhost:3000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "password": "securePassword123",
    "occupation": "Software Developer",
    "description": "Passionate full-stack developer with 5 years of experience",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.dev"
  }'
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "occupation": "Software Developer",
    "description": "Passionate full-stack developer with 5 years of experience",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.dev",
    "profilePicture": null,
    "isActive": true,
    "createdAt": "2023-12-01T10:30:00.000Z",
    "updatedAt": "2023-12-01T10:30:00.000Z"
  }
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "User with this email already exists"
}
```

---

### Login User

**Endpoint:** `POST /users/login`

**Description:** Authenticates user with email and password.

**Request Body:**
```typescript
{
  email: string;           // Required, registered email
  password: string;        // Required, user's password
}
```

**Example Request:**
```bash
curl -X POST http://localhost:3000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "securePassword123"
  }'
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "occupation": "Software Developer",
    "description": "Passionate full-stack developer",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.dev",
    "profilePicture": "/uploads/profiles/profile-123456789.jpg",
    "isActive": true,
    "createdAt": "2023-12-01T10:30:00.000Z",
    "updatedAt": "2023-12-01T10:35:00.000Z"
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

## 👤 Profile Management

### Get User Profile

**Endpoint:** `GET /users/{userId}`

**Description:** Retrieves a specific user's profile information.

**Parameters:**
- `userId` (path): MongoDB ObjectId of the user

**Example Request:**
```bash
curl http://localhost:3000/api/users/507f1f77bcf86cd799439011
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "occupation": "Software Developer",
    "description": "Passionate full-stack developer",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.dev",
    "profilePicture": "/uploads/profiles/profile-123456789.jpg",
    "isActive": true,
    "createdAt": "2023-12-01T10:30:00.000Z",
    "updatedAt": "2023-12-01T10:35:00.000Z"
  }
}
```

**Error Response (404):**
```json
{
  "success": false,
  "message": "User not found"
}
```

---

### Get All Users

**Endpoint:** `GET /users`

**Description:** Retrieves a paginated list of users with optional search functionality.

**Query Parameters:**
- `page` (optional): Page number, default: 1
- `limit` (optional): Items per page, default: 10, max: 100
- `sort` (optional): Sort field, default: "-createdAt" (newest first)
- `search` (optional): Search term (searches firstName, lastName, email, occupation)

**Example Requests:**
```bash
# Get first page with default settings
curl "http://localhost:3000/api/users"

# Get second page with 5 users per page
curl "http://localhost:3000/api/users?page=2&limit=5"

# Search for developers
curl "http://localhost:3000/api/users?search=developer"

# Search with pagination and sorting
curl "http://localhost:3000/api/users?page=1&limit=10&sort=firstName&search=john"
```

**Success Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "firstName": "John",
      "lastName": "Doe",
      "email": "john.doe@example.com",
      "occupation": "Software Developer",
      "description": "Passionate full-stack developer",
      "phoneNumber": "+1234567890",
      "website": "https://johndoe.dev",
      "profilePicture": "/uploads/profiles/profile-123456789.jpg",
      "isActive": true,
      "createdAt": "2023-12-01T10:30:00.000Z",
      "updatedAt": "2023-12-01T10:35:00.000Z"
    }
  ],
  "page": 1,
  "limit": 10,
  "total": 25,
  "pages": 3,
  "hasNext": true,
  "hasPrev": false
}
```

---

### Update User Profile

**Endpoint:** `PUT /users/{userId}`

**Description:** Updates user profile information.

**Parameters:**
- `userId` (path): MongoDB ObjectId of the user

**Request Body:**
```typescript
{
  firstName?: string;      // Optional, max 50 characters
  lastName?: string;       // Optional, max 50 characters
  email?: string;         // Optional, valid email format
  occupation?: string;    // Optional, max 100 characters
  description?: string;   // Optional, max 500 characters
  phoneNumber?: string;   // Optional, international format
  website?: string;       // Optional, valid URL format
}
```

**Example Request:**
```bash
curl -X PUT http://localhost:3000/api/users/507f1f77bcf86cd799439011 \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Jane",
    "lastName": "Smith",
    "occupation": "Senior Software Engineer",
    "description": "Full-stack developer specializing in React and Node.js"
  }'
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "firstName": "Jane",
    "lastName": "Smith",
    "email": "john.doe@example.com",
    "occupation": "Senior Software Engineer",
    "description": "Full-stack developer specializing in React and Node.js",
    "phoneNumber": "+1234567890",
    "website": "https://johndoe.dev",
    "profilePicture": "/uploads/profiles/profile-123456789.jpg",
    "isActive": true,
    "createdAt": "2023-12-01T10:30:00.000Z",
    "updatedAt": "2023-12-01T11:45:00.000Z"
  }
}
```

---

### Change Password

**Endpoint:** `PUT /users/{userId}/password`

**Description:** Changes user's password after verifying current password.

**Parameters:**
- `userId` (path): MongoDB ObjectId of the user

**Request Body:**
```typescript
{
  oldPassword: string;     // Required, current password
  newPassword: string;     // Required, new password (min 6 characters)
}
```

**Example Request:**
```bash
curl -X PUT http://localhost:3000/api/users/507f1f77bcf86cd799439011/password \
  -H "Content-Type: application/json" \
  -d '{
    "oldPassword": "securePassword123",
    "newPassword": "newSecurePassword456"
  }'
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Password updated successfully"
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "Current password is incorrect"
}
```

---

### Upload Profile Picture

**Endpoint:** `PUT /users/{userId}/profile-picture`

**Description:** Uploads and sets user's profile picture.

**Parameters:**
- `userId` (path): MongoDB ObjectId of the user

**Request Body:** `multipart/form-data`
- `profilePicture` (file): Image file

**File Requirements:**
- **Supported formats**: JPEG, PNG, GIF, WebP
- **Maximum size**: 5MB
- **Field name**: `profilePicture`

**Example Request:**
```bash
curl -X PUT http://localhost:3000/api/users/507f1f77bcf86cd799439011/profile-picture \
  -F "profilePicture=@/path/to/your/image.jpg"
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile picture updated successfully",
  "data": {
    "profilePicture": "/uploads/profiles/profile-1640995200000-123456789.jpg"
  }
}
```

**Error Responses:**
```json
// No file uploaded (400)
{
  "success": false,
  "message": "No file uploaded"
}

// Invalid file type (400)
{
  "success": false,
  "message": "Only image files are allowed for profile pictures."
}

// File too large (400)
{
  "success": false,
  "message": "File size too large. Maximum size is 5MB."
}
```

---

### Delete User Account

**Endpoint:** `DELETE /users/{userId}`

**Description:** Permanently deletes a user account and associated data.

**Parameters:**
- `userId` (path): MongoDB ObjectId of the user

**Example Request:**
```bash
curl -X DELETE http://localhost:3000/api/users/507f1f77bcf86cd799439011
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "User account deleted successfully"
}
```

**Error Response (404):**
```json
{
  "success": false,
  "message": "User not found"
}
```

## ❌ Error Handling

### Error Response Format
All errors follow this consistent format:

```typescript
{
  success: false,
  message: string,        // Human-readable error description
  error?: string         // Technical error details (development only)
}
```

### HTTP Status Codes

| Code | Description | Common Causes |
|------|-------------|---------------|
| `200` | OK | Successful GET, PUT requests |
| `201` | Created | Successful POST requests |
| `400` | Bad Request | Validation errors, malformed requests |
| `401` | Unauthorized | Invalid credentials, missing authentication |
| `404` | Not Found | Resource doesn't exist |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | Server-side errors |

### Common Error Examples

**Validation Error (400):**
```json
{
  "success": false,
  "message": "\"email\" must be a valid email"
}
```

**Authentication Error (401):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

**Not Found Error (404):**
```json
{
  "success": false,
  "message": "User not found"
}
```

**Rate Limit Error (429):**
```json
{
  "success": false,
  "message": "Too many requests from this IP, please try again later."
}
```

## 🚦 Rate Limiting

To prevent abuse, the API implements rate limiting:

### Limits
- **Authentication endpoints** (`/register`, `/login`): **5 requests per 15 minutes**
- **General endpoints**: **100 requests per 15 minutes**
- **Per IP address**: Applied to all requests from the same IP

### Headers
Rate limit information is included in response headers:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

### Rate Limit Exceeded Response
```json
{
  "success": false,
  "message": "Too many requests from this IP, please try again later."
}
```

## 📚 Examples

### Complete User Registration Flow

```bash
# 1. Register new user
curl -X POST http://localhost:3000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Alice",
    "lastName": "Johnson",
    "email": "alice@example.com",
    "password": "securePass123",
    "occupation": "UX Designer"
  }'

# Response: User created with ID 507f1f77bcf86cd799439012

# 2. Login to verify account
curl -X POST http://localhost:3000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alice@example.com",
    "password": "securePass123"
  }'

# 3. Upload profile picture
curl -X PUT http://localhost:3000/api/users/507f1f77bcf86cd799439012/profile-picture \
  -F "profilePicture=@alice-photo.jpg"

# 4. Update profile information
curl -X PUT http://localhost:3000/api/users/507f1f77bcf86cd799439012 \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Creative UX designer with expertise in user research",
    "website": "https://alice-designs.com",
    "phoneNumber": "+1555123456"
  }'
```

### Search Users Example

```bash
# Search for developers
curl "http://localhost:3000/api/users?search=developer&page=1&limit=5"

# Search with multiple criteria
curl "http://localhost:3000/api/users?search=john&sort=firstName&page=1&limit=10"

# Get all users sorted by creation date
curl "http://localhost:3000/api/users?sort=-createdAt&limit=20"
```

### JavaScript/Fetch Examples

```javascript
// Register user with fetch
async function registerUser(userData) {
  try {
    const response = await fetch('http://localhost:3000/api/users/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(userData)
    });
    
    const result = await response.json();
    
    if (result.success) {
      console.log('User registered:', result.data);
      return result.data;
    } else {
      console.error('Registration failed:', result.message);
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Network error:', error);
    throw error;
  }
}

// Upload profile picture with fetch
async function uploadProfilePicture(userId, file) {
  try {
    const formData = new FormData();
    formData.append('profilePicture', file);
    
    const response = await fetch(`http://localhost:3000/api/users/${userId}/profile-picture`, {
      method: 'PUT',
      body: formData
    });
    
    const result = await response.json();
    
    if (result.success) {
      console.log('Profile picture updated:', result.data.profilePicture);
      return result.data.profilePicture;
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Upload failed:', error);
    throw error;
  }
}

// Search users with pagination
async function searchUsers(searchTerm, page = 1, limit = 10) {
  try {
    const params = new URLSearchParams({
      search: searchTerm,
      page: page.toString(),
      limit: limit.toString()
    });
    
    const response = await fetch(`http://localhost:3000/api/users?${params}`);
    const result = await response.json();
    
    if (result.success) {
      return {
        users: result.data,
        pagination: {
          page: result.page,
          limit: result.limit,
          total: result.total,
          pages: result.pages,
          hasNext: result.hasNext,
          hasPrev: result.hasPrev
        }
      };
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Search failed:', error);
    throw error;
  }
}
```

### Python Requests Examples

```python
import requests
import json

# Base URL
BASE_URL = "http://localhost:3000/api"

# Register user
def register_user(user_data):
    response = requests.post(
        f"{BASE_URL}/users/register",
        headers={"Content-Type": "application/json"},
        json=user_data
    )
    
    result = response.json()
    if result["success"]:
        print(f"User registered: {result['data']['email']}")
        return result["data"]
    else:
        raise Exception(f"Registration failed: {result['message']}")

# Login user
def login_user(email, password):
    response = requests.post(
        f"{BASE_URL}/users/login",
        headers={"Content-Type": "application/json"},
        json={"email": email, "password": password}
    )
    
    result = response.json()
    if result["success"]:
        print(f"Login successful: {result['data']['email']}")
        return result["data"]
    else:
        raise Exception(f"Login failed: {result['message']}")

# Upload profile picture
def upload_profile_picture(user_id, file_path):
    with open(file_path, 'rb') as file:
        files = {'profilePicture': file}
        response = requests.put(
            f"{BASE_URL}/users/{user_id}/profile-picture",
            files=files
        )
    
    result = response.json()
    if result["success"]:
        print(f"Profile picture uploaded: {result['data']['profilePicture']}")
        return result["data"]["profilePicture"]
    else:
        raise Exception(f"Upload failed: {result['message']}")

# Example usage
if __name__ == "__main__":
    # Register new user
    user_data = {
        "firstName": "Bob",
        "lastName": "Wilson",
        "email": "bob@example.com",
        "password": "securePassword123",
        "occupation": "Data Scientist"
    }
    
    user = register_user(user_data)
    user_id = user["_id"]
    
    # Login
    login_user("bob@example.com", "securePassword123")
    
    # Upload profile picture
    upload_profile_picture(user_id, "profile.jpg")
```

## 🔧 Testing the API

### Using Postman

1. **Import Collection**: Create a new Postman collection
2. **Set Environment Variables**:
   - `base_url`: `http://localhost:3000/api`
   - `user_id`: (set after registration)

3. **Test Endpoints**:
   ```
   POST {{base_url}}/users/register
   POST {{base_url}}/users/login
   GET  {{base_url}}/users/{{user_id}}
   PUT  {{base_url}}/users/{{user_id}}
   ```

### Health Check

Before testing any endpoints, verify the API is running:

```bash
curl http://localhost:3000/api/health

# Expected response:
{
  "success": true,
  "message": "API is running",
  "timestamp": "2023-12-01T12:00:00.000Z",
  "uptime": 3600
}
```

## 📝 Notes

### File Storage
- **Development**: Files stored in `uploads/profiles/` directory
- **Production (Heroku)**: Use cloud storage (Cloudinary, AWS S3) due to ephemeral filesystem

### Database Considerations
- **ObjectIds**: All user IDs are MongoDB ObjectIds (24-character hex strings)
- **Indexing**: Email field is indexed for fast lookups
- **Validation**: Both client-side (Joi) and database-side (Mongoose) validation

### Security Features
- **Password Hashing**: bcrypt with 12 salt rounds
- **Input Sanitization**: All input is validated and sanitized
- **Rate Limiting**: Prevents brute force attacks
- **CORS**: Configured for cross-origin requests
- **Security Headers**: Helmet middleware adds security headers

---

For more information, see the [main documentation](../README.md) or [development guide](development.md).
EOF

print_message "API documentation created successfully! ✅"
echo ""
echo -e "${BLUE}📁 File created:${NC} docs/api.md"
echo -e "${GREEN}🎯 Features:${NC}"
echo "  ✅ Complete API endpoint reference"
echo "  ✅ Request/response examples"
echo "  ✅ Error handling guide"
echo "  ✅ Rate limiting information"
echo "  ✅ Multiple language examples"
echo "  ✅ Testing instructions"






#!/bin/bash

# Script to create docs/development.md for Profile Settings API

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Creating Development Guide${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

print_message "Creating docs directory..."
mkdir -p docs

print_message "Creating development guide file..."

cat > docs/development.md << 'EOF'
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
EOF

print_message "Development guide created successfully! ✅"
echo ""
echo -e "${BLUE}📁 File created:${NC} docs/development.md"
echo -e "${GREEN}🎯 Features:${NC}"
echo "  ✅ Complete development setup guide"
echo "  ✅ Project architecture overview"
echo "  ✅ Development workflow"
echo "  ✅ Code standards and conventions"
echo "  ✅ Testing strategies"
echo "  ✅ Debugging techniques"
echo "  ✅ Performance optimization"
echo "  ✅ Troubleshooting section"





#!/bin/bash

# Script to create docs/deployment.md for Profile Settings API

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Creating Deployment Guide${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

print_message "Creating docs directory..."
mkdir -p docs

print_message "Creating deployment guide file..."

cat > docs/deployment.md << 'EOF'
# 🚀 Deployment Guide

Complete guide for deploying the Profile Settings API to production environments, with focus on Heroku deployment.

## 📋 Table of Contents

- [Production Checklist](#-production-checklist)
- [Heroku Deployment](#-heroku-deployment)
- [Environment Configuration](#-environment-configuration)
- [Database Setup](#-database-setup)
- [File Storage](#-file-storage)
- [Monitoring & Logging](#-monitoring--logging)
- [Security Considerations](#-security-considerations)
- [Troubleshooting](#-troubleshooting)

## ✅ Production Checklist

Before deploying to production, ensure you have:

### Code Quality
- [ ] All tests passing (`npm test`)
- [ ] No TypeScript errors (`npm run type-check`)
- [ ] No linting errors (`npm run lint`)
- [ ] Code coverage above 80%
- [ ] Security audit clean (`npm audit`)

### Configuration
- [ ] Production environment variables set
- [ ] MongoDB Atlas cluster created and configured
- [ ] Cloud storage setup (for file uploads)
- [ ] Logging configuration updated
- [ ] Error monitoring setup

### Security
- [ ] Strong JWT secret generated
- [ ] CORS configured for production domain
- [ ] Rate limiting enabled
- [ ] Input validation implemented
- [ ] Security headers configured

## 🟣 Heroku Deployment

### Prerequisites

1. **Install Heroku CLI**
   ```bash
   # macOS
   brew tap heroku/brew && brew install heroku
   
   # Windows
   # Download from https://devcenter.heroku.com/articles/heroku-cli
   
   # Ubuntu/Debian
   curl https://cli-assets.heroku.com/install.sh | sh
   ```

2. **Verify Installation**
   ```bash
   heroku --version
   heroku login
   ```

### Automated Deployment

Use the provided deployment script:

```bash
# Make script executable
chmod +x scripts/deploy-heroku.sh

# Run deployment
./scripts/deploy-heroku.sh
```

### Manual Deployment Steps

**1. Create Heroku Application**
```bash
# Create new app
heroku create your-app-name

# Or use existing app
heroku git:remote -a your-existing-app-name
```

**2. Configure Build Settings**
```bash
# Set Node.js version (optional)
echo "node 18.x" > .nvmrc

# Heroku will automatically detect Node.js buildpack
```

**3. Set Environment Variables**
```bash
# Required environment variables
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=$(openssl rand -base64 32)
heroku config:set JWT_EXPIRE=30d
heroku config:set LOG_LEVEL=info

# MongoDB Atlas URI (see Database Setup section)
heroku config:set MONGODB_URI="mongodb+srv://username:password@cluster.mongodb.net/dbname?retryWrites=true&w=majority"
```

**4. Deploy Application**
```bash
# Add files to git
git add .
git commit -m "Deploy to production"

# Deploy to Heroku
git push heroku main

# Check deployment status
heroku ps
```

**5. Verify Deployment**
```bash
# Open application
heroku open

# Check API health
curl https://your-app-name.herokuapp.com/api/health

# View logs
heroku logs --tail
```

### Heroku Configuration Files

**Procfile** (tells Heroku how to run your app):
```
web: npm start
```

**package.json** (production scripts):
```json
{
  "scripts": {
    "build": "tsc",
    "start": "node dist/server.js",
    "heroku-postbuild": "npm run build"
  },
  "engines": {
    "node": "18.x",
    "npm": "8.x"
  }
}
```

**app.json** (for easy deployment):
```json
{
  "name": "Profile Settings API",
  "description": "TypeScript Profile Settings API with Express.js and MongoDB",
  "repository": "https://github.com/yourusername/profile-settings-api",
  "keywords": ["node", "typescript", "express", "mongodb", "api"],
  "env": {
    "NODE_ENV": {
      "description": "Node environment",
      "value": "production"
    },
    "MONGODB_URI": {
      "description": "MongoDB Atlas connection string",
      "required": true
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
      "plan": "papertrail:choklad"
    }
  ]
}
```

## ⚙️ Environment Configuration

### Production Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `PORT` | Server port (auto-set by Heroku) | `3000` |
| `MONGODB_URI` | MongoDB connection string | `mongodb+srv://...` |
| `JWT_SECRET` | JWT signing secret | Generate with `openssl rand -base64 32` |
| `JWT_EXPIRE` | JWT expiration time | `30d` |
| `LOG_LEVEL` | Logging level | `info` or `error` |

### Setting Environment Variables

**Via Heroku CLI:**
```bash
heroku config:set VARIABLE_NAME="value"
heroku config:set JWT_SECRET="your-super-secret-key"
```

**Via Heroku Dashboard:**
1. Go to your app's dashboard
2. Navigate to Settings tab
3. Click "Reveal Config Vars"
4. Add your variables

**Viewing Environment Variables:**
```bash
# List all config vars
heroku config

# Get specific variable
heroku config:get JWT_SECRET
```

## 🗄️ Database Setup

### MongoDB Atlas (Recommended)

**1. Create Account and Cluster**
```bash
# Sign up at https://cloud.mongodb.com
# Create new cluster (free tier available)
# Choose cloud provider and region
```

**2. Configure Database Access**
```bash
# Create database user
# Go to Database Access → Add New Database User
Username: api-user
Password: <generate-strong-password>
Role: Read and write to any database
```

**3. Configure Network Access**
```bash
# Go to Network Access → Add IP Address
# For development: Add current IP
# For production: Add 0.0.0.0/0 (allow all) or specific IPs
```

**4. Get Connection String**
```bash
# Go to Clusters → Connect → Connect your application
# Copy connection string:
mongodb+srv://api-user:<password>@cluster0.xxxxx.mongodb.net/<dbname>?retryWrites=true&w=majority

# Replace <password> and <dbname>
mongodb+srv://api-user:yourpassword@cluster0.xxxxx.mongodb.net/profile_production?retryWrites=true&w=majority
```

**5. Set Environment Variable**
```bash
heroku config:set MONGODB_URI="mongodb+srv://api-user:yourpassword@cluster0.xxxxx.mongodb.net/profile_production?retryWrites=true&w=majority"
```

### Database Migration and Seeding

**Production Database Setup:**
```bash
# Connect to production database
heroku config:get MONGODB_URI

# Seed production database (optional)
heroku run npm run seed

# Or connect locally to production DB
MONGODB_URI="your-production-uri" npm run seed
```

**Backup and Restore:**
```bash
# Create backup using mongodump
mongodump --uri="your-mongodb-atlas-uri" --out=backup/

# Restore from backup
mongorestore --uri="your-mongodb-atlas-uri" backup/
```

## 📁 File Storage

### Problem: Heroku Ephemeral Filesystem

Heroku has an **ephemeral filesystem** - uploaded files are deleted when dynos restart. You need cloud storage for production.

### Option 1: Cloudinary (Recommended)

**1. Setup Cloudinary Account**
```bash
# Sign up at https://cloudinary.com (free tier available)
# Get credentials from dashboard
```

**2. Install Cloudinary SDK**
```bash
npm install cloudinary multer-storage-cloudinary
npm install --save-dev @types/multer-storage-cloudinary
```

**3. Configure Cloudinary**
```typescript
// src/config/cloudinary.ts
import { v2 as cloudinary } from 'cloudinary';
import { CloudinaryStorage } from 'multer-storage-cloudinary';

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

export const cloudinaryStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'profile-pictures',
    allowed_formats: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    transformation: [
      { width: 500, height: 500, crop: 'fill' },
      { quality: 'auto' }
    ],
  },
});
```

**4. Set Environment Variables**
```bash
heroku config:set CLOUDINARY_CLOUD_NAME="your-cloud-name"
heroku config:set CLOUDINARY_API_KEY="your-api-key"
heroku config:set CLOUDINARY_API_SECRET="your-api-secret"
```

### Option 2: AWS S3

**1. Setup AWS Account and S3 Bucket**
```bash
# Create AWS account
# Create S3 bucket with public read access
# Create IAM user with S3 permissions
```

**2. Install AWS SDK**
```bash
npm install aws-sdk multer-s3
npm install --save-dev @types/multer-s3
```

**3. Set Environment Variables**
```bash
heroku config:set AWS_ACCESS_KEY_ID="your-access-key"
heroku config:set AWS_SECRET_ACCESS_KEY="your-secret-key"
heroku config:set AWS_REGION="us-east-1"
heroku config:set AWS_S3_BUCKET_NAME="your-bucket-name"
```

## 📊 Monitoring & Logging

### Heroku Add-ons

**1. Papertrail (Logging)**
```bash
# Add Papertrail for log aggregation
heroku addons:create papertrail:choklad

# View logs
heroku addons:open papertrail
```

**2. New Relic (Performance Monitoring)**
```bash
# Add New Relic for APM
heroku addons:create newrelic:wayne

# Configure
heroku config:set NEW_RELIC_APP_NAME="Profile Settings API"
```

### Custom Monitoring

**1. Health Check Endpoint**
```typescript
// Enhanced health check
app.get('/api/health', async (req: Request, res: Response) => {
  try {
    // Check database connection
    await mongoose.connection.db.admin().ping();
    
    res.json({
      success: true,
      message: 'API is running',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      environment: process.env.NODE_ENV,
      version: process.env.npm_package_version
    });
  } catch (error) {
    res.status(503).json({
      success: false,
      message: 'Service unavailable',
      error: 'Database connection failed'
    });
  }
});
```

**2. Application Metrics**
```typescript
// src/middleware/metrics.ts
let requestCount = 0;
let errorCount = 0;

export const metricsMiddleware = (req: Request, res: Response, next: NextFunction) => {
  requestCount++;
  
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    
    if (res.statusCode >= 400) {
      errorCount++;
    }
    
    logger.info('Request metrics', {
      method: req.method,
      url: req.url,
      statusCode: res.statusCode,
      duration,
      requestCount,
      errorCount,
      errorRate: (errorCount / requestCount * 100).toFixed(2)
    });
  });
  
  next();
};
```

## 🔒 Security Considerations

### Production Security Checklist

- [ ] **Strong JWT Secret**: Use `openssl rand -base64 32`
- [ ] **Environment Variables**: Never commit secrets to git
- [ ] **HTTPS**: Heroku provides SSL by default
- [ ] **CORS**: Configure for your domain only
- [ ] **Rate Limiting**: Enabled and tuned for production
- [ ] **Input Validation**: All endpoints validated
- [ ] **Error Handling**: No sensitive data in error messages
- [ ] **Dependencies**: Regular security audits

### Security Configuration

**1. Production CORS Setup**
```typescript
// src/server.ts
const corsOptions = {
  origin: process.env.NODE_ENV === 'production'
    ? ['https://yourfrontend.com', 'https://yourdomain.com']
    : true, // Allow all origins in development
  credentials: true,
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));
```

**2. Enhanced Rate Limiting**
```typescript
// src/middleware/rateLimiter.ts
export const productionLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: process.env.NODE_ENV === 'production' ? 50 : 1000,
  message: {
    success: false,
    message: 'Too many requests, please try again later.'
  },
  standardHeaders: true,
  legacyHeaders: false,
});
```

**3. Security Headers**
```typescript
// Enhanced helmet configuration
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));
```

## 🔧 Troubleshooting

### Common Deployment Issues

**1. Build Failures**
```bash
# Check build logs
heroku logs --tail --dyno web

# Common causes:
# - TypeScript compilation errors
# - Missing dependencies
# - Node/npm version mismatch

# Solutions:
heroku config:set NODE_ENV=production
npm run type-check
npm audit fix
```

**2. Database Connection Issues**
```bash
# Test connection string locally
MONGODB_URI="your-atlas-uri" node -e "
const mongoose = require('mongoose');
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('Connected!'))
  .catch(err => console.error('Failed:', err));
"

# Common issues:
# - Incorrect credentials
# - Network access not configured
# - Wrong database name
```

**3. Memory Issues**
```bash
# Monitor memory usage
heroku logs --tail | grep "Memory"

# Scale up dyno if needed
heroku ps:scale web=1:standard-1x

# Optimize memory usage
# - Use lean() queries
# - Implement pagination
# - Clear unused variables
```

**4. File Upload Issues**
```bash
# Check if cloud storage is configured
heroku config | grep CLOUDINARY

# Test upload endpoint
curl -X PUT https://your-app.herokuapp.com/api/users/ID/profile-picture \
  -F "profilePicture=@test.jpg"
```

### Debugging Production Issues

**1. Log Analysis**
```bash
# View real-time logs
heroku logs --tail

# Search logs
heroku logs --grep "ERROR"

# Download logs
heroku logs -n 1500 > app-logs.txt
```

**2. Database Debugging**
```bash
# Connect to production database
heroku config:get MONGODB_URI
mongosh "your-mongodb-uri"

# Check collections
show collections
db.users.findOne()
db.users.countDocuments()
```

**3. Performance Debugging**
```bash
# Check dyno metrics
heroku ps
heroku logs --ps web

# Monitor response times
heroku logs --tail | grep "duration"
```

### Recovery Procedures

**1. Rollback Deployment**
```bash
# View releases
heroku releases

# Rollback to previous version
heroku rollback v123
```

**2. Database Recovery**
```bash
# Restore from backup
mongorestore --uri="production-uri" backup-folder/

# Reset to known good state
heroku run npm run seed
```

**3. Emergency Scaling**
```bash
# Scale up resources
heroku ps:scale web=2:standard-1x

# Scale down during maintenance
heroku ps:scale web=0
```

### Getting Support

**Heroku Support:**
- Documentation: https://devcenter.heroku.com/
- Status page: https://status.heroku.com/
- Support tickets: Available with paid plans

**MongoDB Atlas Support:**
- Documentation: https://docs.atlas.mongodb.com/
- Community forums: https://community.mongodb.com/
- Support: Available with paid plans

---

For more information, see the [main documentation](../README.md) or [development guide](development.md).
EOF

print_message "Deployment guide created successfully! ✅"
echo ""
echo -e "${BLUE}📁 File created:${NC} docs/deployment.md"
echo -e "${GREEN}🎯 Features:${NC}"
echo "  ✅ Complete Heroku deployment guide"
echo "  ✅ MongoDB Atlas setup instructions"
echo "  ✅ Environment configuration"
echo "  ✅ File storage solutions"
echo "  ✅ Monitoring and logging setup"
echo "  ✅ Security considerations"
echo "  ✅ Troubleshooting section"