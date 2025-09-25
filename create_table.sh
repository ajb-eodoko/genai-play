#!/bin/bash
# Script to create 'users' table in PostgreSQL database

DB_NAME="$1"
DB_USER="$2"
DB_PASSWORD="$3"
DB_HOST="${4:-localhost}"
DB_PORT="${5:-5432}"

export PGPASSWORD="$DB_PASSWORD"

# Drop tables if they exist
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "DROP TABLE IF EXISTS portfolio;"
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "DROP TABLE IF EXISTS users;"

psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "\
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10)
);"

# Insert users
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "\
INSERT INTO users (name, age, gender) VALUES
    ('Alice', 30, 'Female'),
    ('Bob', 25, 'Male');"

# Fetch user IDs
alice_id=$(psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -t -c "SELECT id FROM users WHERE name='Alice';" | xargs)
bob_id=$(psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -t -c "SELECT id FROM users WHERE name='Bob';" | xargs)

psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "\
CREATE TABLE IF NOT EXISTS portfolio (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    total_money NUMERIC,
    invested NUMERIC,
    isa_life_time NUMERIC,
    pension NUMERIC,
    cash_isa NUMERIC,
    stocks NUMERIC,
    GIA NUMERIC,
    balance NUMERIC
);"

# Insert portfolio records using fetched user IDs
if [ -n "$alice_id" ]; then
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "\
INSERT INTO portfolio (user_id, total_money, invested, isa_life_time, pension, cash_isa, stocks, GIA, balance) VALUES
    ($alice_id, 10000, 5000, 2000, 1500, 1000, 500, 0, 5000)
;"
fi
if [ -n "$bob_id" ]; then
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "\
INSERT INTO portfolio (user_id, total_money, invested, isa_life_time, pension, cash_isa, stocks, GIA, balance) VALUES
    ($bob_id, 15000, 7000, 0, 2000, 2000, 500, 2500, 8000)
;"
fi