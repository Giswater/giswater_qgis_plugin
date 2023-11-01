/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 1/11/2023
ALTER TABLE inp_connec DROP CONSTRAINT inp_connec_pattern_id_fkey;
ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_connec DROP CONSTRAINT inp_demand_pattern_id_fkey;
ALTER TABLE inp_dscenario_connec ADD CONSTRAINT inp_demand_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_pattern_id_fkey;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inlet DROP CONSTRAINT inp_dscenario_inlet_pattern_id_fkey;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_pattern_id_fkey;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_curve_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	 
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_reservoir DROP CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey;
ALTER TABLE inp_dscenario_reservoir ADD CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_tank DROP CONSTRAINT inp_dscenario_tank_curve_id_fkey;
ALTER TABLE inp_dscenario_tank ADD CONSTRAINT inp_dscenario_tank_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_virtualpump DROP CONSTRAINT inp_dscenario_virtualpump_curve_id_fkey;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_junction DROP CONSTRAINT inp_junction_pattern_id_fkey;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_curve_id_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_to_arc_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
	  
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_curve_id_fkey;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_pattern_id_fkey;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_reservoir DROP CONSTRAINT inp_reservoir_pattern_id_fkey;
ALTER TABLE inp_reservoir ADD CONSTRAINT inp_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_tank DROP CONSTRAINT inp_tank_curve_id_fkey;
ALTER TABLE inp_tank ADD CONSTRAINT inp_tank_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_valve DROP CONSTRAINT inp_valve_curve_id_fkey;
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_virtualpump DROP CONSTRAINT inp_virtualpump_curve_id_fkey;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;	 

ALTER TABLE inp_virtualvalve DROP CONSTRAINT inp_virtualvalve_curve_id_fkey;
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;