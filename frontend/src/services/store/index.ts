import { combineReducers, configureStore } from "@reduxjs/toolkit";

import fileTreeReducer from "@pages/FileTree/fileTreeSlice";

import userReducer from "@services/store/userSlice";
import { api } from "@services/api/api";
import templateTreeReducer from "@pages/Admin/AdminTabs/ProjectTemplates/templateTreeSlice";

const rootReducer = combineReducers({
  fileTreePage: fileTreeReducer,
  templateTreePage: templateTreeReducer,
  [api.reducerPath]: api.reducer,
  user: userReducer,
});

const store = configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(api.middleware),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export default store;
