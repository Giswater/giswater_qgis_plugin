/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE inp_coverage DROP CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey;
ALTER TABLE inp_coverage ADD CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_divider DROP CONSTRAINT inp_divider_arc_id_fkey;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_divider DROP CONSTRAINT inp_divider_curve_id_fkey;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_arccat_id_fkey;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id)
REFERENCES cat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_matcat_id_fkey;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_matcat_id_fkey FOREIGN KEY (matcat_id)
REFERENCES cat_mat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_flwreg_outlet DROP CONSTRAINT inp_dscenario_flwreg_outlet_curve_id_fkey;
ALTER TABLE inp_dscenario_flwreg_outlet ADD CONSTRAINT inp_dscenario_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_flwreg_pump DROP CONSTRAINT inp_dscenario_flwreg_pump_curve_id_fkey;
ALTER TABLE inp_dscenario_flwreg_pump ADD CONSTRAINT inp_dscenario_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows_poll DROP CONSTRAINT inp_dscenario_inflows_pol_poll_id_fkey;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_pol_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows_poll DROP CONSTRAINT inp_dscenario_inflows_pol_timser_id_fkey;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_pol_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows ADD CONSTRAINT inp_dscenario_inflows_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_lid_usage DROP CONSTRAINT inp_dscenario_lid_usage_lidco_id_fkey;
ALTER TABLE inp_dscenario_lid_usage ADD CONSTRAINT inp_dscenario_lid_usage_lidco_id_fkey FOREIGN KEY (lidco_id)
REFERENCES inp_lid (lidco_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_outfall DROP CONSTRAINT inp_dscenario_outfall_timser_id_fkey;
ALTER TABLE inp_dscenario_outfall ADD CONSTRAINT inp_dscenario_outfall_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_outfall DROP CONSTRAINT inp_dscenario_outfall_curve_id_fkey;
ALTER TABLE inp_dscenario_outfall ADD CONSTRAINT inp_dscenario_outfall_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_raingage ADD CONSTRAINT inp_dscenario_raingage_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_storage DROP CONSTRAINT inp_dscenario_storage_curve_id_fkey;
ALTER TABLE inp_dscenario_storage ADD CONSTRAINT inp_dscenario_storage_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_treatment DROP CONSTRAINT inp_treatment_poll_id_fkey;
ALTER TABLE inp_dscenario_treatment ADD CONSTRAINT inp_treatment_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT inp_dwf_pol_x_node_poll_id_fkey;
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_outlet DROP CONSTRAINT inp_flwreg_outlet_curve_id_fkey;
ALTER TABLE inp_flwreg_outlet ADD CONSTRAINT inp_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_pump DROP CONSTRAINT inp_flwreg_pump_to_arc_fkey;
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_pump DROP CONSTRAINT inp_flwreg_pump_curve_id_fkey;
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_weir DROP CONSTRAINT inp_flwreg_weir_to_arc_fkey;
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_inflows_poll DROP CONSTRAINT inp_inflows_pol_x_node_poll_id_fkey;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	
ALTER TABLE inp_inflows_poll DROP CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;	

ALTER TABLE inp_loadings DROP CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey;
ALTER TABLE inp_loadings ADD CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pattern_value DROP CONSTRAINT inp_pattern_pattern_id_fkey;
ALTER TABLE inp_pattern_value ADD CONSTRAINT inp_pattern_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_outfall DROP CONSTRAINT inp_outfall_curve_id_fkey;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_outfall DROP CONSTRAINT inp_outfall_timser_id_fkey;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_outlet DROP CONSTRAINT inp_outlet_curve_id_fkey;
ALTER TABLE inp_outlet ADD CONSTRAINT inp_outlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_curve_id_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_storage DROP CONSTRAINT inp_storage_curve_id_fkey;
ALTER TABLE inp_storage ADD CONSTRAINT inp_storage_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_treatment DROP CONSTRAINT inp_treatment_node_x_pol_poll_id_fkey;
ALTER TABLE inp_treatment ADD CONSTRAINT inp_treatment_node_x_pol_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_washoff DROP CONSTRAINT inp_washoff_land_x_pol_landus_id_fkey;
ALTER TABLE inp_washoff ADD CONSTRAINT inp_washoff_land_x_pol_landus_id_fkey FOREIGN KEY (landus_id)
REFERENCES inp_landuses (landus_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_washoff DROP CONSTRAINT inp_washoff_land_x_pol_poll_id_fkey;
ALTER TABLE inp_washoff ADD CONSTRAINT inp_washoff_land_x_pol_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;