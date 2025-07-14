import { FileProps, FileType, FileCommonProps } from "Types/files.type";
import { makeVerFile, type ResponseVerFileData } from "./makeVerFile";
import { makeFolder, type ResponseFolderData } from "./makeFolder";
import { ResponseDocumentData, makeDocument } from "./makeDocument";

export type ResponseCommonData = {
  created_at: string;
  id: number;
  name: string;
  file_type_id: number;
  parent_id: number;
  has_abbreviations: boolean;
  project_id: number;
};

export type ResponseFiles =
  | ResponseFolderData
  | ResponseVerFileData
  | ResponseDocumentData;

export function makeCommonFile(
  responseData: ResponseCommonData
): FileCommonProps {
  return {
    createdAt: responseData.created_at,
    hasAbbreviations: responseData.has_abbreviations,
    id: responseData.id,
    name: responseData.name,
    parentId: responseData.parent_id,
    fileTypeId: responseData.file_type_id,
    projectId: responseData.project_id,
  };
}

export default function makeFile(responseData: ResponseFiles): FileProps {
  switch (responseData.file_type_id) {
    case FileType.Folder:
      return makeFolder(responseData);
    case FileType.Document:
      return makeDocument(responseData);
    default:
      return makeVerFile(responseData);
  }
}
