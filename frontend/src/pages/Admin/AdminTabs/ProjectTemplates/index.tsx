import CreateProject from "@pages/FileTree/components/CreateProject";
import {
  useGetMetadataQuery,
} from "@services/api/file";
import { useAppDispatch, useAppSelector } from "@services/hooks";
import { Empty, message, Space, Spin, Tree } from "antd";
import { FC, Key, useEffect } from "react";
import {
  update as updateTemplateTree,
  IDataNode,
  setCurrentTemplateId,
  setMetadata,
} from "./templateTreeSlice";
import makeTemplateNode from "./utils/makeTemplateNode";
import {
  getContextMenuFormInfo,
  getTemplateTreeForRendering,
} from "./templateTreeSelectors";
import MessageErrorContent from "@components/MessageErrorContent";
import ContextMenuForm from "@pages/FileTree/components/ContextMenuForm";
import Dropdown from "./Dropdown";
import { useGetProjectTemplateListQuery, useLazyGetTemplateListQuery } from "@services/api/template";
export const ProjectTemplates: FC = () => {
  const dispatch = useAppDispatch();
  const { data: metadata, isError, error, isLoading } = useGetMetadataQuery();
  const formInfo = useAppSelector(getContextMenuFormInfo);
  const [getTemplateList] = useLazyGetTemplateListQuery();
  const treeData = useAppSelector(getTemplateTreeForRendering);
  const {
    data: res,
    isError: isTemplateListError,
    error: templateListError,
  } = useGetProjectTemplateListQuery();

  useEffect(() => {
    metadata && dispatch(setMetadata(metadata));
    isError &&
      message.error({
        content: (
          <MessageErrorContent
            title="Не удалось получить метаданные"
            details={"error" in error ? error.error : ""}
          />
        ),
      });
  }, []);

  useEffect(() => {
    if (treeData.length) {
      return;
    }
    res &&
      dispatch(
        updateTemplateTree({ key: "0", children: res.map(makeTemplateNode) })
      );
    isTemplateListError &&
      message.error({
        content: (
          <MessageErrorContent
            title="Не удалось получить метаданные"
            details={
              "error" in templateListError ? templateListError.error : ""
            }
          />
        ),
      });
  }, [res]);

  const onLoadData = async ({ key, children }: IDataNode) => {
    if (children) return;
    let newChildren: IDataNode[] = [];
    await getTemplateList(key)
      .unwrap()
      .then((data) => {
        newChildren = data.map(makeTemplateNode);
      });
    dispatch(
      updateTemplateTree({ key: key.toString(), children: newChildren })
    );
  };

  const onSelect = ([key]: (string | number | Key)[]) => {
    if (!key) {
      return;
    }
    dispatch(setCurrentTemplateId(key.toString()));
  };

  const titleRender = (item: IDataNode) => (
    <Dropdown template={item.template}>
      <Space>{item.template.name}</Space>
    </Dropdown>
  );

  return (
    <Space direction="vertical">
      <CreateProject template />
      {isLoading && <Spin size="large" />}
      <Tree
        showIcon
        loadData={onLoadData}
        onSelect={onSelect}
        treeData={treeData}
        titleRender={titleRender}
        onRightClick={({ event }) => event.preventDefault()}
      />
      {!isLoading && !treeData.length && <Empty />}
      {formInfo.open && (
        <ContextMenuForm
          formType={formInfo.formType}
          template={true}
          file={formInfo.template!}
        />
      )}
    </Space>
  );
};
