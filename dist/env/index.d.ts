import { z } from 'zod';
declare const envSchema: z.ZodObject<{
    PORT: z.ZodString;
}, "strip", z.ZodTypeAny, {
    PORT: string;
}, {
    PORT: string;
}>;
export declare const parseEnv: () => void;
declare const getEnvVar: (key: keyof z.infer<typeof envSchema>) => string;
export default getEnvVar;
