import React, { FC } from "react";
import { Card, Col, Row, Space, Spin } from "antd";
import moment from "moment";

import { Metadata } from "@pages/FileTree/fileTreeSlice";
import CompletionPercentageBar from "./CompletionPercentageBar";
import StatusPie from "./StatusPie";
import {
  ProjectStatsApiResponse,
  useGetMetadataQuery,
} from "@services/api/file";

export type StatsData = ProjectStatsApiResponse & {
  actualNumberOfDocuments: number;
  modifiedAt: string;
  completionPercentageStats: { completionPercentage: number; count: number }[];
  statusStats: { statusName: string; count: number }[];
};

interface Props {
  stats: ProjectStatsApiResponse;
}

const gridStyle: React.CSSProperties = {
  width: "50%",
  padding: "12px",
};

const prepareStats = (
  rawStats: ProjectStatsApiResponse,
  metadata: Metadata
): StatsData => {
  const { documentsList } = rawStats;
  const modifiedAt =
    documentsList.length === 0
      ? rawStats.createdAt
      : documentsList.reduce(
          (maxDate, curDoc) =>
            moment(curDoc.modifiedAt).isAfter(maxDate)
              ? curDoc.modifiedAt
              : maxDate,
          documentsList[0].modifiedAt
        );
  const completionPercentageStats: Record<number, number> = {};
  const statusStats: Record<number, number> = {};
  for (const { completionPercentage, statusId } of documentsList) {
    completionPercentageStats[completionPercentage] = completionPercentageStats[
      completionPercentage
    ]
      ? completionPercentageStats[completionPercentage] + 1
      : 1;
    statusStats[statusId] = statusStats[statusId]
      ? statusStats[statusId] + 1
      : 1;
  }
  const processedStats = {
    ...rawStats,
    actualNumberOfDocuments: documentsList.length,
    completionPercentageStats: Object.entries(completionPercentageStats).map(
      ([completionPercentage, count]) => ({
        completionPercentage: +completionPercentage,
        count,
      })
    ),
    statusStats: Object.entries(statusStats).map(([statusId, count]) => ({
      statusName: metadata.statuses[+statusId].status,
      count,
    })),
    modifiedAt,
  };
  const emptyDocumentsCount =
    rawStats.expectedNumberOfDocuments - documentsList.length;
  processedStats.completionPercentageStats.push({
    completionPercentage: 0,
    count: emptyDocumentsCount,
  });
  processedStats.statusStats.push({
    statusName: "Не представлен",
    count: emptyDocumentsCount,
  });
  return processedStats;
};

const makeStatsInfo = (stats: StatsData) => [
  `Фактическое кол-во документов: ${stats.documentsList.length}`,
  `Создано: ${moment(stats.createdAt).format("DD/MM/YYYY")}`,
  `Требуемое кол-во документов: ${stats.expectedNumberOfDocuments}`,
  `Дата последнего изменения: ${moment(stats.modifiedAt).format("DD/MM/YYYY")}`,
];

const ProjectStats: FC<Props> = ({ stats }) => {
  const { data: metadata } = useGetMetadataQuery();
  if (!metadata) {
    return <Spin size="large" />;
  }
  const processedStats = prepareStats(stats, metadata);
  return (
    <Space direction="vertical" size="middle" style={{ width: "100%" }}>
      <Card title={stats.name}>
        {makeStatsInfo(processedStats).map((item) => (
          <Card.Grid style={gridStyle} key={item}>
            {item}
          </Card.Grid>
        ))}
      </Card>
      <Row>
        <Col span={12}>
          <StatusPie data={processedStats.statusStats} />
        </Col>
        <Col span={12}>
          <CompletionPercentageBar
            data={processedStats.completionPercentageStats}
          />
        </Col>
      </Row>
    </Space>
  );
};

export default ProjectStats;
