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
