# GEMINI.md — Tecda Maniquí Database Guidelines

This document provides quick reference instructions and standards for the Tecda Maniquí Database project.

## 🛠️ Database Setup and Test Commands

* **Initialize Database via Docker:** `docker compose up -d` in the root folder.
* **Database Connection Port:** `3307` mapped to MySQL container port `3306`.
* **Run Regression SQL Tests:** Import and execute `tests/db/test_reforma_v2.sql`.

---

## 📂 Project Structure

* `docker/`: Dockerfiles and compose configs for running MySQL isolated.
* `diseño/`: Relational schema diagrams, EER files, and physical designs.
* `docs/`: Technical explanations of stored procedures and triggers.
* `guia_base_de_datos/`: General SQL documentation and catalog setup.
* `scripts/`: Ordered SQL scripts representing the database schema:
  - `step1_schema.sql`: Table structure and logical delete fields.
  - `step2_triggers.sql`: Anti-Frankenstein triggers and serial generation.
  - `step3_procedures.sql`: Stored procedures for business transactions (e.g. `EnsamblarManiqui`).
  - `step4_users.sql`: Role-based access control and user creation.
  - `step5_audit.sql`: Audit table triggers for price changes.
* `tests/`: Verification scripts and regression suites.

---

## 🎨 Code Style and Standards

1. **Naming Conventions:** Use snake_case for tables, columns, procedures, and variables.
2. **Schema Integrity:** Always specify foreign keys explicitly. Do not allow orphans.
3. **Transaction Safety:** Wrap data mutation procedures in `START TRANSACTION ... COMMIT / ROLLBACK` blocks with proper error handlers (`DECLARE EXIT HANDLER FOR SQLEXCEPTION`).
4. **Logical Deletes:** All query queries should filter on `activo = 1` unless specifically fetching historical data.
5. **No Raw Secrets:** Do not store MySQL root passwords in plain text SQL files.
