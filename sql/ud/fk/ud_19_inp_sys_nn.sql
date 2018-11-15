/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE raingage ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE raingage ALTER COLUMN form_type DROP NOT NULL;
ALTER TABLE raingage ALTER COLUMN rgage_type DROP NOT NULL;

ALTER TABLE cat_hydrology ALTER COLUMN infiltration DROP NOT NULL;

ALTER TABLE inp_selector_hydrology ALTER COLUMN hydrology_id DROP NOT NULL;
ALTER TABLE inp_selector_hydrology ALTER COLUMN cur_user DROP NOT NULL;


ALTER TABLE inp_controls_x_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_controls_x_node ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_controls_x_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE inp_controls_x_arc ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_coverage_land_x_subc ALTER COLUMN percent DROP NOT NULL;

ALTER TABLE inp_curve ALTER COLUMN curve_id DROP NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN "x_value" DROP NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN "y_value" DROP NOT NULL;

ALTER TABLE inp_curve_id ALTER COLUMN curve_type DROP NOT NULL;

ALTER TABLE inp_lid_control ALTER COLUMN lidco_id DROP NOT NULL;
ALTER TABLE inp_lid_control ALTER COLUMN lidco_type DROP NOT NULL;


--FLOW REGULATOR
ALTER TABLE inp_flwreg_orifice ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN to_arc DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN flwreg_id DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN flwreg_length DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN ori_type DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN "offset" DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN cd DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN flap DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN shape DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN geom1 DROP NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN geom2 DROP NOT NULL;

ALTER TABLE inp_flwreg_outlet ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN to_arc DROP NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN flwreg_id DROP NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN flwreg_length DROP NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN outlet_type DROP NOT NULL;

ALTER TABLE inp_flwreg_pump ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN to_arc DROP NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN flwreg_id DROP NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN flwreg_length DROP NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN curve_id DROP NOT NULL;

ALTER TABLE inp_flwreg_weir ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN to_arc DROP NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN flwreg_id DROP NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN flwreg_length DROP NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN weir_type DROP NOT NULL;



--rpt
ALTER TABLE rpt_inp_node ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE rpt_inp_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE rpt_inp_node ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE rpt_inp_node ALTER COLUMN "state" DROP NOT NULL;

ALTER TABLE rpt_inp_arc ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE rpt_inp_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE rpt_inp_arc ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE rpt_inp_arc ALTER COLUMN "state" DROP NOT NULL;

ALTER TABLE rpt_arcflow_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_arcpolload_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_condsurcharge_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_continuity_errors ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_critical_elements ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_flowclass_sum ALTER COLUMN result_id DROP NOT NULL;


ALTER TABLE rpt_groundwater_cont ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_high_conterrors ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_high_flowinest_ind ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_instability_index ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_lidperformance_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_nodedepth_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_nodeflooding_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_nodeinflow_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_nodesurcharge_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_outfallflow_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_outfallload_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_pumping_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_qualrouting_cont ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_rainfall_dep ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_routing_timestep ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_runoff_qual ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_runoff_quant ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_storagevol_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_subcathrunoff_sum ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_timestep_critelem ALTER COLUMN result_id DROP NOT NULL;


--SET

ALTER TABLE raingage ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE raingage ALTER COLUMN form_type SET NOT NULL;
ALTER TABLE raingage ALTER COLUMN rgage_type SET NOT NULL;

ALTER TABLE cat_hydrology ALTER COLUMN infiltration SET NOT NULL;

ALTER TABLE inp_selector_hydrology ALTER COLUMN hydrology_id SET NOT NULL;
ALTER TABLE inp_selector_hydrology ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_conduit ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE inp_controls_x_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_controls_x_node ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_controls_x_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE inp_controls_x_arc ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_coverage_land_x_subc ALTER COLUMN percent SET NOT NULL;

ALTER TABLE inp_curve ALTER COLUMN curve_id SET NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN "x_value" SET NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN "y_value" SET NOT NULL;

ALTER TABLE inp_curve_id ALTER COLUMN curve_type SET NOT NULL;


ALTER TABLE inp_lid_control ALTER COLUMN lidco_id SET NOT NULL;
ALTER TABLE inp_lid_control ALTER COLUMN lidco_type SET NOT NULL;

--FLOW REGULATOR

ALTER TABLE inp_flwreg_orifice ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN to_arc SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN flwreg_id SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN flwreg_length SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN ori_type SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN "offset" SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN cd SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN flap SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN shape SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN geom1 SET NOT NULL;
ALTER TABLE inp_flwreg_orifice ALTER COLUMN geom2 SET NOT NULL;

ALTER TABLE inp_flwreg_outlet ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN to_arc SET NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN flwreg_id SET NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN flwreg_length SET NOT NULL;
ALTER TABLE inp_flwreg_outlet ALTER COLUMN outlet_type SET NOT NULL;

ALTER TABLE inp_flwreg_pump ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN to_arc SET NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN flwreg_id SET NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN flwreg_length SET NOT NULL;
ALTER TABLE inp_flwreg_pump ALTER COLUMN curve_id SET NOT NULL;

ALTER TABLE inp_flwreg_weir ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN to_arc SET NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN flwreg_id SET NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN flwreg_length SET NOT NULL;
ALTER TABLE inp_flwreg_weir ALTER COLUMN weir_type SET NOT NULL;


--rpt
ALTER TABLE rpt_inp_node ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE rpt_inp_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE rpt_inp_node ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE rpt_inp_node ALTER COLUMN "state" SET NOT NULL;

ALTER TABLE rpt_inp_arc ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE rpt_inp_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE rpt_inp_arc ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE rpt_inp_arc ALTER COLUMN "state" SET NOT NULL;

ALTER TABLE rpt_arcflow_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_arcpolload_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_condsurcharge_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_continuity_errors ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_critical_elements ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_flowclass_sum ALTER COLUMN result_id SET NOT NULL;


ALTER TABLE rpt_groundwater_cont ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_high_conterrors ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_high_flowinest_ind ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_instability_index ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_lidperformance_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_nodedepth_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_nodeflooding_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_nodeinflow_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_nodesurcharge_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_outfallflow_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_outfallload_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_pumping_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_qualrouting_cont ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_rainfall_dep ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_routing_timestep ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_runoff_qual ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_runoff_quant ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_storagevol_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_subcathrunoff_sum ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_timestep_critelem ALTER COLUMN result_id SET NOT NULL;