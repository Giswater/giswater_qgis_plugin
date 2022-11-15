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
  macrodma_id integer,
  descript text,
  undelete boolean,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  minc double precision,
  maxc double precision,
  effc double precision,
  pattern_id character varying(16),
  link text,
  graphconfig json,
  stylesheet json,
  active boolean DEFAULT true,
  avg_press numeric);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);


--2022/09/28
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_1", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"elev1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"y1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_2", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"elev2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"y2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


--2022/11/14
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"cover", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"sandbox", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"cover", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"sandbox", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_step_pp", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_step_fe", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_step_replace", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_cover", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_cover", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"new_sandbox", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_audit_node", "column":"old_sandbox", "dataType":"text", "isUtils":"False"}}$$);