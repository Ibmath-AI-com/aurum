-- Run once on first container boot
-- Creates the aurumdb database and required extensions

CREATE DATABASE aurumdb;

\connect aurumdb

CREATE EXTENSION IF NOT EXISTS timescaledb;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
