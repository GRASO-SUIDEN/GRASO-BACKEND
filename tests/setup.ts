import { MongoMemoryServer } from 'mongodb-memory-server';
import mongoose from 'mongoose';

let mongoServer: MongoMemoryServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  await mongoose.connect(mongoUri);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

afterEach(async () => {
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    const collection = collections[key];
    await collection.deleteMany({});
  }
});

// In a Jest test environment, beforeAll is provided globally.
// If you need to provide your own implementation (for a custom runner or environment),
// you could do something like this as a minimal mock:

declare global {
  // eslint-disable-next-line no-var
  var __beforeAllCallbacks__: Array<() => Promise<void>> | undefined;
}

global.__beforeAllCallbacks__ = global.__beforeAllCallbacks__ || [];

function beforeAll(callback: () => Promise<void>) {
  global.__beforeAllCallbacks__!.push(callback);
}

function afterAll(callback: () => Promise<void>) {
  // You can implement a similar pattern as beforeAll for afterAll callbacks
  // For demonstration, we'll store them in a global array
  if (!global.__afterAllCallbacks__) {
    // eslint-disable-next-line no-var
    var __afterAllCallbacks__: Array<() => Promise<void>>;
    global.__afterAllCallbacks__ = [];
  }
  global.__afterAllCallbacks__!.push(callback);
}
function afterEach(callback: () => Promise<void>) {
  if (!global.__afterEachCallbacks__) {
    // eslint-disable-next-line no-var
    var __afterEachCallbacks__: Array<() => Promise<void>>;
    global.__afterEachCallbacks__ = [];
  }
  global.__afterEachCallbacks__!.push(callback);
}
