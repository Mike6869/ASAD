import { FC } from "react";

interface Props {
  title: string;
  details: string;
}

const MessageErrorContent: FC<Props> = ({ title, details }) => (
  <>
    {title}
    <details>
      <summary>Подробнее</summary>
      {details}
    </details>
  </>
);

export default MessageErrorContent;
