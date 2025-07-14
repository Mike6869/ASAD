export enum Roles {
  "ADMIN" = 1,
  "READ_ALL" = 2,
  "WRITE_ALL" = 3,
  "DELETE_ALL" = 4,
  "CREATE_PROJECTS" = 5,
  "READ" = 6,
  "WRITE" = 7,
  "DELETE" = 8,
}

export interface User {
  username: string;
  isAdmin: boolean;
  isProjectCreator: boolean;
  roles: { projectId: null | Roles; roleId: number }[];
}

export type UserList = {
  id: string;
  username: string;
  email: string;
  firstName: string;
  lastName: string;
  enabled: boolean;
  createdTimestamp: number;
}[];

export interface RoleInfo {
  roleId: number;
  projectId: number | null;
  label: string;
}

export interface ReturnUserRoleInfo {
  userId: string;
  availableRoles: RoleInfo[];
  currentRoles: RoleInfo[];
}
