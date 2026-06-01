/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
    the_geom geometry(LineString,SRID_VALUE),
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
    the_geom geometry(Point,SRID_VALUE),
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

CREATE OR REPLACE VIEW vu_link AS 
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    presszone_id::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id);

CREATE OR REPLACE VIEW v_link AS 
 SELECT vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2,
    vu_link.epa_type,
    vu_link.is_operative,
    vu_link.staticpressure
   FROM vu_link
     JOIN v_state_link USING (link_id);


     CREATE OR REPLACE VIEW v_link_connec AS 
 SELECT vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2,
    vu_link.epa_type,
    vu_link.is_operative,
    vu_link.staticpressure
   FROM vu_link
     JOIN v_state_link_connec USING (link_id);


CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    l.gis_length,
    l.the_geom,
    l.sector_name,
    l.dma_name,
    l.dqa_name,
    l.presszone_name,
    l.macrosector_id,
    l.macrodma_id,
    l.macrodqa_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure
   FROM v_link l;



CREATE OR REPLACE VIEW v_connec AS 
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
    vu_connec.sector_name,
    vu_connec.macrosector_id,
    vu_connec.customer_code,
    vu_connec.cat_matcat_id,
    vu_connec.cat_pnom,
    vu_connec.cat_dnom,
    vu_connec.connec_length,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.n_hydrometer,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN a.minsector_id IS NULL THEN vu_connec.minsector_id
            ELSE a.minsector_id
        END AS minsector_id,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.dma_name IS NULL THEN vu_connec.dma_name
            ELSE a.dma_name
        END AS dma_name,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
        CASE
            WHEN a.presszone_id IS NULL THEN vu_connec.presszone_id
            ELSE a.presszone_id::character varying(30)
        END AS presszone_id,
        CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.presszone_name
            ELSE a.presszone_name
        END AS presszone_name,
	CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.staticpressure
            ELSE a.staticpressure::numeric(12,3)
        END AS staticpressure,
        CASE
            WHEN a.dqa_id IS NULL THEN vu_connec.dqa_id
            ELSE a.dqa_id
        END AS dqa_id,
        CASE
            WHEN a.dqa_name IS NULL THEN vu_connec.dqa_name
            ELSE a.dqa_name
        END AS dqa_name,
        CASE
            WHEN a.macrodqa_id IS NULL THEN vu_connec.macrodqa_id
            ELSE a.macrodqa_id
        END AS macrodqa_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.num_value,
    vu_connec.connectype_id,
        CASE
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.accessibility,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.dma_style,
    vu_connec.presszone_style,
    vu_connec.epa_type,
    vu_connec.priority,
    vu_connec.valve_location,
    vu_connec.valve_type,
    vu_connec.shutoff_valve,
    vu_connec.access_type,
    vu_connec.placement_type,
    vu_connec.press_max,
    vu_connec.press_min,
    vu_connec.press_avg,
    vu_connec.demand,
    vu_connec.om_state,
    vu_connec.conserv_state,
    vu_connec.crmzone_id,
    vu_connec.crmzone_name,
    vu_connec.expl_id2,
    vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id
   FROM vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (v_link_connec.feature_id) v_link_connec.link_id,
            v_link_connec.feature_type,
            v_link_connec.feature_id,
            v_link_connec.exit_type,
            v_link_connec.exit_id,
            v_link_connec.state,
            v_link_connec.expl_id,
            v_link_connec.sector_id,
            v_link_connec.dma_id,
            v_link_connec.presszone_id,
            v_link_connec.dqa_id,
            v_link_connec.minsector_id,
            v_link_connec.exit_topelev,
            v_link_connec.exit_elev,
            v_link_connec.fluid_type,
            v_link_connec.gis_length,
            v_link_connec.the_geom,
            v_link_connec.sector_name,
            v_link_connec.dma_name,
            v_link_connec.dqa_name,
            v_link_connec.presszone_name,
            v_link_connec.macrosector_id,
            v_link_connec.macrodma_id,
            v_link_connec.macrodqa_id,
            v_link_connec.expl_id2,
            v_link_connec.staticpressure
           FROM v_link_connec
          WHERE v_link_connec.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text;

 
CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone  AS
SELECT n.netscenario_id,
name AS netscenario_name, 
presszone_id, 
presszone_name as name,
head,
graphconfig,
the_geom
FROM selector_netscenario,
plan_netscenario_presszone n
JOIN plan_netscenario p USING (netscenario_id)
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma  AS
SELECT n.netscenario_id, 
name AS netscenario_name, 
dma_id, 
dma_name  as name,
pattern_id, 
graphconfig,
the_geom
FROM selector_netscenario,
plan_netscenario_dma n
JOIN plan_netscenario p USING (netscenario_id)
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_netscenario_arc  AS
SELECT n.netscenario_id, 
arc_id, 
presszone_id, 
dma_id,
the_geom
FROM selector_netscenario,
plan_netscenario_arc n
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_netscenario_node  AS
SELECT n.netscenario_id, 
node_id, 
presszone_id, 
staticpressure,
dma_id,
pattern_id,
the_geom
FROM selector_netscenario,
plan_netscenario_node n
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_netscenario_connec  AS
SELECT n.netscenario_id, 
connec_id, 
presszone_id, 
staticpressure,
dma_id,
pattern_id,
the_geom
FROM selector_netscenario,
plan_netscenario_connec n
WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE VIEW v_minsector_graph AS
SELECT m.* FROM minsector_graph m, selector_expl s 
WHERE cur_user = current_user AND s.expl_id = m.expl_id;

DROP VIEW v_edit_minsector;
CREATE OR REPLACE VIEW v_edit_minsector AS
 SELECT m.minsector_id,
    m.code,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.descript,
    m.addparam,
    m.the_geom
   FROM selector_expl,  minsector m
  WHERE m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector", "column":"sector_id"}}$$);


CREATE OR REPLACE VIEW v_ui_plan_netscenario AS
 SELECT DISTINCT ON (c.netscenario_id) c.netscenario_id,
    c.name,
    c.descript,
    c.netscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM plan_netscenario c,
    selector_expl s
  WHERE s.expl_id = c.expl_id AND s.cur_user = CURRENT_USER::text OR c.expl_id IS NULL;



  CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM node
     JOIN v_state_node USING (node_id)
     JOIN polygon ON polygon.feature_id::text = node.node_id::text;

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM connec
     JOIN v_state_connec USING (connec_id)
     JOIN polygon ON polygon.feature_id::text = connec.connec_id::text;


CREATE OR REPLACE VIEW v_edit_element
AS SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.elevation,
    element.expl_id2,
    element.trace_featuregeom
   FROM selector_expl,
    element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM v_edit_element e
     JOIN polygon USING (pol_id);



DROP VIEW IF EXISTS v_ui_sector;
CREATE OR REPLACE VIEW v_ui_sector AS
 SELECT s.sector_id,
    s.name,
    ms.name AS "macrosector",
    s.descript,
    s.undelete,
    s.sector_type,
    s.active,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.graphconfig,
    s.stylesheet
   FROM sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0
  ORDER BY s.sector_id;


DROP VIEW IF EXISTS v_ui_dma;
CREATE OR REPLACE VIEW v_ui_dma AS
 SELECT d.dma_id,
	d.name,
	d.descript,
	d.expl_id,
	md.name AS "macrodma",
	d.active,
	d.undelete,
	d.minc,
	d.maxc,
	d.effc,
	d.avg_press,
	d.pattern_id,
	d.link,
	d.graphconfig,
	d.stylesheet,
	d.tstamp,
	d.insert_user,
	d.lastupdate,
	d.lastupdate_user
   FROM dma d
     LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  WHERE d.dma_id > 0
  ORDER BY d.dma_id;


DROP VIEW IF EXISTS v_ui_presszone;
CREATE OR REPLACE VIEW v_ui_presszone AS
 SELECT p.presszone_id,
 	p.name,
 	p.descript,
 	p.expl_id,
 	p.link,
 	p.head,
 	p.active,
 	p.graphconfig,
 	p.stylesheet,
 	p.tstamp,
 	p.insert_user,
 	p.lastupdate,
 	p.lastupdate_user 
   FROM presszone p
  WHERE p.presszone_id NOT IN ('0', '-1')
  ORDER BY p.presszone_id;


