import pl from "npm:nodejs-polars@0.8.3";
import { CFWF, TableType } from "../../../../cfwf/mod.ts";

export class Exchanges {
  // deno-lint-ignore no-explicit-any
  config: any;
  name: string;
  title: string;
  description: string;

  srcdir: string;
  dstdir: string;

  // deno-lint-ignore no-explicit-any
  constructor(config: any) {
    this.config = config;
    this.name = "exchanges";
    this.title = "Exchanges list";
    this.description = "A summary of the main global stock marketplaces.";

    this.srcdir = "./database/.export";
    this.dstdir = "./database";
  }

  convert(): void {
    const filename = `${this.srcdir}/${this.name}.csv`;

    try {
      console.log(`Export ${this.name}`);

      const df = pl.readCSV(filename, {
        sep: ",",
        quoteChar: '"',
      });

      this.save(
        {
          tablename: this.name,
          columns: df.columns,
          rows: df.rows(),
        },
      );
    } catch (e) {
      console.log(`ERROR: ${e}`);
    }
  }

  async save(table: TableType): Promise<void> {
    const rows = table.rows || 0;

    if (rows === 0) return;

    const filename = `${this.dstdir}/${table.tablename}.cfwf`;

    const cfwf = new CFWF({
      dataset: {
        title: this.title,
        description: this.description,
        metadatas: {},
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
