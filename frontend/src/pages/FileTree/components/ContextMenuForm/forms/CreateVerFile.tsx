import { FC, useState, useEffect } from "react";
import { Modal, Form, message, Input, Upload } from "antd";
import type { UploadProps } from "antd";
import { InboxOutlined, LoadingOutlined } from "@ant-design/icons";

import { useAppDispatch } from "@services/hooks";
import { FileType, type FileProps } from "Types/files.type";
import getFileExtension from "@utils/getFileExtension";
import {
  closeForm as closeFileForm,
  add as addFile,
} from "../../../fileTreeSlice";
import {
  add as addTempl,
  closeForm as closeTemplateForm,
} from "@pages/Admin/AdminTabs/ProjectTemplates/templateTreeSlice";

import makeDataNode from "../../../utils/makeDataNode";
import DocumentAttributeInputsNewVer from "../components/DocumentAttributeInputsNewVer";
import {
  useCheckDocumentTypeMutation,
  useCreateVerFileMutation,
  useGetMetadataQuery,
  VerFile,
} from "@services/api/file";
import makeTemplateNode from "@pages/Admin/AdminTabs/ProjectTemplates/utils/makeTemplateNode";
import { AddTempate, useAddTemplateMutation } from "@services/api/template";
import { TemplateProps } from "Types/template.type";

interface Props {
  parentId: string;
  template?: boolean;
}

const { Dragger } = Upload;

const getFile = (e: any) => e?.file; // eslint-disable-line @typescript-eslint/no-explicit-any

const CreateVerFile: FC<Props> = ({ parentId, template }) => {
  const dispatch = useAppDispatch();
  const [open, setOpen] = useState(true);
  const [submittable, setSubmittable] = useState(true);
  const [isDocument, setIsDocument] = useState(false);
  const [form] = Form.useForm();
  const formWatch = Form.useWatch([], form);
  const [
    createVerFile,
    { isError: isFileError, isLoading: confirmFileLoading, error: fileError },
  ] = useCreateVerFileMutation();
  const [
    addTemplateApi,
    {
      isError: isTemplateError,
      isLoading: confirmTempateLoading,
      error: templateError,
    },
  ] = useAddTemplateMutation();
  const [checkDocumentType] = useCheckDocumentTypeMutation();
  const { data: metadata } = useGetMetadataQuery();
  const [checkingType, setCheckingType] = useState(false);

  useEffect(() => {
    form.validateFields({ validateOnly: true }).then(
      () => {
        setSubmittable(true);
      },
      () => {
        setSubmittable(false);
      }
    );
  }, [formWatch]);

  const draggerProps: UploadProps = {
    name: "file",
    multiple: false,
    maxCount: 1,
    beforeUpload: async (file: File) => {
      form.setFieldsValue({ name: file.name });

      if (file.name.endsWith(".doc")) {
        Modal.warning({
          title: "Загрузка устаревшего формата",
          content:
            'Вы пытаетесь загрузить файл устаревшего формата ".doc". Для корректной работы системы рекомендуется загружать файлы в формате ".docx".',
        });
      }

      const isDocx = !template ? file.name.endsWith(".docx") : false;
      setIsDocument(isDocx);

      if (isDocx && metadata) {
        setCheckingType(true);
        try {
          const response = await checkDocumentType(file).unwrap();

          if (response.status === "success" && response.documentType) {
            const foundType = Object.entries(metadata.types).find(
              ([, typeData]) => typeData.typeName === response.documentType
            );

            if (foundType) {
              const [id, typeData] = foundType;
              form.setFieldsValue({
                documentTypeId: id,
                documentUrl: typeData.url || "",
              });
            }
          }
        } catch (error) {
          message.error("Произошла ошибка пр определении типа документа");
        } finally {
          setCheckingType(false);
        }
      }

      return false;
    },
  };

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

  const createFile = () => {
    const formData: VerFile = {
      ...formWatch,
      typeId: isDocument ? FileType.Document : FileType.VerFile,
    };
    const result = { parentId, formData };
    createVerFile(result)
      .unwrap()
      .then((createdFile: FileProps) => {
        message.success("Файл добавлен");
        dispatch(
          addFile({ parentKey: parentId, dataNode: makeDataNode(createdFile) })
        );
        onFileCancel();
      });
  };

  const addTemplate = () => {
    const formData: AddTempate = {
      ...formWatch,
      typeId: FileType.Document,
    };
    const result = { parentId, formData };
    addTemplateApi(result)
      .unwrap()
      .then((createdFile: TemplateProps) => {
        message.success("Файл добавлен");
        dispatch(
          addTempl({
            parentKey: parentId,
            dataNode: makeTemplateNode(createdFile),
          })
        );
        onTemplateCancel();
      });
  };

  useEffect(() => {
    if (template) {
      if (isTemplateError && templateError && "data" in templateError) {
        const errorData = (fileError as { data: { error_description: string } })
          .data;
        message.error(errorData.error_description);
      } else if (isTemplateError) {
        message.error("Произошла ошибка при создании файла");
      }
    } else {
      if (isFileError && fileError && "data" in fileError) {
        const errorData = (fileError as { data: { error_description: string } })
          .data;
        message.error(errorData.error_description);
      } else if (isFileError) {
        message.error("Произошла ошибка при создании файла");
      }
    }
  }, [isFileError, fileError, isTemplateError, templateError]);

  const onSubmit = () => {
    form.validateFields().then(() => {
      template ? addTemplate() : createFile();
    });
  };

  return (
    <Modal
      open={open}
      title="Создать новый файл"
      okText="Создать"
      onOk={onSubmit}
      okButtonProps={{ disabled: !submittable }}
      confirmLoading={template ? confirmTempateLoading : confirmFileLoading}
      cancelText="Закрыть"
      onCancel={template ? onTemplateCancel : onFileCancel}
      maskClosable={false}
    >
      <Form form={form} layout="vertical" name="createVerFileForm">
        <Form.Item
          name="name"
          label="Название файла"
          rules={[
            {
              required: true,
              message: "Введите название файла",
            },
            {
              pattern: new RegExp(
                `.${getFileExtension(formWatch?.file?.name || "")}$`
              ),
              message: "Укажите расширение файла (например: example.docx)",
            },
          ]}
        >
          <Input />
        </Form.Item>
        {isDocument && <DocumentAttributeInputsNewVer form={form} />}
        <Form.Item
          name="file"
          valuePropName="file"
          getValueFromEvent={getFile}
          rules={[{ required: true }]}
        >
          <Dragger {...draggerProps}>
            <p className="ant-upload-drag-icon">
              {checkingType ? <LoadingOutlined /> : <InboxOutlined />}
            </p>
            <p className="ant-upload-text">
              {checkingType
                ? "Определение типа документа..."
                : "Кликните или перетащите файл в область для загрузки"}
            </p>
          </Dragger>
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default CreateVerFile;
