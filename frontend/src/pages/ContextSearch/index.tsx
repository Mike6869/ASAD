import { FC } from "react";
import { App, Empty, Input, Space, Spin, Alert } from "antd";
import { useParams } from "react-router-dom";
import type { SearchProps } from "antd/es/input";
import { ShowMatches } from "./ShowMatches";
import { useLazyGetContextSearchQuery } from "@services/api/file";

const { Search } = Input;

const ContextSearch: FC = () => {
  const { folderId } = useParams();
  const { message } = App.useApp();
  const [getContextSearch, { data: foundMatches, isLoading }] =
    useLazyGetContextSearchQuery();

  if (!folderId) {
    return <Alert message="Отсутствует id директории" type="error" />;
  }

  const handleSearch: SearchProps["onSearch"] = (pattern, _, info) => {
    if (info?.source !== "input") {
      return;
    }
    if (pattern.length < 4) {
      message.info("Длина паттерна поиска должна быть больше 3 символов");
      return;
    }
    const args = { folderId, pattern };
    getContextSearch(args);
  };

  return (
    <Space direction="vertical" size="middle" style={{ margin: 12 }}>
      <Search
        placeholder="Введите паттерн для поиска"
        loading={isLoading}
        onSearch={handleSearch}
        enterButton
        allowClear
        style={{ width: 300 }}
      />
      {isLoading && <Spin />}
      {foundMatches && <ShowMatches matches={foundMatches} />}
      {!isLoading && !foundMatches && <Empty />}
    </Space>
  );
};

export default ContextSearch;
