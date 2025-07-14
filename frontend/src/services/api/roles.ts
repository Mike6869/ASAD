import { api } from "./api";
import { ReturnUserRoleInfo, RoleInfo } from "Types/users.type";

interface ResponseRoleInfo {
  role_id: number;
  project_id: number | null;
  label: string;
}

interface RoleResponse {
  user_id: string;
  available_roles: ResponseRoleInfo[];
  current_roles: ResponseRoleInfo[];
}

const makeRoleInfo = (roleInfo: ResponseRoleInfo): RoleInfo => ({
  roleId: roleInfo.role_id,
  projectId: roleInfo.project_id,
  label: roleInfo.label,
});

export const roles = api.injectEndpoints({
  endpoints: (build) => ({
    getUserRoleInfo: build.query<ReturnUserRoleInfo, string>({
      query: (userId: string) => ({
        url: `admin/users/${userId}/role_info`,
      }),
      transformResponse: (response: RoleResponse) => {
        const result = {
          userId: response.user_id,
          availableRoles: response.available_roles.map(makeRoleInfo),
          currentRoles: response.current_roles.map(makeRoleInfo),
        };
        return result;
      },
    }),
    setRoles: build.mutation<
      RoleInfo[],
      { userId: string; newRoles: RoleInfo[] }
    >({
      query: (body) => {
        const { userId, newRoles } = body;
        const roleInfoList = newRoles.map((_) => ({
          label: _.label,
          role_id: _.roleId,
          project_id: _.projectId,
        }));

        return {
          url: `admin/users/${userId}/role_info`,
          method: "PUT",
          body: { roles: roleInfoList },
        };
      },
    }),
  }),
});

export const { useLazyGetUserRoleInfoQuery, useSetRolesMutation } = roles;
