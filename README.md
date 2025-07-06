# 🚀 GRASO BE API

> ### Profile Settings

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
   git clone https://github.com/GRASO-SUIDEN/GRASO-BACKEND.git
   cd GRASO-BACKEND
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

| Document                                      | Description                                   |
| --------------------------------------------- | --------------------------------------------- |
| [API Documentation](docs/api.md)              | Complete API endpoint reference with examples |
| [Development Guide](docs/development.md)      | Development setup, tools, and best practices  |
| [Deployment Guide](docs/deployment.md)        | Heroku deployment and production setup        |
| [Architecture Overview](docs/architecture.md) | System design and technology decisions        |
| [Testing Guide](docs/testing.md)              | Testing strategies and examples               |
| [Contributing](docs/contributing.md)          | Guidelines for contributing to the project    |

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
