import { FC, useEffect, useState } from "react";
import { Modal, Form, message, Upload, Input } from "antd";
import type { UploadProps } from "antd";
import { InboxOutlined } from "@ant-design/icons";

import { useAppDispatch } from "@services/hooks";
import { FileType, type VerFileProps } from "Types/files.type";
import MessageErrorContent from "@components/MessageErrorContent";
import getFileExtension from "@utils/getFileExtension";
import { addNextVersion, closeForm, newHead } from "../../../fileTreeSlice";
import makeDataNode from "../../../utils/makeDataNode";
import DocumentAttributeInputsNextVer from "../components/DocumentAttributeInputsNextVer";
import { useCreateVerFileMutation, VerFile } from "@services/api/file";

interface Props {
  file: VerFileProps;
}

const getFile = (e: any) => e?.file; // eslint-disable-line @typescript-eslint/no-explicit-any

const { Dragger } = Upload;

const AddNextVersion: FC<Props> = ({ file: { id, parentId } }) => {
  const dispatch = useAppDispatch();
  const [open, setOpen] = useState(true);
  const [submittable, setSubmittable] = useState(true);
  // const [confirmLoading, setConfirmLoading] = useState(false);
  const [isDocument, setIsDocument] = useState(false);
  const [form] = Form.useForm();
  const formWatch = Form.useWatch([], form);
  const [createVerFile, { isError, isLoading: confirmLoading, error }] =
    useCreateVerFileMutation();

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
    beforeUpload(newFile) {
      const fileName = newFile.name;
      form.setFieldValue("name", fileName);
      if (fileName.endsWith(".doc")) {
        Modal.warning({
          title: "Загрузка устаревшего формата",
          content:
            'Вы пытаетесь загрузить файл устаревшего формата ".doc". Для корректной работы системы рекомендуется загружать файлы в формате ".docx".',
        });
      }

      setIsDocument(fileName.endsWith("docx"));

      return false;
    },
  };

  const onCancel = () => {
    setOpen(false);
    form.resetFields();
    dispatch(closeForm());
  };

  const createFile = () => {
    const formData: VerFile = {
      ...formWatch,
      typeId: isDocument ? FileType.Document : FileType.VerFile,
      prevVerId: id,
    };
    const result = { parentId, formData };
    createVerFile(result)
      .unwrap()
      .then((createdFile) => {
        const dataNode = makeDataNode(createdFile);
        if (!createdFile.nextVerId) {
          dispatch(newHead({ prevHeadId: id, dataNode }));
        } else {
          dispatch(
            addNextVersion({ prevVerId: createdFile.prevVerId!, dataNode })
          );
        }
        message.success("Файл добавлен");
        onCancel();
      });
    isError &&
      message.error(
        <MessageErrorContent
          title="Возникла ошибка при добавлении новой версии"
          details={error ? ("error" in error ? error.error : "") : ""}
        />
      );
  };

  const onSubmit = () => {
    form.validateFields().then(() => {
      createFile();
    });
  };

  return (
    <Modal
      open={open}
      title="Добавить следующую версию"
      okText="Добавить"
      onOk={onSubmit}
      okButtonProps={{ disabled: !submittable }}
      confirmLoading={confirmLoading}
      cancelText="Закрыть"
      onCancel={onCancel}
      maskClosable={false}
    >
      <Form form={form} layout="vertical" name="createNextVerFileForm">
        <Form.Item
          name="name"
          label="Название загружаемого файла"
          rules={[
            {
              required: true,
              message: "Выберите файл",
            },
            {
              pattern: new RegExp(
                `.${getFileExtension(formWatch?.file?.name || "")}$`
              ),
              message:
                "Загрузите файл с заданным расширением (например: example.docx)",
            },
          ]}
        >
          <Input disabled />
        </Form.Item>
        {isDocument && (
          <DocumentAttributeInputsNextVer
            prevVerId={id.toString()}
            form={form}
          />
        )}
        <Form.Item
          name="file"
          valuePropName="file"
          getValueFromEvent={getFile}
          rules={[{ required: true }]}
        >
          <Dragger {...draggerProps}>
            <p className="ant-upload-drag-icon">
              <InboxOutlined />
            </p>
            <p className="ant-upload-text">
              Кликните или перетащите файл в область для загрузки
            </p>
          </Dragger>
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddNextVersion;
