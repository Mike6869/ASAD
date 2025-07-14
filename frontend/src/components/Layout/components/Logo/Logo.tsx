import { Link } from "react-router-dom";

import "./Logo.scss";

const Logo = () => (
  <Link to="home" className="logo-wrapper">
    <div className="logo" />
  </Link>
);

export default Logo;
