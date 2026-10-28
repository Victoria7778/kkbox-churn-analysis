-- Крок 1: завантаження сирих CSV у DuckDB

DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS train;

CREATE TABLE members AS
SELECT * FROM read_csv_auto('members_v3.csv');

CREATE TABLE transactions AS
SELECT * FROM read_csv_auto('transactions.csv');

CREATE TABLE train AS
SELECT * FROM read_csv_auto('train.csv');
