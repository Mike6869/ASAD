import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";
import keycloak from "@services/auth/keycloak";

const BACKEND_URL =
  import.meta.env.VITE_API_URL ?? location.origin + window.URL_PREFIX;

export const api = createApi({
  reducerPath: "api",
  tagTypes: ["Users", "Files", "Templates"],
  baseQuery: fetchBaseQuery({
    baseUrl: BACKEND_URL + "api/",
    prepareHeaders: (headers) =>
      headers.set("Authorization", `Bearer ${keycloak.token ?? ""}`),
  }),
  refetchOnFocus: true,
  endpoints: () => ({}),
});
