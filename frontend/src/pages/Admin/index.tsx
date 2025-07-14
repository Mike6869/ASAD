import { FC } from "react";
import { Tabs } from "antd";
import type { TabsProps } from "antd";

import { Roles } from "./AdminTabs/Roles";
import { Users } from "./AdminTabs/Users";
import { ProjectTemplates } from "./AdminTabs/ProjectTemplates";

const items: TabsProps["items"] = [
  { key: "1", label: "Роли", children: <Roles /> },
  {
    key: "2",
    label: "Пользователи",
    children: <Users />,
  },
  {
    key: "3",
    label: "Шаблоны проектов",
    children: <ProjectTemplates />,
  },
];

export const Admin: FC = () => (
  <Tabs
    defaultActiveKey="1"
    items={items}
    style={{ height: "100vh", margin: "16px" }}
  />
);
