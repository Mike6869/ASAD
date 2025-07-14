import React, { FC } from "react";
import { Dropdown, Modal, message as messageAntd } from "antd";
import type { MenuProps } from "antd";
import { ExclamationCircleFilled } from "@ant-design/icons";
import { MessageInstance } from "antd/es/message/interface";

import { useAppDispatch } from "@services/hooks";
import { AppDispatch } from "@services/store";
import MessageErrorContent from "@components/MessageErrorContent";
import { FileProps } from "Types/files.type";
import { openForm, deleteNode } from "../../fileTreeSlice";
import { FormType } from "../ContextMenuForm";
import { useDeleteFolderOrFileMutation } from "@services/api/file";

const { confirm } = Modal;

interface Props {
  file: FileProps;
  children: React.ReactNode;
}

export enum MenuItems {
  "CreateFolder" = "CreateFolder",
  "CreateVerFile" = "CreateVerFile",
  "RenameFile" = "RenameFile",
  "DeleteFolder" = "DeleteFolder",
  "FindSimilarDocs" = "FindSimilarDocs",
  "ContextSearch" = "ContextSearch",
  "EditProject" = "EditProject",
  "UploadGroupOfFiles" = "UploadGroupOfFiles",
}

const itemsCommonFolder: MenuProps["items"] = [
  {
    key: MenuItems.CreateFolder,
    label: <div>Создать новую папку</div>,
  },
  {
    key: MenuItems.CreateVerFile,
    label: <div>Добавить файл</div>,
  },
  {
    key: MenuItems.UploadGroupOfFiles,
    label: <div>Загрузить группу файлов</div>,
  },
  {
    key: MenuItems.RenameFile,
    label: <div>Переименовать</div>,
  },
  {
    type: "divider",
  },
  {
    key: MenuItems.ContextSearch,
    label: <div>Контекстный поиск</div>,
  },
  {
    key: MenuItems.FindSimilarDocs,
    label: <div>Поиск схожих документов</div>,
  },
  {
    type: "divider",
  },
  {
    key: MenuItems.DeleteFolder,
    label: <div>Удалить папку</div>,
    danger: true,
  },
];

const itemsProject: MenuProps["items"] = itemsCommonFolder.slice();
itemsProject.splice(3, 0, { key: MenuItems.EditProject, label: "Изменить" });

const DropdownFolder: FC<Props> = ({ file, children }) => {
  const [deleteFolderOrFile] = useDeleteFolderOrFileMutation();
  const dispatch = useAppDispatch();
  const [messageApi, contextHolder] = messageAntd.useMessage();

  const showDeleteConfirm = (
    id: string,
    dispatch: AppDispatch,
    messageApi: MessageInstance
  ) => {
    confirm({
      title: "Удаление директории",
      icon: <ExclamationCircleFilled />,
      content: "Вы уверены, что хотите удалить папку вместе с ее содержимым?",
      onOk() {
        return deleteFolderOrFile(id)
          .unwrap()
          .then(() => dispatch(deleteNode(id)))
          .catch((err: Error) => {
            messageApi.open({
              type: "error",
              content: (
                <MessageErrorContent
                  title="Не удалось создать папку"
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
      case MenuItems.CreateFolder:
        dispatch(openForm({ file, formType: FormType.CreateFolder }));
        break;
      case MenuItems.DeleteFolder:
        showDeleteConfirm(file.id.toString(), dispatch, messageApi);
        break;
      case MenuItems.CreateVerFile:
        dispatch(openForm({ file, formType: FormType.CreateVerFile }));
        break;
      case MenuItems.RenameFile:
        dispatch(openForm({ file, formType: FormType.RenameFile }));
        break;
      case MenuItems.FindSimilarDocs:
        dispatch(openForm({ file, formType: FormType.FindSimilarDocs }));
        break;
      case MenuItems.EditProject:
        dispatch(openForm({ file, formType: FormType.EditProject }));
        break;
      case MenuItems.UploadGroupOfFiles:
        dispatch(openForm({ file, formType: FormType.UploadGroupOfFiles }));
        break;
      case MenuItems.ContextSearch:
        window.open(`/contextsearch/${file.id}`, "_blank", "noreferrer");
        break;
      default:
    }
  };

  return (
    <>
      {contextHolder}
      <Dropdown
        menu={{
          items: file.parentId !== 0 ? itemsCommonFolder : itemsProject,
          onClick,
        }}
        trigger={["contextMenu"]}
      >
        {children}
      </Dropdown>
    </>
  );
};

export default DropdownFolder;
