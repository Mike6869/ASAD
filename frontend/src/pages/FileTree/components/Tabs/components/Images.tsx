import { FC } from "react";
import { Empty, Spin, Image, message, Space } from "antd";

import { useAppSelector } from "@services/hooks";
import { getCurrentFileId } from "@pages/FileTree/fileTreeSelectors";
import MessageErrorContent from "@components/MessageErrorContent";
import { useGetImagesSrcQuery } from "@services/api/file";

export const Images: FC = () => {
  const fileId = useAppSelector(getCurrentFileId);
  const {
    data: images,
    isLoading,
    isError,
    error,
  } = useGetImagesSrcQuery(fileId);

  if (isLoading) {
    return <Spin size="large" />;
  }

  isError &&
    message.error({
      content: (
        <MessageErrorContent
          title="Возникла ошибка при получении списка проектов"
          details={error ? ("error" in error ? error.error : "") : ""}
        />
      ),
    });

  if (images?.imgList.length === 0) {
    return <Empty />;
  }

  return (
    <Space direction="vertical">
      {images &&
        images?.imgList.map((image, i) => <Image key={i} src={image.src} />)}
    </Space>
  );
};
