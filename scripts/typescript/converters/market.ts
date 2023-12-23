import { CFWF, TableType } from "../../../../cfwf/mod.ts";
// import { CFWF } from "https://deno.land/x/cfwf@0.5.0/mod.ts";
import pl from "npm:nodejs-polars@0.8.3";

export class Market {
  // deno-lint-ignore no-explicit-any
  config: any;
  objname: string;
  srcfilename: string;
  dstfilename: string;

  sources: string[];
  foldername: string;

  // deno-lint-ignore no-explicit-any
  constructor(config: any) {
    this.config = config;

    this.sources = ["https://www.iso20022.org/market-identifier-codes"];
    this.objname = "market";
    this.foldername = "./datas";
    this.srcfilename = `${this.foldername}/.export/${this.objname}.csv`;
    this.dstfilename = `${this.foldername}/${this.objname}.cfwf`;
  }

  convert(): void {
    const df = pl.readCSV(this.srcfilename, {
      sep: ",",
      quoteChar: '"',
    });

    this.save({
      tablename: this.objname,
      columns: df.columns,
      rows: df.rows(),
    });
  }

  async save(table: TableType): Promise<void> {
    const rows = table.rows || 0;

    if (rows === 0) return;

    const cfwf = new CFWF({
      dataset: {
        title: table.tablename,
        description: this.config.description,
        metadatas: {
          sources: this.sources,
        },
      },
    });

    cfwf.addTable({
      tablename: table.tablename,
      subtitle: "",
      columns: table.columns,
      rows: rows,
    });

    console.log(`Save ${this.objname}`);

    await cfwf.saveCFWF(this.dstfilename, false);
  }
}
