import { Space } from "antd";
import { FC } from "react";
import { CreateUser } from "./CreateUser";
import { UserTable } from "./UserTable";

export const Users: FC = () => (
  <Space direction="vertical">
    <CreateUser />
    <UserTable />
  </Space>
);
