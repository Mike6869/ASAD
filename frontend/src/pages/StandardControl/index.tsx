import React, { FC, useEffect } from "react";
import type { CSSProperties } from "react";
import { useParams } from "react-router-dom";
import {
  message,
  Spin,
  List,
  Collapse,
  theme,
  Typography,
  Tag,
  Space,
} from "antd";
import type { CollapseProps } from "antd";

import MessageErrorContent from "@components/MessageErrorContent";
import { CaretRightOutlined, CheckOutlined } from "@ant-design/icons";
import {
  ErrorItem,
  StandardControlReport,
  useGetStandardControlReportQuery,
} from "@services/api/file";

const { Text } = Typography;

const renderErrorItem = (item: ErrorItem, type: string) => {
  if (item.format) {
    // Для ФИО
    return (
      <List.Item>
        <Space direction="vertical" style={{ width: "100%" }}>
          <Text strong>{item.full_name}</Text>
          <Text type="secondary">{item.context}</Text>
          {item.recommendation && (
            <Text type="warning">{item.recommendation}</Text>
          )}
        </Space>
      </List.Item>
    );
  } else if (type === "indent") {
    return (
      <List.Item>
        <Space direction="vertical" style={{ width: "100%" }}>
          <Text>
            <Text strong>Отступ:</Text> {item.first_line_indent_cm} см
            {item.style && <Text type="secondary"> (стиль: {item.style})</Text>}
          </Text>
          {item.text && <Text type="secondary">{item.text}...</Text>}
          <Text type="warning">Ожидается: 1.25 см</Text>
        </Space>
      </List.Item>
    );
  } else if (type === "margins") {
    return (
      <List.Item>
        <Space>
          <Text strong>{item.text}:</Text>
          <Text>{item.first_line_indent_cm} мм</Text>
          <Tag color={item.style === "OK" ? "green" : "red"}>
            {item.style === "OK" ? "OK" : "Ошибка"}
          </Tag>
          {item.style === "ERROR" && (
            <Text type="warning">
              Ожидается: {item.first_line_indent_cm} мм
            </Text>
          )}
        </Space>
      </List.Item>
    );
  } else if (item.number) {
    // Для чисел
    return (
      <List.Item>
        <Space direction="vertical" style={{ width: "100%" }}>
          <Text>
            <Text strong>{item.number}</Text> <Text>{item.next_word}</Text>
          </Text>
          <Text type="secondary">{item.context}</Text>
          {item.recommendation && (
            <Text type="warning">{item.recommendation}</Text>
          )}
        </Space>
      </List.Item>
    );
  } else if (item.match) {
    // Для аббревиатур и других случаев
    return (
      <List.Item>
        <Space direction="vertical" style={{ width: "100%" }}>
          <Text strong>{item.match}</Text>
          <Text type="secondary">
            {item.context_before}
            <Text mark>{item.match}</Text>
            {item.context_after}
          </Text>
          {item.recommendation && (
            <Text type="warning">{item.recommendation}</Text>
          )}
        </Space>
      </List.Item>
    );
  }
  return null;
};

