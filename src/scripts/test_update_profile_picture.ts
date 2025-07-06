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
