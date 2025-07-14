import { Roles, User } from "Types/users.type";
import { api } from "./api";

interface UserInfo {
  username: string;
  roles: { project_id: null | Roles; role_id: number }[];
}

export const userInfo = api.injectEndpoints({
  endpoints: (build) => ({
    getUserInfo: build.query<User, void>({
      query: () => ({
        url: "userinfo/",
      }),
      transformResponse: (response: UserInfo) => {
        const result = {
          username: response.username,
          roles: response.roles.map((role) => ({
            projectId: role.project_id,
            roleId: role.role_id,
          })),
          isAdmin: response.roles.some((role) => role.role_id === Roles.ADMIN),
          isProjectCreator: response.roles.some(
            (role) => role.role_id === Roles.CREATE_PROJECTS
          ),
        };
        return result;
      },
    }),
  }),
});

export const { useLazyGetUserInfoQuery } = userInfo;
