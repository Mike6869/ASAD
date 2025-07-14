import { getCurrentFileId } from "@pages/FileTree/fileTreeSelectors";
import { useGetFileQuery } from "@services/api/file";
import { useAppSelector } from "@services/hooks";
import { Empty, Spin } from "antd";

const ViewFile = () => {
  const fileId = useAppSelector(getCurrentFileId);
  const { data: file, isLoading, isError, error } = useGetFileQuery(fileId);

  isError && console.error(error);

  if (isLoading) {
    return <Spin size="large" />;
  }

  if (!file) {
    return <Empty />;
  }

  return <div dangerouslySetInnerHTML={{ __html: file || "" }} />;
};

export default ViewFile;
