import { FC, useState } from "react";
import { Space } from "antd";

import { SelectUser } from "./SelectUser";
import { RoleTransfer } from "./RoleTransfer";

export const Roles: FC = () => {
  const [selectedUserId, setSelectedUserId] = useState("");

  const handleSelect = (userId: string) => {
    setSelectedUserId(userId);
  };

  return (
    <Space direction="vertical">
      <SelectUser onSelect={handleSelect} />
      <RoleTransfer userId={selectedUserId} />
    </Space>
  );
};
