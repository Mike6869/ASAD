import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import store from "@services/store";

import "./styles/fonts.scss";
import "./styles/index.scss";
import "antd/dist/reset.css";
import Main from "./app/Main";

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <Provider store={store}>
    <Main />
  </Provider>
);
