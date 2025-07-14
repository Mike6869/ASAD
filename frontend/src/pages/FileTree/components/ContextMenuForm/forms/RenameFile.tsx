import { FC, useState } from "react";
import { Modal, Form, message as messageAntd, Input } from "antd";

import MessageErrorContent from "@components/MessageErrorContent";
import {
  closeForm as closeFileForm,
  rename as fileRename,
} from "../../../fileTreeSlice";
import {
  closeForm as closeTemplateForm,
  rename as templateRename,
} from "@pages/Admin/AdminTabs/ProjectTemplates/templateTreeSlice";
import { useAppDispatch } from "@services/hooks";
import { useRenameFileMutation } from "@services/api/file";
import { useRenameTemplateMutation } from "@services/api/template";

interface Props {
  id: string;
  name: string;
  template?: boolean;
}

interface FormData {
  newName: string;
}

const RenameFile: FC<Props> = ({ id, name, template }) => {
  const dispatch = useAppDispatch();
  const [messageApi, contextHolder] = messageAntd.useMessage();
  const [open, setOpen] = useState(true);
  // const [confirmLoading, setConfirmLoading] = useState(false);
  const [form] = Form.useForm();
  const [
    renameFileApi,
    { isError: isFileError, isLoading: confirmFileLoading, error: fileError },
  ] = useRenameFileMutation();

  const [
    renameTemplateApi,
    {
      isError: isTemplateError,
      isLoading: confirmTempateLoading,
      error: templateError,
    },
  ] = useRenameTemplateMutation();

  const onFileCancel = () => {
    setOpen(false);
    form.resetFields();
    dispatch(closeFileForm());
  };

  const onTemplateCancel = () => {
    setOpen(false);
    form.resetFields();
    dispatch(closeTemplateForm());
  };

  const renameFile = (newName: string) => {
    const result = { newName, id };
    renameFileApi(result)
      .unwrap()
      .then((changedName) => {
        onFileCancel();
        dispatch(fileRename({ id, newName: changedName }));
      });
    isFileError && showErrorMessage(fileError.toString());
  };

  const renameTemplate = (newName: string) => {
    const result = { newName, id };
    renameTemplateApi(result)
      .unwrap()
      .then((changedName) => {
        onTemplateCancel();
        dispatch(templateRename({ id, newName: changedName }));
      });
    isTemplateError && showErrorMessage(templateError.toString());
  };

  const onsubmit = () => {
    form.validateFields().then(({ newName }: FormData) => {
      template ? renameTemplate(newName) : renameFile(newName);
    });
  };

  const showErrorMessage = (message: string) => {
    messageApi.open({
      type: "error",
      content: (
        <MessageErrorContent
          title="Не удалось переименовать"
          details={message}
        />
      ),
    });
  };

  return (
    <Modal
      open={open}
      title="Переименовать"
      okText="Подтвердить"
      onOk={onsubmit}
      confirmLoading={template ? confirmTempateLoading : confirmFileLoading}
      cancelText="Отмена"
      onCancel={template ? onTemplateCancel : onFileCancel}
      maskClosable={false}
    >
      <Form
        form={form}
        layout="vertical"
        name="renameForm"
        initialValues={{ newName: name }}
      >
        {contextHolder}
        <Form.Item
          name="newName"
          label="Новое название"
          rules={[
            {
              required: true,
              message: "Введите название",
            },
          ]}
        >
          <Input />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default RenameFile;
