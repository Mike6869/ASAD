import { FileType, VerFileProps } from "Types/files.type";
import { makeCommonFile, ResponseCommonData } from "./makeFile";

export interface ResponseVerFileData extends ResponseCommonData {
  file_type_id: FileType.VerFile;
  branch_id: number;
  next_ver_id: null | number;
  prev_ver_id: null | number;
  ver_num: number;
}

const makeVerStr = (num: number) =>
  num < 10 ? `00${num}` : num < 100 ? `0${num}` : num.toString();

export function makeVerFile(responseData: ResponseVerFileData): VerFileProps {
  const commonFile = makeCommonFile(responseData);
  return {
    ...commonFile,
    branchId: responseData.branch_id,
    nextVerId: responseData.next_ver_id,
    prevVerId: responseData.prev_ver_id,
    verNum: makeVerStr(responseData.ver_num),
    fileTypeId: FileType.VerFile,
  };
}
