import 'reflect-metadata';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import { User } from '../models/User';

// Load environment variables
dotenv.config();

const users = [
  {
    firstName: 'Mazi',
    walletAddress: '0x95e0b60436a1e789e18ef54ec7a6b3175a525110f01e6bde5566e0473425b2de',
    lastName: 'OfWeb3',
    email: 'maziofweb3@example.com',
    occupation: 'BE Dev.',
    description:
      'Passionate full-stack w2b, w3b developer with 5 years of experience in TypeScript and Node.js: LOL :)',
    phoneNumber: '+447777213852',
    website: 'https://somtochukwu-k.vercel.app/',
    password: 'passssssss',
  },
  {
    firstName: 'Dev',
    walletAddress: '0xqwerty0436a1e789e18ef54ec7a6b3175a525110f01e6sde5566e0473425b2qe',
    lastName: 'Danny',
    email: 'john@example.com',
    occupation: 'Software Developer',
    description: 'A Web3 FrontEnd Developer and Smart Contract Developer',
    phoneNumber: '+2349067522357',
    website: 'https://github.com/Verifieddanny',
    password: 'password123',
  },
];

const seedDatabase = async (): Promise<void> => {
  try {
    console.log('🌱 Starting database seeding...');

    // Get MongoDB URI from environment variables
    const mongoUri = process.env['MONGODB_URI'] || 'mongodb://localhost:27017/profile_db';

    console.log(`📡 Connecting to MongoDB...`);

    // Connect to MongoDB
    await mongoose.connect(mongoUri);
    console.log('✅ Connected to MongoDB successfully');

    // Clear existing users
    console.log('🗑️  Clearing existing users...');
    const deleteResult = await User.deleteMany({});
    console.log(`🗑️  Deleted ${deleteResult.deletedCount} existing users`);

    // Create new users
    console.log('👥 Creating new users...');
    let createdCount = 0;

    for (const userData of users) {
      try {
        const user = new User(userData);
        await user.save();
        createdCount++;
        console.log(`✅ Created user ${createdCount}/5: ${user.email} (${user.occupation})`);
      } catch (error) {
        console.error(`❌ Failed to create user ${userData.email}:`, error);
      }
    }

    // Verify users were created
    const totalUsers = await User.countDocuments();
    console.log(`\n📊 Database seeding completed!`);
    console.log(`📈 Total users in database: ${totalUsers}`);
    console.log(`✨ Successfully created: ${createdCount} users`);

    // List created users
    console.log('\n👥 Created users:');
    const allUsers = await User.find({}).select('firstName lastName email occupation');
    allUsers.forEach((user, index) => {
      console.log(
        `   ${index + 1}. ${user.firstName} ${user.lastName} - ${user.email} (${user.occupation})`
      );
    });

    console.log('\n🎉 Database seeding finished successfully!');
  } catch (error) {
    console.error('💥 Error seeding database:', error);

    if (error instanceof Error) {
      console.error('Error message:', error.message);

      // Provide helpful error messages
      if (error.message.includes('ECONNREFUSED')) {
        console.error('\n🔧 Troubleshooting:');
        console.error('   - Make sure MongoDB is running');
        console.error('   - Check your MONGODB_URI in .env file');
        console.error(
          '   - For local MongoDB: sudo systemctl start mongod (Linux) or brew services start mongodb-community (macOS)'
        );
      }

      if (error.message.includes('authentication failed')) {
        console.error('\n🔧 Troubleshooting:');
        console.error('   - Check your MongoDB credentials');
        console.error('   - Verify your MONGODB_URI has correct username/password');
        console.error('   - For MongoDB Atlas, ensure your IP is whitelisted');
      }
    }

    process.exit(1);
  } finally {
    // Disconnect from MongoDB
    try {
      await mongoose.disconnect();
      console.log('📡 Disconnected from MongoDB');
    } catch (disconnectError) {
      console.error('Error disconnecting from MongoDB:', disconnectError);
    }

    process.exit(0);
  }
};

// Run the seeding function
console.log('🚀 Profile Settings API - Database Seeding');
console.log('==========================================');
seedDatabase();
