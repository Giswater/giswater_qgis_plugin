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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut_arc", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut_node", "column":"minsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut_valve", "column":"flag", "dataType":"boolean"}}$$);

CREATE TABLE archived_rpt_arc(
    id serial NOT NULL PRIMARY KEY,
    result_id character varying(30) COLLATE pg_catalog."default" NOT NULL,
    arc_id character varying(16) COLLATE pg_catalog."default",
    node_1 character varying(16) COLLATE pg_catalog."default",
    node_2 character varying(16) COLLATE pg_catalog."default",
    arc_type character varying(30) COLLATE pg_catalog."default",
    arccat_id character varying(30) COLLATE pg_catalog."default",
    epa_type character varying(16) COLLATE pg_catalog."default",
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254) COLLATE pg_catalog."default",
    diameter numeric(12,3),
    roughness numeric(12,6),
    length numeric(12,3),
    status character varying(18) COLLATE pg_catalog."default",
    the_geom geometry(LineString,25831),
    expl_id integer,
    flw_code text COLLATE pg_catalog."default",
    minorloss numeric(12,6),
    addparam text COLLATE pg_catalog."default",
    arcparent character varying(16) COLLATE pg_catalog."default",
    dma_id integer,
    presszone_id text COLLATE pg_catalog."default",
    dqa_id integer,
    minsector_id integer,
    age integer,
    rpt_length numeric,
    rpt_diameter numeric,   
    flow numeric,
    vel numeric,
    headloss numeric,
    setting numeric,
    reaction numeric,
    ffactor numeric,
    other character varying(100) COLLATE pg_catalog."default",
    "time" character varying(100) COLLATE pg_catalog."default",
    rpt_status character varying(16)
);

CREATE TABLE archived_rpt_node(
    id serial NOT NULL PRIMARY KEY,
    result_id character varying(30) COLLATE pg_catalog."default" NOT NULL,
    node_id character varying(16) COLLATE pg_catalog."default",
    elevation numeric(12,3),
    elev numeric(12,3),
    node_type character varying(30) COLLATE pg_catalog."default",
    nodecat_id character varying(30) COLLATE pg_catalog."default",
    epa_type character varying(16) COLLATE pg_catalog."default",
    sector_id integer,
    state smallint,
    state_type smallint,
    annotation character varying(254) COLLATE pg_catalog."default",
    demand double precision,
    the_geom geometry(Point,25831),
    expl_id integer,
    pattern_id character varying(16) COLLATE pg_catalog."default",
    addparam text COLLATE pg_catalog."default",
    nodeparent character varying(16) COLLATE pg_catalog."default",
    arcposition smallint,
    dma_id integer,
    presszone_id text COLLATE pg_catalog."default",
    dqa_id integer,
    minsector_id integer,
    age integer,
    rpt_elevation numeric,
    rpt_demand numeric,
    head numeric,
    press numeric,
    other character varying(100) COLLATE pg_catalog."default",
    "time" character varying(100) COLLATE pg_catalog."default",
    quality numeric(12,4)
);

CREATE TABLE archived_rpt_energy_usage(
    id serial NOT NULL PRIMARY KEY,
    result_id character varying(30) COLLATE pg_catalog."default" NOT NULL,
    nodarc_id character varying(16) COLLATE pg_catalog."default",
    usage_fact numeric,
    avg_effic numeric,
    kwhr_mgal numeric,
    avg_kw numeric,
    peak_kw numeric,
    cost_day numeric
);

CREATE TABLE IF NOT EXISTS archived_rpt_hydraulic_status (
    id serial NOT NULL PRIMARY KEY,
    result_id character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "time" character varying(20) COLLATE pg_catalog."default",
    text text COLLATE pg_catalog."default"
);

CREATE TABLE IF NOT EXISTS archived_rpt_inp_pattern_value(
    id serial NOT NULL PRIMARY KEY,
    result_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    dma_id integer,
    pattern_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    idrow integer,
    factor_1 numeric(12,4),
    factor_2 numeric(12,4),
    factor_3 numeric(12,4),
    factor_4 numeric(12,4),
    factor_5 numeric(12,4),
    factor_6 numeric(12,4),
    factor_7 numeric(12,4),
    factor_8 numeric(12,4),
    factor_9 numeric(12,4),
    factor_10 numeric(12,4),
    factor_11 numeric(12,4),
    factor_12 numeric(12,4),
    factor_13 numeric(12,4),
    factor_14 numeric(12,4),
    factor_15 numeric(12,4),
    factor_16 numeric(12,4),
    factor_17 numeric(12,4),
    factor_18 numeric(12,4),
    user_name text
);

 
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer", "column":"is_waterbal", "dataType":"boolean"}}$$);

ALTER TABLE ext_rtc_hydrometer ALTER COLUMN is_waterbal SET DEFAULT True;
