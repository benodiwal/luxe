import { InternalServerError } from "errors/internal-server-error";
import { Request, Response, NextFunction } from "express";
import yt from "libs/yt.lib";
import { readConfigFile } from "utils/index";

class YtController {
    get() {
        return [
            async (_: Request, res: Response, next: NextFunction) =>{
                try {
                    const content = readConfigFile('.luxe.yt');
                    const { access_token } = JSON.parse(content);
                    yt.setCredentials(access_token, "");
                    let data = await yt.getUserInfo();
                    console.log(data);
                    res.sendStatus(200);
                } catch (error) {
                    console.error(error);
                    next(new InternalServerError());
                }
            }
        ];
    }
}

export default YtController;
