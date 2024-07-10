import File from "services/fileio.service";
import path from "path";
import os from "os";

export function template(fileName: string): string {
        const filePath = path.join(__dirname, '..', '..', 'templates', fileName);
        return File.read(filePath);
}

export function writeConfigFile(data: string, fileName: string) {
    const homeDir = os.homedir();
    const configPath = path.join(homeDir, fileName);
    File.write(configPath, data);
}

export function readConfigFile(fileName: string): string {
    const homeDir = os.homedir();
    const configPath = path.join(homeDir, fileName);
    return File.read(configPath);
}
