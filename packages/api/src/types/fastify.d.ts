import type { Pool } from "pg";
import "fastify";

declare module "fastify" {
  interface FastifyInstance {
    pg: Pool;
  }
}
