import getEnvVar from 'env/index';
import { Credentials, gaxios } from 'google-auth-library';
import { google, youtube_v3 } from 'googleapis';
import { parseEnv } from 'env';

const OAuth2 = google.auth.OAuth2;
parseEnv();

class Yt {
  #client: InstanceType<typeof OAuth2>;
  #SCOPES: string[];
  #youtube: youtube_v3.Youtube;

  constructor() {
    this.#SCOPES = [getEnvVar('SCOPE')];
    this.#client = new OAuth2(getEnvVar('CLIENT_ID'), getEnvVar('CLIENT_SECRET'), getEnvVar('REDIRECT_URI'));
    this.#youtube = google.youtube({
      version: 'v3',
      auth: this.#client,
    });
  }

  generateAuthUrl() {
    return this.#client.generateAuthUrl({
      access_type: 'offline',
      scope: this.#SCOPES,
    });
  }

  async getToken(code: string): Promise<Credentials> {
    const { tokens } = await this.#client.getToken(code);
    this.#client.setCredentials(tokens);
    return tokens;
  }

  setCredentials(access_token: string, refresh_token: string) {
    const credentials: Credentials = {
      access_token,
      refresh_token,
    };
    this.#client.setCredentials(credentials);
  }

  async refreshToken(): Promise<Credentials> {
    if (!this.#client.credentials.refresh_token) {
      throw new Error('No refresh token available');
    }
    try {
      const { credentials } = await this.#client.refreshAccessToken();
      this.#client.setCredentials(credentials);
      return credentials;
    } catch (error) {
      console.error('Error refreshing token: ', error);
      throw error;
    }
  }

  async checkTokenValidity(): Promise<boolean> {
    try {
      await this.#youtube.channels.list({
        part: ['snippet'],
        mine: true,
      });
      return true;
    } catch (error: unknown) {
      if (error instanceof gaxios.GaxiosError && error.response && error.response.status === 401) {
        return false;
      }
      throw error;
    }
  }

  async revokeToken(): Promise<boolean> {
    try {
      const tokens = this.#client.credentials;
      if (tokens.access_token) {
        try {
          await this.#client.revokeToken(tokens.access_token);
        } catch (error: unknown) {
          if (this.isGoogleApiError(error) && error.response?.data.error === 'invalid_token') {
            console.log('Access token already invalid or revoked');
          } else {
            throw error;
          }
        }
      }
      if (tokens.refresh_token) {
        try {
          await this.#client.revokeToken(tokens.refresh_token);
        } catch (error: unknown) {
          if (this.isGoogleApiError(error) && error.response?.data.error === 'invalid_token') {
            console.log('Refresh token already invalid or revoked');
          } else {
            throw error;
          }
        }
      }
      this.#client.setCredentials({});
      return true;
    } catch (error) {
      console.error('Error revoking token: ', error);
      return false;
    }
  }

  private isGoogleApiError(error: unknown): error is gaxios.GaxiosError {
    return (
      error instanceof gaxios.GaxiosError &&
      error.response !== undefined &&
      error.response.data !== undefined &&
      typeof error.response.data === 'object' &&
      error.response.data !== null &&
      'error' in error.response.data &&
      typeof error.response.data.error === 'string'
    );
  }
}

const yt = new Yt();
export default yt;
