import { FC } from "react";
import { Badge, Space } from "antd";
import moment from "moment";

import type { IDataNode } from "@pages/FileTree/fileTreeSlice";
import { FileType } from "Types/files.type";

interface Props {
  data: IDataNode;
}

const FileTitle: FC<Props> = ({ data: { file } }) => {
  if (file.fileTypeId !== FileType.Folder) {
    if (file.nextVerId === null) {
      return (
        <Space>
          {file.name}
          <Badge
            className="site-badge-count-109"
            count={file.verNum}
            style={{ backgroundColor: "#52c41a" }}
          />
        </Space>
      );
    }
    return (
      <Space>
        <Badge count={file.verNum} color="#faad14" />
        {moment(file.createdAt).format("DD/MM/YYYY")}
      </Space>
    );
  }
  return <>{file.name}</>;
};

export default FileTitle;
