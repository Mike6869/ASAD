import React, { FC } from "react";
import { Dropdown, Modal, message as messageAntd } from "antd";
import type { MenuProps } from "antd";
import { ExclamationCircleFilled } from "@ant-design/icons";
import { MessageInstance } from "antd/es/message/interface";

import { useAppDispatch } from "@services/hooks";
import { AppDispatch } from "@services/store";
import MessageErrorContent from "@components/MessageErrorContent";
import { FormType } from "@pages/FileTree/components/ContextMenuForm";
import { deleteNode, openForm } from "../templateTreeSlice";
import { TemplateProps } from "Types/template.type";
import { useDeleteFolderOrTemplateMutation } from "@services/api/template";

const { confirm } = Modal;

interface Props {
  template: TemplateProps;
  children: React.ReactNode;
}

export enum MenuItems {
  "CreateFolder" = "CreateFolder",
  "CreateVerFile" = "CreateVerFile",
  "RenameFile" = "RenameFile",
  "DeleteFolder" = "DeleteFolder",
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
    key: MenuItems.DeleteFolder,
    label: <div>Удалить папку</div>,
    danger: true,
  },
];

const itemsProject: MenuProps["items"] = itemsCommonFolder.slice();

const DropdownFolder: FC<Props> = ({ template, children }) => {
  const [deleteFolderOrFile] = useDeleteFolderOrTemplateMutation();
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
                  title="Не удалось удалить папку"
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
        dispatch(openForm({ template, formType: FormType.CreateFolder }));
        break;
      case MenuItems.DeleteFolder:
        showDeleteConfirm(template.id.toString(), dispatch, messageApi);
        break;
      case MenuItems.CreateVerFile:
        dispatch(openForm({ template, formType: FormType.CreateVerFile }));
        break;
      case MenuItems.RenameFile:
        dispatch(openForm({ template, formType: FormType.RenameFile }));
        break;
      case MenuItems.EditProject:
        dispatch(openForm({ template, formType: FormType.EditProject }));
        break;
      case MenuItems.UploadGroupOfFiles:
        dispatch(openForm({ template, formType: FormType.UploadGroupOfFiles }));
        break;
      default:
    }
  };

  return (
    <>
      {contextHolder}
      <Dropdown
        menu={{
          items: template.parentId !== 0 ? itemsCommonFolder : itemsProject,
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
