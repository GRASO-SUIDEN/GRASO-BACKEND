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
