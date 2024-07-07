import { Request, Response } from "express";

class HealthController {
    get() {
        return [
            async (_req: Request, res: Response) => {
                res.sendStatus(200);
            }
        ];
    }
}

export default HealthController;
