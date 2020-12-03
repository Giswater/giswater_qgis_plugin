/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE anl_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE anl_node ALTER COLUMN fprocesscat_id DROP NOT NULL;
ALTER TABLE anl_node ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE anl_connec ALTER COLUMN connec_id DROP NOT NULL;
ALTER TABLE anl_connec ALTER COLUMN fprocesscat_id DROP NOT NULL;
ALTER TABLE anl_connec ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE anl_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE anl_arc ALTER COLUMN fprocesscat_id DROP NOT NULL;
ALTER TABLE anl_arc ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE anl_arc_x_node ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE anl_arc_x_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE anl_arc_x_node ALTER COLUMN fprocesscat_id DROP NOT NULL;
ALTER TABLE anl_arc_x_node ALTER COLUMN cur_user DROP NOT NULL;

--SET

ALTER TABLE anl_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE anl_node ALTER COLUMN fprocesscat_id SET NOT NULL;
ALTER TABLE anl_node ALTER COLUMN cur_user SET NOT NULL;


ALTER TABLE anl_connec ALTER COLUMN connec_id SET NOT NULL;
ALTER TABLE anl_connec ALTER COLUMN fprocesscat_id SET NOT NULL;
ALTER TABLE anl_connec ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE anl_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE anl_arc ALTER COLUMN fprocesscat_id SET NOT NULL;
ALTER TABLE anl_arc ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE anl_arc_x_node ALTER COLUMN arc_id SET NOT NULL;
--ALTER TABLE anl_arc_x_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE anl_arc_x_node ALTER COLUMN fprocesscat_id SET NOT NULL;
ALTER TABLE anl_arc_x_node ALTER COLUMN cur_user SET NOT NULL;
