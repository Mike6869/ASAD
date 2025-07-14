import { UserList } from "Types/users.type";
import { api } from "./api";
import camelcaseKeys from "camelcase-keys";

interface UserListResponse {
  users: UserList;
}

export interface User {
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

export const users = api.injectEndpoints({
  endpoints: (build) => ({
    getUserList: build.query<UserList, void>({
      query: () => ({
        url: "admin/users",
      }),
      providesTags: () => ["Users"],
      transformResponse: (response: UserListResponse) =>
        camelcaseKeys(response.users),
    }),
    createUser: build.mutation<User, User>({
      query: (body) => ({
        url: "admin/users",
        method: "POST",
        body: body,
      }),
      invalidatesTags: ["Users"],
    }),
  }),
});

export const { useCreateUserMutation, useGetUserListQuery } = users;
