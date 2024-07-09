import AuthController from "controllers/auth.controller";
import AbstractRouter from "./index.router";

class AuthRouter extends AbstractRouter {
    registerRoutes(): void {
        const authController = new AuthController();
        this.registerGET('/google', authController.googleAuthCallback());
        this.registerGET('/youtube', authController.ytAuthCallback());
    }
}

export default AuthRouter;
