import { NextFunction, Request, Response } from "express";

class AuthController {
    googleAuthCallback() {
        return [
            async (req: Request, res: Response, next: NextFunction) => {}
        ];
    }
}

export default AuthController;
