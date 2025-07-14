import { FC } from "react";
import {
  Form,
  Alert,
  Select,
  Slider,
  Input,
  FormInstance,
  message,
} from "antd";
import { useGetMetadataQuery } from "@services/api/file";

interface DocumentAttributeInputsNewVerProps {
  form: FormInstance;
}

const DocumentAttributeInputsNewVer: FC<DocumentAttributeInputsNewVerProps> = ({
  form,
}) => {
  const { data: metadata } = useGetMetadataQuery();
  if (!metadata) {
    return (
      <Alert message="Отсутствуют метаданные атрибутов" type="error" showIcon />
    );
  }

  // Обработка изменения типа документа
  const handleTypeChange = (value: number) => {
    const newTypeId = Number(value);

    // Получаем URL для выбранного типа документа
    const url = metadata.types[newTypeId]?.url || "";
    form.setFieldsValue({ documentUrl: url });

    // Показываем уведомление, если URL пуст
    if (!url) {
      message.warning("Шаблон документа отсутствует");
    }
  };

  return (
    <>
      <Form.Item
        name="documentTypeId"
        label="Тип документа"
        required
        rules={[{ required: true }]}
      >
        <Select
          placeholder="Выберите тип документа"
          onChange={handleTypeChange}
        >
          {Object.entries(metadata.types).map(([id, { code, typeName }]) => (
            <Select.Option key={id} value={id}>
              [{code}] {typeName}
            </Select.Option>
          ))}
        </Select>
      </Form.Item>

      <Form.Item name="documentUrl" label="Ссылка на шаблон документа">
        <Input readOnly />
      </Form.Item>

      <Form.Item
        name="statusId"
        label="Статус"
        required
        rules={[{ required: true }]}
      >
        <Select>
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

export default DocumentAttributeInputsNewVer;