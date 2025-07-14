import { FC } from "react";
import { Empty, message, Space, Spin } from "antd";

import { useAppSelector } from "@services/hooks";
import MessageErrorContent from "@components/MessageErrorContent";
import { getCurrentFileId } from "../../../fileTreeSelectors";

import Table from "./components/Table";
import { useGetTablesQuery } from "@services/api/file";

export const Tables: FC = () => {
  const fileId = useAppSelector(getCurrentFileId);
  const { data: tables, isLoading, isError, error } = useGetTablesQuery(fileId);

  isError &&
    message.error({
      content: (
        <MessageErrorContent
          title="Возникла ошибка при получении списка проектов"
          details={error ? ("error" in error ? error.error : "") : ""}
        />
      ),
    });

  if (isLoading) {
    return <Spin size="large" />;
  }

  if (tables?.tables.length === 0) {
    return <Empty />;
  }

  return (
    <Space direction="vertical">
      {tables?.tables.map((table, i) => (
        <Table key={i} header={table.header} rows={table.rows} />
      ))}
    </Space>
  );
};
