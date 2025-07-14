import React, { FC } from "react";

import { FileProps, FileType, VerFileProps } from "Types/files.type";
import DropdownFolder from "./DropdownFolder";
import DropdownVerFile from "./DropdownVerFile";
import DropdownDocument from "./DropdownDocument";

interface Props {
  file: FileProps | VerFileProps;
  children: React.ReactNode;
}

const Dropdown: FC<Props> = ({ file, children }) => {
  switch (file.fileTypeId) {
    case FileType.Folder:
      return <DropdownFolder file={file}>{children}</DropdownFolder>;
    case FileType.VerFile:
      return <DropdownVerFile file={file}>{children}</DropdownVerFile>;
    case FileType.Document:
      return <DropdownDocument file={file}>{children}</DropdownDocument>;
    default:
      return <>{children}</>;
  }
};

export default Dropdown;
