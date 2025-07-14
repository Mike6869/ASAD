import { FC } from "react";
import { Tabs as AntdTabs } from "antd";
import type { TabsProps } from "antd";

import Glossary from "./components/Glossary";
import Stats from "./components/Stats";
import { Images } from "./components/Images";
import { Tables } from "./Tables";
import ViewFile from "./components/ViewFile";

const items: TabsProps["items"] = [
  {
    key: "Abbr",
    label: `Глоссарий`,
    children: <Glossary />,
  },
  {
    key: "Stat",
    label: `Статистика`,
    children: <Stats />,
  },
  {
    key: "Tables",
    label: `Таблицы`,
    children: <Tables />,
  },
  {
    key: "Images",
    label: `Изображения`,
    children: <Images />,
  },
  {
    key: "ViewFile",
    label: `Просмотр файла`,
    children: <ViewFile />,
  },
];

const Tabs: FC = () => <AntdTabs defaultActiveKey="Abbr" items={items} />;

export default Tabs;
