import * as crypto from "crypto";
import * as fs from "fs";
import * as path from "path";

import dotenv from "dotenv";
import { Pool } from "pg";

// Load .env from the monorepo root regardless of cwd
dotenv.config({ path: path.resolve(__dirname, "../../../../.env") });

const pool = new Pool({
  host: process.env["DB_HOST"],
  port: parseInt(process.env["DB_PORT"] ?? "5432", 10),
  database: process.env["DB_NAME"],
  user: process.env["DB_USER"],
  password: process.env["DB_PASSWORD"],
  max: 3,
  ssl: process.env["DB_SSL"] === "true" ? { rejectUnauthorized: false } : false,
});

async function migrate(): Promise<void> {
  const client = await pool.connect();

  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (
        id          TEXT PRIMARY KEY,
        applied_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        checksum    TEXT NOT NULL
      )
    `);

    const migrationsDir = path.join(__dirname, "migrations");
    const files = fs
      .readdirSync(migrationsDir)
      .filter((f) => f.endsWith(".sql"))
      .sort();

    for (const file of files) {
      const id = file.replace(".sql", "");
      const sql = fs.readFileSync(path.join(migrationsDir, file), "utf-8");
      const checksum = crypto.createHash("sha256").update(sql).digest("hex");

      const existing = await client.query<{ checksum: string }>(
        "SELECT checksum FROM schema_migrations WHERE id = $1",
        [id],
      );

      if (existing.rows.length > 0) {
        if (existing.rows[0]!.checksum !== checksum) {
          throw new Error(
            `Checksum mismatch for migration "${id}" — never edit a committed migration. Create a new one instead.`,
          );
        }
        console.log(`  skip  ${file}`);
        continue;
      }

      console.log(`  apply ${file}`);
      await client.query("BEGIN");
      try {
        await client.query(sql);
        await client.query(
          "INSERT INTO schema_migrations (id, checksum) VALUES ($1, $2)",
          [id, checksum],
        );
        await client.query("COMMIT");
      } catch (err) {
        await client.query("ROLLBACK");
        throw err;
      }
    }

    console.log("Migrations complete.");
  } finally {
    client.release();
    await pool.end();
  }
}

migrate().catch((err) => {
  console.error("Migration failed:", err);
  process.exit(1);
});
