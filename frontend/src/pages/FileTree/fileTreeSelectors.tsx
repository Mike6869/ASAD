import { TreeNodeProps } from "antd";
import {
  FileTwoTone,
  FileWordTwoTone,
  FolderOpenTwoTone,
  FolderTwoTone,
} from "@ant-design/icons";

import { createSelector } from "@reduxjs/toolkit";
import { FileType, VerFileProps } from "Types/files.type";
import { IconType } from "rc-tree/lib/interface";
import { IDataNode } from "./fileTreeSlice";
import { RootState } from "@services/store";

export const getFileTree = (state: RootState) => state.fileTreePage.fileTree;

const compareNodes = (a: IDataNode, b: IDataNode) => {
  if (!(a.title && b.title) || a.title === b.title) {
    return 0;
  }
  if (a.title < b.title) {
    return -1;
  }
  return 1;
};

const handleFolderIcon: IconType = ({ expanded }) =>
  expanded ? <FolderOpenTwoTone /> : <FolderTwoTone />;

interface VerFileTreeNodeProps extends TreeNodeProps {
  file: VerFileProps;
}

const handleVerFileIcon = ({ file }: VerFileTreeNodeProps) =>
  file.fileTypeId === FileType.VerFile ? <FileTwoTone /> : <FileWordTwoTone />;

const customizeNode = (
  children: IDataNode[],
  parent: IDataNode
): IDataNode[] => {
  const parentFileTypeId = parent.file.fileTypeId;
  if (
    parentFileTypeId === FileType.VerFile ||
    parentFileTypeId === FileType.Document
  ) {
    return children.slice(1).map((node) => ({
      ...node,
      isLeaf: true,
    }));
  }
  return children
    .map((node): IDataNode => {
      const newNode = { ...node };
      newNode.icon =
        newNode.file.fileTypeId === FileType.Folder
          ? handleFolderIcon
          : (handleVerFileIcon as IconType);
      if (node.children) {
        newNode.children = customizeNode(node.children, node);
      }
      return newNode;
    })
    .sort(compareNodes);
};

export const getFileTreeForRendering = createSelector(
  [getFileTree],
  (fileTree) =>
    fileTree.map((node) => {
      if (node.children) {
        return {
          ...node,
          icon: handleFolderIcon,
          children: customizeNode(node.children, node),
        };
      }
      return {
        ...node,
        icon: handleFolderIcon,
      };
    })
);

export const getContextMenuFormInfo = (state: RootState) =>
  state.fileTreePage.contextMenuForm;

export const getCurrentFileId = ({ fileTreePage }: RootState) =>
  fileTreePage.currentFileId;
