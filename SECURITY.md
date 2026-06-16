# Security Policy

This document outlines the security posture, vulnerability reporting process, and security practices of the Tecda Maniquí Database service.

## 🔒 Security Practices

1. **Role-Based Access Control:** DB accounts are restricted to specific permissions. Do not run application servers using the MySQL `root` account in production; use standard privileges as outlined in `scripts/step4_users.sql`.
2. **SQL Injection Prevention:** SQL queries in calling applications must be parameterized. No raw string concatenation should be used for queries.
3. **No Secrets in Repo:** Do not check in active database credentials. Passwords must be fed through environment variables (e.g. `MYSQL_ROOT_PASSWORD`) in Docker Compose configurations.
4. **Audit Logging:** Table price updates are automatically logged into `Auditoria_Precios` for historical trace security.

## 🛡️ Vulnerability Reporting

If you find a security vulnerability:
1. Do not open a public issue.
2. Email your findings and reproduction steps to the development lead.
3. A patch or migration script will be prepared before disclosure.
