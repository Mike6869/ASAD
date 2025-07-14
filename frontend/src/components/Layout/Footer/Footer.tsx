import { Space } from "antd";
import { Logo, Menu } from "../components";
import "./Footer.scss";

interface IProps {
  className: string;
}

const Footer = ({ className }: IProps) => (
  <footer className={`${className} footer`}>
    <div className="footer-wrap">
      <Logo />
      <address className="address">
        <a href="mailto:servicedesk@inform.gazprom.ru" className="email">
          <span className="underline">servicedesk@inform.gazprom.ru</span>
        </a>
        <Space direction="horizontal">
          <a href="tel:+74957194588" className="number">
            <span className="underline">(495)719-45-88</span>
          </a>
          <a href="tel:70194588" className="number">
            <span className="underline">(701)9-45-88</span>
          </a>
        </Space>
      </address>
      <Menu isFooter className="footer-menu" />
    </div>
    <div className="copyright">© 2022 Gazprom Inform | All Rights Reserved</div>
  </footer>
);

export default Footer;
