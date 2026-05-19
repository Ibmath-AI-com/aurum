import * as path from "path";

import dotenv from "dotenv";
import Fastify from "fastify";
import { Pool } from "pg";

import { healthRoute } from "./routes/health.js";

dotenv.config({ path: path.resolve(__dirname, "../../../.env") });

const pool = new Pool({
  host: process.env["DB_HOST"],
  port: parseInt(process.env["DB_PORT"] ?? "5432", 10),
  database: process.env["DB_NAME"],
  user: process.env["DB_USER"],
  password: process.env["DB_PASSWORD"],
  max: parseInt(process.env["DB_MAX"] ?? "10", 10),
  ssl: process.env["DB_SSL"] === "true" ? { rejectUnauthorized: false } : false,
});

const app = Fastify({ logger: true });

app.decorate("pg", pool);

void app.register(healthRoute);

const port = parseInt(process.env["API_PORT"] ?? "3000", 10);

app.listen({ port, host: "0.0.0.0" }, (err) => {
  if (err) {
    app.log.error(err);
    process.exit(1);
  }
});
