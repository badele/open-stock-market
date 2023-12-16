export type HistoryPrice = {
  date: string;
  open: number;
  high: number;
  low: number;
  close: number;
  volume: number;
  adjclose: number;
};

export type SymbolInfo = {
  code: string;
  type: string;
  subtitle: string;
  description: string;
};
