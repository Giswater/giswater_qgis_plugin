/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;


CREATE TABLE plan_netscenario (
netscenario_id serial NOT NULL PRIMARY KEY,
name character varying(30) COLLATE pg_catalog."default",
descript text COLLATE pg_catalog."default",
parent_id integer,
netscenario_type text COLLATE pg_catalog."default",
active boolean DEFAULT true,
expl_id integer,
log text COLLATE pg_catalog."default",
CONSTRAINT plan_netscenario_name_unique UNIQUE (name),
CONSTRAINT plan_netscenario_expl_id_fkey FOREIGN KEY (expl_id)
    REFERENCES exploitation (expl_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    CONSTRAINT plan_netscenario_parent_id_fkey FOREIGN KEY (parent_id)
    REFERENCES plan_netscenario (netscenario_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT);

CREATE TABLE plan_netscenario_presszone(
netscenario_id integer, 
presszone_id character varying(30), 
presszone_name character varying(30),
head numeric(12,2), 
graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json, 
the_geom geometry(MultiPolygon, SRID_VALUE),
CONSTRAINT plan_netscenario_presszone_pkey PRIMARY KEY (netscenario_id, presszone_id)); 

CREATE TABLE plan_netscenario_dma (
netscenario_id integer, 
dma_id integer, 
dma_name character varying(30),
pattern_id character varying(16), 
graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json, 
the_geom geometry(MultiPolygon, SRID_VALUE),
CONSTRAINT plan_netscenario_dma_pkey PRIMARY KEY (netscenario_id, dma_id)); 

CREATE TABLE plan_netscenario_arc (
netscenario_id integer, 
arc_id character varying(16),
presszone_id character varying(30), 
dma_id integer, 
the_geom geometry(LineString, SRID_VALUE),
CONSTRAINT plan_netscenario_arc_pkey PRIMARY KEY (netscenario_id, arc_id)); 

CREATE TABLE plan_netscenario_node (
netscenario_id integer, 
node_id character varying(16),
presszone_id character varying(30), 
staticpressure numeric(12,3), 
dma_id integer, 
pattern_id character varying(16),  
the_geom geometry(Point, SRID_VALUE),
CONSTRAINT plan_netscenario_node_pkey PRIMARY KEY (netscenario_id, node_id)); 

CREATE TABLE plan_netscenario_connec (
netscenario_id integer, 
connec_id character varying(16),
presszone_id character varying(30), 
staticpressure numeric(12,3), 
dma_id integer, 
pattern_id character varying(16),  
the_geom geometry(Point, SRID_VALUE),
CONSTRAINT plan_netscenario_connec_pkey PRIMARY KEY (netscenario_id, connec_id)); 


CREATE TABLE IF NOT EXISTS selector_netscenario(
    netscenario_id integer NOT NULL,
    cur_user text COLLATE pg_catalog."default" NOT NULL DEFAULT "current_user"(),
    CONSTRAINT selector_netscenario_pkey PRIMARY KEY (netscenario_id, cur_user),
    CONSTRAINT selector_netscenario_netscenario_id_fkey FOREIGN KEY (netscenario_id)
        REFERENCES plan_netscenario (netscenario_id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE);

-- 2023/8/17
ALTER TABLE ext_rtc_scada_x_data DROP CONSTRAINT ext_rtc_scada_x_data_pkey;
ALTER TABLE ext_rtc_scada_x_data RENAME TO _ext_rtc_scada_x_data36_;

CREATE TABLE IF NOT EXISTS ext_rtc_scada_x_data(
  scada_id text NOT NULL,
  node_id character varying(16) NOT NULL,
  value_date timestamp without time zone NOT NULL,
  value double precision,
  value_status integer,
  annotation text,
  CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY (scada_id, value_date),
  CONSTRAINT ext_rtc_scada_x_data_node_id_fkey FOREIGN KEY (node_id)
  REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_scada", "column":"tagname", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_scada", "column":"units", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"staticpressure", "dataType":"numeric(12,3)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"date_value", "dataType":"timestamp"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"text_value", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector_graph", "column":"expl_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector_graph", "column":"sector_id", "dataType":"integer"}}$$);

CREATE TABLE IF NOT EXISTS minsector_graph_inlet(
  minsector_id integer NOT NULL,
  expl_id integer NOT NULL,
  parameters json,
  active boolean DEFAULT true,
  CONSTRAINT minsector_graph_inlet_pkey PRIMARY KEY (minsector_id),
  CONSTRAINT cminsector_graph_inlet_expl_id_fkey FOREIGN KEY (expl_id)
      REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT minsector_graph_inlet_minsector_id_fkey FOREIGN KEY (minsector_id)
      REFERENCES minsector (minsector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE minsector_graph_checkvalve(
  node_id character varying(16) NOT NULL,
  expl_id integer NOT NULL,
  to_minsector character varying(16) NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT minsector_graph_checkvalve_node_id_fkey PRIMARY KEY (node_id)); 
  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut", "column":"minsector_id", "dataType":"integer"}}$$);