DROP VIEW IF EXISTS v_ui_dqa;
CREATE OR REPLACE VIEW v_ui_dqa AS
 SELECT d.dqa_id,
	d."name",
	d.descript,
	d.expl_id,
	md.name as "macrodma",
	d.active,
	d.undelete,
	d.the_geom,
	d.pattern_id,
	d.dqa_type,
	d.link,
	d.graphconfig,
	d.stylesheet,
	d.tstamp,
	d.insert_user,
	d.lastupdate,
	d.lastupdate_user
   FROM dqa d
     LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  WHERE d.dqa_id > 0
  ORDER BY d.dqa_id;

UPDATE config_csv set descript = 'The csv file must have the following fields:
dscenario_name, feature_id, feature_type, value, demand_type, source', active = TRUE WHERE fid=501;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario' , 'Catalog of network scenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_dma' , 'Table of spatial objects representing planified District Meter Area.', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_presszone' , 'Table of spatial objects representing planified Pressure Zones', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_arc' , 'Table to manage arcs related to each netscenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_node' , 'Table to manage nodes related to each netscenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_connec' , 'Table to manage connecs related to each netscenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('selector_netscenario' , 'Selector of network scenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3256, 'gw_fct_graphanalytics_mapzones_plan', 'ws', 'function', 'json', 'json', 'Function to analyze network as a graph. Multiple analysis is avaliable  (PRESSZONE & DMA). Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [plan_netscenario_presszone, plan_netscenario_dma] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
- Create an empty netscenario with type DMA or PRESSZONE.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3256, 'Mapzone Netscenario Planification','{"featureType":[]}',
'[{"widgetname":"netscenario", "label":"Create mapzones for netscenario:","widgettype":"combo","datatype":"text","tooltip": "Create mapzone for a selected netscenario", "layoutname":"grl_option_parameters","layoutorder":1,"dvQueryText":"select netscenario_id as id, name as idval from plan_netscenario  order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}, 
{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""}, 
{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""}, 
{"widgetname":"dscenario_valve", "label":"Use valve status from dscenario:","widgettype":"combo","datatype":"text","tooltip": "Use closed and opened valves defined on inp_dscenario_shortpipe for selected dscenario", "layoutname":"grl_option_parameters","layoutorder":7,"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''SHORTPIPE'' order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""}, 
{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":9,
"comboIds":[0,1,2,3,4], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3258, 'gw_fct_set_netscenario_pattern', 'ws', 'function', 'json', 'json', 
'Function that allows to configure demand dscenario for connecs and nodes, using netscenarios mapzones, defined on table plan_netscenario_dma and using pattern_id assigned to each of the zones', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3258, 'Set pattern values on demand dscenario','{"featureType":[]}',
'[{"widgetname":"netscenario", "label":"Source netscenario:","widgettype":"combo","datatype":"text","tooltip": "Select mapzone dscenario from where data will be copied to demand dscenario", "layoutname":"grl_option_parameters","layoutorder":1,"dvQueryText":"select dscenario_id as id, name as idval from plan_netscenario where netscenario_type =''DMA'' order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"dscenario_demand", "label":"Target dscenario demand:","widgettype":"combo","datatype":"text","tooltip": "Select demand dscenario where data will be inserted", "layoutname":"grl_option_parameters","layoutorder":3,
"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''DEMAND'' order by name","isNullValue":"true", "selectedId":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_typevalue(typevalue, id, addparam)
VALUES ('sys_table_context', '{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', '{"orderBy":24}') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_edit_plan_netscenario_dma' , 'Editable view to visualize dma related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 1, 'Netscenario DMA', '{"pkey":"netscenario_id, dma_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_edit_plan_netscenario_presszone' , 'Editable view to visualize presszone related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 2, 'Netscenario Presszone', '{"pkey":"netscenario_id, presszone_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_arc' , 'View to visualize arcs related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 3, 'Netscenario arc', '{"pkey":"netscenario_id, arc_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_node' , 'View to visualize nodes related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 4, 'Netscenario node', '{"pkey":"netscenario_id, node_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_connec' , 'View to visualize connecs related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 5, 'Netscenario connec', '{"pkey":"netscenario_id, connec_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (502, 'Set dscenario demand using netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO plan_typevalue
VALUES ('netscenario_type', 'DMA', 'DMA',NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO plan_typevalue
VALUES ('netscenario_type', 'PRESSZONE', 'PRESSZONE',NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3260, 'gw_fct_create_netscenario_empty', 'ws', 'function', 'json', 'json', 
'Function that allows to create new empty netscenario', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3260, 'Create empty Netscenario','{"featureType":[]}',
'[{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for netscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT id, idval FROM plan_typevalue WHERE typevalue = ''netscenario_type''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3262, 'gw_fct_create_netscenario_from_toc', 'ws', 'function', 'json', 'json', 
'Function that allows to create new configuration of netscenario and copy mapzones configuration for selected exploitation', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3262, 'Create Netscenario from ToC','{"featureType":[]}',
'[{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for netscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT id, idval FROM plan_typevalue WHERE typevalue = ''netscenario_type''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3264, 'gw_fct_duplicate_netscenario', 'ws', 'function', 'json', 'json', 
'Function that allows to create new configuration of netscenario and copy mapzones configuration from already created netscenario', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3264, 'Duplicate Netscenario','{"featureType":[]}',
'[{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT netscenario_id as id, name as idval FROM plan_netscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":0, "selectedId":""},
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for netscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"parent", "label":"Parent:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Parent for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (508, 'Create new Netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (510, 'Duplicate Netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (512, 'Create Netscenario from ToC', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (504, 'Import flowmeter daily values', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (506, 'Import flowmeter agg values', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3272, 'gw_fct_import_scada_flowmeteragg_values', 'ws', 'function', 'json', 'json', 
'Function to import flowmeter aggregated values with random interval in order to transform to daily values', 'role_om', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_csv VALUES (504, 'Import flowmeter daily values', 'Import daily flowmeter values into table ext_rtc_scada_x_data according example file scada_flowmeter_daily_values.csv', 'gw_fct_import_scada_values', true, 21)
 ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv VALUES (506, 'Import flowmeter agg values', 'Import aggregated flowmeter values into table ext_rtc_scada_x_data according example file scada_flowmeter_agg_values.csv', 'gw_fct_import_scada_flowmeteragg_values', true, 22)
 ON CONFLICT (fid) DO NOTHING;

UPDATE sys_function SET function_name = 'gw_fct_import_scada_values' WHERE id = 3166;
UPDATE sys_fprocess SET fprocess_name = 'Import scada values' WHERE fid = 469;
UPDATE config_csv SET alias = 'Import scada values', descript = 'Import scada values into table ext_rtc_scada_x_data according example file scada_values.csv', 
functionname = 'gw_fct_import_scada_values' WHERE fid = 469;

INSERT INTO ext_rtc_scada_x_data (scada_id, node_id, value_date, value, value_status)
SELECT node_id, node_id, value_date, value, value_status FROM _ext_rtc_scada_x_data36_;

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue', 'tab_netscenario', 'tab_netscenario', 'tabNetscenario', NULL) ON CONFLICT (typevalue, id) DO NOTHING;
	
INSERT INTO config_form_tabs(formname, tabname, label, tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES ('selector_netscenario', 'tab_netscenario', 'Netscenario', 'Netscenario Selector', 'role_basic', null, null, 1,'{4,5}') ON CONFLICT (formname, tabname) DO NOTHING;

INSERT INTO config_param_system(
parameter, value, descript, label, 
dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type,  datatype)
VALUES ('basic_selector_tab_netscenario', '{"table":"plan_netscenario","table_id":"netscenario_id","selector":"selector_netscenario","selector_id":"netscenario_id","label":"netscenario_id, ''-'', name ","query_filter":" ","manageAll":true}', 'Variable to configura all options related to search for the specificic tab','Selector variables', 
null, null, true, null, 'ws', 'json') ON CONFLICT (parameter) DO NOTHING;

UPDATE config_toolbox SET inputparams = b.inp FROM (SELECT json_agg(a.inputs) AS inp FROM
(SELECT json_array_elements(inputparams)as inputs, json_extract_path_text(json_array_elements(inputparams),'widgetname') as widget
FROM   config_toolbox 
WHERE id=2706)a WHERE widget!='sector')b WHERE  id=2706;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (508, 'Set rpt results as archived', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3266, 'gw_fct_set_rpt_archived', 'ws', 'function', 'json', 'json', 
'Function that moves data related to selected result_id from rpt and rpt_inp tables to archived tables', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO inp_typevalue
VALUES('inp_result_status', 3, 'ARCHIVED',NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3268, 'gw_fct_pg2epa_setinitvalues', 'ws', 'function', 'json', 'json', 
'Function that updates initlevel of inlets and tanks using values from selected simulation', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (510, 'Set initlevel of inlets and tanks', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active, device)
VALUES (3268, 'Set initlevel values from executed simulation', '{"featureType":[]}', 
'[{"widgetname":"resultId", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT result_id as id, result_id as idval FROM rpt_cat_result WHERE status !=3", "layoutname":"grl_option_parameters","layoutorder":0, "selectedId":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_sector';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_sector' AND columnname = 'sector_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_sector' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_sector' AND columnname = 'macrosector_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_sector' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_sector' AND columnname = 'undelete';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_sector' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_sector' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_sector' AND columnname = 'active';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_sector' AND columnname = 'parent_id';
UPDATE config_form_fields SET layoutorder =10 WHERE  formname = 'v_edit_sector' AND columnname = 'pattern_id';

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
	dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_presszone', formtype, tabname, columnname, layoutname, 2, datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
	dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
	from config_form_fields 
	where formname ='v_edit_dma' and columnname = 'name' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_dma';

UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_dma' AND columnname = 'dma_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_dma' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_dma' AND columnname = 'macrodma_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_dma' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_dma' AND columnname = 'undelete';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_dma' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_dma' AND columnname = 'pattern_id';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_dma' AND columnname = 'link';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_dma' AND columnname = 'minc';
UPDATE config_form_fields SET layoutorder =10 WHERE  formname = 'v_edit_dma' AND columnname = 'maxc';
UPDATE config_form_fields SET layoutorder =12 WHERE  formname = 'v_edit_dma' AND columnname = 'effc';
UPDATE config_form_fields SET layoutorder =13 WHERE  formname = 'v_edit_dma' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =14 WHERE  formname = 'v_edit_dma' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =15 WHERE  formname = 'v_edit_dma' AND columnname = 'active';
UPDATE config_form_fields SET layoutorder =16 WHERE  formname = 'v_edit_dma' AND columnname = 'avg_press';

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_presszone';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_presszone' AND columnname = 'presszone_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_presszone' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_presszone' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_presszone' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_presszone' AND columnname = 'head';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_presszone' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_presszone' AND columnname = 'active';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_presszone' AND columnname = 'descript';


UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_dqa';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_dqa' AND columnname = 'dqa_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_dqa' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_dqa' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_dqa' AND columnname = 'macrodqa_id';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_dqa' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_dqa' AND columnname = 'undelete';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_dqa' AND columnname = 'pattern_id';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_dqa' AND columnname = 'dqa_type';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_dqa' AND columnname = 'link';
UPDATE config_form_fields SET layoutorder =10 WHERE  formname = 'v_edit_dqa' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =11 WHERE  formname = 'v_edit_dqa' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =12 WHERE  formname = 'v_edit_dqa' AND columnname = 'active';

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_ui_plan_netscenario', 'Table to show netscenario in qgis ui', 'role_master', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, 
label,isparent, iseditable, isautoupdate, isfilter, hidden)
SELECT 'plan_netscenario', 'form_feature', 'tab_none', attname, 'lyt_data_1', attnum,
attname, false, true, false, false, false FROM   pg_attribute
WHERE  attrelid = 'SCHEMA_NAME.plan_netscenario'::regclass and attnum >0
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, 
label,isparent, iseditable, isautoupdate, isfilter, hidden)
SELECT 'v_edit_plan_netscenario_dma', 'form_feature', 'tab_none', attname, 'lyt_data_1', attnum,
attname, false, true, false, false, false FROM   pg_attribute
WHERE  attrelid = 'SCHEMA_NAME.v_edit_plan_netscenario_dma'::regclass 
and attname!='the_geom' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
	
INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, 
label,isparent, iseditable, isautoupdate, isfilter, hidden)
SELECT 'v_edit_plan_netscenario_presszone', 'form_feature', 'tab_none', attname, 'lyt_data_1', attnum,
attname, false, true, false, false, false FROM   pg_attribute
WHERE  attrelid = 'SCHEMA_NAME.v_edit_plan_netscenario_presszone'::regclass 
and attname!='the_geom' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
	
UPDATE config_form_fields set datatype='string', widgettype='text'
where (formname = 'v_edit_plan_netscenario_dma' or formname = 'v_edit_plan_netscenario_presszone') 
and columnname in ('presszone_id','presszone_name','dma_name','graphconfig', 'netscenario_name');

UPDATE config_form_fields set datatype='integer', widgettype='text', ismandatory = true
where (formname = 'v_edit_plan_netscenario_dma' or formname = 'v_edit_plan_netscenario_presszone')  and columnname in ('netscenario_id', 'dma_id');


UPDATE config_form_fields set datatype='numeric', widgettype='text', ismandatory = false
where formname = 'v_edit_plan_netscenario_presszone' and columnname in ('head');

UPDATE config_form_fields set datatype=a.datatype, widgettype=a.widgettype, ismandatory = a.ismandatory, dv_querytext=a.dv_querytext,
dv_orderby_id=a.dv_orderby_id,dv_isnullvalue=a.dv_isnullvalue
from (select datatype, widgettype, ismandatory,  dv_querytext, dv_orderby_id, dv_isnullvalue
from config_form_fields where formname = 'v_edit_dma' and columnname in ('pattern_id'))a
where formname = 'v_edit_plan_netscenario_dma' and columnname in ('pattern_id');

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, 
label,isparent, iseditable, isautoupdate, isfilter, hidden)
SELECT 'v_edit_plan_netscenario_dma', 'form_feature', 'tab_none', attname, 'lyt_data_1', attnum,
attname, false, true, false, false, false FROM   pg_attribute
WHERE  attrelid = 'SCHEMA_NAME.v_edit_plan_netscenario_dma'::regclass 
and attname!='the_geom' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
	
INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, 
label,isparent, iseditable, isautoupdate, isfilter, hidden)
SELECT 'v_edit_plan_netscenario_presszone', 'form_feature', 'tab_none', attname, 'lyt_data_1', attnum,
attname, false, true, false, false, false FROM   pg_attribute
WHERE  attrelid = 'SCHEMA_NAME.v_edit_plan_netscenario_presszone'::regclass 
and attname!='the_geom' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields set datatype='string', widgettype='text'
where formname in ('v_edit_plan_netscenario_dma','v_edit_plan_netscenario_presszone','plan_netscenario') 
and columnname in ('presszone_id','presszone_name','dma_name','graphconfig', 'netscenario_name', 'name', 'descript', 'log');

UPDATE config_form_fields set datatype='integer', widgettype='text', ismandatory = true
where formname in ('v_edit_plan_netscenario_dma','v_edit_plan_netscenario_presszone','plan_netscenario') 
and columnname in ('netscenario_id', 'dma_id');

UPDATE config_form_fields set datatype='numeric', widgettype='text', ismandatory = false
where formname = 'v_edit_plan_netscenario_presszone' and columnname in ('head');

UPDATE config_form_fields set datatype=a.datatype, widgettype=a.widgettype, ismandatory = a.ismandatory, dv_querytext=a.dv_querytext,
dv_orderby_id=a.dv_orderby_id,dv_isnullvalue=a.dv_isnullvalue
from (select datatype, widgettype, ismandatory,  dv_querytext, dv_orderby_id, dv_isnullvalue
from config_form_fields where formname = 'v_edit_dma' and columnname in ('pattern_id'))a
where formname = 'v_edit_plan_netscenario_dma' and columnname in ('pattern_id');

UPDATE config_form_fields set datatype=a.datatype, widgettype=a.widgettype, ismandatory = a.ismandatory, dv_querytext=a.dv_querytext,
dv_orderby_id=a.dv_orderby_id,dv_isnullvalue=a.dv_isnullvalue
from (select datatype, widgettype, ismandatory,  dv_querytext, dv_orderby_id, dv_isnullvalue
from config_form_fields where formname = 'v_edit_dma' and columnname in ('expl_id'))a
where formname = 'plan_netscenario' and columnname in ('expl_id');

UPDATE config_form_fields set datatype=a.datatype, widgettype=a.widgettype, ismandatory = a.ismandatory, dv_querytext=a.dv_querytext,
dv_orderby_id=a.dv_orderby_id,dv_isnullvalue=a.dv_isnullvalue
from (select datatype, widgettype, ismandatory,  dv_querytext, dv_orderby_id, dv_isnullvalue
from config_form_fields where formname = 'v_edit_dma' and columnname in ('active'))a
where formname = 'plan_netscenario' and columnname in ('active');

UPDATE config_form_fields set datatype='string', widgettype='combo', ismandatory = false, 
dv_querytext='SELECT netscenario_id as id,name as idval FROM plan_netscenario WHERE active IS TRUE ',
dv_orderby_id=true, dv_isnullvalue=true
where formname = 'plan_netscenario' and columnname in ('parent_id');

UPDATE config_form_fields set datatype='string', widgettype='combo', ismandatory = true, 
dv_querytext='SELECT id, idval FROM plan_typevalue WHERE typevalue = ''netscenario_type''',
dv_orderby_id=true, dv_isnullvalue=true
where formname = 'plan_netscenario' and columnname in ('netscenario_type');

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3274, 'gw_trg_edit_plan_netscenario', 'ws', 'function trigger', null, null, 'Function trigger that allows editing views of netscenario dma and presszone', 'role_edit', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE ext_rtc_hydrometer SET is_waterbal = true;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'plan_netscenario_dma',formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_plan_netscenario_dma' AND columnname in ('netscenario_id', 'dma_id', 'dma_name','pattern_id','graphconfig') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'plan_netscenario_dma',formtype, tabname, 'dma_name', layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_plan_netscenario_dma' AND columnname in ('name') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'plan_netscenario_presszone',formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_plan_netscenario_presszone' AND columnname in ('netscenario_id', 'presszone_id', 'presszone_name','head','graphconfig') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'plan_netscenario_presszone',formtype, tabname, 'presszone_name', layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_plan_netscenario_presszone' AND columnname in ('name') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET widgettype = 'text', datatype = 'string' where formname ilike '%netscenario%' and columnname ilike '%name';

ALTER TABLE IF EXISTS rpt_cat_result DROP CONSTRAINT IF EXISTS rpt_cat_result_status_check;

ALTER TABLE IF EXISTS rpt_cat_result
 ADD CONSTRAINT rpt_cat_result_status_check CHECK (status = ANY (ARRAY[0, 1, 2, 3]));

CREATE TRIGGER gw_trg_edit_minsector
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON v_edit_minsector
    FOR EACH ROW
    EXECUTE FUNCTION gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_edit_plan_netscenario
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON SCHEMA_NAME.v_edit_plan_netscenario_dma
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMA_NAME.gw_trg_edit_plan_netscenario('DMA');


CREATE TRIGGER gw_trg_edit_plan_netscenario
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON SCHEMA_NAME.v_edit_plan_netscenario_presszone
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMA_NAME.gw_trg_edit_plan_netscenario('PRESSZONE');
