import { TextChunk } from "./text.type";

export interface VerFileComparisonDetails {
  firstSequence: TextChunk;
  secondSequence: TextChunk;
}

export interface VerFileComparison {
  replace: VerFileComparisonDetails[];
  insert: VerFileComparisonDetails[];
  delete: VerFileComparisonDetails[];
}
