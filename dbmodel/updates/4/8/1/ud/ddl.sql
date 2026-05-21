/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
CREATE INDEX IF NOT EXISTS inp_dscenario_conduit_arc_id_idx ON inp_dscenario_conduit (arc_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_controls_dscenario_id_idx ON inp_dscenario_controls (dscenario_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_frorifice_element_id_idx ON inp_dscenario_frorifice (element_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_froutlet_element_id_idx ON inp_dscenario_froutlet (element_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_frpump_element_id_idx ON inp_dscenario_frpump (element_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_frweir_element_id_idx ON inp_dscenario_frweir (element_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_inflows_node_id_idx ON inp_dscenario_inflows (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_inflows_poll_node_id_idx ON inp_dscenario_inflows_poll (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_inlet_node_id_idx ON inp_dscenario_inlet (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_junction_node_id_idx ON inp_dscenario_junction (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_lids_subc_id_idx ON inp_dscenario_lids (subc_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_outfall_node_id_idx ON inp_dscenario_outfall (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_raingage_rg_id_idx ON inp_dscenario_raingage (rg_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_storage_node_id_idx ON inp_dscenario_storage (node_id);
CREATE INDEX IF NOT EXISTS inp_dscenario_treatment_node_id_idx ON inp_dscenario_treatment (node_id);
