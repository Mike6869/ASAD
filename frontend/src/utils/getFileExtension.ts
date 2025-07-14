const getFileExtension = (fileName: string) => {
  const ind = fileName.lastIndexOf(".");
  if (ind === -1) {
    return "";
  }
  return fileName.slice(ind + 1);
};

export default getFileExtension;
