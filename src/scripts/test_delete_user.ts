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
