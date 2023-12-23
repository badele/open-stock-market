import { FinanceDatabase } from "./downloaders/financedatabase.ts";
import { Stooq } from "./downloaders/stooq.ts";

export class Downloader {
  // deno-lint-ignore no-explicit-any
  config: any;
  // deno-lint-ignore no-explicit-any
  providers: Record<string, any>;

  // deno-lint-ignore no-explicit-any
  constructor(config: any) {
    this.config = config;
    this.providers = {
      financedatabase: FinanceDatabase,
      stooq: Stooq,
    };
  }

  async download(): Promise<void> {
    const providers = this.config.downloader.providers;
    const providernames = Object.keys(providers);

    for (const providername of providernames) {
      const downloader = new this.providers[providername](
        providers[providername],
      );
      try {
        console.log(`Download ${providername}`);
        await downloader.download();
      } catch (e) {
        console.log(`ERROR: ${e}`);
      }
    }
    // const symbols = this.config.downloader.providers[providername]
    //   .symbols as SymbolInfo[];
    //
    // for (const symbol of symbols) {
    //   const downloader = new this.providers[providername](symbol);
    //   try {
    //     await downloader.downloadHistoryPrice();
    //   } catch (e) {
    //     console.log(`ERROR: ${e}`);
    //   }
    // }
  }
}
