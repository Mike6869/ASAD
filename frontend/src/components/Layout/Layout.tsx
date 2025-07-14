import { FC } from "react";
import { Outlet } from "react-router-dom";

import Footer from "./Footer/Footer";
import Header from "./Header/Header";

import "./Layout.scss";

const Layout: FC = () => (
  <div className="layout">
    <Header />
    <main className="main">
      <Outlet />
    </main>
    <Footer className="footer" />
  </div>
);

export default Layout;
