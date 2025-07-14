import React, { FC } from "react";

import { Dropdown, Modal, message } from "antd";
import { ExclamationCircleFilled } from "@ant-design/icons";
import type { MenuProps } from "antd";

import { useAppDispatch } from "@services/hooks";
import { AppDispatch } from "@services/store";
import MessageErrorContent from "@components/MessageErrorContent";
import { DocumentProps } from "Types/template.type";
import { downloadFile } from "@utils/downloadFile";
import { FormType } from "@pages/FileTree/components/ContextMenuForm";
import { deleteNode, openForm } from "../templateTreeSlice";
import {
  useDeleteFolderOrTemplateMutation,
  useLazyGetTemplateListQuery,
} from "@services/api/template";

const { confirm } = Modal;

interface Props {
  template: DocumentProps;
  children: React.ReactNode;
}

export enum MenuItems {
  "RenameFile" = "RenameFile",
  "Download" = "Download",
  "DeleteFile" = "DeleteFile",
}

const itemsHeadVer: MenuProps["items"] = [
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

const DropdownDocument: FC<Props> = ({ template, children }) => {
  const dispatch = useAppDispatch();
  const [deleteFolderOrTemplate] = useDeleteFolderOrTemplateMutation();
  const [getTemplateList] = useLazyGetTemplateListQuery();

  const showDeleteConfirm = (id: string, dispatch: AppDispatch) => {
    confirm({
      title: "Удаление файла",
      icon: <ExclamationCircleFilled />,
      content: `Вы уверены, что хотите удалить файл?`,
      onOk() {
        let parentId: null | number = null;
        deleteFolderOrTemplate(id)
          .unwrap()
          .then((fileProps) => {
            dispatch(deleteNode(fileProps.id.toString()));
            parentId = fileProps.parentId;
            return getTemplateList(parentId).unwrap();
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
        showDeleteConfirm(template.id.toString(), dispatch);
        break;
      case MenuItems.Download:
        downloadFile(template.id.toString(), template.name, true);
        break;
      case MenuItems.RenameFile:
        dispatch(openForm({ template, formType: FormType.RenameFile }));
        break;
    }
  };

  return (
    <Dropdown
      menu={{
        items: itemsHeadVer,
        onClick,
      }}
      trigger={["contextMenu"]}
    >
      {children}
    </Dropdown>
  );
};

export default DropdownDocument;
