/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE anl_flow_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN context DROP NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN cur_user DROP NOT NULL;


ALTER TABLE anl_flow_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN context DROP NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE anl_arc_profile_value ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE anl_arc_profile_value ALTER COLUMN profile_id DROP NOT NULL;


--SET

ALTER TABLE anl_flow_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN context SET NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN cur_user SET NOT NULL;


ALTER TABLE anl_flow_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN context SET NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE anl_arc_profile_value ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE anl_arc_profile_value ALTER COLUMN profile_id SET NOT NULL;
