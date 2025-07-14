export enum FileType {
  Folder = 1,
  VerFile = 2,
  Document = 3,
}

export interface FileCommonProps {
  id: number;
  parentId: number;
  projectId: number;
  name: string;
  fileTypeId: FileType;
  createdAt: string;
  hasAbbreviations: boolean;
}

export interface FolderProps extends FileCommonProps {
  fileTypeId: FileType.Folder;
}

export interface VerFileProps extends FileCommonProps {
  fileTypeId: FileType.VerFile;
  prevVerId: number | null;
  nextVerId: number | null;
  branchId: number;
  verNum: string;
}

export interface DocumentProps extends Omit<VerFileProps, "fileTypeId"> {
  fileTypeId: FileType.Document;
}

export type FileProps = FolderProps | VerFileProps | DocumentProps;
