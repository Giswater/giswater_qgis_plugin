/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 10 (class 2615 OID 151924)
-- Name: SCHEMA_NAME; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "SCHEMA_NAME";
SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE EXTENSION IF NOT EXISTS tablefunc;


-- Catalog of table
DROP TABLE IF EXISTS SCHEMA_NAME.db_cat_table CASCADE; 
CREATE TABLE SCHEMA_NAME.db_cat_table (
    id int4 PRIMARY KEY,
    name text NOT NULL,
    project_type text,
    context text,
    db_cat_clientlayer_id int4,
    description text
);


-- Catalog of views
DROP TABLE IF EXISTS SCHEMA_NAME.db_cat_view CASCADE; 
CREATE TABLE SCHEMA_NAME.db_cat_view (
    id int4 PRIMARY KEY,
    name text NOT NULL,
    project_type text,
    context text,
    db_cat_clientlayer_id int4,
    description text
);


-- Catalog of columns
DROP TABLE IF EXISTS SCHEMA_NAME.db_cat_columns CASCADE; 
CREATE TABLE SCHEMA_NAME.db_cat_columns (
    id int4 PRIMARY KEY,
    db_cat_table_id int4 NOT NULL,
    column_name text NOT NULL,
    column_type text,
    description text
);


-- Catalog of client layer
DROP TABLE IF EXISTS SCHEMA_NAME.db_cat_clientlayer CASCADE; 
CREATE TABLE SCHEMA_NAME.db_cat_clientlayer (
    id int4 PRIMARY KEY,
    name text NOT NULL,
    group_level_1 text,
    group_level_2 text,
    group_level_3 text,
    description text
);

