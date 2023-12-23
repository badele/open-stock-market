// import { CFWF, TableType } from "../../../../cfwf/mod.ts";
import { CFWF } from "https://deno.land/x/cfwf@0.5.0/mod.ts";
import { HistoryPrice } from "../types.ts";
import { existsSync } from "https://deno.land/std@0.205.0/fs/mod.ts";
import { getDateFromDate } from "../utils.ts";
import {
  Destination,
  download,
} from "https://deno.land/x/download@v2.0.2/mod.ts";
import pl from "npm:nodejs-polars@0.8.3";

export class Stooq {
  // deno-lint-ignore no-explicit-any
  config: any;

  source: string;
  url: string;
  infos: HistoryPrice[];

  foldername: string;

  // deno-lint-ignore no-explicit-any
  constructor(config: any) {
    this.config = config;

    this.source = "https://stooq.com/q/?s=${symbol}";
    this.url = "https://stooq.com/q/d/l/?s=${symbol}&i=d";
    this.infos = [];

    this.foldername = `./database/stooq`;
  }

  async isCached(type: string, symbol: string): Promise<boolean> {
    const filename = `${this.foldername}/${type}/${symbol}.cfwf`;

    if (existsSync(filename)) {
      const file = await Deno.stat(filename);
      if (file.mtime) {
        const now = getDateFromDate(new Date());
        const filedate = getDateFromDate(file.mtime);
        if (now === filedate) {
          return true;
        }
      }
    }
    return false;
  }

  async download(): Promise<void> {
    if (this.config.symbols) {
      for (const symbol of this.config.symbols) {
        // Check if file is cached
        if (await this.isCached(symbol.type, symbol.code)) continue;

        const url = this.url.replace("${symbol}", symbol.code);
        console.log(`Download ${url}`);

        try {
          const destination: Destination = {
            file: `${symbol.code}.csv`,
            dir: "./.download",
          };
          await download(url, destination);
        } catch (err) {
          console.log(err);
        }

        const df = pl.readCSV(`./.download/${symbol.code}.csv`, {
          sep: ",",
          quoteChar: '"',
        });

        const filename = `${symbol.code}.cfwf`;
        this.save(filename, symbol.type, {
          tablename: symbol,
          columns: df.columns,
          rows: df.rows(),
        });
      }
    }
  }

  async save(filename: string, type: string, table: TableType): Promise<void> {
    const rows = table.rows || 0;

    if (rows === 0) return;

    const source = this.source.replace("{file}", table.tablename);
    const cfwf = new CFWF({
      dataset: {
        title: table.tablename,
        metadatas: {
          source: source,
        },
      },
    });

    cfwf.addTable({
      tablename: table.tablename,
      subtitle: "",
      columns: table.columns,
      rows: rows,
    });

    const foldername = `${this.foldername}/${type}`;
    if (!existsSync(foldername)) {
      Deno.mkdirSync(foldername, { recursive: true });
    }

    console.log(`Save ${filename}`);

    await cfwf.saveCFWF(`${foldername}/${filename}`, false);
  }
}
