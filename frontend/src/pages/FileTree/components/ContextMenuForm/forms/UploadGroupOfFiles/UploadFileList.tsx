import { FC, useEffect, useRef, useState } from "react";
import { Alert, Button, Modal, Progress, List, Typography } from "antd";
import { useCreateGroupTemplateMutation } from "@services/api/template";

import { FileType } from "Types/files.type";
import {
  useCreateGroupVerFileMutation,
  useStartFileAnalyticMutation,
} from "@services/api/file";

const { Text } = Typography;

interface FileWithProgress {
  file: File;
  progress: number;
  status: "pending" | "loading" | "success" | "error";
}

interface Props {
  fileList: File[];
  onComplete: () => void;
  parentId: string | number;
  template?: boolean;
}

const UploadFileList: FC<Props> = ({
  fileList,
  onComplete,
  parentId,
  template = false,
}) => {
  const [files, setFiles] = useState<FileWithProgress[]>([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [open, setOpen] = useState(true);
  const [analyzing, setAnalyzing] = useState(false);
  const [completed, setCompleted] = useState(false);
  const [analysisProgress, setAnalysisProgress] = useState(0);
  const [analysisDuration, setAnalysisDuration] = useState<number | null>(null);

  const uploadedFileIds = useRef<number[]>([]);
  const analysisTimerRef = useRef<number | null>(null);
  const analysisStartTimeRef = useRef<number | null>(null);

  const [createGroupVerFile] = useCreateGroupVerFileMutation();
  const [createGroupTemplate] = useCreateGroupTemplateMutation();
  const [startFileAnalytic] = useStartFileAnalyticMutation();

  // Инициализируем список файлов
  useEffect(() => {
    if (fileList.length === 0) {
      onComplete();
      return;
    }

    setFiles(
      fileList.map((file) => ({
        file,
        progress: 0,
        status: "pending",
      }))
    );
  }, [fileList]);

  const uploadFile = async (index: number) => {
    const fileObj = files[index];
    if (!fileObj || fileObj.status !== "pending") return;

    const curFile = fileObj.file;

    const formData = {
      name: curFile.name,
      file: curFile,
      typeId:
        curFile.name.toLowerCase().endsWith("docx") || template
          ? FileType.Document
          : FileType.VerFile,
    };

    try {
      setFiles((prev) =>
        prev.map((f, i) =>
          i === index ? { ...f, status: "loading", progress: 0 } : f
        )
      );

      const result = !template
        ? await createGroupVerFile({
            parentId,
            formData,
          }).unwrap()
        : await createGroupTemplate({
            parentId,
            formData,
          }).unwrap();

      uploadedFileIds.current.push(result);

      setFiles((prev) =>
        prev.map((f, i) =>
          i === index ? { ...f, status: "success", progress: 100 } : f
        )
      );
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (error: any) {
      console.log(error?.data?.message || error.toString());
      setFiles((prev) =>
        prev.map((f, i) =>
          i === index ? { ...f, status: "error", progress: 0 } : f
        )
      );
    }
  };

  const analyticFiles = async () => {
    if (uploadedFileIds.current.length === 0) {
      // setErrorMessage("Файлы не были загружены");
      return;
    }

    setAnalyzing(true);
    setErrorMessage("");
    setAnalysisProgress(0);
    analysisStartTimeRef.current = Date.now();

    // Запуск имитации прогресса
    if (analysisTimerRef.current) clearInterval(analysisTimerRef.current);
    analysisTimerRef.current = window.setInterval(() => {
      setAnalysisProgress((prev) => {
        if (prev >= 95) return prev;
        const elapsed =
          Date.now() - (analysisStartTimeRef.current || Date.now());
        const estimatedTotalTime = 10000; // Оценочное время анализа (10 сек)
        const simulatedProgress = Math.min(
          Math.round((elapsed / estimatedTotalTime) * 100),
          95
        );
        return simulatedProgress;
      });
    }, 200);

    try {
      const formData = new FormData();
      uploadedFileIds.current.forEach((id) =>
        formData.append("fileIds", id.toString())
      );

      await startFileAnalytic({
        parentId,
        fileIds: uploadedFileIds.current,
      }).unwrap();

      const duration =
        Date.now() - (analysisStartTimeRef.current || Date.now());
      setAnalysisDuration(duration);

      setAnalysisProgress(100);
      setTimeout(() => {
        setCompleted(true);
      }, 300);
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (error: any) {
      console.log(error?.data?.message || error.toString());
    } finally {
      if (analysisTimerRef.current) {
        clearInterval(analysisTimerRef.current);
        analysisTimerRef.current = null;
      }
      setAnalyzing(false);
    }
  };

  // Автоматически запускаем следующий шаг
  useEffect(() => {
    const nextPendingIndex = files.findIndex((f) => f.status === "pending");

    if (nextPendingIndex >= 0) {
      uploadFile(nextPendingIndex);
    } else if (
      files.every((f) => f.status === "success") &&
      !analyzing &&
      !completed
    ) {
      if (template) {
        setCompleted(true);
      } else {
        analyticFiles();
      }
    }

    return () => {
      if (analysisTimerRef.current) {
        clearInterval(analysisTimerRef.current);
      }
    };
  }, [files, template]);

  const totalProgress = files.reduce((sum, f) => sum + f.progress, 0);
  const averageProgress = Math.round(totalProgress / files.length);

  const handleClose = () => {
    setOpen(false);
    onComplete();
  };

  const handleSkip = () => {
    setErrorMessage("");
    const nextErrorIndex = files.findIndex((f) => f.status === "error");
    if (nextErrorIndex >= 0) {
      setFiles((prev) =>
        prev.map((f, i) =>
          i === nextErrorIndex ? { ...f, status: "pending" } : f
        )
      );
    } else if (analyzing) {
      analyticFiles(); // повторить анализ
    }
  };

  const handleRetry = () => {
    setErrorMessage("");
    const nextErrorIndex = files.findIndex((f) => f.status === "error");
    if (nextErrorIndex >= 0) {
      uploadFile(nextErrorIndex); // повторить загрузку
    } else if (analyzing) {
      analyticFiles(); // повторить анализ
    }
  };

  let progressDescription = "";

  if (analyzing) {
    progressDescription = "Анализ загруженных документов...";
  } else if (completed) {
    progressDescription = "Завершено!";
  } else {
    progressDescription = `${averageProgress}%`;
  }

  return (
    <Modal
      title={
        template ? "Прогресс загрузки шаблона" : "Прогресс загрузки файлов"
      }
      open={open}
      onCancel={onComplete}
      closable={false}
      maskClosable={false}
      footer={[
        <Button key="skip" onClick={handleSkip} disabled={!errorMessage}>
          Пропустить
        </Button>,
        <Button key="retry" onClick={handleRetry} disabled={!errorMessage}>
          Повторить
        </Button>,
      ]}
    >
      {errorMessage && <Alert type="error" message={errorMessage} />}

      {completed ? (
        <div style={{ textAlign: "center" }}>
          <Text strong>
            {template
              ? "Все файлы успешно загружены"
              : "Все файлы успешно загружены и проанализированы"}
          </Text>
          {!template && analysisDuration && (
            <p>
              <small>
                Время анализа: {(analysisDuration || 0) / 1000} сек.
              </small>
            </p>
          )}
        </div>
      ) : (
        <>
          <div>{progressDescription}</div>

          {analyzing ? (
            <Progress percent={analysisProgress} status="active" />
          ) : (
            <Progress percent={averageProgress} status="normal" />
          )}

          {!analyzing && (
            <List
              size="small"
              dataSource={files}
              renderItem={(item, index) => (
                <List.Item key={index}>
                  <List.Item.Meta
                    title={<span>{item.file.name}</span>}
                    description={
                      item.status === "loading" ? (
                        <Progress percent={item.progress} size="small" />
                      ) : item.status === "success" ? (
                        <Text type="success">Успешно</Text>
                      ) : item.status === "error" ? (
                        <Text type="danger">Ошибка</Text>
                      ) : null
                    }
                  />
                </List.Item>
              )}
            />
          )}
        </>
      )}

      {completed && (
        <div style={{ textAlign: "right", marginTop: 16 }}>
          <Button type="primary" onClick={handleClose}>
            Закрыть
          </Button>
        </div>
      )}
    </Modal>
  );
};

export default UploadFileList;
