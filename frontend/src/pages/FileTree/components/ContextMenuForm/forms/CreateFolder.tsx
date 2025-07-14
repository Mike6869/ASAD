import { FC, useState } from "react";
import { Modal, Form, message as messageAntd, Input } from "antd";

import MessageErrorContent from "@components/MessageErrorContent";
import { useAppDispatch } from "@services/hooks";
import type { FileProps } from "Types/files.type";
import {
  closeForm as closeFileForm,
  add as addFile,
} from "../../../fileTreeSlice";
import makeDataNode from "../../../utils/makeDataNode";
import { useCreateFolderMutation } from "@services/api/file";
import { TemplateProps } from "Types/template.type";
import makeTemplateNode from "@pages/Admin/AdminTabs/ProjectTemplates/utils/makeTemplateNode";
import {
  add as addTemplate,
  closeForm as closeTemplateForm,
} from "@pages/Admin/AdminTabs/ProjectTemplates/templateTreeSlice";
import { useCreateTemplateFolderMutation } from "@services/api/template";

interface Props {
  parentId: string;
  template?: boolean;
}

interface FormData {
  folderName: string;
}

const CreateFolder: FC<Props> = ({ parentId, template }) => {
  const dispatch = useAppDispatch();
  const [messageApi, contextHolder] = messageAntd.useMessage();
  const [open, setOpen] = useState(true);
  const [form] = Form.useForm();
  const [createFolderApi, { isLoading: confirmLoading, isError, error }] =
    useCreateFolderMutation();
  const [
    createTemplateFolderApi,
    {
      isLoading: confirmTemplateLoading,
      isError: isTemplateError,
      error: Templateerror,
    },
  ] = useCreateTemplateFolderMutation();

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

  const createFolder = (name: string) => {
    const result = { name, parentId };
    createFolderApi(result)
      .unwrap()
      .then((folder: FileProps) => {
        onFileCancel();
        dispatch(
          addFile({ parentKey: parentId, dataNode: makeDataNode(folder) })
        );
      });
    isError && showErrorMessage(error.toString());
  };

  const createTemplateFolder = (name: string) => {
    const result = { name, parentId };
    createTemplateFolderApi(result)
      .unwrap()
      .then((folder: TemplateProps) => {
        onTemplateCancel();
        dispatch(
          addTemplate({
            parentKey: parentId,
            dataNode: makeTemplateNode(folder),
          })
        );
      });
    isTemplateError && showErrorMessage(Templateerror.toString());
  };

  const onCreate = () => {
    form.validateFields().then(({ folderName }: FormData) => {
      template ? createTemplateFolder(folderName) : createFolder(folderName);
    });
  };

  const showErrorMessage = (message: string) => {
    messageApi.open({
      type: "error",
      content: (
        <MessageErrorContent
          title="Не удалось создать папку"
          details={message}
        />
      ),
    });
  };

  return (
    <Modal
      open={open}
      title="Создать новую папку"
      okText="Создать"
      onOk={onCreate}
      confirmLoading={template ? confirmTemplateLoading : confirmLoading}
      cancelText="Отмена"
      onCancel={template ? onTemplateCancel : onFileCancel}
      maskClosable={false}
    >
      <Form form={form} layout="vertical" name="createFolderForm">
        {contextHolder}
        <Form.Item
          name="folderName"
          label="Название Папки"
          rules={[
            {
              required: true,
              message: "Введите название папки",
            },
          ]}
        >
          <Input />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default CreateFolder;
