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
