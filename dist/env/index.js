"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseEnv = void 0;
const zod_1 = require("zod");
const dotenv_1 = require("dotenv");
const envSchema = zod_1.z.object({
    PORT: zod_1.z.string(),
});
const parseEnv = () => {
    (0, dotenv_1.config)();
    envSchema.parse(process.env);
};
exports.parseEnv = parseEnv;
const getEnvVar = (key) => {
    return process.env[key];
};
exports.default = getEnvVar;
