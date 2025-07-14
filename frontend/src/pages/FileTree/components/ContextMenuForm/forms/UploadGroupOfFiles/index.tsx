import { FC, useCallback, useState } from "react";
import { Modal, Upload } from "antd";
import type { UploadProps } from "antd";
import { InboxOutlined } from "@ant-design/icons";

import { useAppDispatch } from "@services/hooks";
import {
  closeForm as fileCloseForm,
  IDataNode as FileIDataNode,
  update as fileUpdate,
} from "@pages/FileTree/fileTreeSlice";
import UploadFileList from "./UploadFileList";
import { useLazyGetTemplateListQuery } from "@services/api/template";
import { useLazyGetFileListQuery } from "@services/api/file";
import {
  closeForm as templateCloseForm,
  IDataNode as TemplateIDataNode,
  update as templateUpdate,
} from "@pages/Admin/AdminTabs/ProjectTemplates/templateTreeSlice";
import makeTemplateNode from "@pages/Admin/AdminTabs/ProjectTemplates/utils/makeTemplateNode";
import makeDataNode from "@pages/FileTree/utils/makeDataNode";

const { Dragger } = Upload;

interface Props {
  parentId: string | number;
  template?: boolean;
}

const UploadGroupOfFiles: FC<Props> = ({ parentId, template }) => {
  const [open, setOpen] = useState(true);
  const [fileList, setFileList] = useState<File[]>([]);
  const [startUploading, setStartUploading] = useState(false);
  const dispatch = useAppDispatch();
  const [getFileList] = useLazyGetFileListQuery();
  const [getTemplateList] = useLazyGetTemplateListQuery();

  const handleClose = useCallback(() => {
    setOpen(false);
    dispatch(template ? templateCloseForm : fileCloseForm());
  }, [open]);

  const handleOk = () => setStartUploading(true);

  const refreshFileNode = (nodeId: number | string) => async () => {
    let dataNodes: FileIDataNode[] = [];
    await getFileList(nodeId)
      .unwrap()
      .then((data) => {
        dataNodes = data.map(makeDataNode);
      });
    dispatch(fileUpdate({ key: nodeId.toString(), children: dataNodes }));
  };

  const refreshTemplateNode = (nodeId: number | string) => async () => {
    let dataNodes: TemplateIDataNode[] = [];
    await getTemplateList(nodeId)
      .unwrap()
      .then((data) => {
        dataNodes = data.map(makeTemplateNode);
      });
    dispatch(templateUpdate({ key: nodeId.toString(), children: dataNodes }));
  };

  const handleCompleteUploading = () => {
    setStartUploading(false);
    dispatch(
      template ? refreshTemplateNode(parentId) : refreshFileNode(parentId)
    );
    handleClose();
  };

  const draggerProps: UploadProps = {
    multiple: true,
    beforeUpload: () => false,
    onChange: (info) =>
      setFileList(info.fileList.map((_) => _.originFileObj as File)),
  };

  return (
    <Modal
      title="Загрузка группы файлов"
      open={open}
      maskClosable={false}
      okText="Загрузить"
      okButtonProps={{ disabled: fileList.length === 0 }}
      onOk={handleOk}
      cancelText="Закрыть"
      onCancel={handleClose}
    >
      <Dragger {...draggerProps}>
        <p className="ant-upload-drag-icon">
          <InboxOutlined />
        </p>
        <p className="ant-upload-text">
          Кликните или перенесите файлы для загрузки
        </p>
        <p className="ant-upload-hint">
          При нажатии &quot;Загрузить&quot; выбранные файлы будут перенесены в
          систему, проанализированы и добавлены
        </p>
      </Dragger>
      {startUploading && (
        <UploadFileList
          fileList={fileList}
          onComplete={handleCompleteUploading}
          parentId={parentId}
          template={template}
        />
      )}
    </Modal>
  );
};

export default UploadGroupOfFiles;
