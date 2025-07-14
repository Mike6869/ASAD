import { FC, useState } from "react";
import { Table as AntdTable, TablePaginationConfig } from "antd";

export interface Table {
  header: string[];
  rows: string[][];
}

interface Props {
  table: Table;
}

const Table: FC<Props> = ({ table: { header, rows } }) => {
  const { columns, dataSource } = generateTableData(header, rows);
  const [pagination, setPagination] = useState<TablePaginationConfig>({
    pageSizeOptions: [5, 10, 20, 50, 100],
    showSizeChanger: true,
    hideOnSinglePage: true,
    defaultPageSize: 5,
  });

  const handleTableChange = (newPagination: TablePaginationConfig) =>
    setPagination(() => newPagination);

  return (
    <AntdTable
      columns={columns}
      dataSource={dataSource}
      pagination={pagination}
      onChange={handleTableChange}
    />
  );
};

function generateTableData(header: string[], rows: string[][]) {
  const columns = header.map((val) => ({
    title: val,
    dataIndex: val,
    key: val,
  }));

  const data = [];
  for (let i = 0; i < rows.length; i++) {
    const newRow: { [key: string]: string } = {};
    for (let j = 0; j < header.length; j++) {
      newRow[header[j]] = rows[i][j];
    }
    newRow.key = i.toString();
    data.push(newRow);
  }

  return { columns, dataSource: data };
}

export default Table;
