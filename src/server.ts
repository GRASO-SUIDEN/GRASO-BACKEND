import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import compression from 'compression';
import { config } from './config/app';
import { connectDatabase } from './config/database';
import { logger } from './config/logger';
import { generalLimiter } from './middleware/rateLimiter';
import { errorHandler, notFound } from './middleware/errorHandler';
import routes from './routes';

// Load environment variables
import dotenv from 'dotenv';
dotenv.config();

class App {
  public app: express.Application;

  constructor() {
    this.app = express();
    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeErrorHandling();
  }

  private initializeMiddlewares(): void {
    // Security middleware
    this.app.use(helmet());
    this.app.use(cors());

    // Compression middleware
    this.app.use(compression());

    // Logging middleware
    if (config.nodeEnv !== 'test') {
      this.app.use(morgan('combined'));
    }

    // Rate limiting
    this.app.use('/api/', generalLimiter);

    // Body parsing middleware
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));

    // Serve static files
    this.app.use('/uploads', express.static('uploads'));
  }

  private initializeRoutes(): void {
    this.app.use('/api', routes);
  }

  private initializeErrorHandling(): void {
    this.app.use(notFound);
    this.app.use(errorHandler);
  }

  public async start(): Promise<void> {
    try {
      // Connect to database
      await connectDatabase();

      // Start server
      this.app.listen(config.port, () => {
        logger.info(`Server running on port http://localhost:${config.port}`);
        logger.info(`Environment: ${config.nodeEnv}`);
      });
    } catch (error) {
      logger.error('Failed to start server:', error);
      process.exit(1);
    }
  }
}

// Start the application
const app = new App();

if (require.main === module) {
  app.start().catch((error) => {
    logger.error('Application startup error:', error);
    process.exit(1);
  });
}

export default app;
