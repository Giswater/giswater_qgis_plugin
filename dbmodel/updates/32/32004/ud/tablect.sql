/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE SCHEMA_NAME.inp_flwreg_weir DROP CONSTRAINT IF EXISTS inp_flwreg_weir_check_type;
ALTER TABLE SCHEMA_NAME.inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_check_type CHECK (weir_type::text = ANY (ARRAY['SIDEFLOW','TRANSVERSE','V-NOTCH','TRAPEZOIDAL_WEIR']::text[]));

ALTER TABLE inp_timser_id DROP CONSTRAINT IF EXISTS inp_timser_id_check;

ALTER TABLE inp_rdii ADD CONSTRAINT inp_rdii_hydro_id_fkey FOREIGN KEY (hydro_id) REFERENCES inp_hydrograph_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE rpt_arc ADD CONSTRAINT rpt_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rpt_node ADD CONSTRAINT rpt_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rpt_subcatchment ADD CONSTRAINT rpt_subcatchment_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rpt_summary_subcatchment ADD CONSTRAINT rpt_summary_subcatchment_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rpt_summary_node ADD CONSTRAINT rpt_summary_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rpt_summary_arc ADD CONSTRAINT rpt_summary_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rpt_summary_crossection ADD CONSTRAINT rpt_summary_crossection_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_arc ADD CONSTRAINT cat_arc_tsect_id_fkey FOREIGN KEY (tsect_id) REFERENCES inp_transects_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE cat_arc ADD CONSTRAINT cat_arc_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

--ALTER TABLE inp_washoff_land_x_pol ADD CONSTRAINT inp_whasoff_land_x_pol_funcw_type_fkey FOREIGN KEY (funcw_type) REFERENCES inp_typevalue (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
