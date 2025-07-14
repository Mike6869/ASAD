import { Metadata } from "@pages/FileTree/fileTreeSlice";
import { api } from "./api";
import mammoth from "mammoth";
import {
  DocumentProps,
  FileCommonProps,
  FileProps,
  FileType,
  FolderProps,
  VerFileProps,
} from "Types/files.type";
import { TextChunk } from "Types/text.type";
import {
  VerFileComparison,
  VerFileComparisonDetails,
} from "Types/comparison.type";
import {
  makeVerFile,
  ResponseVerFileData,
} from "@pages/FileTree/utils/makeVerFile";
import makeFile, { ResponseFiles } from "@pages/FileTree/utils/makeFile";
import {
  makeDocument,
  ResponseDocumentData,
} from "@pages/FileTree/utils/makeDocument";
import {
  makeFolder,
  ResponseFolderData,
} from "@pages/FileTree/utils/makeFolder";
import { Key } from "react";

interface getAbbreviations {
  abbreviations: {
    id: number;
    file_id: number;
    abbreviation: string;
    description: string;
  }[];
  files: { [Id: string]: string };
}

interface getMetadata {
  completionPercentages: number[];
  types: { id: number; code: string; typeName: string; url: string }[];
  statuses: { id: number; status: string }[];
}

type Chunks = {
  prefix: string;
  substr: string;
  postfix: string;
}[];

type getContextSearchResponse = {
  document: ResponseDocumentData;
  chunks: Chunks;
}[];

type getContextSearch = {
  document: DocumentProps;
  chunks: Chunks;
}[];

export interface ImagesSrc {
  imgList: { src: string }[];
}

export type FolderStats = { id: string; name: string; relPath: string }[];

export type FileStatsType = {
  id: string;
  fileId: string;
  size: number;
  name: string;
  createdAt: string;
};

export type DocumentStatsType = FileStatsType & {
  author: string;
  lastModifiedBy: string;
  modifiedAt: string;
  wordsCount: number;
  completionPercentage: number;
  statusId: number;
  typeId: number;
};

export type ProjectStatsApiResponse = {
  id: number;
  createdAt: string;
  expectedNumberOfDocuments: number;
  name: string;
  documentsList: DocumentStatsType[];
};

export type StatsData =
  | {
      fileTypeId: FileType.Folder;
      isProject: false;
      stats: FolderStats;
    }
  | {
      fileTypeId: FileType.Folder;
      isProject: true;
      stats: ProjectStatsApiResponse;
    }
  | {
      fileTypeId: FileType.VerFile;
      stats: FileStatsType;
    }
  | {
      fileTypeId: FileType.Document;
      stats: DocumentStatsType;
    };

export interface ErrorItem {
  position?: number;
  context?: string;
  context_before?: string;
  context_after?: string;
  match?: string;
  recommendation?: string | null;
  number?: string;
  next_word?: string;
  format?: string;
  full_name?: string;
  is_correct?: boolean;
  has_nbsp?: boolean;
  text?: string;
  first_line_indent_cm?: number | null;
  style?: string;
}

interface CategoryData {
  errors?: ErrorItem[];
  correct?: ErrorItem[];
}

export interface StandardControlReport {
  non_breaking?: {
    non_breaking?: {
      abbreviations?: {
        [key: string]: CategoryData;
      };
      numbers?: CategoryData;
      initials?: CategoryData;
    };
    error: string;
  };
  indent?: {
    indent?: {
      correct?: ErrorItem[];
      error?: ErrorItem[];
    };
  };
  margins?: {
    margins: {
      bottom: {
        expected: number;
        actual: number | null;
        status: string;
      };
      left: {
        expected: number;
        actual: number | null;
        status: string;
      };
      top: {
        expected: number;
        actual: number | null;
        status: string;
      };
      right: {
        expected: number;
        actual: number | null;
        status: string;
      };
    };
    error: string;
  };
}
export interface GetTablesResponse {
  tables: { header: string[]; rows: string[][] }[];
}

type Tag = "delete" | "insert" | "replace";
type VerFileComparisonResponse = {
  tag: Tag;
  firstSequence: TextChunk;
  secondSequence: TextChunk;
}[];

export interface FormData {
  name: string;
  file: File;
  typeId: FileType;
  prevVerId?: string;
  statusId?: number;
  documentTypeId?: number;
  completionPercentage?: number;
  needAnalytic?: boolean;
}

type FileData = (VerFileProps & { similarity: number; relPath: string })[];

type findSimilarDocsResponse = (ResponseVerFileData & {
  similarity: number;
  rel_path: string;
})[];

const makeVerFileComparisonDetails: (
  item: VerFileComparisonResponse[number]
) => VerFileComparisonDetails = (item) => ({
  firstSequence: item.firstSequence,
  secondSequence: item.secondSequence,
});

