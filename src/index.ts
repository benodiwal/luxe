import Server from './server'
import getEnvVar, { parseEnv } from './env';

parseEnv();

const server = new Server();
server.start();
