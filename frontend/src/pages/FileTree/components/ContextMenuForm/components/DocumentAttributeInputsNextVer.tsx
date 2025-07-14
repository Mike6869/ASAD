import { FC, useEffect } from "react";
import { Form, Alert, Select, Slider, message, FormInstance } from "antd";

import { FileType } from "Types/files.type";
import { useGetMetadataQuery, useGetStatsQuery } from "@services/api/file";

interface Props {
  prevVerId: string;
  form: FormInstance;
}

const DocumentAttributeInputsNextVer: FC<Props> = ({ prevVerId, form }) => {
  const { data: metadata } = useGetMetadataQuery();
  const [messageApi, contextHolder] = message.useMessage();
  const { data, isError, isLoading, error } = useGetStatsQuery(prevVerId);

  useEffect(() => {
    if (data?.fileTypeId === FileType.Document) {
      form.setFieldsValue({
        documentTypeId: data?.stats.typeId.toString(),
        statusId: data?.stats.statusId.toString(),
        completionPercentage: data?.stats.completionPercentage,
      });
    }
  }, [data, form]);

  if (!metadata) {
    isError && messageApi.open({ type: "error", content: error.toString() });

    return (
      <Alert message="Отсутствуют метаданные атрибутов" type="error" showIcon />
    );
  }

  return (
    <>
      {contextHolder}
      <Form.Item
        name="documentTypeId"
        label="Тип документа"
        required
        rules={[{ required: true }]}
      >
        <Select loading={isLoading}>
          {Object.entries(metadata.types).map(([id, { code, typeName }]) => (
            <Select.Option key={id} value={id}>
              [{code}] {typeName}
            </Select.Option>
          ))}
        </Select>
      </Form.Item>

      <Form.Item
        name="statusId"
        label="Статус"
        required
        rules={[{ required: true }]}
      >
        <Select loading={isLoading}>
          {Object.entries(metadata.statuses).map(([id, { status }]) => (
            <Select.Option key={id} value={id}>
              {status}
            </Select.Option>
          ))}
        </Select>
      </Form.Item>

      <Form.Item
        name="completionPercentage"
        label="Процент выполнения"
        required
        rules={[{ required: true }]}
        initialValue={10}
      >
        <Slider min={10} max={100} step={10} />
      </Form.Item>
    </>
  );
};

export default DocumentAttributeInputsNextVer;