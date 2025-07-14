import { FileType } from "./files.type";

export interface TemplateCommonProps {
  id: number;
  parentId: number;
  projectId: number;
  name: string;
  fileTypeId: FileType;
  createdAt: string;
  hasAbbreviations: boolean;
}

export interface FolderProps extends TemplateCommonProps {
  fileTypeId: FileType.Folder;
}

export interface DocumentProps extends TemplateCommonProps {
  fileTypeId: FileType.Document;
}

export type TemplateProps = FolderProps | DocumentProps;
