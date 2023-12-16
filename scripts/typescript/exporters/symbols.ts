import pl from "npm:nodejs-polars@0.8.3";
import { CFWF, TableType } from "../../../../cfwf/mod.ts";

export class Symbols {
  // deno-lint-ignore no-explicit-any
  config: any;

  srcdir: string;
  dstdir: string;

  // deno-lint-ignore no-explicit-any
  constructor(config: any) {
    this.config = config;
    this.srcdir = "./database/.export/symbols";
    this.dstdir = "./database/symbols";
  }

  async convert(): Promise<void> {
    const cfgmarkets = this.config;
    for await (const dirEntry of Deno.readDir("database/.export/symbols")) {
      const filename = `${this.srcdir}/${dirEntry.name}`;
      const market = dirEntry.name.split(".")[0];

      if (cfgmarkets[market] === undefined) {
        throw new Error(`ERROR: ${market} not found in config`);
      }

      try {
        console.log(`Export ${market}`);

        const df = pl.readCSV(filename, {
          sep: ",",
          quoteChar: '"',
        });

        this.save(
          cfgmarkets[market],
          {
            tablename: market,
            columns: df.columns,
            rows: df.rows(),
          },
        );
      } catch (e) {
        console.log(`ERROR: ${e}`);
      }
    }
  }

  // deno-lint-ignore no-explicit-any
  async save(config: any, table: TableType): Promise<void> {
    const rows = table.rows || 0;

    if (rows === 0) return;

    const filename = `${this.dstdir}/${table.tablename}.cfwf`;

    const cfwf = new CFWF({
      dataset: {
        title: config.title,
        description: config.description,
        metadatas: {
          sources: config.sources,
        },
      },
    });

    cfwf.addTable({
      tablename: table.tablename,
      subtitle: "",
      columns: table.columns,
      rows: rows,
    });

    console.log(`  Save ${table.tablename}`);

    await cfwf.saveCFWF(filename, false);
  }
}
