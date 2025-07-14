import { FC } from "react";

import { FileProps, FolderProps, VerFileProps } from "Types/files.type";
import CreateFolder from "./forms/CreateFolder";
import CreateVerFile from "./forms/CreateVerFile";
import AddNextVersion from "./forms/AddNextVersion";
import RenameFile from "./forms/RenameFile";
import FindSimilarDocs from "./forms/FindSimilarDocs";
import EditProject from "./forms/EditProject";
import UploadGroupOfFiles from "./forms/UploadGroupOfFiles";
import { TemplateProps } from "Types/template.type";

export enum FormType {
  "Empty" = "Empty",
  "CreateFolder" = "CreateFolder",
  "CreateVerFile" = "CreateVerFile",
  "AddNextVersion" = "AddNextVersion",
  "RenameFile" = "RenameFile",
  "FindSimilarDocs" = "FindSimilarDocs",
  "EditProject" = "EditProject",
  "UploadGroupOfFiles" = "UploadGroupOfFiles",
}

interface Props {
  file: FileProps | TemplateProps;
  formType: FormType | null;
  template?: boolean;
}

const ContextMenuForm: FC<Props> = ({ file, formType, template }) => {
  switch (formType) {
    case FormType.CreateFolder:
      return <CreateFolder parentId={file.id.toString()} template={template} />;

    case FormType.CreateVerFile:
      return (
        <CreateVerFile parentId={file.id.toString()} template={template} />
      );

    case FormType.AddNextVersion:
      return <AddNextVersion file={file as VerFileProps} />;

    case FormType.RenameFile:
      return (
        <RenameFile
          id={file.id.toString()}
          name={file.name}
          template={template}
        />
      );

    case FormType.FindSimilarDocs:
      return <FindSimilarDocs folderId={file.id.toString()} />;

    case FormType.EditProject:
      return <EditProject folder={file as FolderProps} />;

    case FormType.UploadGroupOfFiles:
      return <UploadGroupOfFiles parentId={file.id} template={template} />;

    case FormType.Empty:
    default:
      return null;
  }
};

export default ContextMenuForm;
