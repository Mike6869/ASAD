import { FC, useState } from "react";
import {
  Button,
  Modal,
  Form,
  Input,
  message as messageAntd,
  InputNumber,
  Select,
  Flex,
} from "antd";
import { FolderAddOutlined } from "@ant-design/icons";

import { FileProps } from "Types/files.type";
import { TemplateProps } from "Types/template.type";
import MessageErrorContent from "@components/MessageErrorContent";
import { add as addFileTreeNode } from "../../fileTreeSlice";
import { add as addTemplateTreeNode } from "@pages/Admin/AdminTabs/ProjectTemplates/templateTreeSlice";
import makeDataNode from "../../utils/makeDataNode";
import { useAppDispatch, useAppSelector } from "@services/hooks";
import { getUser } from "@services/store/userSelectors";
import { useCreateProjectMutation } from "@services/api/file";
import makeTemplateNode from "@pages/Admin/AdminTabs/ProjectTemplates/utils/makeTemplateNode";
import {
  useCreateProjectTemplateMutation,
  useGetProjectTemplateListQuery,
} from "@services/api/template";

interface FormData {
  projectName: string;
  documentsCount: number;
  templatePath: string;
}

interface IAddProject {
  template: boolean;
}

const AddProject: FC<IAddProject> = ({ template }) => {
  const { user } = useAppSelector(getUser);

  const dispatch = useAppDispatch();
  const [messageApi, contextHolder] = messageAntd.useMessage();
  const [open, setOpen] = useState(false);
  const [form] = Form.useForm();
  const [createProjectApi, { isLoading: confirmLoading, isError, error }] =
    useCreateProjectMutation();
  const [createTemplateApi] = useCreateProjectTemplateMutation();
  const { data: res } = useGetProjectTemplateListQuery();

  const showModal = () => setOpen(true);

  const createProject = (
    name: string,
    documentsCount: number,
    templatePath: string
  ) => {
    const result = { name, documentsCount, templatePath };
    createProjectApi(result)
      .unwrap()
      .then((project: FileProps) => {
        messageApi.success("Проект успешно создан");
        onCancel();
        dispatch(
          addFileTreeNode({ parentKey: "0", dataNode: makeDataNode(project) })
        );
      });
    isError && showErrorMessage(error.toString());
  };

  const createTemplate = (name: string) => {
    const result = { name };
    console.log(1);
    createTemplateApi(result)
      .unwrap()
      .then((project: TemplateProps) => {
        messageApi.success("Проект успешно создан");
        onCancel();
        dispatch(
          addTemplateTreeNode({
            parentKey: "0",
            dataNode: makeTemplateNode(project),
          })
        );
      });
    isError && showErrorMessage(error.toString());
  };

  const onCreate = () => {
    form
      .validateFields()
      .then(({ projectName, documentsCount, templatePath }: FormData) => {
        template
          ? createTemplate(projectName)
          : createProject(projectName, documentsCount, templatePath);
      });
  };

  const onCancel = () => {
    setOpen(false);
    form.resetFields();
  };

  const showErrorMessage = (message: string) => {
    messageApi.open({
      type: "error",
      content: (
        <MessageErrorContent
          title="Не удалось создать проект"
          details={message}
        />
      ),
    });
  };

  if (!user?.isProjectCreator && !user?.isAdmin) {
    return null;
  }

  return (
    <>
      {contextHolder}
      <Button icon={<FolderAddOutlined />} onClick={showModal}>
        Новый проект
      </Button>
      <Modal
        open={open}
        title="Создать новый проект"
        okText="Создать"
        onOk={onCreate}
        confirmLoading={confirmLoading}
        cancelText="Отмена"
        onCancel={onCancel}
        maskClosable={false}
      >
        <Form form={form} layout="vertical" name="createProjectForm">
          <Form.Item
            name="projectName"
            label="Название проекта"
            rules={[
              {
                required: true,
                message: "Введите название проекта",
              },
            ]}
          >
            <Input />
          </Form.Item>
          {!template && (
            <Flex justify="space-between">
              <Form.Item
                name="documentsCount"
                label="Кол-во документов"
                initialValue={10}
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
              <Form.Item
                name="templatePath"
                label="Шаблон проекта"
                initialValue="default"
                rules={[
                  {
                    required: true,
                    message: "Введите шаблон проекта",
                  },
                ]}
              >
                <Select
                  options={[
                    { value: "default", label: "По умолчанию" },
                    ...(res?.map((t) => ({ value: t.name, label: t.name })) ||
                      []),
                  ]}
                  showSearch
                  placeholder="Введите название шаблона"
                />
              </Form.Item>
            </Flex>
          )}
        </Form>
      </Modal>
    </>
  );
};

export default AddProject;
