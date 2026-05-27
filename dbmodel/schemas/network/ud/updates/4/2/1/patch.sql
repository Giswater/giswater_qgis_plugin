/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


alter table archived_psector_gully add column psector_descript text;
 
drop table archived_psector_link;

CREATE TABLE archived_psector_link  (
	id serial4 NOT NULL,
	psector_id int4 NOT NULL,
	psector_state int2 NOT NULL,
	doable bool NOT NULL,
	addparam json NULL,
	audit_tstamp timestamp DEFAULT now() NULL,
	audit_user text DEFAULT CURRENT_USER NULL,
	action varchar(16) NOT NULL,
 	link_id integer,
	code text NULL,
	sys_code text NULL,
	top_elev1 float8 NULL,
	y1 numeric(12, 4) NULL,
	exit_id int4 NULL,
	exit_type varchar(16) NULL,
	top_elev2 float8 NULL,
	y2 numeric(12, 4) NULL,
	feature_type varchar(16) NULL,
	feature_id int4 NULL,
	link_type varchar(30) NOT NULL,
	linkcat_id varchar(30) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	expl_id2 int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	dma_id int4 DEFAULT 0 NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	drainzone_outfall _int4 NULL,
	dwfzone_outfall _int4 NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	custom_length numeric(12, 2) NULL,
	sys_slope numeric(12, 3) NULL,
	annotation text NULL,
	observ text NULL,
	"comment" text NULL,
	descript varchar(254) NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	private_linkcat_id varchar(30) NULL,
	verified int2 NULL,
	uncertain bool NULL,
	userdefined_geom bool NULL,
	datasource int4 NULL,
	is_operative bool NULL,
	lock_level int4 NULL,
	expl_visibility _int2 NULL,
	created_at timestamptz DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamptz NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT archived_psector_link_pkey PRIMARY KEY (id)
);
CREATE INDEX archived_psector_link_exit_id ON archived_psector_link USING btree (exit_id);
CREATE INDEX archived_psector_link_expl_visibility_idx ON link USING btree (expl_visibility);
CREATE INDEX archived_psector_link_feature_id ON archived_psector_link USING btree (feature_id);
CREATE INDEX archived_psector_link_index ON archived_psector_link USING gist (the_geom);
CREATE INDEX archived_psector_link_muni ON archived_psector_link USING btree (muni_id);

ALTER TABLE macroomzone ALTER COLUMN expl_id DROP NOT NULL;


ALTER TABLE om_waterbalance_dma_graph DROP CONSTRAINT IF EXISTS om_waterbalance_dma_graph_dma_id_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_dma_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_dma_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_dma_id_fkey;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_dma_id_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_dma_id_fkey;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS ve_dma;
DROP TABLE IF EXISTS dma;
CREATE TABLE IF NOT EXISTS dma (
    dma_id SERIAL,
    code TEXT,
    name TEXT,
    descript TEXT,
    dma_type VARCHAR(16),
    muni_id INT4[],
    expl_id INT4[],
    sector_id INT4[],
    avg_press INT4,
    pattern_id INT4,
    effc INT4,
    graphconfig JSON,
    stylesheet TEXT,
    lock_level INT4,
    link TEXT,
    addparam JSON,
    active BOOLEAN DEFAULT TRUE,
    the_geom GEOMETRY(POLYGON, SRID_VALUE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by TEXT DEFAULT current_user,
    updated_at TIMESTAMP,
    updated_by TEXT,
    CONSTRAINT dma_pk PRIMARY KEY (dma_id)
);

SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dwfzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"expl_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"link", "dataType":"text", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"expl_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"link", "dataType":"text", "isUtils":"False"}}$$);

-- Redo omzone
DROP VIEW IF EXISTS v_ui_omzone;
DROP VIEW IF EXISTS ve_omzone cascade;
DROP VIEW IF EXISTS v_edit_omzone cascade;

ALTER TABLE omzone DROP CONSTRAINT IF EXISTS omzone_expl_id_fkey;
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"omzone", "column":"expl_id", "dataType":"int4[]"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);


DROP RULE IF EXISTS dma_conflict ON dma;
DROP RULE IF EXISTS dma_undefined ON dma;
UPDATE dma SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE dma ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS omzone_conflict ON omzone;
DROP RULE IF EXISTS omzone_undefined ON omzone;
UPDATE omzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE omzone ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS dwfzone_conflict ON dwfzone;
DROP RULE IF EXISTS dwfzone_undefined ON dwfzone;
UPDATE dwfzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE dwfzone ALTER COLUMN expl_id SET NOT NULL;

DROP VIEW IF EXISTS ve_inp_dscenario_frpump;

CREATE OR REPLACE VIEW ve_inp_dscenario_frpump
AS SELECT s.dscenario_id,
    f.element_id,
    n.node_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frpump f
    JOIN ve_inp_frpump n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id = l.exit_id
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    ve_connec.arc_id,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS catalog,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.sys_type,
    a.state AS arc_state,
    ve_connec.state AS feature_state,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link l ON ve_connec.connec_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_connec.arc_id
  WHERE ve_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.conneccat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_connec c ON c.connec_id = n.feature_id
UNION
 SELECT row_number() OVER () + 3000000 AS rid,
    ve_gully.arc_id,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.gullycat_id AS catalog,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.sys_type,
    a.state AS arc_state,
    ve_gully.state AS feature_state,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link l ON ve_gully.gully_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_gully.arc_id
  WHERE ve_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid,
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gullycat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state AS arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_gully g ON g.gully_id = n.feature_id;


CREATE OR REPLACE VIEW v_element_x_gully
AS SELECT element_x_gully.gully_id,
    element_x_gully.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.updated_at
   FROM element_x_gully
     JOIN element ON element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

DROP VIEW IF EXISTS v_ui_element_x_gully;
CREATE OR REPLACE VIEW v_ui_element_x_gully
AS SELECT element_x_gully.gully_id,
    element_x_gully.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate
   FROM element_x_gully
     JOIN element ON element.element_id = element_x_gully.element_id
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;


CREATE OR REPLACE VIEW v_ui_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
   FROM selector_expl se, omzone o
     LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE se.expl_id = ANY(o.expl_id) AND se.cur_user = CURRENT_USER AND o.omzone_id > 0
  ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW ve_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.the_geom,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
   FROM selector_expl se, omzone o
     LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE se.expl_id = ANY(o.expl_id) AND se.cur_user = CURRENT_USER AND o.omzone_id > 0
  ORDER BY o.omzone_id;

DROP VIEW IF EXISTS v_ui_drainzone;
DROP VIEW IF EXISTS ve_drainzone;
DROP VIEW IF EXISTS v_ui_dwfzone;
DROP VIEW IF EXISTS ve_dwfzone;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS ve_sector;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS ve_dma;
DROP VIEW IF EXISTS v_ui_macrosector;
DROP VIEW IF EXISTS ve_macrosector;
DROP VIEW IF EXISTS v_ui_macroomzone;
DROP VIEW IF EXISTS ve_macroomzone;

CREATE OR REPLACE VIEW v_ui_drainzone
AS SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM drainzone d
     LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE d.drainzone_id > 0
  ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW ve_drainzone
AS SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM drainzone d WHERE d.drainzone_id > 0
  ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW v_ui_dwfzone
AS SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dwfzone_type,
    da.name AS drainzone,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dwfzone d
     LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
     LEFT JOIN drainzone da ON d.drainzone_id = da.drainzone_id
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dwfzone_id > 0
  ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW ve_dwfzone
AS SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dwfzone_type,
    d.drainzone_id,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dwfzone d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dwfzone_id > 0
  ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    et.idval AS sector_type,
    ms.name AS macrosector,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text,
    s.stylesheet::text,
    s.lock_level,
    s.link,
    s.addparam::text,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
   FROM selector_sector ss, sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
     LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  WHERE ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER AND s.sector_id > 0
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW ve_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    s.sector_type,
    s.macrosector_id,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text,
    s.stylesheet::text,
    s.lock_level,
    s.link,
    s.the_geom,
    s.addparam::text,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
   FROM selector_sector ss, sector s
  WHERE ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER AND s.sector_id > 0
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW v_ui_dma
AS SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dma d
     LEFT JOIN edit_typevalue et ON et.id::text = d.dma_type::text AND et.typevalue::text = 'dma_type'::text
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dma_id > 0;

