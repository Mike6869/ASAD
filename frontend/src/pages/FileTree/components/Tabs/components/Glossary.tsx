import React, { FC, useEffect, useState } from "react";
import { Table, message, Input, Space } from "antd";
import type { ColumnsType } from "antd/es/table";

import MessageErrorContent from "@components/MessageErrorContent";
import { useAppSelector } from "@services/hooks";
import { getCurrentFileId } from "../../../fileTreeSelectors";
import { useGetAbbreviationsQuery } from "@services/api/file";
import axiosConfig from "@services/axiosConfig";
import { downloadFile } from "@utils/downloadFile";

const { Search } = Input;

interface DataType {
  key: React.Key;
  abbreviation: string;
  description: string;
  source: React.ReactElement;
}

const columns: ColumnsType<DataType> = [
  {
    title: "Термин",
    dataIndex: "abbreviation",
    width: 150,
  },
  {
    title: "Определение",
    dataIndex: "description",
  },
  {
    title: "Источник",
    dataIndex: "source",
    width: 200,
  },
];

const Glossary: FC = () => {
  const [tableData, setTableData] = useState<DataType[]>([]);
  const [searchPattern, setSearchPattern] = useState("");
  const fileId = useAppSelector(getCurrentFileId);
  const { data, isLoading, isError, error } = useGetAbbreviationsQuery(fileId);
  let newTableData: DataType[] = [];

  let filteredTableData = null;
  if (searchPattern) {
    const reg = new RegExp(searchPattern, "i");
    filteredTableData = tableData.filter(({ abbreviation }) =>
      reg.test(abbreviation)
    );
  }

  function getDownloadLink(id: string | number) {
    return `${axiosConfig.defaults}file/${id}/download`;
  }

  useEffect(() => {
    data &&
      (newTableData = data.abbreviations.map((abbr) => ({
        key: abbr.id,
        source: (
          <a
            href={getDownloadLink(abbr.file_id)}
            onClick={(e) => {
              e.preventDefault();
              downloadFile(abbr.file_id.toString(), data.files[abbr.file_id], false);
            }}
          >
            {data.files[abbr.file_id]}
          </a>
        ),
        abbreviation: abbr.abbreviation,
        description: abbr.description,
      })));
    setTableData(newTableData);
    isError &&
      message.error({
        content: (
          <MessageErrorContent
            title="Возникла ошибка при получении списка проектов"
            details={"error" in error ? error.error : ""}
          />
        ),
      });
  }, [data]);

  return (
    <Space direction="vertical">
      <Search
        placeholder="Поиск по термину"
        allowClear
        onSearch={setSearchPattern}
        style={{ width: 300 }}
      />
      <Table
        columns={columns}
        loading={isLoading}
        dataSource={filteredTableData ?? tableData}
      />
    </Space>
  );
};

export default Glossary;
