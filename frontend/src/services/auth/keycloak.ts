import Keycloak from "keycloak-js";

export const initOptions = {
  onLoad: "login-required",
  checkLoginIframe: true,
  pkceMethod: "S256",
};

const keycloak = new Keycloak({
  url:
    import.meta.env.VITE_KC_BASE_PATH ??
    location.origin + window.URL_PREFIX + "keycloak/",
  realm: import.meta.env.VITE_KC_REALM ?? "doc-analysis",
  clientId: import.meta.env.VITE_KC_CLIENT_ID ?? "react-client",
});

export default keycloak;
