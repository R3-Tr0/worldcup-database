
# World Cup Database

A PostgreSQL relational database project completed as part of freeCodeCamp's Relational Database Certification.

This repository contains a SQL dump of the `worldcup` database, along with Bash scripts for importing World Cup game results and querying the database.

This is a personal educational project and is not an official freeCodeCamp repository.

## Database Overview

The database models World Cup games through two related tables.

| Table | Row Count |
|---|---:|
| teams | 24 |
| games | 32 |

### Tables

**teams**

Stores each unique team participating in the recorded games.

| Column | Data Type | Constraints |
|---|---|---|
| team_id | SERIAL | PRIMARY KEY, NOT NULL |
| name | VARCHAR | UNIQUE, NOT NULL |

**games**

Stores the results of World Cup games.

| Column | Data Type | Constraints |
|---|---|---|
| game_id | SERIAL | PRIMARY KEY, NOT NULL |
| year | INT | NOT NULL |
| round | VARCHAR | NOT NULL |
| winner_id | INT | FOREIGN KEY, NOT NULL |
| opponent_id | INT | FOREIGN KEY, NOT NULL |
| winner_goals | INT | NOT NULL |
| opponent_goals | INT | NOT NULL |

### Relationships

- `games.winner_id` references `teams.team_id`.
- `games.opponent_id` references `teams.team_id`.

Both relationships ensure that the winner and opponent of each recorded game correspond to existing teams.

### Repository Contents

- `worldcup.sql` — SQL dump containing the database schema and data.
- `insert_data.sh` — Bash script that imports the teams and game results.
- `queries.sh` — Bash script containing the required database queries.
- `README.md` — Project documentation and database setup instructions.

## Requirements

- PostgreSQL compatible with the SQL dump.
- The PostgreSQL command-line client (`psql`).
- The PostgreSQL database dump utility (`pg_dump`).
- Bash for running the shell scripts.
- A PostgreSQL role with the necessary database creation and restoration privileges.

The commands below use the `freecodecamp` and `postgres` roles provided by the freeCodeCamp development environment.

## Restore the Database

Run the following command from a Bash terminal in the directory containing `worldcup.sql`, not from inside the `psql` interactive terminal:

```bash
psql -U postgres < worldcup.sql
```

The dump is generated with database-cleanup and database-creation options. Restoring it can drop and recreate an existing database named `worldcup`, so back up any existing database you need to preserve.

## Verify the Restored Database

List the tables:

```bash
psql -U freecodecamp -d worldcup -c '\dt'
```

Inspect the table structures:

```bash
psql -U freecodecamp -d worldcup -c '\d teams'
psql -U freecodecamp -d worldcup -c '\d games'
```

Check the row counts:

```bash
psql -U freecodecamp -d worldcup -c "SELECT 'teams' AS table_name, COUNT(*) FROM teams UNION ALL SELECT 'games', COUNT(*) FROM games;"
```

Expected row counts:

| Table | Expected Rows |
|---|---:|
| teams | 24 |
| games | 32 |

## Run the Shell Scripts

Ensure both scripts have executable permissions:

```bash
chmod +x insert_data.sh queries.sh
```

In the original project environment, run the data-import script when the database is initialized and ready for importing:

```bash
./insert_data.sh
```

Run the query script to display the project's query results:

```bash
./queries.sh
```

The project queries should produce output matching the provided `expected_output.txt` file.

Do not re-import data into an already-populated database unless you intend to repeat the import and have accounted for the script's behavior.

## Regenerate the SQL Dump

After making changes to the database, regenerate the dump from a Bash terminal that can connect to the PostgreSQL instance:

```bash
pg_dump -cC --inserts -U freecodecamp worldcup > worldcup.sql
```

The dump will be written to the current working directory. If `worldcup.sql` already exists there, the command replaces it.

The `-cC` options include database cleanup and creation commands, while `--inserts` records the data as SQL insert statements.

## Learning Objectives

This project demonstrates relational database design, primary and foreign keys, referential integrity, data import using Bash, PostgreSQL database export and restoration, and SQL queries for analyzing World Cup results.
