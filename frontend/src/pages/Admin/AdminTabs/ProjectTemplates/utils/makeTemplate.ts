import { TemplateProps, TemplateCommonProps } from "Types/template.type";
import { makeFolder, ResponseFolderData } from "./makeFold";
import { makeDocument, ResponseDocumentData } from "./makeDoc";
import { FileType } from "Types/files.type";

export type ResponseCommonData = {
  created_at: string;
  id: number;
  name: string;
  file_type_id: number;
  parent_id: number;
  has_abbreviations: boolean;
  project_id: number;
};

export type ResponseTemplates =
  | ResponseFolderData
  | ResponseDocumentData;

export function makeCommonTemplate(
  responseData: ResponseCommonData
): TemplateCommonProps {
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

export default function makeTemplate(responseData: ResponseTemplates): TemplateProps {
  switch (responseData.file_type_id) {
    case FileType.Folder:
      return makeFolder(responseData);
    case FileType.Document:
      return makeDocument(responseData);
  }
}
