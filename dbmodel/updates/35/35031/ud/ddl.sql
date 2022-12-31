/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE IF NOT EXISTS drainzone
(  drainzone_id serial PRIMARY KEY,
  name character varying(30),
  expl_id integer,
  descript text,
  undelete boolean,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  link text,
  graphconfig json DEFAULT '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json,,
  stylesheet json,
  active boolean DEFAULT true);

ALTER TABLE drainzone ALTER COLUMN graphconfig SET DEFAULT '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);


--2022/09/28
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_1", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"node_sys_top_elev_1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"node_sys_elev_1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_2", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"node_sys_top_elev_2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"node_sys_elev_2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


--2022/11/14
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"cover", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"cover", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_cover", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_cover", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_gully", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"parent_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"dma_id", "dataType":"integer", "isUtils":"False"}}$$);


CREATE TABLE anl_gully (
	id serial4 NOT NULL,
	gully_id varchar(16) NOT NULL,
	gratecat_id varchar(30) NULL,
	state int4 NULL,
	gully_id_aux varchar(16) NULL,
	gratecat_id_aux varchar(30) NULL,
	state_aux int4 NULL,
	expl_id int4 NULL,
	fid int4 NOT NULL,
	cur_user varchar(30) NOT NULL DEFAULT "current_user"(),
	the_geom public.geometry(point, SRID_VALUE) NULL,
	descript text NULL,
	result_id varchar(16) NULL,
	dma_id text NULL,
	CONSTRAINT anl_gully_pkey PRIMARY KEY (id)
);
CREATE INDEX anl_gully_gully_id ON anl_gully USING btree (gully_id);
CREATE INDEX anl_gully_index ON anl_gully USING gist (the_geom);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE inp_timeseries ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_gully", "column":"link_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"REMOVE","table":"plan_psector_x_gully", "column":"link_geom"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"REMOVE","table":"plan_psector_x_gully", "column":"userdefined_geom"}}$$);

-- change pjoint_type (VNODE to ARC)
ALTER TABLE connec DROP CONSTRAINT connec_pjoint_type_ckeck;
UPDATE connec SET pjoint_id = arc_id, pjoint_type = 'ARC' WHERE  pjoint_type = 'VNODE';
UPDATE link SET exit_id = arc_id, exit_type = 'ARC' FROM connec WHERE feature_id = connec_id and exit_type = 'VNODE';
ALTER TABLE connec ADD CONSTRAINT connec_pjoint_type_ckeck CHECK (pjoint_type::text = ANY  (ARRAY['NODE', 'ARC', 'CONNEC', 'GULLY']));

-- change pjoint_type (VNODE to ARC)
ALTER TABLE gully DROP CONSTRAINT gully_pjoint_type_ckeck;
UPDATE gully SET pjoint_id = arc_id, pjoint_type = 'ARC' WHERE  pjoint_type = 'VNODE';
UPDATE link SET exit_id = arc_id, exit_type = 'ARC' FROM gully WHERE feature_id = gully_id and exit_type = 'VNODE';
ALTER TABLE gully ADD CONSTRAINT gully_pjoint_type_ckeck CHECK (pjoint_type::text = ANY (ARRAY['NODE', 'ARC', 'CONNEC', 'GULLY']));


ALTER TABLE plan_psector_x_gully DROP CONSTRAINT plan_psector_x_gully_unique;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_unique UNIQUE(gully_id, psector_id, state);

ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_link_id_fkey FOREIGN KEY (link_id)
REFERENCES link (link_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"exit_elev", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"plan_psector_x_gully", "column":"link_geom", "newName":"_link_geom_" }}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"plan_psector_x_gully", "column":"userdefined_geom", "newName":"_userdefined_geom_"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_gully", "column":"active", "dataType":"boolean"}}$$);
ALTER TABLE plan_psector_x_gully ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_gully", "column":"insert_tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_gully", "column":"insert_user", "dataType":"text", "isUtils":"False"}}$$);

ALTER TABLE plan_psector_x_gully ALTER COLUMN insert_tstamp SET DEFAULT NOW();
ALTER TABLE plan_psector_x_gully ALTER COLUMN insert_user SET DEFAULT CURRENT_USER;

