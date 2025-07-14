/* eslint no-param-reassign: ["error", { "props": false }] */
import { createSlice, PayloadAction } from "@reduxjs/toolkit";

import type { User } from "Types/users.type";

export interface UserInfo {
  user?: User;
}

const initialState: UserInfo = {
  user: undefined,
};

export const userSlice = createSlice({
  name: "user",
  initialState,
  reducers: {
    setUser: (state, action: PayloadAction<User | undefined>) => {
      const newUser = action.payload;
      state.user = newUser;
    },
    clearUser: (state) => {
      state.user = undefined;
    },
  },
});

export const { setUser, clearUser } = userSlice.actions;
export default userSlice.reducer;
