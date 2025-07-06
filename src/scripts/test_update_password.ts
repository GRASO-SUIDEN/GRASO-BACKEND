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
