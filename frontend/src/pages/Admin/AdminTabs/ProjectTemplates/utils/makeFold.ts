import { FolderProps } from "Types/template.type";
import { makeCommonTemplate, ResponseCommonData } from "./makeTemplate";
import { FileType } from "Types/files.type";

export interface ResponseFolderData extends ResponseCommonData {
  file_type_id: FileType.Folder;
}

export function makeFolder(responseData: ResponseFolderData): FolderProps {
  return {
    ...makeCommonTemplate(responseData),
    fileTypeId: FileType.Folder,
  };
}