const makeVerFileComparison: (
  response: VerFileComparisonResponse
) => VerFileComparison = (response) => {
  const comparison: VerFileComparison = {
    delete: [],
    insert: [],
    replace: [],
  };

  for (const item of response) {
    switch (item.tag) {
      case "delete":
        comparison.delete.push(makeVerFileComparisonDetails(item));
        break;
      case "insert":
        comparison.insert.push(makeVerFileComparisonDetails(item));
        break;
      case "replace":
        comparison.replace.push(makeVerFileComparisonDetails(item));
        break;
      default:
        break;
    }
  }

  return comparison;
};

export interface VerFile {
  name: string;
  file: File;
  typeId: FileType;
  prevVerId?: string;
  statusId?: number;
  documentTypeId?: number;
  completionPercentage?: number;
  needAnalytic?: boolean;
}

export const file = api.injectEndpoints({
  endpoints: (build) => ({
    getAbbreviations: build.query<getAbbreviations, number | string>({
      query: (filedId: number | string) => ({
        url: `file/${filedId}/abbreviations`,
      }),
    }),

    getMetadata: build.query<Metadata, void>({
      query: () => ({
        url: "file/metadata",
      }),
      transformResponse: (response: getMetadata) => {
        const result = {
          completionPercentages: response.completionPercentages,
          types: response.types.reduce(
            (acc, cur) => ({
              ...acc,
              [cur.id]: {
                code: cur.code,
                typeName: cur.typeName,
                url: cur.url,
              },
            }),
            {}
          ),
          statuses: response.statuses.reduce(
            (acc, cur) => ({
              ...acc,
              [cur.id]: { status: cur.status },
            }),
            {}
          ),
        };
        return result;
      },
    }),

    checkDocumentType: build.mutation<
      {
        documentType: string | null;
        status: "success" | "error";
        matchPosition?: number;
        error?: string;
      },
      File
    >({
      query: (file) => {
        const formData = new FormData();
        formData.append("file", file);
        return {
          url: "file/check-document-type",
          method: "POST",
          body: formData,
        };
      },
    }),

    getProjectList: build.query<FileProps[], void>({
      query: () => ({
        url: "file/",
      }),
      providesTags: () => ["Files"],
      transformResponse: (response: ResponseFiles[]) => {
        return response.map(makeFile);
      },
    }),

    deleteFolderOrFile: build.mutation<FileCommonProps, string>({
      query: (id) => ({
        url: `file/${id}`,
        method: "DELETE",
      }),
      transformResponse: (response: ResponseFiles) => {
        return makeFile(response);
      },
      invalidatesTags: ["Files"],
    }),

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    getBranch: build.query<any, number | string>({
      query: (branchId) => ({
        url: `file/branch/${branchId}`,
      }),
      transformResponse: (response: ResponseFiles[]) => {
        return response.map(makeFile);
      },
    }),

    getContextSearch: build.query<
      getContextSearch,
      { folderId: number | string; pattern: string }
    >({
      query: (args) => {
        const { folderId, pattern } = args;
        return {
          url: `file/${folderId}/substr-docs`,
          params: { pattern },
        };
      },
      transformResponse: (response: getContextSearchResponse) => {
        return response.map((_) => ({
          ..._,
          document: makeDocument(_.document),
        }));
      },
    }),

    getFileList: build.query<FileProps[], string | number | Key>({
      query: (id) => ({
        url: `file/${id.toString()}`,
      }),
      transformResponse: (response: ResponseFiles[]) => {
        return response.map(makeFile);
      },
    }),

    getImagesSrc: build.query<ImagesSrc, string | number>({
      query: (fileId) => ({
        url: `file/${fileId}/media`,
      }),
    }),

    getStandardControlReport: build.query<
      StandardControlReport,
      string | number
    >({
      query: (fileId) => ({
        url: `file/${fileId}/standardcontrol`,
      }),
    }),

    getStats: build.query<StatsData, string | number>({
      query: (fileId) => ({
        url: `file/${fileId}/stats`,
      }),
    }),

    getTables: build.query<GetTablesResponse, string | number>({
      query: (fileId) => ({
        url: `file/${fileId}/tables`,
      }),
    }),

    getVerFileComparison: build.query<
      VerFileComparison,
      { firstFileId: number; secondFileId: number }
    >({
      query: (args) => ({
        url: "file/compare",
        params: {
          firstVersion: args.firstFileId,
          secondVersion: args.secondFileId,
        },
      }),
      transformResponse: (response: VerFileComparisonResponse) => {
        return makeVerFileComparison(response);
      },
    }),

    getTemplateFileComparison: build.query<
      VerFileComparison,
      { firstFileId: number }
    >({
      query: (args) => ({
        url: "file/compare-files",
        params: {
          firstVersion: args.firstFileId,
        },
      }),
      transformResponse: (response: VerFileComparisonResponse) => {
        return makeVerFileComparison(response);
      },
    }),

    getFile: build.query<string, string | number>({
      query: (fileId) => ({
        url: `file/${fileId}/get-file-path`,
        // Указываем, что ответ не JSON, а бинарные данные
        responseHandler: (response) => response.arrayBuffer(),
      }),
      transformResponse: async (arrayBuffer: ArrayBuffer) => {
        // Преобразуем ArrayBuffer в текст с помощью mammoth
        const result = await mammoth.convertToHtml({ arrayBuffer });
        return result.value;
      },
    }),

    getWordcloudSrc: build.query<string, string | number>({
      query: (fileId) => ({
        url: `file/${fileId}/word-cloud`,
        responseHandler: async (response) =>
          URL.createObjectURL(await response.blob()),
        cache: "no-cache",
      }),
    }),

    createFolder: build.mutation<FileProps, { name: string; parentId: string }>(
      {
        query: (args) => {
          const { name, parentId } = args;
          return {
            url: `file/folder/${parentId}`,
            method: "POST",
            body: { name, typeId: FileType.Folder },
          };
        },
        transformResponse: (response: ResponseFiles) => {
          return makeFile(response);
        },
      }
    ),

    createGroupVerFile: build.mutation<
      number,
      { parentId: number | string; formData: VerFile }
    >({
      query: (args) => {
        const { parentId, formData } = args;
        const payload: VerFile = { ...formData, needAnalytic: false };
        const newFormData = new FormData();
        for (const [key, value] of Object.entries(payload)) {
          newFormData.append(key, value);
        }
        return {
          url: `file/${parentId.toString()}`,
          method: "POST",
          body: newFormData,
        };
      },
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      transformResponse: (response: any) => {
        return +response.id;
      },
    }),

    createProject: build.mutation<
      FileProps,
      { name: string; documentsCount: number; templatePath: string }
    >({
      query: (args) => {
        const { name, documentsCount, templatePath } = args;
        return {
          url: "file/",
          method: "POST",
          body: { name, documentsCount, templatePath },
        };
      },
      transformResponse: (response: ResponseFiles) => {
        return makeFile(response);
      },
    }),

    createVerFile: build.mutation<
      VerFileProps | DocumentProps,
      { parentId: number | string; formData: VerFile }
    >({
      query: (args) => {
        const { parentId, formData } = args;
        const payload =
          formData.needAnalytic === undefined
            ? { ...formData, needAnalytic: true }
            : formData;
        const newFormData = new FormData();
        for (const [key, value] of Object.entries(payload)) {
          newFormData.append(key, value);
        }
        return {
          url: `file/${parentId.toString()}`,
          method: "POST",
          body: newFormData,
        };
      },
      transformResponse: (
        response: ResponseVerFileData | ResponseDocumentData
      ) => {
        return response.file_type_id === FileType.Document
          ? makeDocument(response)
          : makeVerFile(response);
      },
    }),

    editProject: build.mutation<
      FolderProps,
      { id: string | number; documentsCount: number }
    >({
      query: (args) => {
        const { id, documentsCount } = args;
        return {
          url: `file/${id.toString()}`,
          method: "PATCH",
          body: { documentsCount: documentsCount },
        };
      },
      transformResponse: (response: ResponseFolderData) => {
        return makeFolder(response);
      },
    }),

    findSimilarDocs: build.mutation<FileData, { folderId: string; file: File }>(
      {
        query: (args) => {
          const { folderId, file } = args;
          const formData = new FormData();
          formData.append("file", file);
          return {
            url: `file/${folderId}/similarity`,
            method: "POST",
            body: formData,
          };
        },
        transformResponse: (response: findSimilarDocsResponse) => {
          return response
            .sort((a, b) => b.similarity - a.similarity)
            .map((data) => ({
              ...makeVerFile(data),
              similarity: data.similarity,
              relPath: data.rel_path,
            }));
        },
      }
    ),

    renameFile: build.mutation<string, { newName: string; id: string }>({
      query: (args) => {
        const { newName, id } = args;
        return {
          url: `file/${id}`,
          method: "PATCH",
          body: { name: newName },
        };
      },
      transformResponse: (response: ResponseFiles) => {
        return makeFile(response).name;
      },
    }),

    startFileAnalytic: build.mutation<
      string,
      { parentId: number | string; fileIds: number[] }
    >({
      query: (args) => {
        const { parentId, fileIds } = args;
        const formData = new FormData();

        // Правильное добавление fileIds как списка
        fileIds.forEach((fileId) => {
          formData.append("fileIds", fileId.toString());
        });

        return {
          url: `file/${parentId}/sorting`,
          method: "POST",
          body: formData,
        };
      },
    }),
  }),
});

export const {
  useGetAbbreviationsQuery,
  useGetMetadataQuery,
  useGetProjectListQuery,
  useDeleteFolderOrFileMutation,
  useGetBranchQuery,
  useLazyGetContextSearchQuery,
  useLazyGetFileListQuery,
  useGetImagesSrcQuery,
  useGetStandardControlReportQuery,
  useGetStatsQuery,
  useGetTablesQuery,
  useLazyGetVerFileComparisonQuery,
  useGetFileQuery,
  useLazyGetTemplateFileComparisonQuery,
  useGetWordcloudSrcQuery,
  useCreateFolderMutation,
  useCreateGroupVerFileMutation,
  useCreateProjectMutation,
  useCreateVerFileMutation,
  useEditProjectMutation,
  useFindSimilarDocsMutation,
  useRenameFileMutation,
  useStartFileAnalyticMutation,
  useCheckDocumentTypeMutation,
} = file;