const makeItems: (
  panelStyle: CSSProperties,
  report: StandardControlReport
) => CollapseProps["items"] = (panelStyle, report) => {
  const items: CollapseProps["items"] = [];

  // Добавляем проверку полей страницы
  if (report.margins?.margins) {
    const marginEntries = Object.entries(report.margins.margins).filter(
      ([, margin]) => margin.actual !== null
    );

    const marginErrors = marginEntries.filter(
      ([, margin]) => margin.status === "ERROR"
    ).length;

    if (marginErrors > 0) {
      items.push({
        key: "margins",
        label: `Поля страницы (${marginErrors} ошибок)`,
        style: panelStyle,
        children: (
          <List
            bordered
            dataSource={marginEntries.map(([name, margin]) => ({
              text: name,
              first_line_indent_cm: margin.actual,
              style: margin.status,
            }))}
            renderItem={(item) => renderErrorItem(item, "margins")}
          />
        ),
      });
    }
  }

  // Добавляем проверку отступов
  if (report.indent?.indent?.error?.length) {
    items.push({
      key: "indent",
      label: `Отступы первой строки (${report.indent.indent.error.length} ошибок)`,
      style: panelStyle,
      children: (
        <List
          bordered
          dataSource={report.indent.indent.error}
          renderItem={(item) => renderErrorItem(item, "indent")}
        />
      ),
    });
  }

  // Добавляем все проверки non_breaking в один раздел с подразделами
  if (report.non_breaking?.non_breaking) {
    const nb = report.non_breaking.non_breaking;
    const nonBreakingItems: CollapseProps["items"] = [];

    // Подраздел для аббревиатур
    if (nb.abbreviations) {
      const abbreviationErrors: ErrorItem[] = [];
      Object.values(nb.abbreviations).forEach((data) => {
        if (data.errors) {
          abbreviationErrors.push(...data.errors);
        }
      });

      if (abbreviationErrors.length > 0) {
        nonBreakingItems.push({
          key: "abbreviations",
          label: `Аббревиатуры (${abbreviationErrors.length} ошибок)`,
          style: panelStyle,
          children: (
            <List
              bordered
              dataSource={abbreviationErrors}
              renderItem={(item) => renderErrorItem(item, "non-breaking")}
            />
          ),
        });
      }
    }

    // Подраздел для инициалов
    if (nb.initials?.errors?.length) {
      nonBreakingItems.push({
        key: "initials",
        label: `Инициалы (${nb.initials.errors.length} ошибок)`,
        style: panelStyle,
        children: (
          <List
            bordered
            dataSource={nb.initials.errors}
            renderItem={(item) => renderErrorItem(item, "non-breaking")}
          />
        ),
      });
    }

    // Подраздел для чисел
    if (nb.numbers?.errors?.length) {
      nonBreakingItems.push({
        key: "numbers",
        label: `Числа (${nb.numbers.errors.length} ошибок)`,
        style: panelStyle,
        children: (
          <List
            bordered
            dataSource={nb.numbers.errors}
            renderItem={(item) => renderErrorItem(item, "non-breaking")}
          />
        ),
      });
    }

    // Добавляем общий раздел для неразрывных пробелов, если есть подразделы
    if (nonBreakingItems.length > 0) {
      const totalErrors = nonBreakingItems.reduce((sum, item) => {
        const label = typeof item.label === "string" ? item.label : "";
        const match = label.match(/\((\d+)/);
        return sum + (match ? parseInt(match[1]) : 0);
      }, 0);

      items.push({
        key: "non-breaking",
        label: `Неразрывные пробелы (${totalErrors} ошибок)`,
        style: panelStyle,
        children: (
          <Collapse
            bordered={false}
            // Убрали defaultActiveKey, чтобы подразделы были свернуты по умолчанию
            expandIcon={({ isActive }) => (
              <CaretRightOutlined rotate={isActive ? 90 : 0} />
            )}
            items={nonBreakingItems}
          />
        ),
      });
    }
  }

  return items;
};

const StandardControl: FC = () => {
  const params = useParams();
  const {
    data: standardControlReport,
    isError,
    isLoading,
    error,
  } = useGetStandardControlReportQuery(params.fileId as string);
  const { token } = theme.useToken();
  const panelStyle: React.CSSProperties = {
    marginBottom: 24,
    background: token.colorFillAlter,
    borderRadius: token.borderRadiusLG,
    border: "none",
  };

  useEffect(() => {
    if (isError) {
      message.error({
        content: (
          <MessageErrorContent
            title="Возникла ошибка при проверке нормоконтроля"
            details={error ? ("error" in error ? error.error : "") : ""}
          />
        ),
      });
    }
  }, [isError, error]);

  if (isLoading) {
    return <Spin size="large" style={{ margin: "16px" }} />;
  }

  if (!standardControlReport) {
    return (
      <Text type="danger" style={{ margin: "24px" }}>
        При проверке на нормоконтроль возникла ошибка
      </Text>
    );
  }

  // Проверяем, есть ли ошибки в отчете
  const hasErrors =
    (standardControlReport.margins?.margins &&
      Object.values(standardControlReport.margins.margins).some(
        (m) => m.status === "ERROR" && m.actual !== null
      )) ||
    (standardControlReport.non_breaking?.non_breaking &&
      (Object.values(
        standardControlReport.non_breaking.non_breaking.abbreviations || {}
      ).some((a) => a?.errors?.length) ||
        standardControlReport.non_breaking.non_breaking.numbers?.errors
          ?.length ||
        standardControlReport.non_breaking.non_breaking.initials?.errors
          ?.length)) ||
    standardControlReport.indent?.indent?.error?.length;

  if (!hasErrors) {
    return (
      <Space direction="vertical" style={{ margin: "24px", width: "100%" }}>
        <CheckOutlined style={{ color: token.colorSuccess }} />
        <Text type="success">Нормоконтроль пройден, ошибок не найдено.</Text>
      </Space>
    );
  }

  return (
    <Collapse
      bordered={false}
      defaultActiveKey={["margins"]}
      expandIcon={({ isActive }) => (
        <CaretRightOutlined rotate={isActive ? 90 : 0} />
      )}
      style={{ background: token.colorBgContainer }}
      items={makeItems(panelStyle, standardControlReport)}
    />
  );
};

export default StandardControl;
