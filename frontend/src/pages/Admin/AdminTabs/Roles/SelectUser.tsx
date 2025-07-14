import { FC } from "react";
import { Select } from "antd";
import { useGetUserListQuery } from "@services/api/users";

interface Props {
  onSelect: (userId: string) => void;
}

export const SelectUser: FC<Props> = ({ onSelect }) => {
  const { data: userList = [] } = useGetUserListQuery();

  return (
    <Select
      showSearch
      placeholder="Выберите пользователя"
      optionFilterProp="children"
      onSelect={(value) => {
        onSelect(value);
      }}
      style={{ width: 300 }}
      filterOption={(input, option) => (option?.label ?? "").includes(input)}
      filterSort={(optionA, optionB) =>
        (optionA?.label ?? "")
          .toLowerCase()
          .localeCompare((optionB?.label ?? "").toLowerCase())
      }
      options={userList.map((user) => ({
        value: user.id,
        label: user.username,
      }))}
    />
  );
};
