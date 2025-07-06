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
