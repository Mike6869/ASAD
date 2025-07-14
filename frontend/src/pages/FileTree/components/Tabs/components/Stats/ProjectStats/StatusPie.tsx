import { FC } from "react";
import {
  Cell,
  LabelList,
  Legend,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
} from "recharts";

interface Props {
  data: { statusName: string; count: number }[];
}

const COLORS = ["#0088FE", "#00C49F", "#FFBB28", "#FF8042", "#B9BAA3"];

const StatusPie: FC<Props> = ({ data }) => (
  <ResponsiveContainer width="100%" height={400}>
    <PieChart>
      <text
        x="50%"
        y={20}
        fill="black"
        textAnchor="middle"
        dominantBaseline="central"
      >
        <tspan fontSize="16">Статус согласования</tspan>
      </text>
      <Legend verticalAlign="middle" layout="vertical" align="left" />
      <Tooltip />
      <Pie
        data={data}
        cx="50%"
        cy="50%"
        labelLine={false}
        outerRadius={100}
        fill="#8884d8"
        dataKey="count"
        nameKey="statusName"
      >
        <LabelList dataKey="count" />
        {data.map((_, index) => (
          <Cell key={`cell-${index}`} fill={COLORS[index]} />
        ))}
      </Pie>
    </PieChart>
  </ResponsiveContainer>
);

export default StatusPie;
