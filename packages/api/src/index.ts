import "dotenv/config";

import Fastify from "fastify";

import { healthRoute } from "./routes/health.js";

const app = Fastify({ logger: true });

app.register(healthRoute);

const port = parseInt(process.env["API_PORT"] ?? "3000", 10);

app.listen({ port, host: "0.0.0.0" }, (err) => {
  if (err) {
    app.log.error(err);
    process.exit(1);
  }
});
