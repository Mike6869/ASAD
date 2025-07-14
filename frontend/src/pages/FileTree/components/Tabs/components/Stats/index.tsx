import { FC } from "react";
import { message, Empty, Spin } from "antd";

import MessageErrorContent from "@components/MessageErrorContent";
import { useAppSelector } from "@services/hooks";
import { FileType } from "Types/files.type";
import { getCurrentFileId } from "../../../../fileTreeSelectors";
import FolderStats from "./FolderStats";
import FileStats from "./FileStats";
import DocumentStats from "./DocumentStats";
import ProjectStats from "./ProjectStats";
import { useGetStatsQuery } from "@services/api/file";

const Stats: FC = () => {
  const fileId = useAppSelector(getCurrentFileId);
  const {
    data: statsData,
    isError,
    isLoading,
    error,
  } = useGetStatsQuery(fileId);

  isError &&
    message.error({
      content: (
        <MessageErrorContent
          title="Возникла ошибка при получении статистики"
          details={error ? ("error" in error ? error.error : "") : ""}
        />
      ),
    });

  if (isLoading) {
    return <Spin />;
  }

  if (!statsData) {
    return <Empty />;
  }

  switch (statsData.fileTypeId) {
    case FileType.Folder:
      if (!statsData.isProject) {
        return <FolderStats stats={statsData.stats} />;
      }
      return <ProjectStats stats={statsData.stats} />;

    case FileType.VerFile:
      return <FileStats stats={statsData.stats} />;

    case FileType.Document:
      return <DocumentStats stats={statsData.stats} />;

    default:
      return <Empty />;
  }
};

export default Stats;
