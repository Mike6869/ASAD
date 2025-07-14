import { FC } from "react";
import { Badge, Select, Space } from "antd";
import moment from "moment";

import { VerFileProps } from "Types/files.type";

interface Props {
  files: VerFileProps[];
  onSelectFirstFile: (fileId: number) => void;
  onSelectSecondFile?: (fileId: number) => void;
}

const fileComparison = (a: VerFileProps, b: VerFileProps) =>
  a.verNum > b.verNum ? -1 : a.verNum < b.verNum ? 1 : 0;

const SelectFiles: FC<Props> = ({
  files,
  onSelectFirstFile,
  onSelectSecondFile,
}) => {
  const selectOptions = files
    .slice()
    .sort(fileComparison)
    .map((file) => ({
      value: file.id,
      label: (
        <Space>
          <Badge count={file.verNum} color="#faad14" />
          {moment(file.createdAt).format("DD/MM/YYYY")}
        </Space>
      ),
    }));

  return (
    <Space>
      <Select
        style={{ width: "140px" }}
        options={selectOptions}
        placeholder="Первая версия"
        onChange={(value: number) => onSelectFirstFile(value)}
      />
      {onSelectSecondFile && (
        <Select
          style={{ width: "140px" }}
          options={selectOptions}
          placeholder="След. версия"
          onChange={(value: number) => onSelectSecondFile(value)}
        />
      )}
    </Space>
  );
};

export default SelectFiles;
