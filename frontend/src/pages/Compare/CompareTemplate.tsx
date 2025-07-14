import { FC, useState } from "react";
import { Button, Space, Spin, message } from "antd";
import { useParams } from "react-router-dom";

import MessageErrorContent from "@components/MessageErrorContent";
import VersionComparison from "./VersionComparison";
import SelectFiles from "./SelectFiles";
import {
  useGetBranchQuery,
  useLazyGetTemplateFileComparisonQuery,
} from "@services/api/file";

const Compare: FC = () => {
  const params = useParams();
  const [firstFileId, setFirstFile] = useState<number | null>(null);
  const [
    getVerFileComparison,
    { data: comparison, isError, error, isLoading },
  ] = useLazyGetTemplateFileComparisonQuery();
  const { data: branch } = useGetBranchQuery(params.branchId as string);

  const handleCompare = () => {
    if (firstFileId === null) {
      return;
    }
    const result = { firstFileId };
    getVerFileComparison(result);
  };

  isError &&
    message.error({
      content: (
        <MessageErrorContent
          title="Возникла ошибка при выполнении сравнения"
          details={error ? ("error" in error ? error.error : "") : ""}
        />
      ),
    });

  if (!branch) {
    return <Spin size="large" style={{ margin: "16px" }} />;
  }

  return (
    <Space direction="vertical" style={{ margin: "16px" }}>
      <Space>
        <SelectFiles files={branch} onSelectFirstFile={setFirstFile} />
        <Button
          type="primary"
          onClick={handleCompare}
          disabled={!firstFileId}
          loading={isLoading}
        >
          Сравнить
        </Button>
      </Space>
      <VersionComparison comparison={comparison} />
    </Space>
  );
};

export default Compare;
