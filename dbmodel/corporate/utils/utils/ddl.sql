/*
This file is part of Giswater 3
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

CREATE SCHEMA utils;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- TABLES
-- ----------------------------

CREATE TABLE address
(
  id character varying(16) NOT NULL,
  muni_id integer ,
  postcode character varying(16),
  streetaxis_id character varying(16),
  postnumber character varying(16),
  plot_id character varying(16),
  the_geom geometry(Point,SRID_VALUE),
  ud_expl_id integer,
  ws_expl_id integer,
  CONSTRAINT address_pkey PRIMARY KEY (id))
;


CREATE TABLE streetaxis
(
  id character varying(16) NOT NULL,
  code character varying(16),
  type character varying(18),
  name character varying(100),
  text text,
  the_geom geometry(MultiLineString,SRID_VALUE),
  ud_expl_id integer,
  ws_expl_id integer,
  muni_id integer,
  CONSTRAINT streetaxis_pkey PRIMARY KEY (id))
;



CREATE TABLE municipality
(
  muni_id integer NOT NULL,
  name text,
  observ text,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  CONSTRAINT municipality_pkey PRIMARY KEY (muni_id)
);



CREATE TABLE plot
(
  id character varying(16) NOT NULL,
  plot_code character varying(30),
  muni_id integer ,
  postcode integer,
  streetaxis_id character varying(16) ,
  postnumber character varying(16),
  complement character varying(16),
  placement character varying(16),
  square character varying(16),
  observ text,
  text text,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  ws_expl_id integer,
  ud_expl_id integer,
  CONSTRAINT plot_pkey PRIMARY KEY (id)
);




CREATE TABLE type_street
(
  id character varying(20) NOT NULL,
  observ character varying(50),
  CONSTRAINT type_street_pkey PRIMARY KEY (id)
);



CREATE TABLE config_param_system
(
  id serial NOT NULL,
  parameter character varying(50) NOT NULL,
  value text,
  data_type character varying(20),
  context character varying(50),
  descript text,
  CONSTRAINT config_param_system_pkey PRIMARY KEY (id)
);