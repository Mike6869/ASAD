import { FC, useEffect, useState } from "react";
import { Form, Modal, message } from "antd";
import { DocumentProps, FileType, VerFileProps } from "Types/files.type";
import DocumentAttributeInputsNextVer from "./DocumentAttributeInputsNextVer";
import { useCreateVerFileMutation, VerFile } from "@services/api/file";

interface Props {
  open: boolean;
  onCancel: () => void;
  onCreate: (createdFile: VerFileProps | DocumentProps) => void;
  file: File | null;
  fileProps: VerFileProps | null;
}

interface FormValues {
  documentTypeId: number;
  statusId: number;
  completionPercentage: number;
}

const CreateNextVerFileForm: FC<Props> = ({
  open,
  file,
  fileProps,
  onCancel,
  onCreate,
}) => {
  const [submittable, setSubmittable] = useState(false);
  const [form] = Form.useForm<FormValues>();
  const formWatch = Form.useWatch([], form);
  const [messageApi, contextHolder] = message.useMessage();
  const [createVerFile, { isError, isLoading: confirmLoading, error }] =
    useCreateVerFileMutation();

  useEffect(() => {
    form.validateFields({ validateOnly: true }).then(
      () => setSubmittable(true),
      () => setSubmittable(false)
    );
  }, [formWatch]);

  if (!(fileProps && file)) {
    messageApi.open({
      type: "error",
      content:
        "Отсутствует загружаемый документ или не выделена предыдущая версия документа.",
    });
    return null;
  }

  const handleCreate = () => {
    const formData: VerFile = {
      file,
      ...formWatch,
      typeId: FileType.Document,
      name: fileProps.name,
      prevVerId: fileProps.id.toString(),
    };
    const parentId = fileProps?.parentId;
    const result = { parentId, formData };
    createVerFile(result)
      .unwrap()
      .then((createdFile) => {
        onCreate(createdFile);
        form.resetFields();
      });
    isError &&
      messageApi.open({
        type: "error",
        content: `Не удалось загрузить файл. ${error.toString()}`,
      });
  };

  return (
    <>
      {contextHolder}
      <Modal
        open={open}
        title="Добавить следующую версию"
        onOk={handleCreate}
        okText="Создать"
        okButtonProps={{ disabled: !submittable }}
        confirmLoading={confirmLoading}
        onCancel={onCancel}
        cancelText="Закрыть"
        maskClosable={false}
      >
        <Form form={form} layout="vertical" name="createNextVerForm">
          <DocumentAttributeInputsNextVer
            prevVerId={fileProps.id.toString()}
            form={form}
          />
        </Form>
      </Modal>
    </>
  );
};

export default CreateNextVerFileForm;
