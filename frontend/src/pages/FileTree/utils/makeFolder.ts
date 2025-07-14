import { FileType, FolderProps } from "Types/files.type";
import { makeCommonFile, ResponseCommonData } from "./makeFile";

export interface ResponseFolderData extends ResponseCommonData {
  file_type_id: FileType.Folder;
}

export function makeFolder(responseData: ResponseFolderData): FolderProps {
  return {
    ...makeCommonFile(responseData),
    fileTypeId: FileType.Folder,
  };
}
