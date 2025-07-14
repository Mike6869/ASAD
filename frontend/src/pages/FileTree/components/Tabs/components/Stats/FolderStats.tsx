import { FC, useState } from "react";
import { Table, Space, Input } from "antd";
import type { ColumnsType } from "antd/es/table";

type StatsData = { id: string; name: string; relPath: string }[];

interface Props {
  stats: StatsData;
}

type DataType = Omit<StatsData[number], "id"> & { key: string };

const columns: ColumnsType<DataType> = [
  { title: "Имя файла", key: "name", dataIndex: "name" },
  { title: "Относительный путь", key: "relPath", dataIndex: "relPath" },
];

const prepareData = (data: StatsData): DataType[] =>
  data.map(({ id, name, relPath }) => ({ name, relPath, key: id }));

const { Search } = Input;

const FolderStats: FC<Props> = ({ stats }) => {
  const [searchPattern, setSearchPattern] = useState("");

  let filteredTableData = null;
  if (searchPattern) {
    const reg = new RegExp(searchPattern, "i");
    filteredTableData = stats.filter(({ name }) => reg.test(name));
  }

  return (
    <Space direction="vertical">
      <Search
        placeholder="Поиск по названию файла"
        allowClear
        onSearch={setSearchPattern}
        style={{ width: 300 }}
      />
      <Table
        columns={columns}
        dataSource={prepareData(filteredTableData ?? stats)}
      />
    </Space>
  );
};

export default FolderStats;
