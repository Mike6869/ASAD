import { FileProps } from "Types/files.type";
import { IDataNode } from "../fileTreeSlice";

const makeDataNode = (file: FileProps): IDataNode => {
  const dataNode: IDataNode = {
    title: file.name,
    key: file.id.toString(),
    file,
  };
  return dataNode;
};

export default makeDataNode;
