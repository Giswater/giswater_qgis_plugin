/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- MINCUT RESULT CATALOG
-- ----------------------------

--SEQUENCES

CREATE SEQUENCE "anl_mincut_result_cat_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--TABLES

CREATE TABLE "anl_mincut_result_cat_type" (
id varchar(30) NOT NULL,
descript text,
CONSTRAINT mincut_result_cat_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_cat_state" (
id varchar(30) NOT NULL,
descript text,
CONSTRAINT mincut_result_cat_state_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_cat" (
id varchar (30) DEFAULT nextval('"SCHEMA_NAME".anl_mincut_result_cat_seq'::regclass) NOT NULL,
mincut_result_type varchar(30),
mincut_result_state varchar (30),
anl_tstamp timestamp default now(),
anl_user varchar(30),
anl_descript text,
exec_forecast_date date,
exec_start timestamp,
exec_end timestamp,
exec_user varchar(30),
exec_descript text, 
CONSTRAINT mincut_result_cat_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_polygon" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
polygon_id varchar (16),
the_geom public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT anl_mincut_result_polygon_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_node" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
node_id varchar (16),
CONSTRAINT anl_mincut_result_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_arc" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
arc_id varchar (16),
CONSTRAINT anl_mincut_result_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_valve" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
valve_id character varying(16),
CONSTRAINT anl_mincut_result_valve_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_connec" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
connec_id character varying(16) NOT NULL,
CONSTRAINT anl_mincut_result_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_hydrometer" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
hydrometer_id character varying(16) NOT NULL,
CONSTRAINT anl_mincut_result_hydrometer_pkey PRIMARY KEY (id)
);



CREATE TABLE "anl_mincut_result_selector" (
id varchar (30),
CONSTRAINT mincut_result_selector_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_selector_compare" (
id varchar (30),
CONSTRAINT mincut_result_selector_compare_pkey PRIMARY KEY (id)
);


-- FK

ALTER TABLE "anl_mincut_result_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_valve" ADD FOREIGN KEY ("valve_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_hydrometer" ADD FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "anl_mincut_result_polgyon" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_node" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_arc" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_connec" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_valve" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_hydrometer" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "anl_mincut_result_selector" ADD FOREIGN KEY ("id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_selector_compare" ADD FOREIGN KEY ("id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


-- VIEWS

DROP VIEW IF EXISTS "v_anl_mincut_result_arc" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.mincut_result_cat_id,
anl_mincut_result_arc.arc_id,  
arc.the_geom 
FROM ((arc 
JOIN anl_mincut_result_arc ON (((anl_mincut_result_arc.arc_id)::text = (arc.arc_id)::text))) 
JOIN anl_mincut_result_selector ON (((anl_mincut_result_selector.id)::text = (anl_mincut_result_arc.mincut_result_cat_id)::text)));


DROP VIEW IF EXISTS "v_anl_mincut_result_node" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.mincut_result_cat_id,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM ((node 
JOIN anl_mincut_result_node ON (((anl_mincut_result_node.node_id)::text = (node.node_id)::text))) 
JOIN anl_mincut_result_selector ON (((anl_mincut_result_selector.id)::text = (anl_mincut_result_node.mincut_result_cat_id)::text)));


DROP VIEW IF EXISTS "v_anl_mincut_result_valve" CASCADE; 
CREATE VIEW "v_anl_mincut_result_valve" AS
SELECT 
anl_mincut_result_valve.id,
anl_mincut_result_valve.mincut_result_cat_id,
anl_mincut_result_valve.valve_id,  
node.the_geom 
FROM ((node 
JOIN anl_mincut_result_valve ON (((anl_mincut_result_valve.valve_id)::text = (node.node_id)::text))) 
JOIN anl_mincut_result_selector ON (((anl_mincut_result_selector.id)::text = (anl_mincut_result_valve.mincut_result_cat_id)::text)));



DROP VIEW IF EXISTS "v_anl_mincut_result_connec";
CREATE OR REPLACE VIEW "v_anl_mincut_result_restult_connec" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.mincut_result_cat_id,
anl_mincut_result_connec.connec_id,  
connec.the_geom 
FROM ((connec 
JOIN anl_mincut_result_connec ON (((anl_mincut_result_connec.connec_id)::text = (connec.connec_id)::text))) 
JOIN anl_mincut_result_selector ON (((anl_mincut_result_selector.id)::text = (anl_mincut_result_connec.mincut_result_cat_id)::text)));


DROP VIEW IF EXISTS "v_anl_mincut_result_polygon";
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.mincut_result_cat_id,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM (anl_mincut_result_polygon
JOIN anl_mincut_result_selector ON (((anl_mincut_result_selector.id)::text = (anl_mincut_result_polygon.mincut_result_cat_id)::text)));



DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer";
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.mincut_result_cat_id,
anl_mincut_result_hydrometer.hydrometer_id
FROM anl_mincut_result_hydrometer
JOIN anl_mincut_result_selector ON (((anl_mincut_result_selector.id)::text = (anl_mincut_result_hydrometer.mincut_result_cat_id)::text));;




DROP VIEW IF EXISTS "v_anl_mincut_result_arc_compare" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc_compare" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.mincut_result_cat_id,
anl_mincut_result_arc.arc_id,  
arc.the_geom 
FROM ((arc 
JOIN anl_mincut_result_arc ON (((anl_mincut_result_arc.arc_id)::text = (arc.arc_id)::text))) 
JOIN anl_mincut_result_selector_compare ON (((anl_mincut_result_selector_compare.id)::text = (anl_mincut_result_arc.mincut_result_cat_id)::text)));


DROP VIEW IF EXISTS "v_anl_mincut_result_node_compare" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node_compare" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.mincut_result_cat_id,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM ((node 
JOIN anl_mincut_result_node ON (((anl_mincut_result_node.node_id)::text = (node.node_id)::text))) 
JOIN anl_mincut_result_selector_compare ON (((anl_mincut_result_selector_compare.id)::text = (anl_mincut_result_node.mincut_result_cat_id)::text)));


