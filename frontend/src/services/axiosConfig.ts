import axios from "axios";

import keycloak from "./auth/keycloak";

const BACKEND_URL =
  import.meta.env.VITE_API_URL ?? location.origin + window.URL_PREFIX;

const apiClient = axios.create({
  baseURL: BACKEND_URL + "api/",
});

apiClient.interceptors.request.use((config) => {
  config.headers.Authorization = `Bearer ${keycloak.token ?? ""}`;
  return config;
});

export default apiClient;
