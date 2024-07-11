import YtController from 'controllers/yt.controller';
import AbstractRouter from './index.router';

class YtRouter extends AbstractRouter {
  registerRoutes(): void {
    const ytController = new YtController();
    this.registerGET('/', ytController.get());
  }
}

export default YtRouter;
