import type { FastifyInstance } from "fastify";

export function healthRoute(app: FastifyInstance, _opts: object, done: () => void): void {
  app.get("/health", async (_req, reply) => {
    const pool = app.pg;
    let dbStatus: "connected" | "disconnected" = "disconnected";
    let dbName: string | null = null;

    try {
      const client = await pool.connect();
      try {
        const result = await client.query<{ current_database: string }>(
          "SELECT current_database()",
        );
        dbStatus = "connected";
        dbName = result.rows[0]?.current_database ?? null;
      } finally {
        client.release();
      }
    } catch {
      // pool unreachable — status stays "disconnected"
    }

    return reply.send({
      status: "ok",
      db: dbStatus,
      db_name: dbName,
      timestamp: new Date().toISOString(),
    });
  });

  done();
}
