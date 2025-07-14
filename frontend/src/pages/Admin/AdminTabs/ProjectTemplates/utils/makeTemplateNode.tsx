import { TemplateProps } from "Types/template.type";
import { IDataNode } from "../templateTreeSlice";

const makeTemplateNode = (template: TemplateProps): IDataNode => {
  const dataNode: IDataNode = {
    title: template.name,
    key: template.id.toString(),
    template,
  };
  return dataNode;
};

export default makeTemplateNode;
