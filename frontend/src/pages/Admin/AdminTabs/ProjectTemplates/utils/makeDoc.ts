import { DocumentProps } from "Types/template.type";
import { makeCommonTemplate, ResponseCommonData } from "./makeTemplate";
import { FileType } from "Types/files.type";

export interface ResponseDocumentData extends ResponseCommonData {
  file_type_id: FileType.Document;
}

export function makeDocument(
  responseData: ResponseDocumentData
): DocumentProps {
  const commonTemplate = makeCommonTemplate(responseData);
  return {
    ...commonTemplate,
    fileTypeId: FileType.Document,
  };
}
