import { FileType, DocumentProps } from "Types/files.type";
import { makeVerFile, type ResponseVerFileData } from "./makeVerFile";

export interface ResponseDocumentData
  extends Omit<ResponseVerFileData, "file_type_id"> {
  file_type_id: FileType.Document;
}

export function makeDocument(
  responseData: ResponseDocumentData
): DocumentProps {
  const verFileData = makeVerFile(responseData as any); // eslint-disable-line @typescript-eslint/no-explicit-any
  return {
    ...verFileData,
    fileTypeId: FileType.Document,
  };
}
