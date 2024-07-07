import getEnvVar from 'env/index';
import { OAuth2Client, TokenPayload, gaxios } from 'google-auth-library';

class GoogleOAuthClient {
  #client: OAuth2Client;

  constructor() {
    this.#client = new OAuth2Client({
      clientId: getEnvVar('CLIENT_ID'),
      clientSecret: getEnvVar('CLIENT_SECRET'),
      redirectUri: getEnvVar('REDIRECT_URI'),
    });
  }

  async getTokenAndVerifyFromCode(code: string): Promise<TokenPayload> {
    try {
      const { tokens } = await this.#client.getToken(code);
      const verifyResponse = await this.#client.verifyIdToken({ idToken: tokens.id_token as string });
      return verifyResponse.getPayload() as TokenPayload;
    } catch (e: unknown) {
      const error = e as gaxios.GaxiosError;
      throw new Error(JSON.stringify({ name: error.name, message: error.message, status: error.status }));
    }
  }
}

const googleOAuthClient = new GoogleOAuthClient();

export default googleOAuthClient;
