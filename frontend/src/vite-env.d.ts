/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_APP_TITLE: string;
  readonly API_URL: string;
  readonly KC_BASE_PATH: string;
  readonly KC_REALM: string;
  readonly KC_CLIENT_ID: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
