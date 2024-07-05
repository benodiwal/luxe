import express, { Express } from 'express';
import cors from 'cors';
import getEnvVar from '../env/index';

class Server {
    #engine: Express;
    
    constructor() {
        this.#engine = express();
    }

    #registerMiddlwares() {
        this.#engine.use(express.json());
        this.#engine.use(cors());
    }

    #registerHandlers() {}

    start() {
        this.#registerMiddlwares();
        this.#registerHandlers();
        this.#engine.listen(parseInt(getEnvVar('PORT')), () => {
            console.log(`\nServer listening on ${getEnvVar("PORT")}`);
        });
    }
}

export default Server;
