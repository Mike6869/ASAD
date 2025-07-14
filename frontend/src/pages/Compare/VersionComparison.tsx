import React, { FC } from "react";
import type { CSSProperties } from "react";
import { CaretRightOutlined } from "@ant-design/icons";
import { Collapse, List, Space, theme, Typography } from "antd";
import type { CollapseProps } from "antd";

import { VerFileComparison } from "Types/comparison.type";

const { Text } = Typography;

const makeItems: (
  panelStyle: CSSProperties,
  comparison: VerFileComparison
) => CollapseProps["items"] = (panelStyle, comparison) => [
  {
    key: "1",
    label: `Удалено (${comparison.delete.length})`,
    children: (
      <List
        bordered
        dataSource={comparison.delete}
        renderItem={({ firstSequence }) => (
          <List.Item>
            {firstSequence.prefix}
            <span className="highlight-red">{firstSequence.data}</span>
            {firstSequence.postfix}
          </List.Item>
        )}
      />
    ),
    style: panelStyle,
  },
  {
    key: "2",
    label: `Добавлено (${comparison.insert.length})`,
    children: (
      <List
        bordered
        dataSource={comparison.insert}
        renderItem={({ secondSequence }) => (
          <List.Item>
            {secondSequence.prefix}
            <span className="highlight-green">{secondSequence.data}</span>
            {secondSequence.postfix}
          </List.Item>
        )}
      />
    ),
    style: panelStyle,
  },
  {
    key: "3",
    label: `Изменено (${comparison.replace.length})`,
    children: (
      <List
        bordered
        dataSource={comparison.replace}
        renderItem={({ firstSequence, secondSequence }) => (
          <List.Item>
            <Space direction="vertical">
              <Text>
                {firstSequence.prefix}
                <span className="highlight-red">{firstSequence.data}</span>
                {firstSequence.postfix}
              </Text>
              <Text>
                {secondSequence.prefix}
                <span className="highlight-green">{secondSequence.data}</span>
                {secondSequence.postfix}
              </Text>
            </Space>
          </List.Item>
        )}
      />
    ),
    style: panelStyle,
  },
];

interface Props {
  comparison: VerFileComparison | undefined;
}

const VersionComparison: FC<Props> = ({ comparison }) => {
  const { token } = theme.useToken();

  const panelStyle: React.CSSProperties = {
    marginBottom: 24,
    background: token.colorFillAlter,
    borderRadius: token.borderRadiusLG,
    border: "none",
  };

  if (!comparison) {
    return null;
  }

  return (
    <Collapse
      bordered={false}
      expandIcon={({ isActive }) => (
        <CaretRightOutlined rotate={isActive ? 90 : 0} />
      )}
      style={{ background: token.colorBgContainer }}
      items={makeItems(panelStyle, comparison)}
    />
  );
};

export default VersionComparison;
