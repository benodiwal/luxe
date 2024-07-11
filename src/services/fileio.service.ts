import fs from 'fs';

class File {
  static read(filePath: string): string {
    try {
      const data = fs.readFileSync(filePath, 'utf8');
      return data.toString();
    } catch (error) {
      console.error(`Error reading file: ${error}`);
      throw error;
    }
  }

  static write(filePath: string, content: string) {
    try {
      fs.writeFileSync(filePath, content, 'utf8');
    } catch (error) {}
  }
}

export default File;