CREATE OR REPLACE VIEW ve_dma
AS SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dma d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dma_id > 0;

CREATE OR REPLACE VIEW v_ui_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    code,
    name,
    descript,
    active,
    expl_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macrosector m
  WHERE macrosector_id > 0
  ORDER BY macrosector_id;

CREATE OR REPLACE VIEW ve_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    code,
    name,
    descript,
    active,
    expl_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    the_geom,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macrosector m
  WHERE macrosector_id > 0
  ORDER BY macrosector_id;

CREATE OR REPLACE VIEW v_ui_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macroomzone m
  WHERE macroomzone_id > 0
  ORDER BY macroomzone_id;

CREATE OR REPLACE VIEW ve_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    the_geom,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macroomzone m
  WHERE macroomzone_id > 0
  ORDER BY macroomzone_id;

DELETE FROM config_form_fields WHERE formname ILIKE 've_element_%';
DO $$
DECLARE
  rec record;
  v_view text;
BEGIN
  FOR rec IN (SELECT * FROM cat_feature_element WHERE id NOT IN ('EPUMP', 'EORIFICE', 'EWEIR', 'EOUTLET'))
  LOOP
    v_view := concat('ve_element_', lower(REPLACE(REC.id, ' ', '_')));

    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID:','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Element number:','Element number',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comment:','Comment',false,false,true,false,'{"setMultiline":true}'::json,true);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function type:','Function type',false,false,true,false,concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''E',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category type:','Category type',false,false,true,false,concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''E',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location type:','Location type',false,false,true,false,concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''E',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat:','Workcat',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID end:','Workcat ID end','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Builtdate:','Builtdate:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','Enddate:','Enddate',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner:','ownercat_id - Related to the catalog of owners (cat_owner)',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
        VALUES (v_view,'form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','brand_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand WHERE ''E',rec.id,''' = ANY(featurecat_id::text[])'),false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
        VALUES (v_view,'form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','model_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand_model WHERE ''E',rec.id,''' = ANY(featurecat_id::text[])'),false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top elevation:','top_elev - Elevation of the node in ft or m.',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation:','Exploitation',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
        VALUES (v_view,'form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observation:','Observation',false,false,true,false,'{"setMultiline":true}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Catalog:','Catalog',true,false,true,false,concat('SELECT id, id as idval FROM cat_element WHERE element_type = ''E',rec.id,''''),true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
        VALUES (v_view,'form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
        VALUES (v_view,'form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
    "icon": "111"
    }'::json,'{
    "saveValue": false
    }'::json,'{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
        VALUES (v_view,'form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
    "icon": "112"
    }'::json,'{
    "saveValue": false
    }'::json,'{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
        VALUES (v_view,'form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
    "icon": "137"
    }'::json,'{
    "saveValue": false
    }'::json,'{
    "functionName": "selection_init"
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
    "icon": "178"
    }'::json,'{
    "saveValue": false
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }'::json,'tbl_element_x_arc',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }'::json,'tbl_element_x_connec',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }'::json,'tbl_element_x_link',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }'::json,'tbl_element_x_node',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
      VALUES (v_view,'form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (v_view,'form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }'::json,'tbl_doc_x_element',false,4);
      END LOOP;
END $$;

-- FRELEM
-- EPUMP
DO $$
DECLARE
  rec record;
  v_view text;
BEGIN
  FOR rec IN SELECT val AS v_view,  elem as id FROM (VALUES ('ve_element_epump', 'EPUMP'), ('ve_element_eorifice', 'EORIFICE'), ('ve_element_eweir', 'EWEIR'), ('ve_element_eoutlet', 'EOUTLET') ) AS t(val, elem)
  LOOP
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID:','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','code','lyt_data_1',2,'string','text','Code:','Code:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Element number:','Element number',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comment:','Comment',false,false,true,false,'{"setMultiline":true}'::json,true);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function type:','Function type',false,false,true,false,concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category type:','Category type',false,false,true,false,concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location type:','Location type',false,false,true,false,concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat:','Workcat',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat ID end:','Workcat ID end','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Builtdate:','Builtdate:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','Enddate:','Enddate',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner:','ownercat_id - Related to the catalog of owners (cat_owner)',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
      VALUES (rec.v_view,'form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand:','brand_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand WHERE ''',rec.id,''' = ANY(featurecat_id::text[])'));
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
      VALUES (rec.v_view,'form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model:','model_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand_model WHERE ''',rec.id,''' = ANY(featurecat_id::text[])'));
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','rotation','lyt_data_1',15,'double','text','Rotation:','Rotation:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','top_elev','lyt_data_1',16,'double','text','Top elevation:','top_elev - Elevation of the node in ft or m.',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','flwreg_length','lyt_data_2',1,'double','text','Flwreg length:','flwreg_length',true,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','node_id','lyt_data_1',1,'integer','text','Node id:','node_id',false,false,false,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','To arc:','to_arc',true,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','expl_id','lyt_data_2',3,'integer','combo','Exploitation:','Exploitation',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observation:','Observation',false,false,true,false,'{"setMultiline":true}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Catalog:','Catalog',true,false,true,false,concat('SELECT id, id as idval FROM cat_element WHERE element_type = ''',rec.id,''''),true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
        VALUES (rec.v_view,'form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type:','EPA Type',false,false,true,true,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''','{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }'::json,'tbl_doc_x_element',false,4);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
      "icon": "111"
    }'::json,'{
      "saveValue": false
    }'::json,'{
      "functionName": "insert_feature",
      "parameters": {
        "targetwidget": "tab_features_feature_id"
      }
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
      "icon": "112"
    }'::json,'{
      "saveValue": false
    }'::json,'{
      "functionName": "delete_object",
      "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
      }
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
      "icon": "137"
    }'::json,'{
      "saveValue": false
    }'::json,'{
      "functionName": "selection_init"
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
      "icon": "178"
    }'::json,'{
      "saveValue": false
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_arc",
      "featureType": "arc"
    }'::json,'tbl_element_x_arc',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_connec",
      "featureType": "connec"
    }'::json,'tbl_element_x_connec',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_link",
      "featureType": "link"
    }'::json,'tbl_element_x_link',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_node",
      "featureType": "node"
    }'::json,'tbl_element_x_node',false);
      END LOOP;
END $$;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,dv_parent_id,dv_querytext_filterc,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder) VALUES
	 ('ve_arc_varc','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_siphon','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_pump_pipe','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_waccel','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_conduit','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99)
	 ON CONFLICT (formname,formtype,tabname,columnname) DO NOTHING;


update config_toolbox set active = false where id in (3424,3492);

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,sample_query,"source",function_alias) VALUES
	 (3302,'gw_fct_getgraphconfig','utils','function','json','json','Function to recover graphconfig values. ','role_om',NULL,'core',NULL);



INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(638, 'Check that all flow regulator elements have the same length', 'ud', NULL, 'core', NULL, 'Check epa-data', NULL, 2,
'nodes with flowregulators with different lengths and same to_arc', NULL, NULL,
'SELECT count(DISTINCT flwreg_length) FROM man_frelem GROUP BY node_id, to_arc HAVING count(DISTINCT flwreg_length) > 1',
'All flow regulator elements with the same node_id and to_arc have the same length', '[gw_fct_pg2epa_check_data]', true);

UPDATE config_form_fields SET dv_querytext =
'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outlet'''
WHERE formname = 've_epa_froutlet' and columnname = 'outlet_type';

UPDATE sys_table SET context = '{"levels": ["EPA", "HYDRAULICS"]}' WHERE id LIKE '%ve_inp_fr%';
UPDATE sys_table SET context = '{"levels": ["EPA", "DSCENARIO"]}' WHERE id LIKE '%ve_inp_dscenario_fr%';

