import React, { FC } from "react";
import { Space, Card } from "antd";
import moment from "moment";
import { FileStatsType } from "@services/api/file";

interface Props {
  stats: FileStatsType;
}

const gridStyle: React.CSSProperties = {
  width: "50%",
  padding: "12px",
};

const makeStatsInfo = (stats: Props["stats"]) => [
  `Имя: ${stats.name}`,
  `Размер: ${stats.size} МБ`,
  `Создано: ${moment(stats.createdAt).format("DD/MM/YYYY")}`,
];

const FileStats: FC<Props> = ({ stats }) => {
  const data = makeStatsInfo(stats);

  return (
    <Space direction="vertical" size="middle">
      <Card>
        {data.map((item, ind) => (
          <Card.Grid key={ind} style={gridStyle}>
            {item}
          </Card.Grid>
        ))}
      </Card>
    </Space>
  );
};

export default FileStats;
