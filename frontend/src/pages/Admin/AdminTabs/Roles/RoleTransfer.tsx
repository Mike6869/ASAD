import { FC, Key, useEffect, useState } from "react";
import { App, Button, Transfer } from "antd";
import type { TransferProps } from "antd";
import type { ReturnUserRoleInfo, RoleInfo } from "Types/users.type";
import {
  useLazyGetUserRoleInfoQuery,
  useSetRolesMutation,
} from "@services/api/roles";

interface Props {
  userId: string;
}

interface RecordType {
  key: string;
  label: string;
  roleId: number;
  projectId: number | null;
}

const makeData = (rawData: Awaited<ReturnUserRoleInfo>): RecordType[] =>
  [...rawData.currentRoles, ...rawData.availableRoles].map((data) => ({
    ...data,
    key: data.label,
  }));

export const RoleTransfer: FC<Props> = ({ userId }) => {
  const [data, setData] = useState<RecordType[]>([]);
  const [targetKeys, setTargetKeys] = useState<Key[]>([]);
  const [initialTargetKeys, setInitialTargetKeys] = useState<Key[]>([]);
  const { message } = App.useApp();

  const clearTransfer = () => {
    setData([]);
    setTargetKeys([]);
  };

  const [getRoles, { isLoading, error: getRoleError }] =
    useLazyGetUserRoleInfoQuery();
  const [setRole, { error: setRoleError }] = useSetRolesMutation();

  const roles = () => {
    clearTransfer();
    if (!userId) {
      return;
    }
    message.loading("Роли пользователя загружаются");
    getRoles(userId)
      .unwrap()
      .then((roles) => {
        const newTargetKeys = roles.currentRoles.map(
          (curRole) => curRole.label
        );
        setInitialTargetKeys(newTargetKeys);
        setTargetKeys(newTargetKeys);
        setData(makeData(roles));
        message.destroy();
      })
      .catch(() => message.error(String(getRoleError)));
  };

  useEffect(() => {
    roles();
  }, [userId]);

  const handleSave = async () => {
    const newRoles: RoleInfo[] = data.filter((role) =>
      targetKeys.includes(role.key)
    );
    const roles = { userId, newRoles };
    await setRole(roles)
      .unwrap()
      .then(() => {
        message.success("Роли пользователя успешно изменены"),
          setInitialTargetKeys(targetKeys);
      })
      .catch(() => message.error(String(setRoleError)));
  };

  const renderFooter: TransferProps["footer"] = (_, info) => {
    if (info?.direction !== "right") {
      return null;
    }
    return (
      <Button
        size="middle"
        type="primary"
        onClick={handleSave}
        style={{ float: "right", margin: 5 }}
        loading={isLoading}
        disabled={
          data.length === 0 ||
          (targetKeys.length === initialTargetKeys.length &&
            targetKeys.every((val, ind) => val === initialTargetKeys[ind]))
        }
      >
        Сохранить
      </Button>
    );
  };

  return (
    <Transfer
      titles={["Доступные роли", "Текущие роли"]}
      listStyle={{ width: 300, height: 600 }}
      showSearch
      disabled={isLoading}
      dataSource={data}
      targetKeys={targetKeys}
      onChange={(newTargetKeys: Key[]) => setTargetKeys(newTargetKeys)}
      footer={renderFooter}
      render={(item) => item.label}
    />
  );
};
