import { Application, Request, Response, NextFunction } from "express";

export type QueryResult = {
  head: {
    link: string[];
    vars: string[];
  };
  results: {
    distinct: boolean;
    ordered: boolean;
    bindings: {
      [key: string]: {
        type: string;
        value: string;
        datatype?: string;
        "xml:lang"?: string;
      };
    }[];
  };
};

declare const mu: {
  app: Application;
  sparql: (strings: TemplateStringsArray, ...expr: string[]) => void;
  SPARQL: (strings: TemplateStringsArray, ...expr: string[]) => void;
  query: (q: string) => Promise<QueryResult>;
  update: (q: string) => Promise<QueryResult>;
  sparqlEscape: (value: any) => string;
  sparqlEscapeString: (value: string) => string;
  sparqlEscapeUri: (value: string) => string;
  sparqlEscapeDecimal: (value: string | number) => string;
  sparqlEscapeInt: (value: string | number) => string;
  sparqlEscapeFloat: (value: string | number) => string;
  sparqlEscapeDate: (value: string | number | Date) => string;
  sparqlEscapeDateTime: (value: string | number | Date) => string;
  sparqlEscapeBool: (
    value: boolean | string | number | null | undefined
  ) => string;
  uuid: () => string;
  errorHandler: (
    err: Error,
    req: Request,
    res: Response,
    next: NextFunction
  ) => void;
};

declare const app: (typeof mu)["app"];
declare const sparql: (typeof mu)["sparql"];
declare const SPARQL: (typeof mu)["SPARQL"];
declare const query: (typeof mu)["query"];
declare const update: (typeof mu)["update"];
declare const sparqlEscape: (typeof mu)["sparqlEscape"];
declare const sparqlEscapeString: (typeof mu)["sparqlEscapeString"];
declare const sparqlEscapeUri: (typeof mu)["sparqlEscapeUri"];
declare const sparqlEscapeDecimal: (typeof mu)["sparqlEscapeDecimal"];
declare const sparqlEscapeInt: (typeof mu)["sparqlEscapeInt"];
declare const sparqlEscapeFloat: (typeof mu)["sparqlEscapeFloat"];
declare const sparqlEscapeDate: (typeof mu)["sparqlEscapeDate"];
declare const sparqlEscapeDateTime: (typeof mu)["sparqlEscapeDateTime"];
declare const sparqlEscapeBool: (typeof mu)["sparqlEscapeBool"];
declare const uuid: (typeof mu)["uuid"];
declare const errorHandler: (typeof mu)["errorHandler"];
