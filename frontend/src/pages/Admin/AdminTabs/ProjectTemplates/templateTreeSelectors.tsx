import { FolderOpenTwoTone, FolderTwoTone } from "@ant-design/icons";

import { createSelector } from "@reduxjs/toolkit";
import { IconType } from "rc-tree/lib/interface";
import { IDataNode } from "./templateTreeSlice";
import { RootState } from "@services/store";
import { FileType } from "Types/files.type";

export const gettemplateTree = (state: RootState) =>
  state.templateTreePage.templateTree;

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

const customizeNode = (
  children: IDataNode[],
  parent: IDataNode
): IDataNode[] => {
  const parenttemplateTypeId = parent.template.fileTypeId;
  if (parenttemplateTypeId === FileType.Document) {
    return children.slice(1).map((node) => ({
      ...node,
      isLeaf: true,
    }));
  }
  return children
    .map((node): IDataNode => {
      const newNode = { ...node };
      newNode.icon =
        newNode.template.fileTypeId === FileType.Folder &&
        handleFolderIcon;
      if (node.children) {
        newNode.children = customizeNode(node.children, node);
      }
      return newNode;
    })
    .sort(compareNodes);
};

export const getTemplateTreeForRendering = createSelector(
  [gettemplateTree],
  (templateTree) =>
    templateTree.map((node) => {
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
  state.templateTreePage.contextMenuForm;

export const getCurrenttemplateId = ({ templateTreePage }: RootState) =>
  templateTreePage.currenttemplateId;
