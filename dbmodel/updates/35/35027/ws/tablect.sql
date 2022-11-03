/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/11
ALTER TABLE om_streetaxis DROP CONSTRAINT IF EXISTS om_streetaxis_exploitation_id_fkey;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_streetaxis DROP CONSTRAINT IF EXISTS om_streetaxis_unique;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_unique UNIQUE(muni_id, id);
ALTER TABLE man_tank DROP CONSTRAINT IF EXISTS man_tank_pol_id_fkey;
ALTER TABLE man_fountain DROP CONSTRAINT IF EXISTS man_fountain_pol_id_fkey;
ALTER TABLE man_register DROP CONSTRAINT IF EXISTS man_register_pol_id_fkey;


--2022/08/19
ALTER TABLE inp_dscenario_virtualvalve DROP CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey;
ALTER TABLE inp_dscenario_virtualvalve ADD CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES inp_virtualvalve (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_tank DROP CONSTRAINT inp_dscenario_tank_node_id_fkey;
ALTER TABLE inp_dscenario_tank ADD CONSTRAINT inp_dscenario_tank_node_id_fkey FOREIGN KEY (node_id)
REFERENCES inp_tank (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_shortpipe DROP CONSTRAINT inp_dscenario_shortpipe_node_id_fkey;
ALTER TABLE inp_dscenario_shortpipe ADD CONSTRAINT inp_dscenario_shortpipe_node_id_fkey FOREIGN KEY (node_id)
REFERENCES inp_shortpipe (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_node_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_node_id_fkey FOREIGN KEY (node_id)
REFERENCES inp_pump (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_node_id_fkey;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_node_id_fkey FOREIGN KEY (node_id)
REFERENCES inp_junction (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_inlet DROP CONSTRAINT inp_dscenario_inlet_node_id_fkey;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_node_id_fkey FOREIGN KEY (node_id)
REFERENCES inp_inlet (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE; 

ALTER TABLE inp_dscenario_connec DROP CONSTRAINT inp_dscenario_connec_connec_id_fkey;
ALTER TABLE inp_dscenario_connec ADD CONSTRAINT inp_dscenario_connec_connec_id_fkey FOREIGN KEY (connec_id)
REFERENCES inp_connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;