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
