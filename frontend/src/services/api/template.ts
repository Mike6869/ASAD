import { api } from "./api";
import { Key } from "react";
import {
  TemplateProps,
  TemplateCommonProps,
} from "Types/template.type";
import makeTemplate, {
  ResponseTemplates,
} from "@pages/Admin/AdminTabs/ProjectTemplates/utils/makeTemplate";
import { ResponseDocumentData } from "@pages/Admin/AdminTabs/ProjectTemplates/utils/makeDoc";
import { FileType } from "Types/files.type";

export interface AddTempate {
  name: string;
  file: File;
  typeId: FileType;
}

export const template = api.injectEndpoints({
  endpoints: (build) => ({
    getProjectTemplateList: build.query<TemplateProps[], void>({
      query: () => ({
        url: "template/project_template",
      }),
      providesTags: () => ["Templates"],
      transformResponse: (response: ResponseTemplates[]) => {
        return response.map(makeTemplate);
      },
    }),

    getTemplateList: build.query<TemplateProps[], string | number | Key>({
      query: (id) => ({
        url: `template/${id.toString()}`,
      }),
      transformResponse: (response: ResponseTemplates[]) => {
        return response.map(makeTemplate);
      },
    }),

    createTemplateFolder: build.mutation<
      TemplateProps,
      { name: string; parentId: string }
    >({
      query: (args) => {
        const { name, parentId } = args;
        return {
          url: `template/folder/${parentId}`,
          method: "POST",
          body: { name, typeId: FileType.Folder },
        };
      },
      transformResponse: (response: ResponseTemplates) => {
        return makeTemplate(response);
      },
      invalidatesTags: ["Templates"],
    }),

    createProjectTemplate: build.mutation<TemplateProps, { name: string }>({
      query: (args) => {
        const { name } = args;
        return {
          url: "template/project_template",
          method: "POST",
          body: { name },
        };
      },
      transformResponse: (response: ResponseTemplates) => {
        return makeTemplate(response);
      },
      invalidatesTags: ["Templates"],
    }),

    deleteFolderOrTemplate: build.mutation<TemplateCommonProps, string>({
      query: (id) => ({
        url: `template/${id}`,
        method: "DELETE",
      }),
      transformResponse: (response: ResponseTemplates) => {
        return makeTemplate(response);
      },
      invalidatesTags: ["Templates"],
    }),

    renameTemplate: build.mutation<string, { newName: string; id: string }>({
      query: (args) => {
        const { newName, id } = args;
        return {
          url: `template/${id}`,
          method: "PATCH",
          body: { name: newName },
        };
      },
      transformResponse: (response: ResponseTemplates) => {
        return makeTemplate(response).name;
      },
      invalidatesTags: ["Templates"],
    }),

    addTemplate: build.mutation<
      TemplateProps,
      { parentId: number | string; formData: AddTempate }
    >({
      query: (args) => {
        const { parentId, formData } = args;
        const newFormData = new FormData();
        for (const [key, value] of Object.entries(formData)) {
          newFormData.append(key, value);
        }
        return {
          url: `template/${parentId.toString()}`,
          method: "POST",
          body: newFormData,
        };
      },
      transformResponse: (response: ResponseDocumentData) => {
        return makeTemplate(response);
      },
      invalidatesTags: ["Templates"],
    }),

    createGroupTemplate: build.mutation<
      number,
      { parentId: number | string; formData: AddTempate }
    >({
      query: (args) => {
        const { parentId, formData } = args;
        const newFormData = new FormData();
        for (const [key, value] of Object.entries(formData)) {
          newFormData.append(key, value);
        }
        return {
          url: `template/${parentId.toString()}`,
          method: "POST",
          body: newFormData,
        };
      },
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      transformResponse: (response: any) => {
        return +response.id;
      },
    }),
  }),
});

export const {
  useGetProjectTemplateListQuery,
  useLazyGetTemplateListQuery,
  useCreateTemplateFolderMutation,
  useCreateProjectTemplateMutation,
  useDeleteFolderOrTemplateMutation,
  useRenameTemplateMutation,
  useAddTemplateMutation,
  useCreateGroupTemplateMutation
} = template;
