import { Routes, Route } from "react-router-dom";
import { Spin } from "antd";
import { useKeycloak } from "@react-keycloak/web";

import Layout from "../components/Layout";
import {
  Home,
  NotFound,
  FileTree,
  Compare,
  StandardControl,
  Admin,
  ContextSearch,
} from "../pages";
import { getUser } from "@services/store/userSelectors";
import { useAppSelector } from "@services/hooks";
import CompareTemplate from "@pages/Compare/CompareTemplate";

const App = () => {
  const { initialized } = useKeycloak();
  const { user } = useAppSelector(getUser);
  if (!initialized || !user) {
    return <Spin size="large" fullscreen />;
  }

  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="home" element={<Home />} />
        <Route path="file-tree" element={<FileTree />} />
        <Route path="admin" element={<Admin />} />
        <Route path="compare-files/:branchId" element={<CompareTemplate />} />
        <Route path="compare/:branchId" element={<Compare/>} />
        <Route path="standardcontrol/:fileId" element={<StandardControl />} />
        <Route path="contextsearch/:folderId" element={<ContextSearch />} />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  );
};

export default App;
