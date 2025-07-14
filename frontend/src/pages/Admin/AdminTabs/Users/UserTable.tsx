import { FC } from "react";
import type { TableProps } from "antd";
import { Table } from "antd";
import moment from "moment";
import { useGetUserListQuery } from "@services/api/users";

interface DataType {
  id: string;
  username: string;
  email: string;
  firstName: string;
  lastName: string;
  enabled: boolean;
  createdTimestamp: number;
}

const columns: TableProps<DataType>["columns"] = [
  { title: "Пользователь", dataIndex: "username", key: "username" },
  { title: "Почта", dataIndex: "email", key: "email" },
  { title: "Имя", dataIndex: "firstName", key: "firstName" },
  { title: "Фамилия", dataIndex: "lastName", key: "lastName" },
  {
    title: "Дата создания",
    dataIndex: "createdAt",
    key: "createdAt",
    render: (date) => moment(date).format("DD.MM.YYYY"),
  },
];

export const UserTable: FC = () => {
  const { data: users = [] } = useGetUserListQuery();

  return <Table rowKey="id" columns={columns} dataSource={users} />;
};
