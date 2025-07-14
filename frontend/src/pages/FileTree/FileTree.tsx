import React, { FC, Key, useEffect } from "react";
import { Space, Tree, Spin, Empty, message, Col, Row } from "antd";

import { useAppSelector, useAppDispatch } from "@services/hooks";
import MessageErrorContent from "@components/MessageErrorContent";
import {
  IDataNode,
  update as updateFileTree,
  setCurrentFileId,
  setMetadata,
} from "./fileTreeSlice";
import {
  getContextMenuFormInfo,
  getFileTreeForRendering,
} from "./fileTreeSelectors";
import CreateProject from "./components/CreateProject";
import makeDataNode from "./utils/makeDataNode";
import Dropdown from "./components/Dropdown";
import ContextMenuForm from "./components/ContextMenuForm";
import Tabs from "./components/Tabs";
import FileTitle from "./components/FileTitle";
import {
  useGetMetadataQuery,
  useGetProjectListQuery,
  useLazyGetFileListQuery,
} from "@services/api/file";

const FileTree: FC = () => {
  const dispatch = useAppDispatch();
  const formInfo = useAppSelector(getContextMenuFormInfo);
  const treeData = useAppSelector(getFileTreeForRendering);
  const { data: metadata, isError, error, isLoading } = useGetMetadataQuery();
  const [getFileList] = useLazyGetFileListQuery();
  const {
    data: res,
    isError: isProjectListError,
    error: projectListError,
  } = useGetProjectListQuery();

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
      dispatch(updateFileTree({ key: "0", children: res.map(makeDataNode) }));
    isProjectListError &&
      message.error({
        content: (
          <MessageErrorContent
            title="Не удалось получить метаданные"
            details={"error" in projectListError ? projectListError.error : ""}
          />
        ),
      });
  }, [res]);

  const onLoadData = async ({ key, children }: IDataNode) => {
    if (children) return;
    let newChildren: IDataNode[] = [];
    await getFileList(key)
      .unwrap()
      .then((data) => {
        newChildren = data.map(makeDataNode);
      });
    dispatch(updateFileTree({ key: key.toString(), children: newChildren }));
  };

  const titleRender = (item: IDataNode) => (
    <Dropdown file={item.file}>
      <span>
        <FileTitle data={item} />
      </span>
    </Dropdown>
  );

  const onSelect = ([key]: (string | number | Key)[]) => {
    if (!key) {
      return;
    }
    dispatch(setCurrentFileId(key.toString()));
  };

  const colStyle: React.CSSProperties = {
    height: "100%",
    overflowY: "auto",
    padding: "8px",
  };

  return (
    <Row style={{ height: "100vh", margin: "16px" }}>
      <Col span={8} style={colStyle}>
        <Space direction="vertical">
          <CreateProject template={false} />
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
              file={formInfo.file!}
              formType={formInfo.formType}
            />
          )}
        </Space>
      </Col>
      <Col span={16} style={colStyle}>
        <Tabs />
      </Col>
    </Row>
  );
};

export default FileTree;
