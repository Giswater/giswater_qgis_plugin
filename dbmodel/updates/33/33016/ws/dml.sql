/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--23/11/2019
INSERT INTO audit_cat_table VALUES ('inp_virtualvalve', 'Hydraulic input data', 'Used to store valves originally defined as arcs', 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL, false);
INSERT INTO audit_cat_table VALUES ('v_edit_inp_virtualvalve', 'Hydraulic feature', 'Shows editable information about virtualvalves', 'role_epa', 0, NULL, NULL, 2, 'Basic operation', NULL, NULL, false);


INSERT INTO inp_junction (node_id) SELECT node_id FROM node WHERE epa_type='JUNCTION' on conflict (node_id) DO nothing;
INSERT INTO inp_tank (node_id) SELECT node_id FROM node WHERE epa_type='TANK' on conflict (node_id) DO nothing;
INSERT INTO inp_reservoir (node_id) SELECT node_id FROM node WHERE epa_type='RESERVOIR' on conflict (node_id) DO nothing;
INSERT INTO inp_inlet (node_id) SELECT node_id FROM node WHERE epa_type='INLET' on conflict (node_id) DO nothing;
INSERT INTO inp_pump (node_id) SELECT node_id FROM node WHERE epa_type='PUMP' on conflict (node_id) DO nothing;
INSERT INTO inp_shortpipe (node_id) SELECT node_id FROM node WHERE epa_type='SHORTPIPE' on conflict (node_id) DO nothing;
INSERT INTO inp_valve (node_id) SELECT node_id FROM node WHERE epa_type='VALVE' on conflict (node_id) DO nothing;
INSERT INTO inp_virtualvalve (arc_id) SELECT arc_id FROM arc WHERE epa_type='VIRTUALVALVE' on conflict (arc_id) DO nothing;
INSERT INTO inp_pipe (arc_id) SELECT arc_id FROM arc WHERE epa_type='PIPE' on conflict (arc_id) DO nothing;
