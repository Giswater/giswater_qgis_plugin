/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


-- ----------------------------
-- TABLES
-- ----------------------------

CREATE TABLE utils.address
(
  id character varying(16) NOT NULL,
  muni_id integer ,
  postcode character varying(16),
  streetaxis_id character varying(16),
  postnumber character varying(16),
  plot_id character varying(16),
  the_geom geometry(Point,25831),
  ud_expl_id integer,
  ws_expl_id integer,
  CONSTRAINT address_pkey PRIMARY KEY (id))
;

GRANT SELECT ON TABLE utils.address TO role_basic;
GRANT ALL ON TABLE utils.address TO role_edit;
GRANT SELECT ON TABLE utils.address TO role_om;
GRANT SELECT ON TABLE utils.address TO role_epa;
GRANT SELECT ON TABLE utils.address TO role_master;
GRANT SELECT ON TABLE utils.address TO role_admin;
GRANT ALL ON TABLE utils.address TO postgres;



CREATE TABLE utils.streetaxis
(
  id character varying(16) NOT NULL,
  code character varying(16),
  type character varying(18),
  name character varying(100),
  text text,
  the_geom geometry(MultiLineString,25831),
  ud_expl_id integer,
  ws_expl_id integer,
  muni_id integer,
  CONSTRAINT streetaxis_pkey PRIMARY KEY (id))
;

GRANT SELECT ON TABLE utils.streetaxis TO role_basic;
GRANT ALL ON TABLE utils.streetaxis TO role_edit;
GRANT SELECT ON TABLE utils.streetaxis TO role_om;
GRANT SELECT ON TABLE utils.streetaxis TO role_epa;
GRANT SELECT ON TABLE utils.streetaxis TO role_master;
GRANT SELECT ON TABLE utils.streetaxis TO role_admin;
GRANT ALL ON TABLE utils.streetaxis TO postgres;




CREATE TABLE utils.municipality
(
  muni_id integer NOT NULL,
  name text,
  observ text,
  the_geom geometry(MultiPolygon,25831),
  CONSTRAINT municipality_pkey PRIMARY KEY (muni_id)
);


GRANT ALL ON TABLE utils.municipality TO postgres;
GRANT SELECT ON TABLE utils.municipality TO role_basic;
GRANT ALL ON TABLE utils.municipality TO role_edit;
GRANT SELECT ON TABLE utils.municipality TO role_om;
GRANT SELECT ON TABLE utils.municipality TO role_epa;
GRANT SELECT ON TABLE utils.municipality TO role_master;
GRANT SELECT ON TABLE utils.municipality TO role_admin;



CREATE TABLE utils.plot
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
  the_geom geometry(MultiPolygon,25831),
  ws_expl_id integer,
  ud_expl_id integer,
  CONSTRAINT plot_pkey PRIMARY KEY (id)
);

GRANT SELECT ON TABLE utils.plot TO role_basic;
GRANT ALL ON TABLE utils.plot TO role_edit;
GRANT SELECT ON TABLE utils.plot TO role_om;
GRANT SELECT ON TABLE utils.plot TO role_epa;
GRANT SELECT ON TABLE utils.plot TO role_master;
GRANT SELECT ON TABLE utils.plot TO role_admin;
GRANT ALL ON TABLE utils.plot TO postgres;





CREATE TABLE utils.type_street
(
  id character varying(20) NOT NULL,
  observ character varying(50),
  CONSTRAINT type_street_pkey PRIMARY KEY (id)
);

GRANT ALL ON TABLE utils.type_street TO postgres;
GRANT SELECT ON TABLE utils.type_street TO role_basic;
GRANT ALL ON TABLE utils.type_street TO role_edit;
GRANT SELECT ON TABLE utils.type_street TO role_om;
GRANT SELECT ON TABLE utils.type_street TO role_epa;
GRANT SELECT ON TABLE utils.type_street TO role_master;
GRANT SELECT ON TABLE utils.type_street TO role_admin;



CREATE TABLE utils.config_param_system
(
  id serial NOT NULL,
  parameter character varying(50) NOT NULL,
  value text,
  data_type character varying(20),
  context character varying(50),
  descript text,
  CONSTRAINT config_param_system_pkey PRIMARY KEY (id)
);