DROP VIEW IF EXISTS "v_anl_mincut_result_valve_compare" CASCADE; 
CREATE VIEW "v_anl_mincut_result_valve_compare" AS
SELECT 
anl_mincut_result_valve.id,
anl_mincut_result_valve.mincut_result_cat_id,
anl_mincut_result_valve.valve_id,  
node.the_geom 
FROM ((node 
JOIN anl_mincut_result_valve ON (((anl_mincut_result_valve.valve_id)::text = (node.node_id)::text))) 
JOIN anl_mincut_result_selector_compare ON (((anl_mincut_result_selector_compare.id)::text = (anl_mincut_result_valve.mincut_result_cat_id)::text)));



DROP VIEW IF EXISTS "v_anl_mincut_result_connec_compare";
CREATE OR REPLACE VIEW "v_anl_mincut_result_restult_connec_compare" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.mincut_result_cat_id,
anl_mincut_result_connec.connec_id,  
connec.the_geom 
FROM ((connec 
JOIN anl_mincut_result_connec ON (((anl_mincut_result_connec.connec_id)::text = (connec.connec_id)::text))) 
JOIN anl_mincut_result_selector_compare ON (((anl_mincut_result_selector_compare.id)::text = (anl_mincut_result_connec.mincut_result_cat_id)::text)));


DROP VIEW IF EXISTS "v_anl_mincut_result_polygon_compare";
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon_compare" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.mincut_result_cat_id,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM ((anl_mincut_result_polygon
JOIN anl_mincut_result_selector_compare ON (((anl_mincut_result_selector_compare.id)::text = (anl_mincut_result_polygon.mincut_result_cat_id)::text))));



DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer_compare";
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer_compare" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.mincut_result_cat_id,
anl_mincut_result_hydrometer.hydrometer_id
FROM anl_mincut_result_hydrometer
JOIN anl_mincut_result_selector_compare ON (((anl_mincut_result_selector_compare.id)::text = (anl_mincut_result_hydrometer.mincut_result_cat_id)::text));;

-- FUNCTIONS

