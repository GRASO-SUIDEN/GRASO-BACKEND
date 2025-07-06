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
