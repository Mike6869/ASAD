import React, { FC, useEffect } from "react";
import { Image, Space, Spin, Card, App } from "antd";
import moment from "moment";

import type { Metadata } from "@pages/FileTree/fileTreeSlice";
import MessageErrorContent from "@components/MessageErrorContent";
import {
  DocumentStatsType,
  useGetMetadataQuery,
  useGetWordcloudSrcQuery,
} from "@services/api/file";

interface Props {
  stats: DocumentStatsType;
}

const gridStyle: React.CSSProperties = {
  width: "50%",
  padding: "12px",
};

const makeStatsInfo = (stats: Props["stats"], metadata: Metadata) => [
  `Имя: ${stats.name}`,
  `Размер: ${stats.size} МБ`,
  metadata.types[stats.typeId].url
    ? `Тип документа: <a href="${
        metadata.types[stats.typeId].url
      }" target="_blank" rel="noopener noreferrer">${
        metadata.types[stats.typeId].typeName
      }</a>`
    : `Тип документа: ${metadata.types[stats.typeId].typeName}`,
  `Кол-во слов: ${stats.wordsCount}`,
  `Статус документа: ${metadata.statuses[stats.statusId].status}`,
  `Автор: ${stats.author}`,
  `Процент завершения: ${stats.completionPercentage}%`,
  `Последним внес изменения: ${stats.lastModifiedBy}`,
  `Дата последнего изменения: ${moment(stats.modifiedAt).format("DD/MM/YYYY")}`,
  `Создано: ${moment(stats.createdAt).format("DD/MM/YYYY")}`,
];

const DocumentStats: FC<Props> = ({ stats }) => {
  const { data: metadata } = useGetMetadataQuery();
  const { message } = App.useApp();

  if (!metadata) {
    return <Spin size="large" />;
  }

  const data = makeStatsInfo(stats, metadata);
  const {
    data: imgSrc,
    isError,
    isLoading,
    error,
  } = useGetWordcloudSrcQuery(stats.fileId);

  useEffect(() => {
    if (!error) {
      return;
    }
    if (isError) {
      message.error(
        <MessageErrorContent
          title="Не удалось загрузить облако слов"
          details={error ? ("error" in error ? error.error : "") : ""}
        />
      );
    }
  }, [error]);

  return (
    <Space direction="vertical" size="middle">
      <Card>
        {data.map((item, index) => (
          <Card.Grid style={gridStyle} key={index}>
            <div dangerouslySetInnerHTML={{ __html: item }} />
          </Card.Grid>
        ))}
      </Card>
      {isLoading ? <Spin /> : <Image alt="Word-cloud" src={imgSrc} />}
    </Space>
  );
};

export default DocumentStats;
