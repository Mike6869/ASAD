import { FC } from "react";
import { Logo, Menu } from "../components";
import "./Header.scss";

const Header: FC = () => (
  <header className="header">
    <Logo />
    <Menu />
  </header>
);

export default Header;
