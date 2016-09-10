/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Foreign Key system structure
-- ----------------------------
ALTER TABLE "arc" ADD FOREIGN KEY ("epa_type") REFERENCES "inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD FOREIGN KEY ("epa_type") REFERENCES "inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- Foreign Key structure 
-- ----------------------------

ALTER TABLE "inp_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_curve" ADD FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_divider" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_dwf" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_dwf_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_inflows" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_inflows_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_junction" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_node_x_sector" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_node_x_sector" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_orifice" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_options" ADD FOREIGN KEY ("allow_ponding") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("normal_flow_limited") REFERENCES "inp_value_options_nfl" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("inertial_damping") REFERENCES "inp_value_options_id" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("skip_steady_state") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("ignore_quality") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("ignore_routing") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("ignore_groundwater") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("ignore_snowmelt") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("ignore_rainfall") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("force_main_equation") REFERENCES "inp_value_options_fme" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("link_offsets") REFERENCES "inp_value_options_lo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("flow_routing") REFERENCES "inp_value_options_fr" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD FOREIGN KEY ("flow_units") REFERENCES "inp_value_options_fu" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_outlet" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outlet" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_pump" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_rdii" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_report" ADD FOREIGN KEY ("controls") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD FOREIGN KEY ("input") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD FOREIGN KEY ("continuity") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD FOREIGN KEY ("flowstats") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_storage" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_timeseries" ADD FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_treatment_node_x_pol" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_weir" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_arcflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_condsurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_continuity_errors" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_critical_elements" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_flowclass_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_flowrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_groundwater_cont" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_high_conterrors" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_high_flowinest_ind" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_instability_index" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_lidperformance_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodedepth_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodeflooding_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodeinflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodesurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_outfallflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_outfallload_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_pumping_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_qualrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_rainfall_dep" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_routing_timestep" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_runoff_qual" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_runoff_quant" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_storagevol_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_subcatchwashoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_subcathrunoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_timestep_critelem" ADD FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "subcatchment" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "subcatchment" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "subcatchment" ADD FOREIGN KEY ("hydrology_id") REFERENCES "cat_hydrology" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

