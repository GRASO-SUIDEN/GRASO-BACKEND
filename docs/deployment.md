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
