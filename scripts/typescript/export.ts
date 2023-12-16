import { parse as yamlParse } from "https://deno.land/std@0.202.0/yaml/mod.ts";
// import { Downloader } from "./downloader.ts";
import { Symbols } from "./exporters/symbols.ts";
import { Exchanges } from "./exporters/exchanges.ts";

// Load ledger tools config
const text = Deno.readTextFileSync("config/markets.yaml");
// deno-lint-ignore no-explicit-any
const config = yamlParse(text) as any;

// const downloader = new Downloader(config);
// downloader.download();

const symbols = new Symbols(config);
symbols.convert();

const exchanges = new Exchanges(config);
exchanges.convert();

Deno.readTextFile("README.md").then((text) => {
  Deno.readTextFile("database/exchanges.cfwf").then((exchanges) => {
    const elines = exchanges.split("\n");
    const ystart = elines.findIndex((line) => line.startsWith("╴╴╴"));

    const rlines = text.split("\n");
    const rstart = rlines.findIndex((line) =>
      line.startsWith("<!-- BEGIN exchanges")
    );
    const rend = rlines.findIndex((line) =>
      line.startsWith("<!-- END exchanges")
    );
    const newLines = [
      ...rlines.slice(0, rstart + 1),
      "\n```text",
      ...elines.slice(0, ystart),
      "```\n",
      ...rlines.slice(rend),
    ];

    const content = newLines.join("\n");
    Deno.writeTextFile("README.md", content);
  });
});
