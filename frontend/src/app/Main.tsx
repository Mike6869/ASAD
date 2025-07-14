import React from "react";
import { BrowserRouter } from "react-router-dom";
import { App as AntdApp } from "antd";
import { ReactKeycloakProvider } from "@react-keycloak/web";
import App from "./App";
import keycloak, { initOptions } from "@services/auth/keycloak";
import type { AuthClientEvent } from "@react-keycloak/core/lib/types";
import { useLazyGetUserInfoQuery } from "@services/api/userInfo";
import store from "@services/store";
import { clearUser, setUser } from "@services/store/userSlice";

const Main = () => {
  const [getUser] = useLazyGetUserInfoQuery();
  const eventHandler = async (event: AuthClientEvent) => {
    switch (event) {
      case "onAuthSuccess": {
        await getUser()
          .unwrap()
          .then((data) => store.dispatch(setUser(data)));
        break;
      }
      case "onAuthLogout":
        store.dispatch(clearUser());
        break;
      default:
    }
  };
  return (
    <ReactKeycloakProvider
      authClient={keycloak}
      initOptions={initOptions}
      onEvent={eventHandler}
    >
      <React.StrictMode>
        <BrowserRouter 
          future={{
            v7_startTransition: true,
            v7_relativeSplatPath: true
          }}
        >
          <AntdApp>
            <App />
          </AntdApp>
        </BrowserRouter>
      </React.StrictMode>
    </ReactKeycloakProvider>
  );
};

export default Main;