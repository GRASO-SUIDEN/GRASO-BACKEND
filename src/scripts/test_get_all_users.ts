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
