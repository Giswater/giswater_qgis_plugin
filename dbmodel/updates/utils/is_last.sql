/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE SEQUENCE sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
CREATE SEQUENCE point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
--URN
-- ----------------------------
CREATE SEQUENCE urn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
-- ----------------------------
-- STATE TOPOLOGYC COHERENCE
-- ----------------------------
ALTER TABLE value_state ADD COLUMN node_topocoh boolean;
ALTER TABLE value_state ADD COLUMN arc_topocoh boolean;

-- CATALOG OF FUNCTION
INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (190, 'gw_fct_node_state_update', 'trigger function', 'utils', null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (200, 'gw_fct_arc_state_update', 'trigger function', 'utils', null,null);





-- ----------------------------
-- CUSTOM FIELDS
-- ----------------------------
DROP TABLE IF EXISTS man_custom_field_parameter;
CREATE TABLE man_custom_field_parameter(
field_id character varying (50) NOT NULL PRIMARY KEY,
descript character varying (254),
feature_type character varying (18) NOT NULL
);

DROP TABLE IF EXISTS man_custom_field;
CREATE TABLE man_custom_field(
id serial NOT NULL PRIMARY KEY,
field_id character varying (50) NOT NULL,
feature_id character varying (16),
value character varying (50),
tstamp timestamp default now()
);


 ALTER TABLE man_custom_field ADD CONSTRAINT man_custom_field_man_custom_field_parameter_fkey FOREIGN KEY (field_id) REFERENCES man_custom_field_parameter (field_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
  ALTER TABLE man_custom_field_parameter ADD CONSTRAINT man_custom_field_parameter_cat_feature_fkey FOREIGN KEY (feature_type) REFERENCES cat_feature (feature_type) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
 
-- ----------------------------
-- IMPROVE STATE TOPOLOGY COHERENCE TOOLS
-- ----------------------------


-- FIX ANL/MAN TOOLS SELECTOR ONLY WITH ONE ROW
CREATE UNIQUE INDEX anl_selector_state_one_row ON anl_selector_state((id IS NOT NULL));
CREATE UNIQUE INDEX man_selector_state_one_row ON man_selector_state((id IS NOT NULL));


--
ALTER TABLE ws_sample.value_state ADD COLUMN node_topology_coherence boolean;
ALTER TABLE ws_sample.value_state ADD COLUMN arc_topology_coherence boolean;




-- ----------------------------
-- VDEFAULT STRATEGY
-- ----------------------------
CREATE TABLE config_vdefault (
id serial PRIMARY KEY,
"parameter" character varying (30),
"value" character varying (30),
"user" character varying (30)
);
/*
ALTER TABLE config ADD COLUMN state_vdefault character varying(16);
ALTER TABLE config ADD COLUMN workcat_vdefault character varying(30);
ALTER TABLE config ADD COLUMN verified_vdefault character varying(20);
ALTER TABLE config ADD COLUMN builtdate_vdefault date;

ALTER TABLE "config" ADD CONSTRAINT "confige_state_vdefault_fkey" FOREIGN KEY ("state_vdefault") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "config" ADD CONSTRAINT "config_workcat_vdefault_fkey" FOREIGN KEY ("workcat_vdefault") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "config" ADD CONSTRAINT "config_verified_vdefault_fkey" FOREIGN KEY ("verified_vdefault") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "config" ADD CONSTRAINT "config_nodeinsert_catalog_vdefault_fkey" FOREIGN KEY ("nodeinsert_catalog_vdefault") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

*/
-- ----------------------------
-- EXPLOTITATION STRATEGY
-- ----------------------------


CREATE TABLE exploitation(
expl_id integer  NOT NULL PRIMARY KEY,
short_descript character varying(50) NOT NULL,
descript character varying(100),
the_geom geometry(POLYGON,SRID_VALUE),
undelete boolean
);


CREATE TABLE expl_selector (
expl_id integer NOT NULL PRIMARY KEY,
cur_user text
);

ALTER TABLE ext_streetaxis ADD COLUMN expl_id integer;

-- ----------------------------
-- ADDING GEOMETRY TO CATALOG OF WORKS
-- ----------------------------

ALTER TABLE cat_work ADD COLUMN the_geom public.geometry(MULTIPOLYGON, SRID_VALUE);




-- ----------------------------
-- TRACEABILITY
-- ----------------------------


CREATE TABLE om_traceability (
id serial,
type character varying(50),
arc_id character varying(16),
arc_id1 character varying(16),
arc_id2 character varying(16),
node_id character varying(16),
tstamp timestamp(6) without time zone,
"user" character varying(50)
);


 
  -- ----------------------------
-- VALUE DOMAIN ON WEB/MOBILE CLIENT
-- ----------------------------
  
  CREATE TABLE config_client_dvalue
(
  id serial NOT NULL,
  table_id text,
  column_id text,
  dv_table text,
  dv_key_column text,
  dv_value_column text,
  orderby_value boolean,
  allow_null boolean,
  CONSTRAINT config_client_dvalue_pkey PRIMARY KEY (id),
  CONSTRAINT config_client_value_colum_id_fkey FOREIGN KEY (dv_table, dv_key_column)
      REFERENCES db_cat_table_x_column (db_cat_table_id, column_name) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT config_client_value_origin_id_fkey FOREIGN KEY (table_id, column_id)
      REFERENCES db_cat_table_x_column (db_cat_table_id, column_name) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
);




-- ----------------------------
-- IMPROVE VISIT STRATEGY
-- ----------------------------

CREATE TABLE om_visit_cat
(
  id serial NOT NULL,
  type character varying (18),
  short_des character varying (30),
  descript text,
  startdate date DEFAULT now(),
  enddate date,
  CONSTRAINT om_visit_cat_pkey PRIMARY KEY (id)
);



ALTER TABLE om_visit ADD COLUMN visitcat_id integer;


ALTER TABLE om_visit
  ADD CONSTRAINT om_visit_om_visit_cat_id_fkey FOREIGN KEY (visitcat_id)
      REFERENCES om_visit_cat (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;


 
CREATE TABLE om_visit_event_photo
(
  id serial NOT NULL,
  visit_id bigint NOT NULL,
  event_id bigint NOT NULL,
  tstamp timestamp(6) without time zone DEFAULT now(),
  value text,
  text text,
  compass double precision,
  CONSTRAINT om_visit_event_foto_pkey PRIMARY KEY (id),
  CONSTRAINT om_visit_event_foto_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES om_visit_event (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id)
      REFERENCES om_visit (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ----------------------------
-- anl_arc_no_startend_node
-- ----------------------------

ALTER TABLE anl_arc_no_startend_node ADD COLUMN id serial;
ALTER TABLE anl_arc_no_startend_node ALTER COLUMN id SET NOT NULL;
ALTER TABLE anl_arc_no_startend_node DROP CONSTRAINT anl_arc_no_startend_node_pkey;
ALTER TABLE anl_arc_no_startend_node ADD CONSTRAINT anl_arc_no_startend_node_pkey PRIMARY KEY(id);
ALTER TABLE anl_arc_no_startend_node ADD COLUMN the_geom_p geometry(Point,SRID_VALUE);


-- ----------------------------
-- new node_type fields
-- ----------------------------
ALTER TABLE node_type ADD COLUMN order_by integer;
ALTER TABLE node_type ADD COLUMN active_type boolean;



