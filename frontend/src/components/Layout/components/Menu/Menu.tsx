import { ReactElement, FC } from "react";
import { Menu as MenuAntd } from "antd";
import { Link, useLocation } from "react-router-dom";

import "./Menu.scss";
import keycloak from "@services/auth/keycloak";
import { useAppSelector } from "@services/hooks";
import { getUser } from "@services/store/userSelectors";

interface IProps {
  isFooter?: boolean;
  className?: string;
}

const links: [string, string | ReactElement][] = [
  ["/home", "Главная"],
  ["/file-tree", "Архив документов"],
];

const itemsHeader = links.map(([path, desc]) => ({
  label: <Link to={path}>{desc}</Link>,
  key: path,
}));

itemsHeader.push({
  key: "/logout",
  label: (
    <Link to="/" onClick={() => keycloak.logout()}>
      Выход
    </Link>
  ),
});

const itemsHeaderAdmin = itemsHeader.slice();
itemsHeaderAdmin.splice(2, 0, {
  key: "/admin",
  label: <Link to="/admin">Администрирование</Link>,
});

const itemsFooter = itemsHeader.map((item) => item.label);
const itemsFooterAdmin = itemsHeaderAdmin.map((item) => item.label);

const Menu: FC<IProps> = ({ isFooter = false, className = "" }: IProps) => {
  const location = useLocation();
  const { user } = useAppSelector(getUser);
  if (!isFooter) {
    const curRoute = location.pathname;
    const selectedKey = curRoute === "/" ? "/home" : curRoute;
    return (
      <MenuAntd
        className={`${className} menu`}
        mode="horizontal"
        items={user?.isAdmin ? itemsHeaderAdmin : itemsHeader}
        selectedKeys={[selectedKey]}
      />
    );
  }
  return (
    <nav className={`${className} nav-footer`}>
      {user?.isAdmin ? itemsFooterAdmin : itemsFooter}
    </nav>
  );
};

export default Menu;