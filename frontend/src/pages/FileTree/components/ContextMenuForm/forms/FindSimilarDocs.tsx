import { FC, useState } from "react";
import { Modal, Button, message, Upload, Space, Table } from "antd";
import { InfoCircleFilled, UploadOutlined } from "@ant-design/icons";
import type { UploadProps } from "antd/es/upload/interface";
import type { ColumnsType } from "antd/es/table";

import { closeForm, newHead } from "@pages/FileTree/fileTreeSlice";
import makeDataNode from "@pages/FileTree/utils/makeDataNode";
import { DocumentProps, VerFileProps } from "Types/files.type";
import CreateNextVerFileForm from "../components/CreateNextVerForm";
import { useAppDispatch } from "@services/hooks";
import { useFindSimilarDocsMutation } from "@services/api/file";

const { confirm } = Modal;

interface Props {
  folderId: string;
}

interface DataType extends VerFileProps {
  key: string;
  relPath: string;
  similarity: number;
}

const columns: ColumnsType<DataType> = [
  {
    title: "Имя файла",
    dataIndex: "name",
    key: "name",
    ellipsis: true,
    width: 300,
  },
  {
    title: "Относительный путь",
    dataIndex: "relPath",
    key: "relPath",
  },
  {
    title: "Схожесть",
    dataIndex: "similarity",
    key: "similarity",
    width: 100,
  },
];

const FindSimilarDocs: FC<Props> = ({ folderId }) => {
  const dispatch = useAppDispatch();
  const [open, setOpen] = useState(true);
  const [file, setFile] = useState<File | null>(null);
  const [selectedDoc, setSelectedDoc] = useState<DataType | null>(null);
  const [tableData, setTableData] = useState<DataType[] | null>(null);
  const [searchButtonDisabled, setSearchButtonDisabled] = useState(true);
  const [openAddNextVerForm, setOpenAddNextVerForm] = useState(false);
  const [findSimilarDocsApi, { isError, isLoading: loadingSearch, error }] =
    useFindSimilarDocsMutation();

  const handleSearch = () => {
    if (!file) {
      return;
    }
    const result = { folderId, file };
    findSimilarDocsApi(result)
      .unwrap()
      .then((docs) =>
        setTableData(
          docs.map((doc) => ({
            ...doc,
            key: doc.id.toString(),
          }))
        )
      );
    isError && message.error(error.toString());
  };

  const handleClear = () => {
    setFile(null);
    setSelectedDoc(null);
    setTableData(null);
    setSearchButtonDisabled(true);
  };

  const handleCancel = () => {
    setOpen(false);
    dispatch(closeForm());
  };

  const handleCreate = (createdFile: VerFileProps | DocumentProps) => {
    const dataNode = makeDataNode(createdFile);
    dispatch(newHead({ prevHeadId: createdFile.prevVerId!, dataNode }));
    message.success("Файл добавлен");
    handleClear();
  };

  const handleAddNewVersion = () => {
    confirm({
      title: "Вы уверены, что хотите добавить новую версию?",
      icon: <InfoCircleFilled color="#1677ff" />,
      content: `Будет добавлена новая версия для файла ${selectedDoc?.name}`,
      onOk: () => {
        if (!selectedDoc || !file) {
          return;
        }
        setOpenAddNextVerForm(true);
      },
    });
  };

  const uploadProps: UploadProps = {
    name: "file",
    multiple: false,
    maxCount: 1,
    disabled: !!tableData,

    beforeUpload: (uploadedFile) => {
      const isDocx = uploadedFile.name.toLowerCase().endsWith(".docx");
      if (!isDocx) {
        message.error(`${uploadedFile.name} is not a docx file`);
      }
      setFile(uploadedFile);
      return isDocx ? false : Upload.LIST_IGNORE;
    },

    onChange({ fileList }) {
      if (!fileList.length) {
        setSearchButtonDisabled(true);
        return;
      }
      setSearchButtonDisabled(false);
    },
  };
  if (!file) {
    uploadProps.fileList = [];
  }

  return (
    <Modal
      open={open}
      title="Поиск схожих документов"
      okText="Поиск"
      onOk={handleSearch}
      okButtonProps={{ disabled: searchButtonDisabled, loading: loadingSearch }}
      cancelText="Закрыть"
      onCancel={handleCancel}
      width={768}
      maskClosable={false}
    >
      <Space direction="vertical" size="middle">
        <Upload {...uploadProps}>
          <Button icon={<UploadOutlined />}>Выбрать файл</Button>
        </Upload>
        <Table
          dataSource={tableData || undefined}
          columns={columns}
          rowSelection={{
            type: "radio",
            onSelect: (record) => {
              setSelectedDoc(record);
            },
          }}
        />
        <Space>
          <Button onClick={handleAddNewVersion} disabled={!selectedDoc}>
            Добавить новую версию
          </Button>
          <Button onClick={handleClear} disabled={!tableData}>
            Очистить результат
          </Button>
        </Space>
      </Space>
      <CreateNextVerFileForm
        open={openAddNextVerForm}
        file={file}
        fileProps={selectedDoc}
        onCancel={() => setOpenAddNextVerForm(false)}
        onCreate={handleCreate}
      />
    </Modal>
  );
};

export default FindSimilarDocs;