update sys_table set context = '{"levels": ["EPA", "HYDRAULICS"]}' where id like '%ve_inp_fr%';
update sys_table set context = '{"levels": ["EPA", "DSCENARIO"]}' where id like '%ve_inp_dscenario_fr%';

update sys_table set alias = 'FRoutlet Dscenario' where id = 've_inp_dscenario_froutlet';
update sys_table set alias = 'FRpump Dscenario' where id = 've_inp_dscenario_frpump';
update sys_table set alias = 'FRorifice Dscenario' where id = 've_inp_dscenario_frorifice';
update sys_table set alias = 'FRweir Dscenario' where id = 've_inp_dscenario_frweir';

update sys_table set alias = 'FRoutlet' where id = 've_inp_froutlet';
update sys_table set alias = 'FRpump' where id = 've_inp_frpump';
update sys_table set alias = 'FRorifice' where id = 've_inp_frorifice';
update sys_table set alias = 'FRweir' where id = 've_inp_frweir';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4342, 'There are %v_count% %v_feature_type%s with fluid_type equal to zero.', NULL, 0, true, 'ud', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4344, 'There are %v_count% %v_feature_type%s with fluid_type different to zero.', NULL, 0, true, 'ud', 'core', 'AUDIT');



-- Add columns to inp_dscenario_frpump
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'curve_id', 'lyt_main_1', 3, 'string', 'combo', 'Curve id:', 'Curve id', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type IN (''PUMP'', ''PUMP1'', ''PUMP2'', ''PUMP3'', ''PUMP4'')', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'status', 'lyt_main_1', 4, 'string', 'combo', 'Status:', 'Status', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_status''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'startup', 'lyt_main_1', 5, 'numeric', 'text', 'Startup:', 'Startup', NULL, false, NULL, true, NULL, false, NULL, true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'shutoff', 'lyt_main_1', 6, 'numeric', 'text', 'Shutoff:', 'Shutoff', NULL, false, NULL, true, NULL, false, NULL, true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Add columns to inp_dscenario_frweir

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'weir_type', 'lyt_main_1', 3, 'string', 'combo', 'Weir type:', 'Weir type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_weirs''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'offsetval', 'lyt_main_1', 4, 'numeric', 'text', 'Offset:', 'Offset', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'cd', 'lyt_main_1', 5, 'numeric', 'text', 'Cd:', 'Discharge coefficient', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'ec', 'lyt_main_1', 6, 'numeric', 'text', 'Ec:', 'End contractions', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'cd2', 'lyt_main_1', 7, 'numeric', 'text', 'Cd2:', 'Discharge coefficient 2', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'flap', 'lyt_main_1', 8, 'string', 'text', 'Flap:', 'Flap gate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom1', 'lyt_main_1', 9, 'numeric', 'text', 'Geom1:', 'Height/Crest height', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom2', 'lyt_main_1', 10, 'numeric', 'text', 'Geom2:', 'Length/Width', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom3', 'lyt_main_1', 11, 'numeric', 'text', 'Geom3:', 'Side slope', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom4', 'lyt_main_1', 12, 'numeric', 'text', 'Geom4:', 'Number of steps', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'surcharge', 'lyt_main_1', 13, 'string', 'text', 'Surcharge:', 'Surcharge', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'road_width', 'lyt_main_1', 14, 'numeric', 'text', 'Road width:', 'Road width', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'road_surf', 'lyt_main_1', 15, 'string', 'text', 'Road surface:', 'Road surface', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_roadSurface''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'coef_curve', 'lyt_main_1', 16, 'numeric', 'text', 'Coef curve:', 'Coefficient curve', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''RATING''', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL);

-- Add columns to inp_dscenario_frorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'orifice_type', 'lyt_main_1', 3, 'string', 'combo', 'Orifice type:', 'Orifice type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_orifice''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'offsetval', 'lyt_main_1', 4, 'numeric', 'text', 'Offset:', 'Offset', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'cd', 'lyt_main_1', 5, 'numeric', 'text', 'Cd:', 'Discharge coefficient', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'orate', 'lyt_main_1', 6, 'numeric', 'text', 'Orate:', 'Opening/closing rate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'flap', 'lyt_main_1', 7, 'string', 'text', 'Flap:', 'Flap gate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'shape', 'lyt_main_1', 8, 'string', 'combo', 'Shape:', 'Shape', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_orifice_shape''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom1', 'lyt_main_1', 9, 'numeric', 'text', 'Geom1:', 'Height', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom2', 'lyt_main_1', 10, 'numeric', 'text', 'Geom2:', 'Width', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom3', 'lyt_main_1', 11, 'numeric', 'text', 'Geom3:', 'Length', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom4', 'lyt_main_1', 12, 'numeric', 'text', 'Geom4:', 'Side slope', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


-- Add columns to inp_dscenario_froutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'outlet_type', 'lyt_main_1', 3, 'string', 'combo', 'Outlet type:', 'Outlet type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_outlet''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'offsetval', 'lyt_main_1', 4, 'numeric', 'text', 'Offset:', 'Offset', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'curve_id', 'lyt_main_1', 5, 'string', 'combo', 'Curve id:', 'Rating curve', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''RATING''', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'cd1', 'lyt_main_1', 6, 'numeric', 'text', 'Cd1:', 'Discharge coefficient 1', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'cd2', 'lyt_main_1', 7, 'numeric', 'text', 'Cd2:', 'Discharge coefficient 2', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'flap', 'lyt_main_1', 8, 'string', 'text', 'Flap:', 'Flap gate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_element_x_gully', 'Contains the elements related to gully', 'role_edit');


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}', NULL, NULL, '{
  "orderBy": 9
}'::json);
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":30}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "ANALYTICS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":29}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["BASEMAP", "CARTO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":28}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["BASEMAP", "ADDRESS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":27}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "NETSCENARIO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":26}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "TRACEABILITY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":25}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "PRICES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":24}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "PSECTOR"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":23}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "COMPARE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":22}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "RESULTS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":21}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "DSCENARIO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":20}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "FLOWREG"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":19}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "HYDRAULICS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":18}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "HYDROLOGY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":17}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":16}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "VISIT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":15}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "FLOWTRACE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":14}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "MINCUT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":13}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "VALUE DOMAIN"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":12}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "AUXILIAR"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 11}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "OTHER"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 4}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "MAP ZONES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":0}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}';

UPDATE sys_table SET project_template = '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_man_frelem';

UPDATE sys_table SET project_template = NULL WHERE id = 've_man_genelem';

UPDATE sys_table SET project_template = '{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id = 've_element';

UPDATE sys_table SET orderby=1 WHERE id='ve_node';
UPDATE sys_table SET orderby=2 WHERE id='ve_man_frelem';
UPDATE sys_table SET orderby=2 WHERE id='ve_element';
UPDATE sys_table SET orderby=3 WHERE id='ve_arc';
UPDATE sys_table SET orderby=4 WHERE id='ve_connec';
UPDATE sys_Table SET orderby=5 WHERE id='ve_gully';
UPDATE sys_table SET orderby=6 WHERE id='ve_link';

DELETE FROM cat_element WHERE id='GATE-01' AND element_type='EGATE';


INSERT INTO sys_table (id, descript, sys_role, context, orderby, alias, source) VALUES ('ve_inp_inlet', 'Shows editable information about inlets.', 'role_epa', '{"levels": ["EPA", "HYDRAULICS"]}', 20, 'Inp Inlet', 'core');

-- gully form
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias) VALUES ('gully form','ud','tbl_element_x_gully','epa_type',6,true,'epa_type');
UPDATE config_form_tableview SET columnindex=7 WHERE objectname='tbl_element_x_gully' AND columnname='state';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_gully' AND columnname='state_type';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_gully' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_gully' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_gully' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_gully' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=13 WHERE objectname='tbl_element_x_gully' AND columnname='descript';
UPDATE config_form_tableview SET columnindex=14 WHERE objectname='tbl_element_x_gully' AND columnname='location_type';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status''', dv_isnullvalue=true WHERE formname='ve_epa_frpump' AND columnname='status';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_yesno'' ', dv_isnullvalue=true WHERE formname='ve_epa_frorifice' AND columnname='flap';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_orifice'' ', dv_isnullvalue=true WHERE formname='ve_epa_frorifice' AND columnname='shape';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_yesno'' ', dv_isnullvalue=true WHERE formname='ve_epa_froutlet' AND columnname='flap';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', dv_isnullvalue=TRUE WHERE formname='ve_epa_froutlet' AND columnname='curve_id';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', dv_isnullvalue=true WHERE formname='ve_epa_frpump' AND columnname='curve_id';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outlet''', dv_isnullvalue=true WHERE formname='ve_epa_froutlet' AND columnname='outlet_type';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_orifice''', dv_isnullvalue=true WHERE formname='ve_epa_frorifice' AND columnname='outlet_type';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_weirs''', dv_isnullvalue=true WHERE formname='ve_epa_frweir' AND columnname='outlet_type';

