import Server from './server/index'
import { parseEnv } from './env/index';

parseEnv();

const server = new Server();
server.start();
