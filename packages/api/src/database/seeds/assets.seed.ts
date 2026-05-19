import * as path from "path";

import dotenv from "dotenv";
import { Pool } from "pg";

dotenv.config({ path: path.resolve(__dirname, "../../../../../.env") });

const pool = new Pool({
  host: process.env["DB_HOST"],
  port: parseInt(process.env["DB_PORT"] ?? "5432", 10),
  database: process.env["DB_NAME"],
  user: process.env["DB_USER"],
  password: process.env["DB_PASSWORD"],
  max: 3,
  ssl: process.env["DB_SSL"] === "true" ? { rejectUnauthorized: false } : false,
});

const ASSETS = [
  { symbol: "XAU/USD", name: "Gold Spot",            asset_class: "metal",  category: "precious_metal"  },
  { symbol: "XAG/USD", name: "Silver Spot",          asset_class: "metal",  category: "precious_metal"  },
  { symbol: "XPT/USD", name: "Platinum Spot",        asset_class: "metal",  category: "precious_metal"  },
  { symbol: "XPD/USD", name: "Palladium Spot",       asset_class: "metal",  category: "precious_metal"  },
  { symbol: "SPY",     name: "SPDR S&P 500 ETF",     asset_class: "etf",    category: "broad_market"    },
  { symbol: "GLD",     name: "SPDR Gold Shares",     asset_class: "etf",    category: "gold_etf"        },
  { symbol: "SLV",     name: "iShares Silver Trust", asset_class: "etf",    category: "silver_etf"      },
  { symbol: "NEM",     name: "Newmont Corporation",  asset_class: "equity", category: "mining_stock"    },
  { symbol: "GDX",     name: "VanEck Gold Miners ETF", asset_class: "etf", category: "mining_etf"      },
  { symbol: "DXY",     name: "US Dollar Index",      asset_class: "index",  category: "currency_index"  },
];

interface CountRow {
  count: string;
}

async function seed(): Promise<void> {
  const client = await pool.connect();
  try {
    for (const asset of ASSETS) {
      await client.query(
        `INSERT INTO assets (symbol, name, asset_class, category, currency)
         VALUES ($1, $2, $3, $4, 'USD')
         ON CONFLICT (symbol) DO NOTHING`,
        [asset.symbol, asset.name, asset.asset_class, asset.category],
      );
    }
    const { rows } = await client.query<CountRow>("SELECT count(*) FROM assets");
    console.log(`Seed complete. assets row count: ${rows[0]?.count ?? "?"}`);
  } finally {
    client.release();
    await pool.end();
  }
}

seed().catch((err) => {
  console.error("Seed failed:", err);
  process.exit(1);
});
