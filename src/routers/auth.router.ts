import AuthController from "controllers/auth.controller";
import AbstractRouter from "./index.router";

class AuthRouter extends AbstractRouter {
    registerRoutes(): void {
        const authController = new AuthController();
        this.registerPOST('/google/callback', authController.googleAuthCallback());
    }
}

export default AuthRouter;
