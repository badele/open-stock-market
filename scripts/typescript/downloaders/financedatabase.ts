// import { CFWF, TableType } from "../../../../cfwf/mod.ts";
import { CFWF } from "https://deno.land/x/cfwf@0.5.0/mod.ts";
import { getDateFromDate } from "../utils.ts";
import { existsSync } from "https://deno.land/std@0.205.0/fs/exists.ts";
import pl from "npm:nodejs-polars@0.8.3";
import {
  Destination,
  download,
} from "https://deno.land/x/download@v2.0.2/mod.ts";

// deno-lint-ignore no-explicit-any
const filesinfos: Record<string, any> = {
  "cryptos": {
    "isnotnull": [
      "name",
      "cryptocurrency",
      "currency",
      "summary",
    ],
    "columns": [
      "symbol",
      "name",
      "cryptocurrency",
      "currency",
      "summary",
    ],
  },
  "equities": {
    "isnotnull": [
      "isin",
      "name",
      "currency",
      "sector",
      "industry",
      "industry_group",
      "exchange",
    ],
    "columns": [
      "isin",
      "symbol",
      "name",
      "currency",
      "sector",
      "industry",
      "industry_group",
      "exchange",
      "market",
      "country",
      "state",
      "city",
      "zipcode",
      "website",
      "market_cap",
    ],
  },
  "etfs": {
    "isnotnull": [
      "name",
      "currency",
      "summary",
    ],
    "columns": [
      "symbol",
      "name",
      "currency",
      "category_group",
      "family",
      "exchange",
    ],
  },
  "indices": {
    "isnotnull": [
      "name",
      "currency",
      "market",
      "exchange",
    ],
    "columns": [
      "symbol",
      "name",
      "currency",
      "exchange",
      "market",
    ],
  },
};

export class FinanceDatabase {
  // deno-lint-ignore no-explicit-any
  config: any;

  source: string;
  url: string;
  // deno-lint-ignore no-explicit-any
  infos: any[];

  foldername: string;

  // deno-lint-ignore no-explicit-any
  constructor(config: any) {
    this.config = config;

    this.source =
      "https://github.com/JerBouma/FinanceDatabase/blob/main/database/{file}.csv";
    this.url =
      "https://raw.githubusercontent.com/JerBouma/FinanceDatabase/main/database/{file}.csv";
    this.infos = [];

    this.foldername = `./database/financedatabase`;
  }

  async isCached(item: string): Promise<boolean> {
    const filename = `${this.foldername}/${item}.cfwf`;

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
    if (this.config.files) {
      for (const file of this.config.files) {
        // Check if file is cached
        if (await this.isCached(file)) continue;

        // download file
        const url = this.url.replace("{file}", file);
        console.log(`Download ${url}`);

        try {
          const destination: Destination = {
            file: `${file}.csv`,
            dir: "./.download",
          };
          await download(url, destination);
        } catch (err) {
          console.log(err);
        }

        const q = pl.scanCSV(`./.download/${file}.csv`, {
          sep: ",",
          quoteChar: '"',
        })
          .filter(pl.allHorizontal(
            pl.col(filesinfos[file].isnotnull).isNotNull(),
          ))
          .select(
            pl.col(filesinfos[file].columns),
          );
        const df = await q.collect();

        const filename = `${file}.cfwf`;
        this.save(filename, {
          tablename: file,
          columns: df.columns,
          rows: df.rows(),
        });
      }
    }
  }

  async save(filename: string, table: TableType): Promise<void> {
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

    if (!existsSync(this.foldername)) {
      Deno.mkdirSync(this.foldername, { recursive: true });
    }

    console.log(`Save ${filename}`);

    await cfwf.saveCFWF(`${this.foldername}/${filename}`, false);
  }
}
