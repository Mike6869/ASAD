/* eslint no-param-reassign: ["error", { "props": false }] */
import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { DataNode } from "antd/es/tree";

import { FileType, FileProps } from "Types/files.type";
import { FormType } from "./components/ContextMenuForm";

export interface IDataNode extends DataNode {
  file: FileProps;
  children?: IDataNode[];
}

export interface Metadata {
  completionPercentages: number[];
  statuses: Record<number, { status: string }>;
  types: Record<number, { code: string; typeName: string, url: string }>;
}

export interface FileTreePageState {
  fileTree: IDataNode[];
  contextMenuForm: {
    open: boolean;
    file: FileProps | null;
    formType: FormType;
  };
  currentFileId: string;
  metadata: Metadata | null;
}

const initialState: FileTreePageState = {
  fileTree: [],
  contextMenuForm: {
    open: false,
    file: null,
    formType: FormType.Empty,
  },
  currentFileId: "0",
  metadata: null,
};

export const fileTreePageSlice = createSlice({
  name: "fileTreePage",
  initialState,
  reducers: {
    update: (
      state,
      action: PayloadAction<{ key: string; children: IDataNode[] }>
    ) => {
      const { key, children } = action.payload;
      if (key === "0") {
        return { ...state, fileTree: [...children] };
      }
      const fileTree = updateTreeData(state.fileTree, key, children);
      return { ...state, fileTree };
    },

    add: (
      state,
      action: PayloadAction<{ parentKey: string; dataNode: IDataNode }>
    ) => {
      const { parentKey, dataNode } = action.payload;
      if (parentKey === "0") {
        return { ...state, fileTree: [...state.fileTree, dataNode] };
      }

      const fileTree = addTreeData(state.fileTree, parentKey, dataNode);
      return { ...state, fileTree };
    },

    deleteNode: (state, { payload: id }: PayloadAction<string>) => {
      let isDeleted = false;
      const deleteNode = (list: IDataNode[]) => {
        for (const [ind, node] of Object.entries(list)) {
          if (isDeleted) {
            return;
          }
          if (node.key === id) {
            list.splice(+ind, 1);
            isDeleted = true;
            return;
          }
          if (node.children) {
            deleteNode(node.children);
          }
        }
      };
      deleteNode(state.fileTree);
    },

    rename: (
      state,
      {
        payload: { id, newName },
      }: PayloadAction<{ id: string; newName: string }>
    ) => {
      let isRenamed = false;
      const renameNode = (list: IDataNode[]) => {
        for (const node of list) {
          if (isRenamed) {
            return;
          }
          if (node.key === id) {
            node.title = newName;
            node.file.name = newName;
            isRenamed = true;
            return;
          }
          if (node.children) {
            renameNode(node.children);
          }
        }
      };
      renameNode(state.fileTree);
    },

    newHead: (
      state,
      {
        payload: { prevHeadId, dataNode },
      }: PayloadAction<{ prevHeadId: number; dataNode: IDataNode }>
    ) => {
      const fileTree = addNewHeadTreeData(state.fileTree, prevHeadId, dataNode);
      return { ...state, fileTree };
    },

    addNextVersion: (
      state,
      {
        payload: { prevVerId, dataNode },
      }: PayloadAction<{ prevVerId: number; dataNode: IDataNode }>
    ) => {
      const fileTree = addNextVerTreeData(state.fileTree, prevVerId, dataNode);
      return { ...state, fileTree };
    },

    openForm: (
      { contextMenuForm },
      action: PayloadAction<{ file: FileProps; formType: FormType }>
    ) => {
      const { file, formType } = action.payload;
      contextMenuForm.open = true;
      contextMenuForm.file = file;
      contextMenuForm.formType = formType;
    },

    closeForm: ({ contextMenuForm }) => {
      contextMenuForm.open = false;
      contextMenuForm.file = null;
      contextMenuForm.formType = FormType.Empty;
    },

    setCurrentFileId: (state, { payload }: PayloadAction<string>) => {
      state.currentFileId = payload;
    },

    setMetadata: (state, { payload }: PayloadAction<Metadata>) => {
      state.metadata = payload;
    },
  },
});

const updateTreeData = (
  list: IDataNode[],
  key: React.Key,
  children: IDataNode[]
): IDataNode[] =>
  list.map((node) => {
    if (node.key === key) {
      return {
        ...node,
        children,
      };
    }
    if (node.children) {
      return {
        ...node,
        children: updateTreeData(node.children, key, children),
      };
    }
    return node;
  });

const addTreeData = (
  list: IDataNode[],
  parentKey: React.Key,
  dataNode: IDataNode
): IDataNode[] =>
  list.map((node) => {
    if (node.key === parentKey) {
      if (node.children !== undefined) {
        return { ...node, children: [...node.children, dataNode] };
      }
      return { ...node };
    }
    if (node.children) {
      return {
        ...node,
        children: addTreeData(node.children, parentKey, dataNode),
      };
    }
    return node;
  });

const addNewHeadTreeData = (
  list: IDataNode[],
  prevHeadId: number,
  dataNode: IDataNode
): IDataNode[] =>
  list.map((node) => {
    if (node.file.id === prevHeadId) {
      return dataNode;
    }
    if (node.children) {
      return {
        ...node,
        children: addNewHeadTreeData(node.children, prevHeadId, dataNode),
      };
    }
    return node;
  });

const addNextVerTreeData = (
  list: IDataNode[],
  prevVerId: number,
  dataNode: IDataNode
): IDataNode[] =>
  list.map((node) => {
    const { fileTypeId } = node.file;
    if (
      (fileTypeId === FileType.Document || fileTypeId === FileType.VerFile) &&
      node.children
    ) {
      const ind = node.children.findIndex((_) => _.file.id === prevVerId);
      if (ind !== -1) {
        const newChildren = [...node.children];
        newChildren.splice(ind, 0, dataNode);
        return { ...node, children: newChildren };
      }
    } else if (node.children) {
      return {
        ...node,
        children: addNextVerTreeData(node.children, prevVerId, dataNode),
      };
    }
    return node;
  });

export const {
  update,
  add,
  deleteNode,
  newHead,
  addNextVersion,
  closeForm,
  openForm,
  rename,
  setCurrentFileId,
  setMetadata,
} = fileTreePageSlice.actions;

export default fileTreePageSlice.reducer;
