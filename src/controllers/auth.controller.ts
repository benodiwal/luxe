import { NextFunction, Request, Response } from "express";
import { validateRequestQuery } from "validators/validateRequest";
import { z } from 'zod';
import { InternalServerError } from "errors/internal-server-error";
import googleOAuthClient from "libs/google.lib";
import { template, writeConfigFile } from "utils/index";
import yt from "libs/yt.lib";

class AuthController {

    googleAuthCallback() {
        return [
            validateRequestQuery(z.object({ code: z.string() })),
            async (req: Request, res: Response, next: NextFunction) => {
                try {
                    const { code } = req.query as unknown as { code: string };
                    const response = await googleOAuthClient.getTokenAndVerifyFromCode(code);
                    writeConfigFile(JSON.stringify(response), '.luxe.config');

                    res.status(200).send(template('luxe.html'));                   
                } catch (e: unknown) {
                    console.error(e);
                    next(new InternalServerError());
                }
            }
        ];
    }

    ytAuthCallback() {
        return [
            validateRequestQuery(z.object({ code: z.string() })),
            async (req: Request, res: Response, next: NextFunction) => {
                try {
                    const { code } = req.query as unknown as { code: string };
                    const tokens = await yt.getToken(code);
                    writeConfigFile(JSON.stringify(tokens), '.luxe.yt');

                    res.status(200).send(template('yt.html'));
                } catch (e: unknown) {
                    console.error(e);
                    next(new InternalServerError());
                }            
            }
        ];   
    }

}

export default AuthController;
