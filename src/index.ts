import Server from 'server';
import { parseEnv } from 'env';

parseEnv();

const server = new Server();
server.start();
