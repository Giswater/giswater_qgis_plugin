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
head numeric(12,2), 
graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json, 
the_geom geometry(MultiPolygon, SRID_VALUE),
CONSTRAINT plan_netscenario_presszone_pkey PRIMARY KEY (netscenario_id, presszone_id)); 

CREATE TABLE plan_netscenario_dma (
netscenario_id integer, 
dma_id integer, 
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
        ON UPDATE CASCADE
        ON DELETE CASCADE);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"staticpressure", "dataType":"numeric(12,3)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_scada_x_data", "column":"scada_id", "dataType":"text"}}$$);

UPDATE ext_rtc_scada_x_data SET scada_id = s.scada_id FROM ext_rtc_scada s WHERE s.node_id = ext_rtc_scada_x_data.node_id;
UPDATE  ext_rtc_scada_x_data SET scada_id = node_id WHERE scada_id is null;
ALTER TABLE ext_rtc_scada_x_data DROP CONSTRAINT ext_rtc_scada_x_data_pkey;
ALTER TABLE ext_rtc_scada_x_data ADD CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY(scada_id, value_date);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"date_value", "dataType":"timestamp"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"text_value", "dataType":"text"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector_graph", "column":"expl_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector_graph", "column":"sector_id", "dataType":"integer"}}$$);


CREATE TABLE config_graph_minsector(
  minsector_id integer NOT NULL,
  expl_id integer,
  parameters json,
  active boolean DEFAULT true,
  CONSTRAINT config_graph_minsector_pkey PRIMARY KEY (minsector_id),
  CONSTRAINT config_graph_minsector_expl_id_fkey FOREIGN KEY (expl_id)
      REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT config_graph_minsector_minsector_id_fkey FOREIGN KEY (minsector_id)
      REFERENCES minsector (minsector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE);