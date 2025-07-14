/* eslint no-param-reassign: ["error", { "props": false }] */
import { FormType } from "@pages/FileTree/components/ContextMenuForm";
import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { DataNode } from "antd/es/tree";
import { FileType } from "Types/files.type";
import { TemplateProps } from "Types/template.type";

export interface IDataNode extends DataNode {
  template: TemplateProps;
  children?: IDataNode[];
}

export interface Metadata {
  completionPercentages: number[];
  statuses: Record<number, { status: string }>;
  types: Record<number, { code: string; typeName: string; url: string }>;
}

export interface templateTreePageState {
  templateTree: IDataNode[];
  contextMenuForm: {
    open: boolean;
    template: TemplateProps | null;
    formType: FormType | null;
  };
  currenttemplateId: string;
  metadata: Metadata | null;
}

const initialState: templateTreePageState = {
  templateTree: [],
  contextMenuForm: {
    open: false,
    template: null,
    formType: null,
  },
  currenttemplateId: "0",
  metadata: null,
};

export const templateTreePageSlice = createSlice({
  name: "templateTreePage",
  initialState,
  reducers: {
    update: (
      state,
      action: PayloadAction<{ key: string; children: IDataNode[] }>
    ) => {
      const { key, children } = action.payload;
      if (key === "0") {
        return { ...state, templateTree: [...children] };
      }
      const templateTree = updateTreeData(state.templateTree, key, children);
      return { ...state, templateTree };
    },

    add: (
      state,
      action: PayloadAction<{ parentKey: string; dataNode: IDataNode }>
    ) => {
      const { parentKey, dataNode } = action.payload;
      if (parentKey === "0") {
        return { ...state, templateTree: [...state.templateTree, dataNode] };
      }

      const templateTree = addTreeData(state.templateTree, parentKey, dataNode);
      return { ...state, templateTree };
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
      deleteNode(state.templateTree);
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
            node.template.name = newName;
            isRenamed = true;
            return;
          }
          if (node.children) {
            renameNode(node.children);
          }
        }
      };
      renameNode(state.templateTree);
    },

    newHead: (
      state,
      {
        payload: { prevHeadId, dataNode },
      }: PayloadAction<{ prevHeadId: number; dataNode: IDataNode }>
    ) => {
      const templateTree = addNewHeadTreeData(
        state.templateTree,
        prevHeadId,
        dataNode
      );
      return { ...state, templateTree };
    },

    addNextVersion: (
      state,
      {
        payload: { prevVerId, dataNode },
      }: PayloadAction<{ prevVerId: number; dataNode: IDataNode }>
    ) => {
      const templateTree = addNextVerTreeData(
        state.templateTree,
        prevVerId,
        dataNode
      );
      return { ...state, templateTree };
    },

    openForm: (
      { contextMenuForm },
      action: PayloadAction<{ template: TemplateProps; formType: FormType }>
    ) => {
      const { template, formType } = action.payload;
      contextMenuForm.open = true;
      contextMenuForm.template = template;
      contextMenuForm.formType = formType;
    },

    closeForm: ({ contextMenuForm }) => {
      contextMenuForm.open = false;
      contextMenuForm.template = null;
      contextMenuForm.formType = FormType.Empty;
    },

    setCurrentTemplateId: (state, { payload }: PayloadAction<string>) => {
      state.currenttemplateId = payload;
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
    if (node.template.id === prevHeadId) {
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
    const { fileTypeId } = node.template;
    if (fileTypeId === FileType.Document && node.children) {
      const ind = node.children.findIndex((_) => _.template.id === prevVerId);
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
  setCurrentTemplateId,
  setMetadata,
} = templateTreePageSlice.actions;

export default templateTreePageSlice.reducer;
