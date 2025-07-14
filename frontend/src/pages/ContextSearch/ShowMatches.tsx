import { FC } from "react";
import { Collapse, Empty, List, Space, Typography } from "antd";
import type { CollapseProps } from "antd";

import type { DocumentProps } from "Types/files.type";
import { FileWordOutlined } from "@ant-design/icons";

const { Text } = Typography;

export type Matches = {
  document: DocumentProps;
  chunks: {
    prefix: string;
    substr: string;
    postfix: string;
  }[];
}[];

interface Props {
  matches: Matches;
}

const makeItems = (matches: Matches): CollapseProps["items"] =>
  matches.map(({ document, chunks }) => ({
    key: document.id,
    label: (
      <>
        <FileWordOutlined />
        {document.name} (кол-во совпадений: {chunks.length})
      </>
    ),
    children: (
      <List
        dataSource={chunks}
        renderItem={(item) => (
          <List.Item>
            {item.prefix}
            <Text mark>{item.substr}</Text>
            {item.postfix}
          </List.Item>
        )}
      />
    ),
  }));

export const ShowMatches: FC<Props> = ({ matches }) => {
  if (matches.length === 0) {
    return <Empty description="Совпадения не найдены" />;
  }

  return (
    <Space direction="vertical">
      <Text strong>Найдено в следующих документах:</Text>
      <Collapse items={makeItems(matches)} />
    </Space>
  );
};
