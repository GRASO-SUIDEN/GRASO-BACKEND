#!/bin/bash

# generate_register_test.sh - Generate TypeScript test for user registration
# Usage: ./generate_register_test.sh

echo "🚀 Generating TypeScript test for User Registration endpoint"
echo "==========================================================="

# Create the TypeScript test file
cat > test_register.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

interface RegisterData {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  occupation: string;
  description: string;
  phoneNumber: string;
  website: string;
  walletAddress: string;
}

interface ApiResponse {
  success: boolean;
  message: string;
  data?: any;
  user?: any;
  token?: string;
}

const testRegisterUser = async (): Promise<void> => {
  try {
    console.log('🧪 Testing User Registration Endpoint');
    console.log('====================================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
    const endpoint = `${baseUrl}/api/users/register`;

    console.log(`📡 Endpoint: ${endpoint}`);

    // Test user data
    const userData: RegisterData = {
      firstName: 'TestUser',
      lastName: 'Generated',
      email: `test${Date.now()}@example.com`, // Unique email
      password: 'testPassword123!',
      occupation: 'QA Engineer',
      description: 'Test user created by TypeScript script',
      phoneNumber: '+1234567890',
      website: 'https://test-user.dev',
      walletAddress: `0x${Math.random().toString(16).substring(2, 42)}`
    };

    console.log('📝 User Data:');
    console.log(JSON.stringify(userData, null, 2));
    console.log('');

    // Make the registration request
    console.log('🚀 Sending registration request...');
    const startTime = Date.now();

    const response = await axios.post<ApiResponse>(endpoint, userData, {
      headers: {
        'Content-Type': 'application/json',
      },
      timeout: 10000, // 10 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if registration was successful
    if (response.status === 200 || response.status === 201) {
      console.log('✅ User registration successful!');
      
      // Extract user information
      const user = response.data.user || response.data.data || response.data;
      if (user && user.email) {
        console.log(`👤 Created User: ${user.firstName} ${user.lastName} (${user.email})`);
        
        // Save user ID for other tests
        if (user._id || user.id) {
          const userId = user._id || user.id;
          console.log(`🆔 User ID: ${userId}`);
          
          // Save to file for other tests
          require('fs').writeFileSync('.test_user_id', userId);
          console.log('💾 User ID saved to .test_user_id file');
        }
      }

      // Save token if provided
      if (response.data.token) {
        console.log(`🎫 Token received: ${response.data.token.substring(0, 20)}...`);
        require('fs').writeFileSync('.test_auth_token', response.data.token);
        console.log('💾 Token saved to .test_auth_token file');
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Registration test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 400) {
        console.error('   💡 Tip: Check if user data meets validation requirements');
      } else if (error.response.status === 409) {
        console.error('   💡 Tip: User might already exist, try with different email');
      } else if (error.response.status === 500) {
        console.error('   💡 Tip: Check server logs and database connection');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Registration test completed!');
};

// Run the test
testRegisterUser();
EOF

echo "✅ TypeScript registration test generated: test_register.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Create .env file with BASE_URL=http://localhost:3000"
echo "   3. npx ts-node test_register.ts"
echo ""
echo "💡 The test will:"
echo "   - Generate unique user data"
echo "   - Test the registration endpoint"
echo "   - Save user ID and token for other tests"
echo "   - Provide detailed error diagnostics"




















#!/bin/bash

# generate_login_test.sh - Generate TypeScript test for user login
# Usage: ./generate_login_test.sh

echo "🔐 Generating TypeScript test for User Login endpoint"
echo "==================================================="

# Create the TypeScript test file
cat > test_login.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';

// Load environment variables
dotenv.config();

interface LoginData {
  email: string;
  password: string;
}

interface LoginResponse {
  success: boolean;
  message: string;
  token?: string;
  accessToken?: string;
  user?: any;
  data?: any;
}

const testLoginUser = async (): Promise<void> => {
  try {
    console.log('🔐 Testing User Login Endpoint');
    console.log('==============================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
    const endpoint = `${baseUrl}/api/users/login`;

    console.log(`📡 Endpoint: ${endpoint}`);

    // Get login credentials from environment or use defaults from seed data
    const email = process.env.TEST_EMAIL || 'maziofweb3@example.com';
    const password = process.env.TEST_PASSWORD || 'passssssss';

    const loginData: LoginData = {
      email,
      password
    };

    console.log('📝 Login Data:');
    console.log(`   Email: ${loginData.email}`);
    console.log(`   Password: ${'*'.repeat(loginData.password.length)}`);
    console.log('');

    // Make the login request
    console.log('🚀 Sending login request...');
    const startTime = Date.now();

    const response = await axios.post<LoginResponse>(endpoint, loginData, {
      headers: {
        'Content-Type': 'application/json',
      },
      timeout: 10000, // 10 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if login was successful
    if (response.status === 200) {
      console.log('✅ User login successful!');
      
      // Extract token
      const token = response.data.token || response.data.accessToken;
      if (token) {
        console.log(`🎫 Token received: ${token.substring(0, 20)}...`);
        
        // Save token to file for other tests
        fs.writeFileSync('.test_auth_token', token);
        console.log('💾 Token saved to .test_auth_token file');
      } else {
        console.log('⚠️  No token received in response');
      }

      // Extract user information
      const user = response.data.user || response.data.data;
      if (user) {
        console.log(`👤 Logged in User: ${user.firstName} ${user.lastName} (${user.email})`);
        
        // Save user ID
        if (user._id || user.id) {
          const userId = user._id || user.id;
          console.log(`🆔 User ID: ${userId}`);
          fs.writeFileSync('.test_user_id', userId);
          console.log('💾 User ID saved to .test_user_id file');
        }
      }

    } else {
      console.log('❌ Unexpected response status');
    }

    // Test token validation (if we have a token)
    const token = response.data.token || response.data.accessToken;
    if (token) {
      console.log('');
      console.log('🔍 Testing token validation...');
      
      try {
        const testResponse = await axios.get(`${baseUrl}/api/users`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          },
          timeout: 5000
        });

        if (testResponse.status === 200) {
          console.log('✅ Token is valid and working!');
        } else {
          console.log('⚠️  Token validation returned unexpected status');
        }
      } catch (tokenError: any) {
        console.log('❌ Token validation failed');
        if (tokenError.response?.status === 401) {
          console.log('   💡 Token might be invalid or expired');
        }
      }
    }

  } catch (error: any) {
    console.error('💥 Login test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Check if email and password are correct');
      } else if (error.response.status === 404) {
        console.error('   💡 Tip: User might not exist, try registering first');
      } else if (error.response.status === 500) {
        console.error('   💡 Tip: Check server logs and database connection');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Login test completed!');
};

// Run the test
testLoginUser();
EOF

echo "✅ TypeScript login test generated: test_login.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Create .env file with:"
echo "      BASE_URL=http://localhost:3000"
echo "      TEST_EMAIL=maziofweb3@example.com"
echo "      TEST_PASSWORD=passssssss"
echo "   3. npx ts-node test_login.ts"
echo ""
echo "💡 The test will:"
echo "   - Login with provided credentials"
echo "   - Save authentication token for other tests"
echo "   - Validate the token works"
echo "   - Provide detailed error diagnostics"















#!/bin/bash

# generate_update_user_test.sh - Generate TypeScript test for updating user details
# Usage: ./generate_update_user_test.sh

echo "✏️ Generating TypeScript test for Update User endpoint"
echo "===================================================="

# Create the TypeScript test file
cat > test_update_user.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';

// Load environment variables
dotenv.config();

interface UpdateUserData {
  firstName?: string;
  lastName?: string;
  occupation?: string;
  description?: string;
  phoneNumber?: string;
  website?: string;
  walletAddress?: string;
}

interface ApiResponse {
  success: boolean;
  message: string;
  data?: any;
  user?: any;
}

const testUpdateUser = async (): Promise<void> => {
  try {
    console.log('✏️ Testing Update User Endpoint');
    console.log('===============================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

    // Get user ID and token from files or environment
    let userId = process.env.TEST_USER_ID;
    let token = process.env.TEST_AUTH_TOKEN;

    // Try to read from files if not in environment
    if (!userId && fs.existsSync('.test_user_id')) {
      userId = fs.readFileSync('.test_user_id', 'utf8').trim();
    }

    if (!token && fs.existsSync('.test_auth_token')) {
      token = fs.readFileSync('.test_auth_token', 'utf8').trim();
    }

    if (!userId) {
      console.error('❌ No user ID found. Please run login test first or set TEST_USER_ID');
      process.exit(1);
    }

    if (!token) {
      console.error('❌ No auth token found. Please run login test first or set TEST_AUTH_TOKEN');
      process.exit(1);
    }

    const endpoint = `${baseUrl}/api/users/${userId}`;

    console.log(`📡 Endpoint: ${endpoint}`);
    console.log(`🆔 User ID: ${userId}`);
    console.log(`🎫 Token: ${token.substring(0, 20)}...`);
    console.log('');

    // First, get current user data
    console.log('📋 Getting current user data...');
    const currentUserResponse = await axios.get(endpoint, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });

    const currentUser = currentUserResponse.data.user || currentUserResponse.data.data || currentUserResponse.data;
    console.log('Current user data:');
    console.log(JSON.stringify(currentUser, null, 2));
    console.log('');

    // Update data with timestamp to show changes
    const timestamp = new Date().toISOString();
    const updateData: UpdateUserData = {
      firstName: 'Updated',
      lastName: 'User',
      occupation: 'Senior TypeScript Developer',
      description: `Profile updated via TypeScript test at ${timestamp}`,
      phoneNumber: '+1987654321',
      website: 'https://updated-profile.dev',
      walletAddress: currentUser.walletAddress // Keep existing wallet address
    };

    console.log('📝 Update Data:');
    console.log(JSON.stringify(updateData, null, 2));
    console.log('');

    // Make the update request
    console.log('🚀 Sending update request...');
    const startTime = Date.now();

    const response = await axios.put<ApiResponse>(endpoint, updateData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      timeout: 10000, // 10 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if update was successful
    if (response.status === 200 || response.status === 204) {
      console.log('✅ User update successful!');

      // Verify the update by fetching user again
      console.log('');
      console.log('🔍 Verifying update by fetching user data...');
      
      const verifyResponse = await axios.get(endpoint, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });

      const updatedUser = verifyResponse.data.user || verifyResponse.data.data || verifyResponse.data;
      
      console.log('Updated user data:');
      console.log(JSON.stringify(updatedUser, null, 2));

      // Check specific fields were updated
      const fieldsToCheck = ['firstName', 'lastName', 'occupation', 'description'];
      let updatedFields = 0;

      fieldsToCheck.forEach(field => {
        if (updatedUser[field] === updateData[field]) {
          console.log(`   ✅ ${field}: Updated successfully`);
          updatedFields++;
        } else {
          console.log(`   ❌ ${field}: Update failed`);
          console.log(`      Expected: ${updateData[field]}`);
          console.log(`      Actual: ${updatedUser[field]}`);
        }
      });

      if (updatedFields === fieldsToCheck.length) {
        console.log('🎉 All fields updated successfully!');
      } else {
        console.log(`⚠️  Only ${updatedFields}/${fieldsToCheck.length} fields updated`);
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Update user test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Token might be invalid or expired, try logging in again');
      } else if (error.response.status === 403) {
        console.error('   💡 Tip: You might not have permission to update this user');
      } else if (error.response.status === 404) {
        console.error('   💡 Tip: User not found, check the user ID');
      } else if (error.response.status === 400) {
        console.error('   💡 Tip: Check if update data meets validation requirements');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Update user test completed!');
};

// Run the test
testUpdateUser();
EOF

echo "✅ TypeScript update user test generated: test_update_user.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Make sure you have .test_user_id and .test_auth_token files (run login test first)"
echo "   3. npx ts-node test_update_user.ts"
echo ""
echo "💡 The test will:"
echo "   - Get current user data"
echo "   - Update user profile with new information"
echo "   - Verify the update was successful"
echo "   - Compare before and after data"















#!/bin/bash

# generate_get_user_test.sh - Generate TypeScript test for getting user details
# Usage: ./generate_get_user_test.sh

echo "👤 Generating TypeScript test for Get User endpoint"
echo "================================================="

# Create the TypeScript test file
cat > test_get_user.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';

// Load environment variables
dotenv.config();

interface User {
  _id?: string;
  id?: string;
  firstName: string;
  lastName: string;
  email: string;
  occupation: string;
  description: string;
  phoneNumber: string;
  website: string;
  walletAddress: string;
  createdAt?: string;
  updatedAt?: string;
}

interface ApiResponse {
  success: boolean;
  message: string;
  data?: User;
  user?: User;
}

const testGetUser = async (): Promise<void> => {
  try {
    console.log('👤 Testing Get User Endpoint');
    console.log('============================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

    // Get user ID and token from files or environment
    let userId = process.env.TEST_USER_ID;
    let token = process.env.TEST_AUTH_TOKEN;

    // Try to read from files if not in environment
    if (!userId && fs.existsSync('.test_user_id')) {
      userId = fs.readFileSync('.test_user_id', 'utf8').trim();
    }

    if (!token && fs.existsSync('.test_auth_token')) {
      token = fs.readFileSync('.test_auth_token', 'utf8').trim();
    }

    if (!userId) {
      console.error('❌ No user ID found. Please run login test first or set TEST_USER_ID');
      process.exit(1);
    }

    const endpoint = `${baseUrl}/api/users/${userId}`;

    console.log(`📡 Endpoint: ${endpoint}`);
    console.log(`🆔 User ID: ${userId}`);
    if (token) {
      console.log(`🎫 Token: ${token.substring(0, 20)}...`);
    }
    console.log('');

    // Prepare headers
    const headers: any = {
      'Content-Type': 'application/json'
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    // Make the get user request
    console.log('🚀 Sending get user request...');
    const startTime = Date.now();

    const response = await axios.get<ApiResponse>(endpoint, {
      headers,
      timeout: 10000, // 10 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if request was successful
    if (response.status === 200) {
      console.log('✅ User details retrieved successfully!');
      
      // Extract user data
      const user = response.data.user || response.data.data || response.data;
      
      if (user && typeof user === 'object') {
        console.log('');
        console.log('👤 User Details:');
        console.log('================');
        console.log(`   Name: ${user.firstName} ${user.lastName}`);
        console.log(`   Email: ${user.email}`);
        console.log(`   Occupation: ${user.occupation}`);
        console.log(`   Phone: ${user.phoneNumber}`);
        console.log(`   Website: ${user.website}`);
        console.log(`   Wallet: ${user.walletAddress}`);
        console.log(`   Description: ${user.description}`);
        
        if (user.createdAt) {
          console.log(`   Created: ${new Date(user.createdAt).toLocaleString()}`);
        }
        
        if (user.updatedAt) {
          console.log(`   Updated: ${new Date(user.updatedAt).toLocaleString()}`);
        }

        // Validate required fields
        console.log('');
        console.log('🔍 Field Validation:');
        const requiredFields = ['firstName', 'lastName', 'email', 'occupation'];
        let validFields = 0;

        requiredFields.forEach(field => {
          if (user[field] && user[field].length > 0) {
            console.log(`   ✅ ${field}: Present`);
            validFields++;
          } else {
            console.log(`   ❌ ${field}: Missing or empty`);
          }
        });

        // Check data types
        console.log('');
        console.log('🔍 Data Type Validation:');
        const typeChecks = [
          { field: 'email', check: user.email?.includes('@'), name: 'Valid email format' },
          { field: 'website', check: user.website?.startsWith('http'), name: 'Valid website URL' },
          { field: 'walletAddress', check: user.walletAddress?.startsWith('0x'), name: 'Valid wallet address' },
          { field: 'phoneNumber', check: user.phoneNumber?.startsWith('+'), name: 'Valid phone format' }
        ];

        typeChecks.forEach(({ field, check, name }) => {
          if (user[field]) {
            if (check) {
              console.log(`   ✅ ${name}`);
            } else {
              console.log(`   ⚠️  ${name}: Format might be invalid`);
            }
          }
        });

        console.log('');
        if (validFields === requiredFields.length) {
          console.log('🎉 All required fields are present!');
        } else {
          console.log(`⚠️  Only ${validFields}/${requiredFields.length} required fields are present`);
        }

      } else {
        console.log('⚠️  No user data found in response');
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Get user test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Authentication required or token invalid');
      } else if (error.response.status === 404) {
        console.error('   💡 Tip: User not found, check the user ID');
      } else if (error.response.status === 403) {
        console.error('   💡 Tip: Permission denied, you might not be allowed to view this user');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Get user test completed!');
};

// Run the test
testGetUser();
EOF

echo "✅ TypeScript get user test generated: test_get_user.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Make sure you have .test_user_id file (run login test first)"
echo "   3. npx ts-node test_get_user.ts"
echo ""
echo "💡 The test will:"
echo "   - Retrieve user details by ID"
echo "   - Validate all user fields"
echo "   - Check data types and formats"
echo "   - Display comprehensive user information"



























#!/bin/bash

# generate_get_all_users_test.sh - Generate TypeScript test for getting all users
# Usage: ./generate_get_all_users_test.sh

echo "👥 Generating TypeScript test for Get All Users endpoint"
echo "======================================================"

# Create the TypeScript test file
cat > test_get_all_users.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';

// Load environment variables
dotenv.config();

interface User {
  _id?: string;
  id?: string;
  firstName: string;
  lastName: string;
  email: string;
  occupation: string;
  description: string;
  phoneNumber: string;
  website: string;
  walletAddress: string;
  createdAt?: string;
  updatedAt?: string;
}

interface ApiResponse {
  success: boolean;
  message: string;
  data?: User[];
  users?: User[];
  count?: number;
  total?: number;
}

const testGetAllUsers = async (): Promise<void> => {
  try {
    console.log('👥 Testing Get All Users Endpoint');
    console.log('=================================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
    const endpoint = `${baseUrl}/api/users`;

    // Get token from file or environment (might be optional)
    let token = process.env.TEST_AUTH_TOKEN;
    if (!token && fs.existsSync('.test_auth_token')) {
      token = fs.readFileSync('.test_auth_token', 'utf8').trim();
    }

    console.log(`📡 Endpoint: ${endpoint}`);
    if (token) {
      console.log(`🎫 Token: ${token.substring(0, 20)}...`);
    } else {
      console.log('🔓 No token found - testing without authentication');
    }
    console.log('');

    // Prepare headers
    const headers: any = {
      'Content-Type': 'application/json'
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    // Make the get all users request
    console.log('🚀 Sending get all users request...');
    const startTime = Date.now();

    const response = await axios.get<ApiResponse>(endpoint, {
      headers,
      timeout: 15000, // 15 second timeout for potentially large response
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);

    // Check if request was successful
    if (response.status === 200) {
      console.log('✅ All users retrieved successfully!');
      
      // Extract users array
      const users = response.data.users || response.data.data || response.data;
      const userCount = response.data.count || response.data.total;

      if (Array.isArray(users)) {
        console.log(`📈 Total users found: ${users.length}`);
        
        if (userCount && userCount !== users.length) {
          console.log(`📊 Server reported count: ${userCount}`);
        }

        if (users.length > 0) {
          console.log('');
          console.log('👥 User Summary:');
          console.log('================');

          // Display summary of each user
          users.forEach((user, index) => {
            console.log(`   ${index + 1}. ${user.firstName} ${user.lastName}`);
            console.log(`      Email: ${user.email}`);
            console.log(`      Occupation: ${user.occupation}`);
            console.log(`      ID: ${user._id || user.id}`);
            console.log('');
          });

          // Analyze user data
          console.log('📊 Data Analysis:');
          console.log('=================');

          // Count by occupation
          const occupations = users.reduce((acc: {[key: string]: number}, user) => {
            acc[user.occupation] = (acc[user.occupation] || 0) + 1;
            return acc;
          }, {});

          console.log('   Occupations:');
          Object.entries(occupations).forEach(([occupation, count]) => {
            console.log(`      ${occupation}: ${count} user(s)`);
          });

          // Check for required fields
          console.log('');
          console.log('🔍 Data Validation:');
          const requiredFields = ['firstName', 'lastName', 'email', 'occupation'];
          let validUsers = 0;

          users.forEach((user, index) => {
            const missingFields = requiredFields.filter(field => !user[field] || user[field].length === 0);
            
            if (missingFields.length === 0) {
              validUsers++;
            } else {
              console.log(`   ⚠️  User ${index + 1} missing fields: ${missingFields.join(', ')}`);
            }
          });

          console.log(`   ✅ ${validUsers}/${users.length} users have all required fields`);

          // Check for unique emails
          const emails = users.map(user => user.email);
          const uniqueEmails = new Set(emails);
          
          if (emails.length === uniqueEmails.size) {
            console.log('   ✅ All email addresses are unique');
          } else {
            console.log('   ⚠️  Duplicate email addresses found');
          }

          // Check for unique wallet addresses
          const wallets = users.map(user => user.walletAddress).filter(wallet => wallet);
          const uniqueWallets = new Set(wallets);
          
          if (wallets.length === uniqueWallets.size) {
            console.log('   ✅ All wallet addresses are unique');
          } else {
            console.log('   ⚠️  Duplicate wallet addresses found');
          }

          // Performance analysis
          console.log('');
          console.log('⚡ Performance Analysis:');
          console.log(`   Response time: ${responseTime}ms`);
          console.log(`   Users per second: ${Math.round(users.length / (responseTime / 1000))}`);
          
          if (responseTime > 5000) {
            console.log('   ⚠️  Response time is quite slow (>5s)');
          } else if (responseTime > 1000) {
            console.log('   ⚠️  Response time is slow (>1s)');
          } else {
            console.log('   ✅ Good response time');
          }

        } else {
          console.log('📭 No users found in the database');
          console.log('💡 Tip: Run the seed script to add test users');
        }

        // Sample response data (limited to avoid overwhelming output)
        console.log('');
        console.log('📋 Sample Response Data (first 2 users):');
        console.log(JSON.stringify(users.slice(0, 2), null, 2));

      } else {
        console.log('⚠️  Response is not an array of users');
        console.log('Response data:', JSON.stringify(response.data, null, 2));
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Get all users test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Authentication required, try running login test first');
      } else if (error.response.status === 403) {
        console.error('   💡 Tip: Permission denied, you might not be allowed to view all users');
      } else if (error.response.status === 500) {
        console.error('   💡 Tip: Server error, check server logs and database connection');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Get all users test completed!');
};

// Run the test
testGetAllUsers();
EOF

echo "✅ TypeScript get all users test generated: test_get_all_users.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Optionally have .test_auth_token file (from login test)"
echo "   3. npx ts-node test_get_all_users.ts"
echo ""
echo "💡 The test will:"
echo "   - Retrieve all users from the database"
echo "   - Analyze user data and occupations"
echo "   - Validate data integrity"
echo "   - Check for duplicates"
echo "   - Measure performance"



















#!/bin/bash

# generate_update_password_test.sh - Generate TypeScript test for updating user password
# Usage: ./generate_update_password_test.sh

echo "🔐 Generating TypeScript test for Update Password endpoint"
echo "========================================================"

# Create the TypeScript test file
cat > test_update_password.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';

// Load environment variables
dotenv.config();

interface UpdatePasswordData {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
}

interface ApiResponse {
  success: boolean;
  message: string;
  data?: any;
}

const testUpdatePassword = async (): Promise<void> => {
  try {
    console.log('🔐 Testing Update Password Endpoint');
    console.log('===================================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

    // Get user ID and token from files or environment
    let userId = process.env.TEST_USER_ID;
    let token = process.env.TEST_AUTH_TOKEN;

    // Try to read from files if not in environment
    if (!userId && fs.existsSync('.test_user_id')) {
      userId = fs.readFileSync('.test_user_id', 'utf8').trim();
    }

    if (!token && fs.existsSync('.test_auth_token')) {
      token = fs.readFileSync('.test_auth_token', 'utf8').trim();
    }

    if (!userId) {
      console.error('❌ No user ID found. Please run login test first or set TEST_USER_ID');
      process.exit(1);
    }

    if (!token) {
      console.error('❌ No auth token found. Please run login test first or set TEST_AUTH_TOKEN');
      process.exit(1);
    }

    const endpoint = `${baseUrl}/api/users/${userId}/password`;

    console.log(`📡 Endpoint: ${endpoint}`);
    console.log(`🆔 User ID: ${userId}`);
    console.log(`🎫 Token: ${token.substring(0, 20)}...`);
    console.log('');

    // Password update data
    const currentPassword = process.env.TEST_CURRENT_PASSWORD || 'passssssss';
    const newPassword = 'newSecurePassword123!';
    
    const passwordData: UpdatePasswordData = {
      currentPassword,
      newPassword,
      confirmPassword: newPassword
    };

    console.log('📝 Password Update Data:');
    console.log(`   Current Password: ${'*'.repeat(currentPassword.length)}`);
    console.log(`   New Password: ${'*'.repeat(newPassword.length)}`);
    console.log(`   Confirm Password: ${'*'.repeat(newPassword.length)}`);
    console.log('');

    // Validate password strength
    console.log('🔍 Password Validation:');
    const validations = [
      { test: newPassword.length >= 8, message: 'At least 8 characters' },
      { test: /[A-Z]/.test(newPassword), message: 'Contains uppercase letter' },
      { test: /[a-z]/.test(newPassword), message: 'Contains lowercase letter' },
      { test: /\d/.test(newPassword), message: 'Contains number' },
      { test: /[!@#$%^&*]/.test(newPassword), message: 'Contains special character' }
    ];

    validations.forEach(({ test, message }) => {
      console.log(`   ${test ? '✅' : '❌'} ${message}`);
    });

    const isPasswordStrong = validations.every(v => v.test);
    console.log(`   Overall: ${isPasswordStrong ? '✅ Strong password' : '⚠️  Weak password'}`);
    console.log('');

    // Make the password update request
    console.log('🚀 Sending password update request...');
    const startTime = Date.now();

    const response = await axios.put<ApiResponse>(endpoint, passwordData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      timeout: 10000, // 10 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if update was successful
    if (response.status === 200 || response.status === 204) {
      console.log('✅ Password updated successfully!');

      // Test login with new password
      console.log('');
      console.log('🔍 Testing login with new password...');
      
      try {
        // First get user email for login test
        const userResponse = await axios.get(`${baseUrl}/api/users/${userId}`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        const user = userResponse.data.user || userResponse.data.data || userResponse.data;
        const userEmail = user.email;

        // Try to login with new password
        const loginResponse = await axios.post(`${baseUrl}/api/users/login`, {
          email: userEmail,
          password: newPassword
        }, {
          headers: { 'Content-Type': 'application/json' }
        });

        if (loginResponse.status === 200) {
          console.log('✅ Login with new password successful!');
          
          // Update token file with new token if provided
          const newToken = loginResponse.data.token || loginResponse.data.accessToken;
          if (newToken) {
            fs.writeFileSync('.test_auth_token', newToken);
            console.log('💾 Updated token saved to .test_auth_token file');
          }
        } else {
          console.log('⚠️  Login returned unexpected status');
        }

      } catch (loginError: any) {
        console.log('❌ Login with new password failed');
        if (loginError.response?.status === 401) {
          console.log('   💡 This might indicate the password update didn\'t work');
        }
      }

      // Test that old password no longer works
      console.log('');
      console.log('🔍 Verifying old password no longer works...');
      
      try {
        const userResponse = await axios.get(`${baseUrl}/api/users/${userId}`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        const user = userResponse.data.user || userResponse.data.data || userResponse.data;
        const userEmail = user.email;

        const oldLoginResponse = await axios.post(`${baseUrl}/api/users/login`, {
          email: userEmail,
          password: currentPassword
        });

        if (oldLoginResponse.status === 200) {
          console.log('⚠️  Old password still works - password update might have failed');
        }

      } catch (oldLoginError: any) {
        if (oldLoginError.response?.status === 401) {
          console.log('✅ Old password correctly rejected');
        } else {
          console.log('❓ Unexpected error testing old password');
        }
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Update password test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Current password is incorrect or token is invalid');
      } else if (error.response.status === 403) {
        console.error('   💡 Tip: Permission denied, you can only update your own password');
      } else if (error.response.status === 404) {
        console.error('   💡 Tip: User not found, check the user ID');
      } else if (error.response.status === 400) {
        console.error('   💡 Tip: Check password requirements or if new passwords match');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Update password test completed!');
};

// Run the test
testUpdatePassword();
EOF

echo "✅ TypeScript update password test generated: test_update_password.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Make sure you have .test_user_id and .test_auth_token files"
echo "   3. Set TEST_CURRENT_PASSWORD environment variable if different from default"
echo "   4. npx ts-node test_update_password.ts"
echo ""
echo "💡 The test will:"
echo "   - Validate new password strength"
echo "   - Update the user's password"
echo "   - Test login with new password"
echo "   - Verify old password no longer works"
echo "   - Update auth token file"

















#!/bin/bash

# generate_update_profile_picture_test.sh - Generate TypeScript test for updating profile picture
# Usage: ./generate_update_profile_picture_test.sh

echo "🖼️ Generating TypeScript test for Update Profile Picture endpoint"
echo "================================================================"

# Create the TypeScript test file
cat > test_update_profile_picture.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';

// Load environment variables
dotenv.config();

interface ApiResponse {
  success: boolean;
  message: string;
  data?: any;
  profilePictureUrl?: string;
}

const testUpdateProfilePicture = async (): Promise<void> => {
  try {
    console.log('🖼️ Testing Update Profile Picture Endpoint');
    console.log('==========================================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

    // Get user ID and token from files or environment
    let userId = process.env.TEST_USER_ID;
    let token = process.env.TEST_AUTH_TOKEN;
    let imagePath = process.env.TEST_IMAGE_PATH;

    // Try to read from files if not in environment
    if (!userId && fs.existsSync('.test_user_id')) {
      userId = fs.readFileSync('.test_user_id', 'utf8').trim();
    }

    if (!token && fs.existsSync('.test_auth_token')) {
      token = fs.readFileSync('.test_auth_token', 'utf8').trim();
    }

    if (!userId) {
      console.error('❌ No user ID found. Please run login test first or set TEST_USER_ID');
      process.exit(1);
    }

    if (!token) {
      console.error('❌ No auth token found. Please run login test first or set TEST_AUTH_TOKEN');
      process.exit(1);
    }

    const endpoint = `${baseUrl}/api/users/${userId}/profile-picture`;

    console.log(`📡 Endpoint: ${endpoint}`);
    console.log(`🆔 User ID: ${userId}`);
    console.log(`🎫 Token: ${token.substring(0, 20)}...`);
    console.log('');

    // Handle image file
    if (!imagePath) {
      // Look for common image file extensions in current directory
      const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
      const currentDir = process.cwd();
      
      console.log('🔍 Looking for image files in current directory...');
      
      const files = fs.readdirSync(currentDir);
      const imageFiles = files.filter(file => 
        imageExtensions.some(ext => file.toLowerCase().endsWith(ext))
      );

      if (imageFiles.length > 0) {
        imagePath = path.join(currentDir, imageFiles[0]);
        console.log(`📁 Found image file: ${imagePath}`);
      } else {
        // Create a simple test image file
        console.log('📝 No image file found. Creating a test file...');
        
        // Create a minimal PNG file (1x1 pixel)
        const pngData = Buffer.from([
          0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
          0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
          0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53, 0xDE, 0x00, 0x00, 0x00,
          0x0C, 0x49, 0x44, 0x41, 0x54, 0x08, 0x99, 0x01, 0x01, 0x00, 0x00, 0x00,
          0xFF, 0xFF, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0xE2, 0x21, 0xBC, 0x33,
          0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
        ]);
        
        imagePath = path.join(currentDir, 'test_profile_picture.png');
        fs.writeFileSync(imagePath, pngData);
        console.log(`✅ Created test image: ${imagePath}`);
      }
    }

    // Verify image file exists
    if (!fs.existsSync(imagePath)) {
      console.error(`❌ Image file not found: ${imagePath}`);
      console.error('💡 Please provide a valid image file path via TEST_IMAGE_PATH environment variable');
      process.exit(1);
    }

    // Get file information
    const stats = fs.statSync(imagePath);
    const fileSize = stats.size;
    const fileName = path.basename(imagePath);
    const fileExt = path.extname(imagePath).toLowerCase();

    console.log('📋 Image File Information:');
    console.log(`   File: ${fileName}`);
    console.log(`   Size: ${fileSize} bytes (${(fileSize / 1024).toFixed(2)} KB)`);
    console.log(`   Extension: ${fileExt}`);
    console.log('');

    // Validate file size (warn if too large)
    if (fileSize > 10 * 1024 * 1024) { // 10MB
      console.log('⚠️  Warning: File is larger than 10MB, server might reject it');
    } else if (fileSize > 5 * 1024 * 1024) { // 5MB
      console.log('⚠️  Warning: File is larger than 5MB, some servers might reject it');
    } else {
      console.log('✅ File size looks good');
    }

    // Validate file type
    const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    if (allowedExtensions.includes(fileExt)) {
      console.log('✅ File type is supported');
    } else {
      console.log('⚠️  Warning: File type might not be supported');
    }

    console.log('');

    // Prepare form data
    const FormData = require('form-data');
    const formData = new FormData();
    
    // Read the file and append to form data
    const fileBuffer = fs.readFileSync(imagePath);
    formData.append('profilePicture', fileBuffer, {
      filename: fileName,
      contentType: `image/${fileExt.substring(1)}`
    });

    // Make the profile picture update request
    console.log('🚀 Sending profile picture update request...');
    const startTime = Date.now();

    const response = await axios.put<ApiResponse>(endpoint, formData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        ...formData.getHeaders()
      },
      timeout: 30000, // 30 second timeout for file upload
      maxContentLength: 50 * 1024 * 1024, // 50MB max
      maxBodyLength: 50 * 1024 * 1024, // 50MB max
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Upload Speed: ${(fileSize / 1024 / (responseTime / 1000)).toFixed(2)} KB/s`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if update was successful
    if (response.status === 200 || response.status === 204) {
      console.log('✅ Profile picture updated successfully!');

      // Check if we got a profile picture URL back
      const profilePictureUrl = response.data?.profilePictureUrl || 
                               response.data?.data?.profilePictureUrl ||
                               response.data?.user?.profilePictureUrl;

      if (profilePictureUrl) {
        console.log(`🖼️  Profile Picture URL: ${profilePictureUrl}`);
        
        // Test if the URL is accessible
        console.log('');
        console.log('🔍 Testing profile picture URL accessibility...');
        
        try {
          const urlTest = await axios.head(profilePictureUrl, { timeout: 5000 });
          console.log(`✅ Profile picture URL is accessible (${urlTest.status})`);
          
          if (urlTest.headers['content-type']) {
            console.log(`   Content-Type: ${urlTest.headers['content-type']}`);
          }
          if (urlTest.headers['content-length']) {
            const size = parseInt(urlTest.headers['content-length']);
            console.log(`   Size: ${size} bytes (${(size / 1024).toFixed(2)} KB)`);
          }
        } catch (urlError) {
          console.log('⚠️  Profile picture URL is not accessible');
        }
      }

      // Verify the update by fetching user data
      console.log('');
      console.log('🔍 Verifying update by fetching user data...');
      
      try {
        const userResponse = await axios.get(`${baseUrl}/api/users/${userId}`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        const user = userResponse.data.user || userResponse.data.data || userResponse.data;
        
        if (user.profilePicture || user.profilePictureUrl || user.avatar) {
          console.log('✅ Profile picture field updated in user data');
          const pictureField = user.profilePicture || user.profilePictureUrl || user.avatar;
          console.log(`   Picture field: ${pictureField}`);
        } else {
          console.log('⚠️  No profile picture field found in user data');
        }

      } catch (verifyError) {
        console.log('⚠️  Could not verify update in user data');
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Update profile picture test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Token might be invalid or expired');
      } else if (error.response.status === 403) {
        console.error('   💡 Tip: Permission denied, you can only update your own profile picture');
      } else if (error.response.status === 404) {
        console.error('   💡 Tip: User not found, check the user ID');
      } else if (error.response.status === 400) {
        console.error('   💡 Tip: Check if image file is valid and meets server requirements');
      } else if (error.response.status === 413) {
        console.error('   💡 Tip: File too large, try a smaller image');
      } else if (error.response.status === 415) {
        console.error('   💡 Tip: Unsupported media type, check file format');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running and accepts file uploads');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Update profile picture test completed!');
};

// Run the test
testUpdateProfilePicture();
EOF

echo "✅ TypeScript update profile picture test generated: test_update_profile_picture.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node form-data @types/form-data"
echo "   2. Make sure you have .test_user_id and .test_auth_token files"
echo "   3. Optionally place an image file in the current directory"
echo "   4. npx ts-node test_update_profile_picture.ts"
echo ""
echo "💡 The test will:"
echo "   - Look for image files in current directory or create a test image"
echo "   - Validate file size and format"
echo "   - Upload the profile picture"
echo "   - Test the returned image URL"
echo "   - Verify the update in user data"



















#!/bin/bash

# generate_delete_user_test.sh - Generate TypeScript test for deleting user
# Usage: ./generate_delete_user_test.sh

echo "🗑️ Generating TypeScript test for Delete User endpoint"
echo "===================================================="

# Create the TypeScript test file
cat > test_delete_user.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';
import * as fs from 'fs';
import * as readline from 'readline';

// Load environment variables
dotenv.config();

interface ApiResponse {
  success: boolean;
  message: string;
  data?: any;
}

const askForConfirmation = (question: string): Promise<boolean> => {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes');
    });
  });
};

const testDeleteUser = async (): Promise<void> => {
  try {
    console.log('🗑️ Testing Delete User Endpoint');
    console.log('===============================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

    // Get user ID and token from files or environment
    let userId = process.env.TEST_USER_ID;
    let token = process.env.TEST_AUTH_TOKEN;

    // Try to read from files if not in environment
    if (!userId && fs.existsSync('.test_user_id')) {
      userId = fs.readFileSync('.test_user_id', 'utf8').trim();
    }

    if (!token && fs.existsSync('.test_auth_token')) {
      token = fs.readFileSync('.test_auth_token', 'utf8').trim();
    }

    if (!userId) {
      console.error('❌ No user ID found. Please run login test first or set TEST_USER_ID');
      process.exit(1);
    }

    if (!token) {
      console.error('❌ No auth token found. Please run login test first or set TEST_AUTH_TOKEN');
      process.exit(1);
    }

    const endpoint = `${baseUrl}/api/users/${userId}`;

    console.log(`📡 Endpoint: ${endpoint}`);
    console.log(`🆔 User ID: ${userId}`);
    console.log(`🎫 Token: ${token.substring(0, 20)}...`);
    console.log('');

    // First, get user data to show what will be deleted
    console.log('📋 Getting user data before deletion...');
    try {
      const userResponse = await axios.get(endpoint, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });

      const user = userResponse.data.user || userResponse.data.data || userResponse.data;
      
      console.log('👤 User to be deleted:');
      console.log(`   Name: ${user.firstName} ${user.lastName}`);
      console.log(`   Email: ${user.email}`);
      console.log(`   Occupation: ${user.occupation}`);
      console.log(`   ID: ${user._id || user.id}`);
      console.log('');

    } catch (getUserError) {
      console.log('⚠️  Could not retrieve user data before deletion');
    }

    // Safety confirmation
    console.log('⚠️  WARNING: This will permanently delete the user!');
    console.log('⚠️  This action cannot be undone!');
    console.log('');

    // Check if running in CI/automated environment
    const isAutomated = process.env.CI || process.env.AUTOMATED_TEST || process.argv.includes('--force');
    
    if (!isAutomated) {
      const confirmed = await askForConfirmation('Are you sure you want to delete this user? (y/N): ');
      
      if (!confirmed) {
        console.log('❌ Operation cancelled by user.');
        process.exit(0);
      }
    } else {
      console.log('🤖 Running in automated mode, skipping confirmation');
    }

    console.log('');

    // Make the delete request
    console.log('🚀 Sending delete request...');
    const startTime = Date.now();

    const response = await axios.delete<ApiResponse>(endpoint, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      timeout: 10000, // 10 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));

    // Check if deletion was successful
    if (response.status === 200 || response.status === 204) {
      console.log('✅ User deleted successfully!');

      // Verify deletion by trying to fetch the user again
      console.log('');
      console.log('🔍 Verifying deletion by attempting to fetch user...');
      
      try {
        await axios.get(endpoint, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        console.log('⚠️  User still exists - deletion might have failed');

      } catch (verifyError: any) {
        if (verifyError.response?.status === 404) {
          console.log('✅ Confirmed: User no longer exists');
        } else if (verifyError.response?.status === 401) {
          console.log('🔐 Cannot verify deletion due to authentication (this is expected)');
        } else {
          console.log('❓ Unexpected error while verifying deletion');
        }
      }

      // Test that the deleted user's token no longer works
      console.log('');
      console.log('🔍 Testing if deleted user\'s token still works...');
      
      try {
        await axios.get(`${baseUrl}/api/users`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        console.log('⚠️  Token still works - user might not be fully deleted');

      } catch (tokenError: any) {
        if (tokenError.response?.status === 401) {
          console.log('✅ Token correctly invalidated');
        } else {
          console.log('❓ Unexpected error testing token');
        }
      }

      // Clean up test files
      console.log('');
      console.log('🧹 Cleaning up test files...');
      
      try {
        if (fs.existsSync('.test_user_id')) {
          fs.unlinkSync('.test_user_id');
          console.log('   ✅ Removed .test_user_id');
        }
        
        if (fs.existsSync('.test_auth_token')) {
          fs.unlinkSync('.test_auth_token');
          console.log('   ✅ Removed .test_auth_token');
        }
      } catch (cleanupError) {
        console.log('   ⚠️  Could not clean up some test files');
      }

      console.log('');
      console.log('🎉 User deletion test completed successfully!');
      console.log('💡 You may need to run the registration/login tests again to continue testing');

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Delete user test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 401) {
        console.error('   💡 Tip: Token might be invalid or expired');
      } else if (error.response.status === 403) {
        console.error('   💡 Tip: Permission denied, you might not be allowed to delete this user');
      } else if (error.response.status === 404) {
        console.error('   💡 Tip: User not found, might already be deleted');
      } else if (error.response.status === 409) {
        console.error('   💡 Tip: Conflict - user might have related data that prevents deletion');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   Network Error: No response received');
      console.error('   💡 Tip: Check if the API server is running');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Delete user test completed!');
};

// Run the test
testDeleteUser();
EOF

echo "✅ TypeScript delete user test generated: test_delete_user.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Make sure you have .test_user_id and .test_auth_token files"
echo "   3. npx ts-node test_delete_user.ts"
echo "   4. Or use --force flag to skip confirmation: npx ts-node test_delete_user.ts --force"
echo ""
echo "💡 The test will:"
echo "   - Show user details before deletion"
echo "   - Ask for confirmation (unless in automated mode)"
echo "   - Delete the user"
echo "   - Verify the deletion was successful"
echo "   - Test that the user's token is invalidated"
echo "   - Clean up test files"

















#!/bin/bash

# generate_health_check_test.sh - Generate TypeScript test for health check endpoint
# Usage: ./generate_health_check_test.sh

echo "🏥 Generating TypeScript test for Health Check endpoint"
echo "====================================================="

# Create the TypeScript test file
cat > test_health_check.ts << 'EOF'
import axios from 'axios';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

interface HealthResponse {
  status: string;
  message: string;
  timestamp?: string;
  uptime?: number;
  version?: string;
  environment?: string;
  database?: {
    status: string;
    connected: boolean;
  };
  services?: {
    [key: string]: string;
  };
}

const testHealthCheck = async (): Promise<void> => {
  try {
    console.log('🏥 Testing Health Check Endpoint');
    console.log('================================');

    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
    const endpoint = `${baseUrl}/api/health`;

    console.log(`📡 Endpoint: ${endpoint}`);
    console.log('');

    // Make the health check request
    console.log('🚀 Sending health check request...');
    const startTime = Date.now();

    const response = await axios.get<HealthResponse>(endpoint, {
      timeout: 5000, // 5 second timeout
    });

    const endTime = Date.now();
    const responseTime = endTime - startTime;

    console.log('📊 Response Details:');
    console.log(`   Status Code: ${response.status}`);
    console.log(`   Response Time: ${responseTime}ms`);
    console.log(`   Response Data:`);
    console.log(JSON.stringify(response.data, null, 4));
    console.log('');

    // Check if health check was successful
    if (response.status === 200) {
      console.log('✅ API is healthy!');

      const healthData = response.data;

      // Analyze health response
      console.log('🔍 Health Analysis:');
      console.log('==================');

      // Check status
      if (healthData.status) {
        const status = healthData.status.toLowerCase();
        if (status === 'ok' || status === 'healthy' || status === 'up') {
          console.log(`   ✅ Status: ${healthData.status}`);
        } else {
          console.log(`   ⚠️  Status: ${healthData.status} (might indicate issues)`);
        }
      } else {
        console.log('   ❓ No status field in response');
      }

      // Check message
      if (healthData.message) {
        console.log(`   💬 Message: ${healthData.message}`);
      }

      // Check timestamp
      if (healthData.timestamp) {
        const timestamp = new Date(healthData.timestamp);
        const now = new Date();
        const timeDiff = Math.abs(now.getTime() - timestamp.getTime());
        
        console.log(`   ⏰ Timestamp: ${timestamp.toISOString()}`);
        
        if (timeDiff > 60000) { // More than 1 minute difference
          console.log(`   ⚠️  Timestamp is ${Math.round(timeDiff / 1000)}s off from current time`);
        } else {
          console.log('   ✅ Timestamp is current');
        }
      }

      // Check uptime
      if (healthData.uptime !== undefined) {
        const uptimeSeconds = healthData.uptime;
        const uptimeHours = uptimeSeconds / 3600;
        const uptimeDays = uptimeHours / 24;

        console.log(`   📈 Uptime: ${uptimeSeconds}s`);
        
        if (uptimeDays >= 1) {
          console.log(`      (${uptimeDays.toFixed(1)} days)`);
        } else if (uptimeHours >= 1) {
          console.log(`      (${uptimeHours.toFixed(1)} hours)`);
        } else {
          console.log(`      (${(uptimeSeconds / 60).toFixed(1)} minutes)`);
        }
      }

      // Check version
      if (healthData.version) {
        console.log(`   📦 Version: ${healthData.version}`);
      }

      // Check environment
      if (healthData.environment) {
        console.log(`   🌍 Environment: ${healthData.environment}`);
        
        if (healthData.environment === 'production') {
          console.log('   💼 Running in production mode');
        } else if (healthData.environment === 'development') {
          console.log('   🔧 Running in development mode');
        }
      }

      // Check database status
      if (healthData.database) {
        console.log('   🗄️  Database:');
        
        if (healthData.database.connected) {
          console.log('      ✅ Connected');
        } else {
          console.log('      ❌ Not connected');
        }
        
        if (healthData.database.status) {
          console.log(`      Status: ${healthData.database.status}`);
        }
      }

      // Check services
      if (healthData.services) {
        console.log('   🔧 Services:');
        
        Object.entries(healthData.services).forEach(([service, status]) => {
          const statusLower = status.toLowerCase();
          if (statusLower === 'ok' || statusLower === 'healthy' || statusLower === 'up') {
            console.log(`      ✅ ${service}: ${status}`);
          } else {
            console.log(`      ❌ ${service}: ${status}`);
          }
        });
      }

      // Performance analysis
      console.log('');
      console.log('⚡ Performance Analysis:');
      console.log(`   Response time: ${responseTime}ms`);
      
      if (responseTime < 100) {
        console.log('   ✅ Excellent response time');
      } else if (responseTime < 500) {
        console.log('   ✅ Good response time');
      } else if (responseTime < 1000) {
        console.log('   ⚠️  Slow response time');
      } else {
        console.log('   ❌ Very slow response time');
      }

      // Overall health assessment
      console.log('');
      console.log('🏥 Overall Health Assessment:');
      
      let healthScore = 0;
      let maxScore = 0;

      // Score based on status
      maxScore += 2;
      if (healthData.status && ['ok', 'healthy', 'up'].includes(healthData.status.toLowerCase())) {
        healthScore += 2;
      }

      // Score based on database
      maxScore += 2;
      if (healthData.database?.connected) {
        healthScore += 2;
      }

      // Score based on response time
      maxScore += 1;
      if (responseTime < 500) {
        healthScore += 1;
      }

      // Score based on timestamp freshness
      if (healthData.timestamp) {
        maxScore += 1;
        const timestamp = new Date(healthData.timestamp);
        const timeDiff = Math.abs(new Date().getTime() - timestamp.getTime());
        if (timeDiff < 60000) {
          healthScore += 1;
        }
      }

      const healthPercentage = maxScore > 0 ? Math.round((healthScore / maxScore) * 100) : 0;
      
      if (healthPercentage >= 90) {
        console.log(`   🟢 Excellent (${healthPercentage}%)`);
      } else if (healthPercentage >= 70) {
        console.log(`   🟡 Good (${healthPercentage}%)`);
      } else if (healthPercentage >= 50) {
        console.log(`   🟠 Fair (${healthPercentage}%)`);
      } else {
        console.log(`   🔴 Poor (${healthPercentage}%)`);
      }

    } else {
      console.log('❌ Unexpected response status');
    }

  } catch (error: any) {
    console.error('💥 Health check test failed!');
    
    if (error.response) {
      // Server responded with error status
      console.error(`   Status Code: ${error.response.status}`);
      console.error(`   Error Data:`, JSON.stringify(error.response.data, null, 4));
      
      if (error.response.status === 503) {
        console.error('   🚨 Service unavailable - API is down or under maintenance');
      } else if (error.response.status === 500) {
        console.error('   💥 Internal server error - API has issues');
      } else if (error.response.status === 404) {
        console.error('   ❓ Health endpoint not found - check API documentation');
      }
    } else if (error.request) {
      // Request was made but no response received
      console.error('   🌐 Network Error: No response received');
      console.error('   💡 Possible causes:');
      console.error('      - API server is not running');
      console.error('      - Wrong URL or port');
      console.error('      - Network connectivity issues');
      console.error('      - Firewall blocking the request');
    } else {
      // Something else happened
      console.error(`   Error: ${error.message}`);
    }

    console.error('');
    console.error('🔧 Troubleshooting Tips:');
    console.error('   1. Check if the API server is running');
    console.error('   2. Verify the correct URL and port');
    console.error('   3. Test with curl: curl ' + (process.env.BASE_URL || 'http://localhost:3000') + '/api/health');
    console.error('   4. Check server logs for errors');

    process.exit(1);
  }

  console.log('');
  console.log('🏁 Health check test completed!');
};

// Run the test
testHealthCheck();
EOF

echo "✅ TypeScript health check test generated: test_health_check.ts"
echo ""
echo "📋 To run the test:"
echo "   1. npm install axios dotenv @types/node typescript ts-node"
echo "   2. Create .env file with BASE_URL=http://localhost:3000"
echo "   3. npx ts-node test_health_check.ts"
echo ""
echo "💡 The test will:"
echo "   - Check API health status"
echo "   - Analyze response components (status, uptime, database, etc.)"
echo "   - Measure response time and performance"
echo "   - Provide overall health assessment"
echo "   - Give troubleshooting tips if health check fails"






















#!/bin/bash

# generate_all_tests.sh - Generate all TypeScript test files for API endpoints
# Usage: ./generate_all_tests.sh

echo "🚀 Profile Settings API - TypeScript Test Generator"
echo "=================================================="
echo ""

# Array of test generators
generators=(
    "generate_health_check_test.sh:Health Check Test"
    "generate_register_test.sh:User Registration Test"
    "generate_login_test.sh:User Login Test"
    "generate_get_all_users_test.sh:Get All Users Test"
    "generate_get_user_test.sh:Get User Details Test"
    "generate_update_user_test.sh:Update User Details Test"
    "generate_update_password_test.sh:Update Password Test"
    "generate_update_profile_picture_test.sh:Update Profile Picture Test"
    "generate_delete_user_test.sh:Delete User Test"
)

# Function to run a generator
run_generator() {
    local generator_script=$1
    local description=$2
    
    echo "📝 Generating: $description"
    echo "   Script: $generator_script"
    
    if [ -f "$generator_script" ]; then
        if [ -x "$generator_script" ]; then
            ./"$generator_script"
            if [ $? -eq 0 ]; then
                echo "   ✅ Generated successfully"
            else
                echo "   ❌ Generation failed"
                return 1
            fi
        else
            echo "   ⚠️  Script not executable, making it executable..."
            chmod +x "$generator_script"
            ./"$generator_script"
            if [ $? -eq 0 ]; then
                echo "   ✅ Generated successfully"
            else
                echo "   ❌ Generation failed"
                return 1
            fi
        fi
    else
        echo "   ❌ Generator script not found: $generator_script"
        return 1
    fi
    
    echo ""
}

# Make all generator scripts executable
echo "🔧 Making generator scripts executable..."
chmod +x generate_*.sh 2>/dev/null
echo ""

# Check which generators exist
echo "🔍 Checking available generators..."
missing_generators=0

for generator_info in "${generators[@]}"; do
    generator_script=$(echo "$generator_info" | cut -d':' -f1)
    description=$(echo "$generator_info" | cut -d':' -f2)
    
    if [ -f "$generator_script" ]; then
        echo "   ✅ $generator_script"
    else
        echo "   ❌ $generator_script (missing)"
        missing_generators=$((missing_generators + 1))
    fi
done

if [ $missing_generators -gt 0 ]; then
    echo ""
    echo "⚠️  Warning: $missing_generators generator script(s) missing."
    echo "Some TypeScript tests will not be generated."
fi

echo ""
read -p "Press Enter to start generating TypeScript tests, or Ctrl+C to cancel..."
echo ""

# Generate all tests
echo "🏗️  Generating TypeScript test files..."
echo ""

generated_count=0
failed_count=0

for generator_info in "${generators[@]}"; do
    generator_script=$(echo "$generator_info" | cut -d':' -f1)
    description=$(echo "$generator_info" | cut -d':' -f2)
    
    if run_generator "$generator_script" "$description"; then
        generated_count=$((generated_count + 1))
    else
        failed_count=$((failed_count + 1))
    fi
done

# Generate package.json and setup files
echo "📦 Generating package.json and setup files..."

cat > package.json << 'EOF'
{
  "name": "api-tests",
  "version": "1.0.0",
  "description": "TypeScript tests for Profile Settings API",
  "main": "index.js",
  "scripts": {
    "test:health": "ts-node test_health_check.ts",
    "test:register": "ts-node test_register.ts",
    "test:login": "ts-node test_login.ts",
    "test:get-users": "ts-node test_get_all_users.ts",
    "test:get-user": "ts-node test_get_user.ts",
    "test:update-user": "ts-node test_update_user.ts",
    "test:update-password": "ts-node test_update_password.ts",
    "test:update-picture": "ts-node test_update_profile_picture.ts",
    "test:delete-user": "ts-node test_delete_user.ts --force",
    "test:all": "npm run test:health && npm run test:register && npm run test:login && npm run test:get-users && npm run test:get-user && npm run test:update-user",
    "install-deps": "npm install axios dotenv @types/node typescript ts-node form-data @types/form-data"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "dotenv": "^16.3.0",
    "form-data": "^4.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/form-data": "^2.5.0",
    "typescript": "^5.0.0",
    "ts-node": "^10.9.0"
  },
  "keywords": ["api", "testing", "typescript", "automation"],
  "author": "Generated by test generator",
  "license": "MIT"
}
EOF

echo "   ✅ package.json created"

# Generate .env template
cat > .env.example << 'EOF'
# API Configuration
BASE_URL=http://localhost:3000

# Test User Credentials (from seed data)
TEST_EMAIL=maziofweb3@example.com
TEST_PASSWORD=passssssss
TEST_CURRENT_PASSWORD=passssssss

# Optional: Specific user ID for testing
# TEST_USER_ID=

# Optional: Auth token for testing
# TEST_AUTH_TOKEN=

# Optional: Image path for profile picture test
# TEST_IMAGE_PATH=./test-image.jpg

# Set to true to skip confirmations in automated testing
# AUTOMATED_TEST=false
# CI=false
EOF

echo "   ✅ .env.example created"

# Generate README
cat > README.md << 'EOF'
# API TypeScript Tests

Generated TypeScript tests for Profile Settings API endpoints.

## Setup

1. Install dependencies:
```bash
npm run install-deps
# or
npm install
```

2. Create environment file:
```bash
cp .env.example .env
# Edit .env with your API configuration
```

3. Make sure your API server is running

## Running Tests

### Individual Tests
```bash
npm run test:health              # Health check
npm run test:register            # User registration
npm run test:login               # User login
npm run test:get-users           # Get all users
npm run test:get-user            # Get user details
npm run test:update-user         # Update user profile
npm run test:update-password     # Update password
npm run test:update-picture      # Update profile picture
npm run test:delete-user         # Delete user (with --force flag)
```

### Run All Tests (Recommended Sequence)
```bash
npm run test:all                 # Runs safe tests in sequence
```

### Manual Test Execution
```bash
npx ts-node test_health_check.ts
npx ts-node test_register.ts
npx ts-node test_login.ts
# ... etc
```

## Test Files

- `test_health_check.ts` - API health check
- `test_register.ts` - User registration
- `test_login.ts` - User login (saves token)
- `test_get_all_users.ts` - Get all users
- `test_get_user.ts` - Get user by ID
- `test_update_user.ts` - Update user profile
- `test_update_password.ts` - Update password
- `test_update_profile_picture.ts` - Upload profile picture
- `test_delete_user.ts` - Delete user

## Test Flow

1. **Health Check** - Verify API is running
2. **Register** - Create test user (optional)
3. **Login** - Authenticate and save token
4. **Get Users** - List all users
5. **Get User** - Get specific user details
6. **Update User** - Modify user profile
7. **Update Password** - Change password
8. **Update Picture** - Upload profile image
9. **Delete User** - Remove user (destructive)

## Environment Variables

- `BASE_URL` - API base URL (default: http://localhost:3000)
- `TEST_EMAIL` - User email for login
- `TEST_PASSWORD` - User password for login
- `TEST_USER_ID` - Specific user ID to test
- `TEST_AUTH_TOKEN` - Auth token for requests
- `TEST_IMAGE_PATH` - Path to test image file
- `AUTOMATED_TEST` - Skip confirmations (true/false)

## Generated Files

Tests automatically create these files:
- `.test_user_id` - Stores user ID from login
- `.test_auth_token` - Stores auth token from login
- `test_profile_picture.png` - Generated test image

## Features

- **Comprehensive Testing** - Tests all CRUD operations
- **Error Handling** - Detailed error messages and troubleshooting
- **Data Validation** - Validates response structure and data types
- **Performance Monitoring** - Measures response times
- **Token Management** - Automatic token handling between tests
- **Safety Checks** - Confirmation prompts for destructive operations
- **Detailed Logging** - Step-by-step execution details

## Troubleshooting

1. **Connection Errors**: Check if API server is running
2. **Authentication Errors**: Run login test first
3. **Permission Errors**: Ensure correct user permissions
4. **File Upload Errors**: Check image file exists and format
5. **Database Errors**: Verify MongoDB connection

## Notes

- Login test must be run before other authenticated tests
- Delete test is destructive and requires confirmation
- Profile picture test auto-generates test image if none provided
- Tests work with both seeded data and newly created users
EOF

echo "   ✅ README.md created"

# Generate TypeScript configuration
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": false,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true
  },
  "include": [
    "test_*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist"
  ]
}
EOF

echo "   ✅ tsconfig.json created"

# Generate run script
cat > run_tests.sh << 'EOF'
#!/bin/bash

# run_tests.sh - Run TypeScript tests in recommended order
echo "🧪 Running TypeScript API Tests"
echo "==============================="
echo ""

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm run install-deps
    echo ""
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  No .env file found. Creating from template..."
    cp .env.example .env
    echo "💡 Please edit .env file with your API configuration"
    echo ""
fi

echo "🏁 Starting test sequence..."
echo ""

# Run tests in recommended order
tests=(
    "test:health:Health Check"
    "test:register:User Registration"
    "test:login:User Login"
    "test:get-users:Get All Users"
    "test:get-user:Get User Details"
    "test:update-user:Update User Profile"
)

for test_info in "${tests[@]}"; do
    test_name=$(echo "$test_info" | cut -d':' -f2)
    description=$(echo "$test_info" | cut -d':' -f3)
    
    echo "🧪 Running: $description"
    echo "   Command: npm run $test_name"
    
    if npm run "$test_name"; then
        echo "   ✅ PASSED"
    else
        echo "   ❌ FAILED"
        echo ""
        echo "❌ Test sequence stopped due to failure"
        echo "💡 Fix the issue and run again"
        exit 1
    fi
    
    echo ""
done

echo "🎉 All tests completed successfully!"
echo ""
echo "⚠️  Destructive tests (password update, delete user) not included"
echo "💡 Run them manually if needed:"
echo "   npm run test:update-password"
echo "   npm run test:delete-user"
EOF

chmod +x run_tests.sh
echo "   ✅ run_tests.sh created (executable)"

echo ""

# Summary
echo "📊 GENERATION SUMMARY"
echo "===================="
echo "TypeScript Tests Generated: $generated_count"
echo "Generation Failures: $failed_count"
echo ""

if [ $failed_count -eq 0 ]; then
    echo "🎉 All TypeScript tests generated successfully!"
else
    echo "⚠️  Some tests failed to generate. Check the output above."
fi

echo ""
echo "📁 Generated Files:"
echo "   TypeScript Tests: test_*.ts"
echo "   Configuration: package.json, tsconfig.json, .env.example"
echo "   Documentation: README.md"
echo "   Runner Script: run_tests.sh"
echo ""
echo "🚀 Quick Start:"
echo "   1. npm run install-deps"
echo "   2. cp .env.example .env && edit .env"
echo "   3. ./run_tests.sh"
echo ""
echo "💡 Or run individual tests:"
echo "   npm run test:health"
echo "   npm run test:login"
echo "   npm run test:all"
echo ""
echo "🏁 TypeScript test generation completed!"