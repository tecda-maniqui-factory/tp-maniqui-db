# Project Memory & Architecture Decisions

This file tracks important context and architecture decisions for the Tecda Maniquí Database project.

---

## 📝 Decisions & Resolutions

### 1. Database Schema Name
* **Date:** 2026-06-16
* **Context:** Some scripts referred to `gestion_bbdd` or other schemas.
* **Decision:** The source of truth schema name is `tecda_maniqui`.

### 2. Logical Deletion
* **Date:** 2026-06-16
* **Context:** Business logic requires maintaining referential integrity while soft-deleting objects.
* **Decision:** Use an `activo` column (Boolean / tinyint(1)) defaulted to 1. When `activo = 0`, the record is hidden but intact.

### 3. Business Logic Encapsulation
* **Date:** 2026-06-16
* **Context:** Validations for "Frankenstein" models (assembling left and right limbs incorrectly) and stock.
* **Decision:** Encapsulate validation and assembly inside a MySQL stored procedure `EnsamblarManiqui` to run atomically.
