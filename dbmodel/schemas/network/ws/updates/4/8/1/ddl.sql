/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
CREATE INDEX IF NOT EXISTS inp_dscenario_connec_connec_id_idx ON inp_dscenario_connec (connec_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_inlet_node_id_idx ON inp_dscenario_inlet (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_junction_node_id_idx ON inp_dscenario_junction (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_pipe_arc_id_idx ON inp_dscenario_pipe (arc_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_pump_node_id_idx ON inp_dscenario_pump (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_pump_additional_node_id_idx ON inp_dscenario_pump_additional (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_reservoir_node_id_idx ON inp_dscenario_reservoir (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_shortpipe_node_id_idx ON inp_dscenario_shortpipe (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_tank_node_id_idx ON inp_dscenario_tank (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_valve_node_id_idx ON inp_dscenario_valve (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_virtualpump_arc_id_idx ON inp_dscenario_virtualpump (arc_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_virtualvalve_arc_id_idx ON inp_dscenario_virtualvalve (arc_id);
