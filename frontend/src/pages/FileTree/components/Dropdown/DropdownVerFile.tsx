import React, { FC } from "react";

import { Dropdown, Modal, message } from "antd";
import { ExclamationCircleFilled } from "@ant-design/icons";
import type { MenuProps } from "antd";

import { useAppDispatch } from "@services/hooks";
import { AppDispatch } from "@services/store";
import MessageErrorContent from "@components/MessageErrorContent";
import { VerFileProps } from "Types/files.type";
import { deleteNode, openForm } from "../../fileTreeSlice";
import { FormType } from "../ContextMenuForm";
import {
  useDeleteFolderOrFileMutation,
  useLazyGetFileListQuery,
} from "@services/api/file";
import { downloadFile } from "@utils/downloadFile";

const { confirm } = Modal;

interface Props {
  file: VerFileProps;
  children: React.ReactNode;
}

export enum MenuItems {
  "RenameFile" = "RenameFile",
  "AddNextVersion" = "AddNextVersion",
  "Download" = "Download",
  "DeleteFile" = "DeleteFile",
}

const itemsHeadVer: MenuProps["items"] = [
  { key: MenuItems.AddNextVersion, label: <div>Добавить след. версию</div> },
  { key: MenuItems.RenameFile, label: <div>Переименовать</div> },
  {
    type: "divider",
  },
  {
    key: MenuItems.Download,
    label: <div>Скачать</div>,
  },
  {
    type: "divider",
  },
  {
    key: MenuItems.DeleteFile,
    label: <div>Удалить версию</div>,
    danger: true,
  },
];

const itemsPrevVer: MenuProps["items"] = [
  {
    type: "divider",
  },
  {
    key: MenuItems.Download,
    label: <div>Скачать</div>,
  },
  {
    type: "divider",
  },
  {
    key: MenuItems.DeleteFile,
    label: <div>Удалить версию</div>,
    danger: true,
  },
];

const DropdownVerFile: FC<Props> = ({ file, children }) => {
  const dispatch = useAppDispatch();
  const [deleteFolderOrFile] = useDeleteFolderOrFileMutation();
  const [getFileList] = useLazyGetFileListQuery();

  const showDeleteConfirm = (id: string, dispatch: AppDispatch) => {
    confirm({
      title: "Удаление файла",
      icon: <ExclamationCircleFilled />,
      content: `Вы уверены, что хотите удалить файл?`,
      onOk() {
        let parentId: null | number = null;
        return deleteFolderOrFile(id)
          .unwrap()
          .then((fileProps) => {
            dispatch(deleteNode(fileProps.id.toString()));
            parentId = fileProps.parentId;
            return getFileList(parentId).unwrap();
          })
          .catch((err: Error) => {
            message.error({
              content: (
                <MessageErrorContent
                  title="Возникла ошибка при удалении файла"
                  details={err.message}
                />
              ),
            });
          });
      },
    });
  };

  const onClick: MenuProps["onClick"] = ({ key, domEvent }) => {
    domEvent.stopPropagation();

    switch (key) {
      case MenuItems.DeleteFile:
        showDeleteConfirm(file.id.toString(), dispatch);
        break;
      case MenuItems.Download:
        downloadFile(file.id.toString(), file.name, false);
        break;
      case MenuItems.AddNextVersion:
        dispatch(openForm({ file, formType: FormType.AddNextVersion }));
        break;
      case MenuItems.RenameFile:
        dispatch(openForm({ file, formType: FormType.RenameFile }));
        break;
    }
  };

  return (
    <Dropdown
      menu={{
        items: file.nextVerId === null ? itemsHeadVer : itemsPrevVer,
        onClick,
      }}
      trigger={["contextMenu"]}
    >
      {children}
    </Dropdown>
  );
};

export default DropdownVerFile;
