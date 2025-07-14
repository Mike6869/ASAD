import React, { FC } from "react";
import { TemplateProps } from "Types/template.type";
import DropdownDocument from "./DropdownDocument";
import DropdownFolder from "./DropdownFolder";
import { FileType } from "Types/files.type";


interface Props {
  template: TemplateProps;
  children: React.ReactNode;
}

const Dropdown: FC<Props> = ({ template, children }) => {
  switch (template.fileTypeId) {
    case FileType.Folder:
      return <DropdownFolder template={template}>{children}</DropdownFolder>;
    case FileType.Document:
      return <DropdownDocument template={template}>{children}</DropdownDocument>;
    default:
      return <>{children}</>;
  }
};

export default Dropdown;
