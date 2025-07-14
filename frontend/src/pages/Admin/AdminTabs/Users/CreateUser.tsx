/* eslint-disable react/prop-types */
import { FC, useState } from "react";
import { App, Button, Form, Input, Modal } from "antd";

import { useCreateUserMutation, User } from "@services/api/users";

interface CollectionCreateFormProps {
  open: boolean;
  onCreate: (values: User) => void;
  onCancel: () => void;
  loading: boolean;
}

const CollectionCreateForm: React.FC<CollectionCreateFormProps> = ({
  open,
  onCreate,
  onCancel,
  loading,
}) => {
  const [form] = Form.useForm();
  const { message } = App.useApp();

  const handleCancel = () => {
    form.resetFields();
    onCancel();
  };

  return (
    <Modal
      open={open}
      confirmLoading={loading}
      title="Добавить нового пользователя"
      okText="Добавить"
      cancelText="Отмена"
      onCancel={handleCancel}
      okButtonProps={{ htmlType: "submit" }}
      modalRender={(dom) => (
        <Form
          form={form}
          layout="vertical"
          onFinish={() => {
            form
              .validateFields()
              .then((values) => {
                onCreate(values);
              })
              .catch(() => message.error("Ошибка в заполнении формы"));
          }}
          name="createUser"
          initialValues={{ password: "initpassword" }}
        >
          {dom}
        </Form>
      )}
    >
      <Form.Item
        name="username"
        label="Логин"
        rules={[
          {
            required: true,
            message: "Введите название пользователя",
          },
        ]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="email"
        label="Почта"
        rules={[
          {
            required: true,
            type: "email",
            message: "Введите корректную почту пользователя",
          },
        ]}
      >
        <Input type="email" />
      </Form.Item>
      <Form.Item
        name="firstName"
        label="Имя"
        rules={[
          {
            required: true,
            message: "Введите имя пользователя",
          },
        ]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="lastName"
        label="Фамилия"
        rules={[
          {
            required: true,
            message: "Введите фамилию пользователя",
          },
        ]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="password"
        label="Пароль"
        rules={[
          {
            required: true,
            message: "Введите пароль пользователя",
          },
        ]}
      >
        <Input />
      </Form.Item>
    </Modal>
  );
};

export const CreateUser: FC = () => {
  const { message } = App.useApp();
  const [open, setOpen] = useState(false);
  const [createUser, { isLoading, error }] = useCreateUserMutation();

  const onCreate = async (values: User) => {
    await createUser(values)
      .unwrap()
      .then(() => setOpen(false))
      .catch(() => message.error(`Ошибка при создании пользователя(${error})`));
  };

  return (
    <>
      <Button onClick={() => setOpen(true)}>Добавить пользователя</Button>
      <CollectionCreateForm
        open={open}
        loading={isLoading}
        onCreate={onCreate}
        onCancel={() => {
          setOpen(false);
        }}
      />
    </>
  );
};
