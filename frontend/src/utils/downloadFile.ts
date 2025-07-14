import axiosConfig from "@services/axiosConfig";

const { baseURL } = axiosConfig.defaults;

export function downloadFile(id: string, fileName: string, templ: boolean) {
  axiosConfig
    .get(`${templ ? "template" : "file"}/${id}/download`, {
      responseType: "blob",
    })
    .then((response) => {
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", fileName);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    });
}

export function getDownloadLink(id: string | number) {
  return `${baseURL}file/${id}/download`;
}
