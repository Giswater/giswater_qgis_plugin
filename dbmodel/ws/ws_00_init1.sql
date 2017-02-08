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


-- Catalog of tables &views
DROP TABLE IF EXISTS db_cat_table CASCADE; 
CREATE TABLE db_cat_table (
    id text NOT NULL PRIMARY KEY,
    context text,
    description text
);



-- Catalog of columns
DROP TABLE IF EXISTS db_cat_table_x_column CASCADE; 
CREATE TABLE db_cat_table_x_column (
    id text NOT NULL PRIMARY KEY,
    table_id text,
    column_id text,
    column_type text,
    description text
);


-- Catalog of client layer
DROP TABLE IF EXISTS db_cat_clientlayer CASCADE; 
CREATE TABLE db_cat_clientlayer (
    qgis_layer_id text NOT NULL PRIMARY KEY,
    db_cat_table_id text NOT NULL,
    layer_alias text,
    client_id text,
    description text,
    pre_dependences text,
    post_dependences text,
    db_cat_client_layer_agrupation_id character varying(50),
    styleqml_use_asdefault boolean,
    styleqml_file text,
    geometry_field text,
    project_criticity smallint,
    automatic_reload_layer boolean
);

DROP TABLE IF EXISTS db_cat_client_agrupation CASCADE; 
CREATE TABLE db_cat_client_agrupation(
  id varchar(50) NOT NULL,
  description text,
  workflow text,
  pre_dependences text,
  post_dependences text,
  db_cat_client_layer_agrupation_id varchar(50),
  CONSTRAINT db_cat_client_agrupation_pkey PRIMARY KEY (id));

