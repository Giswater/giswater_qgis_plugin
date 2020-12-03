/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--23/11/2019
INSERT INTO inp_junction (node_id) SELECT node_id FROM node WHERE epa_type='JUNCTION' on conflict (node_id) DO nothing;
INSERT INTO inp_outfall (node_id) SELECT node_id FROM node WHERE epa_type='OUTFALL' on conflict (node_id) DO nothing;
INSERT INTO inp_storage (node_id) SELECT node_id FROM node WHERE epa_type='STORAGE' on conflict (node_id) DO nothing;
INSERT INTO inp_divider (node_id) SELECT node_id FROM node WHERE epa_type='DIVIDER' on conflict (node_id) DO nothing;
INSERT INTO inp_pump (arc_id) SELECT arc_id FROM node WHERE epa_type='PUMP' on conflict (arc_id) DO nothing;
INSERT INTO inp_conduit (arc_id) SELECT arc_id FROM arc WHERE epa_type='CONDUIT' on conflict (arc_id) DO nothing;
INSERT INTO inp_weir (arc_id) SELECT arc_id FROM arc WHERE epa_type='WEIR' on conflict (arc_id) DO nothing;
INSERT INTO inp_orifice (arc_id) SELECT arc_id FROM arc WHERE epa_type='ORIFICE' on conflict (arc_id) DO nothing;
INSERT INTO inp_outlet (arc_id) SELECT arc_id FROM arc WHERE epa_type='OUTLET' on conflict (arc_id) DO nothing;
INSERT INTO inp_virtual (arc_id) SELECT arc_id FROM arc WHERE epa_type='VIRTUAL' on conflict (arc_id) DO nothing;