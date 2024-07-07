import express, { Express } from 'express';
import cors from 'cors';
import getEnvVar from '../env/index';
import AuthRouter from 'routers/auth.router';
import HealthRouter from 'routers/health.router';

class Server {
    #engine: Express;
    
    constructor() {
        this.#engine = express();
    }

    #registerMiddlwares() {
        this.#engine.use(express.json());
        this.#engine.use(cors());
    }

    #registerHandlers() {
        const healthRouter = new HealthRouter(this.#engine, '');
        const authRouter = new AuthRouter(this.#engine, '/auth');

        healthRouter.register();
        authRouter.register();
    }

    start() {
        this.#registerMiddlwares();
        this.#registerHandlers();
        this.#engine.listen(parseInt(getEnvVar('PORT')), () => {
            console.log(`\nServer listening on ${getEnvVar('PORT')}`);
        });
    }
}

export default Server;
