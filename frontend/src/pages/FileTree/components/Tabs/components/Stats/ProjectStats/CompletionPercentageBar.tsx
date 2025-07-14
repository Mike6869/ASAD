import { FC } from "react";
import {
  Bar,
  BarChart,
  LabelList,
  ResponsiveContainer,
  XAxis,
  Tooltip,
} from "recharts";

interface Props {
  data: { completionPercentage: number; count: number }[];
}

const DATA_TEMPLATE: {
  completionPercentage: string;
  count: null | number;
}[] = Array.from({ length: 11 }, (_, ind) => ({
  completionPercentage: `${ind * 10}%`,
  count: null,
}));

const prepareData = (data: Props["data"]) => {
  const preparedData = DATA_TEMPLATE.map((item) => ({ ...item }));
  for (const item of data) {
    preparedData[item.completionPercentage / 10].count = item.count;
  }
  return preparedData;
};

const CompletionPercentageBar: FC<Props> = ({ data }) => {
  const processedData = prepareData(data);
  return (
    <ResponsiveContainer width="100%" height={400}>
      <BarChart
        data={processedData}
        margin={{ top: 20, right: 20, bottom: 20, left: 20 }}
      >
        <text
          x="50%"
          y={20}
          fill="black"
          textAnchor="middle"
          dominantBaseline="central"
        >
          <tspan fontSize="16">Процент готовности</tspan>
        </text>
        <XAxis dataKey="completionPercentage" />
        <Tooltip />
        <Bar dataKey="count" name="Кол-во" fill="#0088FE">
          <LabelList dataKey="count" position="top" />
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
};

export default CompletionPercentageBar;
