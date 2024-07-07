import { NextFunction, Request, Response } from "express";
import File from "services/fileio.service";
import { validateRequestQuery } from "validators/validateRequest";
import os from 'os';
import { z } from 'zod';
import path from 'path';
import { InternalServerError } from "errors/internal-server-error";
import googleOAuthClient from "libs/google.lib";

class AuthController {

    private template(): string {
        const filePath = path.join(__dirname, '..', '..', 'templates', 'luxe.html');
        return File.read(filePath);
    }

    private writeConfigFile(code: string) {
        const homeDir = os.homedir();
        const configPath = path.join(homeDir, '.luxe.config');
        File.write(configPath, code);
    }

    googleAuthCallback() {
        return [
            validateRequestQuery(z.object({ code: z.string() })),
            async (req: Request, res: Response, next: NextFunction) => {
                try {
                    const { code } = req.query as unknown as { code: string };
                    const response = await googleOAuthClient.getTokenAndVerifyFromCode(code);
                    this.writeConfigFile(JSON.stringify(response));

                    res.status(200).send(this.template());                   
                } catch (e: unknown) {
                    console.error(e);
                    next(new InternalServerError());
                }
            }
        ];
    }
}

export default AuthController;
