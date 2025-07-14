import { isAxiosError } from "axios";

export default function throwErrorAPI(error: Error): never {
  if (isAxiosError(error)) {
    const data = error.response?.data;
    if (data) {
      throw new Error(`${data.error}. ${data.error_description}`);
    }
    throw new Error(error.message);
  }
  throw error;
}