DELETE FROM config_form_fields WHERE columnname = 'nodarc_id';

INSERT INTO dma (dma_id, name, expl_id) VALUES (0, 'UNDEFINED', '{0}') ON CONFLICT (dma_id) DO NOTHING;

-- ve_dma
DELETE FROM config_form_fields where formname in ('v_ui_dma', 've_dma');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','dma_id','lyt_data_1',1,'integer','text','Dma id:','dma_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','dma_type','lyt_data_1',6,'string','combo','Dma type:','dma_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dma_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_dma','form_feature','tab_none','avg_press','lyt_data_1',10,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','pattern_id','lyt_data_1',11,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','effc','lyt_data_1',12,'string','text','Effc:','effc',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','graphconfig','lyt_data_1',13,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','stylesheet','lyt_data_1',14,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','lock_level','lyt_data_1',15,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','link','lyt_data_1',19,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','addparam','lyt_data_1',17,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_at','lyt_data_1',18,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_by','lyt_data_1',19,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_at','lyt_data_1',20,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_by','lyt_data_1',21,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_dwfzone
DELETE FROM config_form_fields WHERE formname IN ('ve_dwfzone', 'v_ui_dwfzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','dwfzone_id','lyt_data_1',1,'integer','text','Dwfzone id:','dwfzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dwfzone", "activated": true, "keyColumn": "dwfzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','dwfzone_type','lyt_data_1',6,'string','combo','Dwfzone type:','dwfzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dwfzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','drainzone_id','lyt_data_1',7,'string','combo','Drainzone:','drainzone_id',false,false,true,false,'SELECT drainzone_id as id, name as idval FROM drainzone WHERE drainzone_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','graphconfig','lyt_data_1',11,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','stylesheet','lyt_data_1',12,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','lock_level','lyt_data_1',13,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','link','lyt_data_1',14,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','addparam','lyt_data_1',15,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','created_at','lyt_data_1',16,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','created_by','lyt_data_1',17,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','updated_at','lyt_data_1',18,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','updated_by','lyt_data_1',19,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_drainzone
DELETE FROM config_form_fields WHERE formname IN ('ve_drainzone', 'v_ui_drainzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','drainzone_id','lyt_data_1',1,'integer','text','Drainzone id:','drainzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_drainzone", "activated": true, "keyColumn": "drainzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','drainzone_type','lyt_data_1',6,'string','combo','Drainzone type:','drainzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''drainzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','graphconfig','lyt_data_1',10,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','stylesheet','lyt_data_1',11,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','lock_level','lyt_data_1',12,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','link','lyt_data_1',13,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','addparam','lyt_data_1',14,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','created_at','lyt_data_1',15,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','created_by','lyt_data_1',16,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','updated_at','lyt_data_1',17,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','updated_by','lyt_data_1',18,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_omzone
DELETE FROM config_form_fields WHERE formname IN ('ve_omzone', 'v_ui_omzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','omzone_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','omzone_type','lyt_data_1',6,'string','combo','Omzone type:','omzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''omzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','macroomzone_id','lyt_data_1',7,'string','combo','Macroomzone:','macroomzone_id',false,false,true,false,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','graphconfig','lyt_data_1',11,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','stylesheet','lyt_data_1',12,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','lock_level','lyt_data_1',13,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','link','lyt_data_1',14,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','addparam','lyt_data_1',15,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','created_at','lyt_data_1',16,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','created_by','lyt_data_1',17,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','updated_at','lyt_data_1',18,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','updated_by','lyt_data_1',19,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macroomzone
DELETE FROM config_form_fields WHERE formname IN ('ve_macroomzone', 'v_ui_macroomzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','macroomzone_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,true,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macrosector
DELETE FROM config_form_fields WHERE formname IN ('ve_macrosector', 'v_ui_macrosector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','macrosector_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_sector
DELETE FROM config_form_fields WHERE formname IN ('v_ui_sector','ve_sector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','sector_id','lyt_data_1',1,'integer','text','Sector id:','sector_id',true,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','sector_type','lyt_data_1',6,'string','combo','Sector type:','sector_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','macrosector_id','lyt_data_1',7,'string','combo','Macrosector id:','macrosector_id',false,false,true,false,'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_sector','form_feature','tab_none','avg_press','lyt_data_1',10,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','pattern_id','lyt_data_1',11,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','graphconfig','lyt_data_1',12,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','stylesheet','lyt_data_1',13,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','lock_level','lyt_data_1',14,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','link','lyt_data_1',15,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','addparam','lyt_data_1',16,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','created_at','lyt_data_1',17,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','created_by','lyt_data_1',18,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','updated_at','lyt_data_1',19,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','updated_by','lyt_data_1',20,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- Mapzone types
DELETE FROM edit_typevalue WHERE typevalue = 'sector_type';
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','COLLECTION SYSTEMS','COLLECTION SYSTEMS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','TRUNK SEWERS','TRUNK SEWERS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','UNDEFINED','UNDEFINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dma_type','COLLECTION SYSTEMS','COLLECTION SYSTEMS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dma_type','TRUNK SEWERS','TRUNK SEWERS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dma_type','UNDEFINED','UNDEFINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','4','COMBINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','2','DILUTE COMBINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','1','STORMWATER');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','3','SEWAGE');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','0','NOT INFORMED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','4','COMBINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','3','SEWAGE');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','1','STORMWATER');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','0','NOT INFORMED');



INSERT INTO config_typevalue (typevalue,id,idval) VALUES ('widgettype_typevalue','list','list');
UPDATE config_form_fields SET widgettype='list' WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('expl_id', 'sector_id', 'muni_id');

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = 'inp_typevalue_weir' WHERE typevalue='inp_value_weirs';

UPDATE sys_foreignkey SET typevalue_name='inp_typevalue_weir', target_table='inp_weir' WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_weirs' AND target_table='inp_weir' AND target_field='weir_type';
UPDATE sys_foreignkey SET typevalue_name='inp_typevalue_weir', target_table='inp_frweir' WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_weirs' AND target_table='inp_flwreg_weir' AND target_field='weir_type';
UPDATE sys_foreignkey SET typevalue_name='inp_typevalue_weir', target_table='inp_dscenario_frweir' WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_weirs' AND target_table='inp_dscenario_flwreg_weir' AND target_field='weir_type';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE config_form_fields SET dv_querytext = REPLACE(dv_querytext, 'inp_value_weirs', 'inp_typevalue_weir') WHERE dv_querytext ILIKE '%inp_value_weirs%';

update sys_table set orderby =  1 WHERE id = 've_exploitation';
update sys_table set orderby =  2 WHERE id = 've_drainzone';
update sys_table set orderby =  3 WHERE id = 've_dwfzone';
update sys_table set orderby =  4 WHERE id = 've_sector';
update sys_table set project_template = null WHERE id = 've_macrosector';

UPDATE config_form_fields SET iseditable=true WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname = 'graphconfig';
UPDATE config_form_fields SET widgettype='text' WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('created_at', 'updated_at');

UPDATE config_form_fields SET placeholder=NULL WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('expl_id', 'sector_id', 'muni_id') AND iseditable=false;

UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyLocal="1" maxScale="0" autoRefreshTime="0" styleCategories="Symbology|Labeling|Rendering" simplifyMaxScale="1" labelsEnabled="1" simplifyDrawingHints="0" autoRefreshMode="Disabled" hasScaleBasedVisibilityFlag="1" minScale="1500" symbologyReferenceScale="-1" simplifyDrawingTol="1" version="3.40.8-Bratislava" simplifyAlgorithm="0">
  <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0" referencescale="-1">
    <symbols>
      <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="marker" force_rhr="0" name="0" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" id="{530097a1-86f2-4db3-9af9-68575db8c144}" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="angle">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="field" value="rotation"/>
                  <Option type="int" name="type" value="2"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="SimpleMarker" enabled="1" locked="0" id="{cd778ca5-e978-4413-a92f-4f163f504401}" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255,rgb:1,0,0,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="cross"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="3"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="angle">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="field" value="rotation"/>
                  <Option type="int" name="type" value="2"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="marker" force_rhr="0" name="" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" id="{c50ba677-e9a0-4034-8295-19ccf19b4a32}" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255,rgb:1,0,0,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style blendMode="0" textOrientation="horizontal" fieldName="arc_id" isExpression="0" textOpacity="1" stretchFactor="100" capitalization="0" multilineHeightUnit="Percentage" fontFamily="Arial" fontKerning="1" legendString="Aa" fontSizeUnit="Point" textColor="50,50,50,255,rgb:0.19607843137254902,0.19607843137254902,0.19607843137254902,1" allowHtml="0" forcedItalic="0" fontItalic="0" fontSize="8" namedStyle="Normal" fontWordSpacing="0" tabStopDistance="80" forcedBold="0" fontStrikeout="0" multilineHeight="1" fontWeight="50" fontLetterSpacing="0" previewBkgrdColor="255,255,255,255,rgb:1,1,1,1" fontSizeMapUnitScale="3x:0,0,0,0,0,0" tabStopDistanceUnit="Point" fontUnderline="0" tabStopDistanceMapUnitScale="3x:0,0,0,0,0,0" useSubstitutions="0">
        <families/>
        <text-buffer bufferNoFill="1" bufferOpacity="1" bufferBlendMode="0" bufferSize="1" bufferDraw="0" bufferColor="250,250,250,255,rgb:0.98039215686274506,0.98039215686274506,0.98039215686274506,1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferJoinStyle="128"/>
        <text-mask maskSizeUnits="MM" maskJoinStyle="128" maskEnabled="0" maskType="0" maskSize2="1.5" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers="" maskSize="1.5" maskOpacity="1"/>
        <background shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="Point" shapeFillColor="255,255,255,255,rgb:1,1,1,1" shapeType="0" shapeOffsetY="0" shapeSizeType="0" shapeRotationType="0" shapeBorderColor="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1" shapeSVGFile="" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOpacity="1" shapeRadiiX="0" shapeDraw="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRotation="0" shapeSizeX="0" shapeRadiiUnit="Point" shapeBorderWidthUnit="Point" shapeBlendMode="0" shapeJoinStyle="64" shapeOffsetX="0" shapeOffsetUnit="Point" shapeSizeY="0" shapeBorderWidth="0">
          <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="marker" force_rhr="0" name="markerSymbol" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" enabled="1" locked="0" id="" pass="0">
              <Option type="Map">
                <Option type="QString" name="angle" value="0"/>
                <Option type="QString" name="cap_style" value="square"/>
                <Option type="QString" name="color" value="141,90,153,255,rgb:0.55294117647058827,0.35294117647058826,0.59999999999999998,1"/>
                <Option type="QString" name="horizontal_anchor_point" value="1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="name" value="circle"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
                <Option type="QString" name="outline_style" value="solid"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="scale_method" value="diameter"/>
                <Option type="QString" name="size" value="2"/>
                <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="size_unit" value="MM"/>
                <Option type="QString" name="vertical_anchor_point" value="1"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="fill" force_rhr="0" name="fillSymbol" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleFill" enabled="1" locked="0" id="" pass="0">
              <Option type="Map">
                <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="color" value="255,255,255,255,rgb:1,1,1,1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1"/>
                <Option type="QString" name="outline_style" value="no"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_unit" value="Point"/>
                <Option type="QString" name="style" value="solid"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowUnder="0" shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255,rgb:0,0,0,1" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowScale="100" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowOffsetAngle="135" shadowRadius="1.5" shadowRadiusAlphaOnly="0" shadowBlendMode="6" shadowRadiusUnit="MM"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format placeDirectionSymbol="0" formatNumbers="0" useMaxLineLengthForAutoWrap="1" multilineAlign="3" addDirectionSymbol="0" rightDirectionSymbol=">" reverseDirectionSymbol="0" decimals="3" plussign="0" leftDirectionSymbol="&lt;" wrapChar="" autoWrapLength="0"/>
      <placement offsetUnits="MM" prioritization="PreferCloser" repeatDistanceUnits="MM" allowDegraded="0" xOffset="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" maximumDistanceUnit="MM" offsetType="1" lineAnchorType="0" geometryGeneratorEnabled="0" centroidInside="0" geometryGenerator="" yOffset="0" layerType="PointGeometry" centroidWhole="0" maxCurvedCharAngleIn="25" dist="0" priority="5" distMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" overrunDistanceUnit="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorClipping="0" maximumDistanceMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" polygonPlacementFlags="2" maximumDistance="0" placementFlags="10" placement="6" preserveRotation="1" overrunDistance="0" overlapHandling="PreventOverlap" fitInPolygonOnly="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" lineAnchorPercent="0.5" maxCurvedCharAngleOut="-25" distUnits="MM" repeatDistance="0" rotationUnit="AngleDegrees" lineAnchorTextPoint="FollowPlacement" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
      <rendering scaleMin="0" mergeLines="0" unplacedVisibility="0" obstacle="1" obstacleType="1" scaleVisibility="1" fontLimitPixelSize="0" limitNumLabels="0" scaleMax="1000" upsidedownLabels="0" obstacleFactor="1" fontMinPixelSize="3" maxNumLabels="2000" labelPerPart="0" minFeatureSize="0" drawLabels="1" fontMaxPixelSize="10000" zIndex="0"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" name="name" value=""/>
          <Option name="properties"/>
          <Option type="QString" name="type" value="collection"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" name="anchorPoint" value="pole_of_inaccessibility"/>
          <Option type="int" name="blendMode" value="0"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
          <Option type="bool" name="drawToAllParts" value="false"/>
          <Option type="QString" name="enabled" value="0"/>
          <Option type="QString" name="labelAnchorPoint" value="point_on_exterior"/>
          <Option type="QString" name="lineSymbol" value="&lt;symbol is_animated=&quot;0&quot; clip_to_extent=&quot;1&quot; frame_rate=&quot;10&quot; type=&quot;line&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; alpha=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; locked=&quot;0&quot; id=&quot;{4d5a862b-025f-4912-9d96-397d898dc724}&quot; pass=&quot;0&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;align_dash_pattern&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;capstyle&quot; value=&quot;square&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash&quot; value=&quot;5;2&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;draw_inside_polygon&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;joinstyle&quot; value=&quot;bevel&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_color&quot; value=&quot;60,60,60,255,rgb:0.23529411764705882,0.23529411764705882,0.23529411764705882,1&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_style&quot; value=&quot;solid&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width&quot; value=&quot;0.3&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;ring_filter&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;tweak_dash_pattern_on_corners&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;use_custom_dash&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;width_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>"/>
          <Option type="double" name="minLength" value="0"/>
          <Option type="QString" name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="minLengthUnit" value="MM"/>
          <Option type="double" name="offsetFromAnchor" value="0"/>
          <Option type="QString" name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromAnchorUnit" value="MM"/>
          <Option type="double" name="offsetFromLabel" value="0"/>
          <Option type="QString" name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromLabelUnit" value="MM"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_connec' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyLocal="1" maxScale="0" autoRefreshTime="0" styleCategories="Symbology|Labeling|Rendering" simplifyMaxScale="1" labelsEnabled="1" simplifyDrawingHints="0" autoRefreshMode="Disabled" hasScaleBasedVisibilityFlag="1" minScale="1500" symbologyReferenceScale="-1" simplifyDrawingTol="1" version="3.40.8-Bratislava" simplifyAlgorithm="0">
  <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0" referencescale="-1">
    <symbols>
      <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="marker" force_rhr="0" name="0" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" id="{3eb53a79-7a30-4451-94ba-61a4c5450970}" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,255,255,0,rgb:1,1,1,0"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="65,62,62,255,rgb:0.25490196078431371,0.24313725490196078,0.24313725490196078,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="1.6"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="marker" force_rhr="0" name="" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" id="{77f9622a-3131-4a52-9ac8-9531f513a65a}" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255,rgb:1,0,0,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style blendMode="0" textOrientation="horizontal" fieldName="arc_id" isExpression="0" textOpacity="1" stretchFactor="100" capitalization="0" multilineHeightUnit="Percentage" fontFamily="Arial" fontKerning="1" legendString="Aa" fontSizeUnit="Point" textColor="50,50,50,255,rgb:0.19607843137254902,0.19607843137254902,0.19607843137254902,1" allowHtml="0" forcedItalic="0" fontItalic="0" fontSize="8" namedStyle="Normal" fontWordSpacing="0" tabStopDistance="80" forcedBold="0" fontStrikeout="0" multilineHeight="1" fontWeight="50" fontLetterSpacing="0" previewBkgrdColor="255,255,255,255,rgb:1,1,1,1" fontSizeMapUnitScale="3x:0,0,0,0,0,0" tabStopDistanceUnit="Point" fontUnderline="0" tabStopDistanceMapUnitScale="3x:0,0,0,0,0,0" useSubstitutions="0">
        <families/>
        <text-buffer bufferNoFill="1" bufferOpacity="1" bufferBlendMode="0" bufferSize="1" bufferDraw="0" bufferColor="250,250,250,255,rgb:0.98039215686274506,0.98039215686274506,0.98039215686274506,1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferJoinStyle="128"/>
        <text-mask maskSizeUnits="MM" maskJoinStyle="128" maskEnabled="0" maskType="0" maskSize2="1.5" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers="" maskSize="1.5" maskOpacity="1"/>
        <background shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="Point" shapeFillColor="255,255,255,255,rgb:1,1,1,1" shapeType="0" shapeOffsetY="0" shapeSizeType="0" shapeRotationType="0" shapeBorderColor="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1" shapeSVGFile="" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOpacity="1" shapeRadiiX="0" shapeDraw="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRotation="0" shapeSizeX="0" shapeRadiiUnit="Point" shapeBorderWidthUnit="Point" shapeBlendMode="0" shapeJoinStyle="64" shapeOffsetX="0" shapeOffsetUnit="Point" shapeSizeY="0" shapeBorderWidth="0">
          <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="marker" force_rhr="0" name="markerSymbol" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" enabled="1" locked="0" id="" pass="0">
              <Option type="Map">
                <Option type="QString" name="angle" value="0"/>
                <Option type="QString" name="cap_style" value="square"/>
                <Option type="QString" name="color" value="232,113,141,255,rgb:0.90980392156862744,0.44313725490196076,0.55294117647058827,1"/>
                <Option type="QString" name="horizontal_anchor_point" value="1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="name" value="circle"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
                <Option type="QString" name="outline_style" value="solid"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="scale_method" value="diameter"/>
                <Option type="QString" name="size" value="2"/>
                <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="size_unit" value="MM"/>
                <Option type="QString" name="vertical_anchor_point" value="1"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol is_animated="0" clip_to_extent="1" frame_rate="10" type="fill" force_rhr="0" name="fillSymbol" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleFill" enabled="1" locked="0" id="" pass="0">
              <Option type="Map">
                <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="color" value="255,255,255,255,rgb:1,1,1,1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1"/>
                <Option type="QString" name="outline_style" value="no"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_unit" value="Point"/>
                <Option type="QString" name="style" value="solid"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowUnder="0" shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255,rgb:0,0,0,1" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowScale="100" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowOffsetAngle="135" shadowRadius="1.5" shadowRadiusAlphaOnly="0" shadowBlendMode="6" shadowRadiusUnit="MM"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format placeDirectionSymbol="0" formatNumbers="0" useMaxLineLengthForAutoWrap="1" multilineAlign="3" addDirectionSymbol="0" rightDirectionSymbol=">" reverseDirectionSymbol="0" decimals="3" plussign="0" leftDirectionSymbol="&lt;" wrapChar="" autoWrapLength="0"/>
      <placement offsetUnits="MM" prioritization="PreferCloser" repeatDistanceUnits="MM" allowDegraded="0" xOffset="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" maximumDistanceUnit="MM" offsetType="1" lineAnchorType="0" geometryGeneratorEnabled="0" centroidInside="0" geometryGenerator="" yOffset="0" layerType="PointGeometry" centroidWhole="0" maxCurvedCharAngleIn="25" dist="0" priority="5" distMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" overrunDistanceUnit="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorClipping="0" maximumDistanceMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" polygonPlacementFlags="2" maximumDistance="0" placementFlags="10" placement="6" preserveRotation="1" overrunDistance="0" overlapHandling="PreventOverlap" fitInPolygonOnly="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" lineAnchorPercent="0.5" maxCurvedCharAngleOut="-25" distUnits="MM" repeatDistance="0" rotationUnit="AngleDegrees" lineAnchorTextPoint="FollowPlacement" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
      <rendering scaleMin="0" mergeLines="0" unplacedVisibility="0" obstacle="1" obstacleType="1" scaleVisibility="1" fontLimitPixelSize="0" limitNumLabels="0" scaleMax="1000" upsidedownLabels="0" obstacleFactor="1" fontMinPixelSize="3" maxNumLabels="2000" labelPerPart="0" minFeatureSize="0" drawLabels="1" fontMaxPixelSize="10000" zIndex="0"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" name="name" value=""/>
          <Option name="properties"/>
          <Option type="QString" name="type" value="collection"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" name="anchorPoint" value="pole_of_inaccessibility"/>
          <Option type="int" name="blendMode" value="0"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
          <Option type="bool" name="drawToAllParts" value="false"/>
          <Option type="QString" name="enabled" value="0"/>
          <Option type="QString" name="labelAnchorPoint" value="point_on_exterior"/>
          <Option type="QString" name="lineSymbol" value="&lt;symbol is_animated=&quot;0&quot; clip_to_extent=&quot;1&quot; frame_rate=&quot;10&quot; type=&quot;line&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; alpha=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; locked=&quot;0&quot; id=&quot;{ea00919f-ced0-4fbc-bfa4-f8e1bb148e15}&quot; pass=&quot;0&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;align_dash_pattern&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;capstyle&quot; value=&quot;square&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash&quot; value=&quot;5;2&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;draw_inside_polygon&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;joinstyle&quot; value=&quot;bevel&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_color&quot; value=&quot;60,60,60,255,rgb:0.23529411764705882,0.23529411764705882,0.23529411764705882,1&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_style&quot; value=&quot;solid&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width&quot; value=&quot;0.3&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;ring_filter&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;tweak_dash_pattern_on_corners&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;use_custom_dash&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;width_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>"/>
          <Option type="double" name="minLength" value="0"/>
          <Option type="QString" name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="minLengthUnit" value="MM"/>
          <Option type="double" name="offsetFromAnchor" value="0"/>
          <Option type="QString" name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromAnchorUnit" value="MM"/>
          <Option type="double" name="offsetFromLabel" value="0"/>
          <Option type="QString" name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromLabelUnit" value="MM"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_gully' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis hasScaleBasedVisibilityFlag="0" autoRefreshTime="0" maxScale="0" simplifyLocal="1" labelsEnabled="1" minScale="0" simplifyAlgorithm="0" simplifyDrawingTol="1" symbologyReferenceScale="-1" version="3.40.4-Bratislava" styleCategories="LayerConfiguration|Symbology|Symbology3D|Labeling|Rendering" autoRefreshMode="Disabled" simplifyDrawingHints="1" readOnly="0" simplifyMaxScale="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <renderer-v2 symbollevels="0" enableorderby="0" referencescale="-1" forceraster="0" attr="state" type="categorizedSymbol">
    <categories>
      <category value="0" label="OBSOLETE" symbol="0" type="double" render="true" uuid="{80823eb1-ba4e-4517-8d07-82b656725f9b}"/>
      <category value="1" label="OPERATIVE" symbol="1" type="string" render="true" uuid="{718813e6-c212-4d14-b2d5-b98922743e2c}"/>
      <category value="2" label="PLANIFIED" symbol="2" type="double" render="true" uuid="{f2a68c83-ffba-48c2-9142-acb8ab246deb}"/>
    </categories>
    <symbols>
      <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" locked="0" pass="0" enabled="1" id="{125567a8-a047-460b-9af5-14ba91bb9a69}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.36" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#10;when cat_geom1 is not null then&#10;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/4) + 0.720)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="MarkerLine" locked="0" pass="0" enabled="1" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#10;when cat_geom1 is not null then&#10;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/4) + 0.720)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="@0@1" type="marker" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" locked="0" pass="0" enabled="1" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="filled_arrowhead" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="0.36" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="size" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE &#10;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#10;WHEN @map_scale  > 1000 THEN 0&#10;END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="1" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" locked="0" pass="0" enabled="1" id="{125567a8-a047-460b-9af5-14ba91bb9a69}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.36" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#10;when cat_geom1 is not null then&#10;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/4) + 0.720)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="SimpleLine" locked="0" pass="0" enabled="1" id="{7684a725-426f-47d3-859a-9e4bb0b9a024}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="219,219,219,0,hsv:0,0,0.86047150377660797,0" name="line_color" type="QString"/>
            <Option value="dot" name="line_style" type="QString"/>
            <Option value="0.3" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineColor" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when initoverflowpath = true then color_rgba(255,255,255,200) else color_rgba(100,100,100,0) end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.1 + 0.415 * ln((cat_geom1*cat_geom2) + 0.10)&#10;when cat_geom1 is not null then&#10;0.1 + 0.415 * ln((3.14*cat_geom1*cat_geom1/4) + 0.10)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="MarkerLine" locked="0" pass="0" enabled="1" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#10;when cat_geom1 is not null then&#10;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/4) + 0.720)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="@1@2" type="marker" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" locked="0" pass="0" enabled="1" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="filled_arrowhead" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2.56" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="size" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE &#10;WHEN  @map_scale  &lt;= 1500 THEN 3.0 &#10;WHEN @map_scale  > 1500 THEN 0&#10;END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="2" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" locked="0" pass="0" enabled="1" id="{125567a8-a047-460b-9af5-14ba91bb9a69}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.36" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#10;when cat_geom1 is not null then&#10;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/4) + 0.720)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="MarkerLine" locked="0" pass="0" enabled="1" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when cat_geom2 > 1 and  cat_geom2 < 10 then&#10;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#10;when cat_geom1 is not null then&#10;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/4) + 0.720)&#10;else 0.35 end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="@2@1" type="marker" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" locked="0" pass="0" enabled="1" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="filled_arrowhead" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="0.36" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="size" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE &#10;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#10;WHEN @map_scale  > 1000 THEN 0&#10;END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" locked="0" pass="0" enabled="1" id="{3803a869-1bdf-438a-bb5c-37d3f352e512}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.36" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#10;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#10;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#10;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="MarkerLine" locked="0" pass="0" enabled="1" id="{737b3486-832c-473a-a370-2cfc286e6e75}">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#10;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#10;WHEN @map_scale  > 5000 THEN 0&#10;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="@0@1" type="marker" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" locked="0" pass="0" enabled="1" id="{48a00b63-2aee-4e04-a1cf-ef06d7691b80}">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="filled_arrowhead" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="0.36" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="size" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE &#10;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#10;WHEN @map_scale  > 1000 THEN 0&#10;END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" locked="0" pass="0" enabled="1" id="{3eade21d-240a-43fc-8947-ccec8cc9a73f}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.26" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fontItalic="0" tabStopDistanceUnit="Point" previewBkgrdColor="255,255,255,255,rgb:1,1,1,1" fontUnderline="0" fontFamily="Arial" textOrientation="horizontal" multilineHeight="1" legendString="Aa" fontSizeUnit="Point" fontKerning="1" fieldName="arccat_id" tabStopDistance="80" tabStopDistanceMapUnitScale="3x:0,0,0,0,0,0" allowHtml="0" textOpacity="1" fontWordSpacing="0" multilineHeightUnit="Percentage" capitalization="0" useSubstitutions="0" forcedBold="0" fontWeight="50" blendMode="0" fontSize="8" fontLetterSpacing="0" textColor="50,50,50,255,rgb:0.19607843137254902,0.19607843137254902,0.19607843137254902,1" isExpression="0" forcedItalic="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" namedStyle="Normal" fontStrikeout="0">
        <families/>
        <text-buffer bufferSize="1" bufferNoFill="1" bufferSizeUnits="MM" bufferOpacity="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferJoinStyle="128" bufferColor="250,250,250,255,rgb:0.98039215686274506,0.98039215686274506,0.98039215686274506,1" bufferBlendMode="0" bufferDraw="0"/>
        <text-mask maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskSize2="1.5" maskSizeUnits="MM" maskSize="1.5" maskEnabled="0" maskType="0" maskOpacity="1" maskedSymbolLayers="" maskJoinStyle="128"/>
        <background shapeSizeType="0" shapeBorderWidthUnit="Point" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRotationType="0" shapeBorderWidth="0" shapeType="0" shapeSVGFile="" shapeFillColor="255,255,255,255,rgb:1,1,1,1" shapeJoinStyle="64" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="Point" shapeOffsetY="0" shapeSizeUnit="Point" shapeSizeX="0" shapeRadiiY="0" shapeRotation="0" shapeOpacity="1" shapeDraw="0" shapeBorderColor="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="Point" shapeSizeY="0" shapeBlendMode="0" shapeOffsetX="0" shapeRadiiX="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0">
          <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="markerSymbol" type="marker" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" locked="0" pass="0" enabled="1" id="">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="231,113,72,255,rgb:0.90588235294117647,0.44313725490196076,0.28235294117647058,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol clip_to_extent="1" force_rhr="0" alpha="1" is_animated="0" name="fillSymbol" type="fill" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleFill" locked="0" pass="0" enabled="1" id="">
              <Option type="Map">
                <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
                <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1" name="outline_color" type="QString"/>
                <Option value="no" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="Point" name="outline_width_unit" type="QString"/>
                <Option value="solid" name="style" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowOpacity="0.69999999999999996" shadowDraw="0" shadowUnder="0" shadowBlendMode="6" shadowRadius="1.5" shadowScale="100" shadowOffsetAngle="135" shadowOffsetGlobal="1" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusAlphaOnly="0" shadowRadiusUnit="MM" shadowColor="0,0,0,255,rgb:0,0,0,1"/>
        <dd_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format addDirectionSymbol="0" decimals="3" formatNumbers="0" multilineAlign="0" plussign="0" placeDirectionSymbol="0" rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" leftDirectionSymbol="&lt;" wrapChar="" reverseDirectionSymbol="0" autoWrapLength="0"/>
      <placement centroidWhole="0" offsetType="0" polygonPlacementFlags="2" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorEnabled="0" centroidInside="0" prioritization="PreferCloser" overrunDistanceUnit="MM" quadOffset="4" distMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" xOffset="0" priority="5" placementFlags="10" lineAnchorPercent="0.5" lineAnchorTextPoint="FollowPlacement" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" overlapHandling="PreventOverlap" repeatDistance="0" lineAnchorType="0" overrunDistance="0" placement="2" offsetUnits="MM" allowDegraded="0" geometryGeneratorType="PointGeometry" rotationUnit="AngleDegrees" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" rotationAngle="0" lineAnchorClipping="0" repeatDistanceUnits="MM" geometryGenerator="" maximumDistanceUnit="MM" yOffset="0" maximumDistance="0" distUnits="MM" maxCurvedCharAngleIn="25" maximumDistanceMapUnitScale="3x:0,0,0,0,0,0" fitInPolygonOnly="0" maxCurvedCharAngleOut="-25" layerType="LineGeometry"/>
      <rendering zIndex="0" scaleMin="0" fontMaxPixelSize="10000" fontLimitPixelSize="0" fontMinPixelSize="3" maxNumLabels="2000" unplacedVisibility="0" drawLabels="1" scaleMax="1000" scaleVisibility="1" minFeatureSize="0" obstacleType="1" mergeLines="0" obstacle="1" obstacleFactor="1" limitNumLabels="0" upsidedownLabels="0" labelPerPart="0"/>
      <dd_properties>
        <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
          <Option value="0" name="blendMode" type="int"/>
          <Option name="ddProperties" type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
          <Option value="false" name="drawToAllParts" type="bool"/>
          <Option value="0" name="enabled" type="QString"/>
          <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
          <Option value="&lt;symbol clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot; alpha=&quot;1&quot; is_animated=&quot;0&quot; name=&quot;symbol&quot; type=&quot;line&quot; frame_rate=&quot;10&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer class=&quot;SimpleLine&quot; locked=&quot;0&quot; pass=&quot;0&quot; enabled=&quot;1&quot; id=&quot;{1a8612c9-6c68-4e45-9fdf-7aa3775daa24}&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255,rgb:0.23529411764705882,0.23529411764705882,0.23529411764705882,1&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
          <Option value="0" name="minLength" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
          <Option value="MM" name="minLengthUnit" type="QString"/>
          <Option value="0" name="offsetFromAnchor" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
          <Option value="0" name="offsetFromLabel" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <previewExpression>"descript"</previewExpression>
  <layerGeometryType>1</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_arc' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis autoRefreshTime="0" simplifyDrawingHints="1" simplifyMaxScale="1" minScale="10000" simplifyLocal="1" maxScale="0" version="3.40.8-Bratislava" styleCategories="Symbology|Rendering" symbologyReferenceScale="-1" hasScaleBasedVisibilityFlag="1" autoRefreshMode="Disabled" simplifyAlgorithm="0" simplifyDrawingTol="1">
  <renderer-v2 referencescale="-1" symbollevels="0" attr="epa_type" forceraster="0" type="categorizedSymbol" enableorderby="0">
    <categories>
      <category label="Flow regulator ORIFICE" symbol="0" uuid="{d0547662-4ed3-4cf1-bba0-fb08d679aeb7}" render="true" value="FRORIFICE" type="string"/>
      <category label="Flow regulator WEIR" symbol="1" uuid="{f10e416b-8b5d-4607-8d86-8bf12cea1869}" render="true" value="FRWEIR" type="string"/>
      <category label="Flow regulator PUMP" symbol="2" uuid="{bdcdc8f9-e728-41c1-bb9d-c34a7ec50b07}" render="true" value="FRPUMP" type="string"/>
      <category label="Flow regulator OUTLET" symbol="3" uuid="{791dc514-8d05-4949-afff-6aa7ba9c1e5b}" render="true" value="FROUTLET" type="string"/>
    </categories>
    <symbols>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="0" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="175,186,23,128,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@0@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="175,186,23,255,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="R" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="175,186,23,255,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="1" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="234,237,205,128,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@1@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="234,237,205,255,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="W" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="234,237,205,255,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="2" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="255,127,0,128,rgb:1,0.49803921568627452,0,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@2@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="P" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="3" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="30,116,186,128,hsv:0.57477777777777783,0.83938353551537348,0.72941176470588232,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@3@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="30,116,186,255,hsv:0.57477777777777783,0.83938353551537348,0.72941176470588232,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="L" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="30,116,186,255,hsv:0.57477777777777783,0.83938353551537348,0.72941176470588232,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="0" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{4cffe4cf-56b8-437b-960e-bdd6847ff482}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="225,89,137,255,rgb:0.88235294117647056,0.34901960784313724,0.53725490196078429,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{e1f7db85-eea8-4093-90cd-b96fa9b90260}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>1</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_man_frelem' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" symbollevels="0" forceraster="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="0" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="234,237,205,128,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@0@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="234,237,205,255,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="W" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="234,237,205,255,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{1249c014-e132-477d-a1d7-7a65d7024ea6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_inp_weir' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" symbollevels="0" forceraster="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="0" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="255,127,0,128,rgb:1,0.49803921568627452,0,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@0@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="P" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{bb3087e0-50a0-4430-8bd3-006b61ebaafb}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_inp_pump' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" symbollevels="0" forceraster="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="0" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="175,186,23,128,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@0@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="175,186,23,255,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="R" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="175,186,23,255,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{76149b8e-7aff-4d69-81e6-c096ab868a11}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_inp_orifice' AND styleconfig_id=101;


UPDATE sys_style
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" symbollevels="0" forceraster="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="0" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{26f7c2f5-9fe9-466d-b138-ca04159644f6}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2.6" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{5166b5a2-a76e-4eb2-9a72-8d008186d107}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="30,116,186,128,hsv:0.57477777777777783,0.83938353551537348,0.72941176470588232,0.50000762951094835" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="2" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" locked="0" pass="0" id="{3877e09a-9553-4852-9456-770494abb6fa}" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="CentralPoint" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="@0@2" frame_rate="10" alpha="1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer enabled="1" locked="0" pass="0" id="{2df35a6f-952b-41c1-bb4f-61ca75c279ea}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="90" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="30,116,186,255,hsv:0.57477777777777783,0.83938353551537348,0.72941176470588232,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3.8" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{bdb3b393-ca82-4d3d-b537-1bbadebf5ee0}" class="FontMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="chr" value="L" type="QString"/>
                <Option name="color" value="0,0,0,255,rgb:0,0,0,1" type="QString"/>
                <Option name="font" value="Arial" type="QString"/>
                <Option name="font_style" value="Normal" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,-0.20000000000000007" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="size" value="2.3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer enabled="1" locked="0" pass="0" id="{60a10c90-06d8-418d-af7b-fea7e4472047}" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="30,116,186,255,hsv:0.57477777777777783,0.83938353551537348,0.72941176470588232,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="filled_arrowhead" type="QString"/>
                <Option name="offset" value="-1.60000000000000009,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0.3" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="3" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" clip_to_extent="1" name="" frame_rate="10" alpha="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" locked="0" pass="0" id="{fa796aa3-1c80-439e-abe4-4b93ed5fa667}" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>', active=true
WHERE layername='ve_inp_outlet' AND styleconfig_id=101;

ALTER TABLE inp_frorifice ALTER COLUMN flap DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN cd DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN shape DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN geom1 DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN geom2 DROP NOT NULL;


ALTER TABLE om_waterbalance_dma_graph ADD CONSTRAINT om_waterbalance_dma_graph_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE arc ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE connec ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE gully ADD CONSTRAINT gully_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE link ADD CONSTRAINT link_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE node ADD CONSTRAINT node_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);

CREATE RULE omzone_conflict AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = '-1'::integer) OR (old.omzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE omzone_undefined AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = 0) OR (old.omzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;

CREATE RULE dwfzone_conflict AS
    ON UPDATE TO dwfzone
   WHERE ((new.dwfzone_id = '-1'::integer) OR (old.dwfzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dwfzone_undefined AS
    ON UPDATE TO dwfzone
   WHERE ((new.dwfzone_id = 0) OR (old.dwfzone_id = 0)) DO INSTEAD NOTHING;


-- expl_id is not void
CREATE RULE dma_expl AS
    ON UPDATE TO dma
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE RULE dwfzone_expl AS
    ON UPDATE TO dwfzone
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE RULE omzone_expl AS
    ON UPDATE TO omzone
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frpump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frorifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frweir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_froutlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_ui_element_x_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('gully');

DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON exploitation;
DO $$
DECLARE
    v_utils boolean;
BEGIN
    SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';
    IF v_utils THEN
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id", "macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "utils.municipality":"expl_id", "omzone":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id", "macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "utils.municipality":"expl_id", "omzone":"expl_id"}');
    ELSE
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id", "macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id", "omzone":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id", "macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id", "omzone":"expl_id"}');
    END IF;
END$$;

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');


CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dwfzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_drainzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macroomzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');
