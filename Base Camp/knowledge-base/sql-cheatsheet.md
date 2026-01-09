# 🐘 PostgreSQL Performance & Advanced SQL
> **Purpose:** Mastering the database layer to handle complex data relationships and high-performance querying in Season 1.

---

## ⚡ 1. Indexing Strategy: Beyond B-Tree
While standard indexes are great, PostgreSQL offers specialized types for specific Season 1 use cases.

* **GIN (Generalized Inverted Index):** Essential for searching within `JSONB` fields or implementing Full-Text Search.
* **Partial Indexes:** Save space and speed up queries by indexing only a subset of data (e.g., `CREATE INDEX idx_active_tasks ON tasks (user_id) WHERE status = 'active';`).
* **Covering Indexes (INCLUDE):** Use the `INCLUDE` clause to add "payload" columns to an index, allowing for "Index Only Scans" that never touch the actual heap.
* **BRIN (Block Range Index):** Perfect for massive, naturally ordered tables (like logs or time-series data) to achieve high performance with minimal disk space.

## 📦 2. JSONB: Relational vs. Document
PostgreSQL allows you to store unstructured data without sacrificing performance.

* **When to use:** Use `JSONB` for third-party API responses (like OpenAI metadata in Week 07) or highly dynamic user preferences.
* **Querying:** Use the `->>` operator to get text or `@>` to check if a JSONB object contains specific keys/values.
* **Performance:** Always pair `JSONB` with a GIN index if you plan to filter by its contents in your Django views.

## 🔍 3. Query Optimization & Diagnostics
Never guess why a query is slow; ask the database.

* **EXPLAIN ANALYZE:** Run this on any query triggered more than 100 times per minute. Look for "Seq Scan" on large tables—this usually indicates a missing index.
* **Parallel Queries:** PostgreSQL 16 can use multiple CPU cores for a single query. Ensure your `max_parallel_workers` setting in Docker matches your dev machine's capability.
* **Avoid NOT IN:** When checking for non-existence, use `NOT EXISTS` or a `LEFT JOIN ... WHERE ... IS NULL`. These are typically much faster than `NOT IN` with subqueries.

## 🛠️ 4. Power Features: CTEs & Window Functions
Advanced SQL patterns to reduce logic complexity in Python.

* **Common Table Expressions (WITH):** Use `WITH` to break complex queries into readable, logical blocks.
* **Window Functions (OVER):** Use `ROW_NUMBER()`, `RANK()`, or `SUM() OVER(...)` to perform calculations across a set of rows related to the current row (e.g., "Top 3 tasks per user").
* **UPSERT (ON CONFLICT):** Use `INSERT ... ON CONFLICT (id) DO UPDATE ...` to handle "create or update" logic in a single atomic database hit.

## 🛡️ 5. Data Integrity & Safety
PostgreSQL is your last line of defense for data consistency.

* **Check Constraints:** Add `CHECK` constraints directly to the DB for logic that simple Django field types can't catch (e.g., `CHECK (price > 0)`).
* **Transactional DDL:** Remember that in Postgres, you can run migrations inside a transaction. If a migration fails halfway, it rolls back automatically, preventing "half-mig