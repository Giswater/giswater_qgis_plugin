/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/





-- ----------------------------
-- Foreign Key system structure
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- Foreign Key structure 
-- ----------------------------

ALTER TABLE "SCHEMA_NAME"."inp_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD FOREIGN KEY ("curve_id") REFERENCES "SCHEMA_NAME"."inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_divider" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_dwf" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_dwf_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_inflows" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_inflows_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_node_x_sector" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_node_x_sector" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_orifice" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_orifice" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("allow_ponding") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("normal_flow_limited") REFERENCES "SCHEMA_NAME"."inp_value_options_nfl" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("inertial_damping") REFERENCES "SCHEMA_NAME"."inp_value_options_id" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("skip_steady_state") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_quality") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_routing") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_groundwater") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_snowmelt") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_rainfall") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("force_main_equation") REFERENCES "SCHEMA_NAME"."inp_value_options_fme" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("link_offsets") REFERENCES "SCHEMA_NAME"."inp_value_options_lo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("flow_routing") REFERENCES "SCHEMA_NAME"."inp_value_options_fr" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("flow_units") REFERENCES "SCHEMA_NAME"."inp_value_options_fu" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_outlet" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_outlet" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_rdii" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("controls") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("input") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("continuity") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("flowstats") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_storage" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_timeseries" ADD FOREIGN KEY ("timser_id") REFERENCES "SCHEMA_NAME"."inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_treatment_node_x_pol" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_weir" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_weir" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_arcflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_condsurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_continuity_errors" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_critical_elements" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_flowclass_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_flowrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_groundwater_cont" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_high_conterrors" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_high_flowinest_ind" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_instability_index" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_lidperformance_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_nodedepth_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_nodeflooding_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_nodeinflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_nodesurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_outfallflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_outfallload_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_pumping_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_qualrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_rainfall_dep" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_routing_timestep" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_runoff_qual" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_runoff_quant" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_storagevol_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_subcatchwashoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_subcathrunoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_timestep_critelem" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."subcatchment" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."subcatchment" ADD FOREIGN KEY ("hydrology_id") REFERENCES "SCHEMA_NAME"."cat_hydrology" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

