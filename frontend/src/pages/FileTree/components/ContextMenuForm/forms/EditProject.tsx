import { FC, useState } from "react";
import { Modal, Form, message as messageAntd, InputNumber } from "antd";

import MessageErrorContent from "@components/MessageErrorContent";
import { useAppDispatch } from "@services/hooks";
import { FolderProps } from "Types/files.type";
import { closeForm } from "../../../fileTreeSlice";
import { useEditProjectMutation } from "@services/api/file";

interface Props {
  folder: FolderProps;
}

interface FormData {
  documentsCount: number;
}

const EditProject: FC<Props> = ({ folder: { id } }) => {
  const dispatch = useAppDispatch();
  const [messageApi, contextHolder] = messageAntd.useMessage();
  const [open, setOpen] = useState(true);
  const [form] = Form.useForm();
  const [editProjectApi, { isError, isLoading: confirmLoading, error }] =
    useEditProjectMutation();

  const onCancel = () => {
    setOpen(false);
    form.resetFields();
    dispatch(closeForm());
  };

  const editProject = (documentsCount: number) => {
    const result = { id, documentsCount };
    editProjectApi(result)
      .unwrap()
      .then(() => onCancel());
    isError && showErrorMessage(error.toString());
  };

  const onsubmit = () => {
    form.validateFields().then(({ documentsCount }: FormData) => {
      editProject(documentsCount);
    });
  };

  const showErrorMessage = (message: string) => {
    messageApi.open({
      type: "error",
      content: (
        <MessageErrorContent
          title="Не удалось изменить атрибуты проекта"
          details={message}
        />
      ),
    });
  };

  return (
    <Modal
      open={open}
      title="Изменить"
      okText="Подтвердить"
      onOk={onsubmit}
      confirmLoading={confirmLoading}
      cancelText="Отмена"
      onCancel={onCancel}
      maskClosable={false}
    >
      <Form form={form} layout="vertical" name="editForm">
        {contextHolder}
        <Form.Item
          name="documentsCount"
          label="Количество документов"
          rules={[
            {
              required: true,
              message: "Задайте планируемое количество документов",
            },
            {
              type: "number",
              min: 1,
              message: "Количество документов не может быть меньше 1",
            },
          ]}
        >
          <InputNumber min={1} />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default EditProject;
