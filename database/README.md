# Database

`schema.sql` documents the initial relational model for the MVP. TypeORM
migrations will become the executable source of truth once the NestJS backend is
scaffolded; this SQL file remains useful for design review and local inspection.

## Apply locally

After MySQL is installed and the `studymate` user has been created:

```bash
mysql -u studymate -p < database/schema.sql
```

## Reset warning

The schema intentionally contains no `DROP DATABASE` or `DROP TABLE` statements.
Do not add destructive reset commands to normal setup scripts.
