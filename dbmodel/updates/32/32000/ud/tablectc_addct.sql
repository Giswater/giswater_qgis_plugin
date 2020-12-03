/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE arc_type ADD CONSTRAINT arc_type_epa_table_check CHECK (epa_table IN ('inp_conduit', 'inp_orifice', 'inp_outlet','inp_virtual','inp_pump', 'inp_weir'));

ALTER TABLE arc_type ADD CONSTRAINT arc_type_man_table_check CHECK (man_table IN ('man_conduit', 'man_waccel', 'man_varc', 'man_siphon'));

--ALTER TABLE node_type ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table IN ('inp_junction', 'inp_divider', 'inp_storage', 'inp_outfall', 'null'));

ALTER TABLE node_type ADD CONSTRAINT node_type_man_table_check CHECK (man_table IN ('man_chamber', 'man_junction', 'man_manhole', 'man_netelement', 'man_netgully','man_netinit', 'man_outfall', 'man_storage', 'man_valve', 'man_wjump', 'man_wwtp'));

ALTER TABLE connec_type ADD CONSTRAINT connec_type_man_table_check CHECK (man_table IN ('man_connec'));

ALTER TABLE gully_type ADD CONSTRAINT gully_type_man_table_check CHECK (man_table IN ('man_gully'));


ALTER TABLE subcatchment ADD CONSTRAINT subcatchment_snow_id_fkey FOREIGN KEY (snow_id) REFERENCES inp_snowpack_id (snow_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_snowpack ADD CONSTRAINT inp_snowpack_snow_id_fkey FOREIGN KEY (snow_id) REFERENCES inp_snowpack_id (snow_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE inp_aquifer ADD CONSTRAINT inp_aquifer_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_pat1_fkey FOREIGN KEY (pat1) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_pat2_fkey FOREIGN KEY (pat2) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;  
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_pat3_fkey FOREIGN KEY (pat3) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;	  
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_pat4_fkey FOREIGN KEY (pat4) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;  

ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_pat1_fkey FOREIGN KEY (pat1) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_pat2_fkey FOREIGN KEY (pat2) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;  
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_pat3_fkey FOREIGN KEY (pat3) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;	  
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_pat4_fkey FOREIGN KEY (pat4) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;  

ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;  
ALTER TABLE inp_inflows_pol_x_node ADD CONSTRAINT inp_inflows_pol_x_node_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;  

ALTER TABLE inp_pattern_value ADD CONSTRAINT inp_pattern_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;




--ADD
--INP
/*
ALTER TABLE "inp_typevalue" ADD CONSTRAINT "inp_typevalue_id_unique" UNIQUE(id);

ALTER TABLE "raingage" ADD CONSTRAINT "raingage_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "raingage" ADD CONSTRAINT "raingage_rgage_type_fkey" FOREIGN KEY ("rgage_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_routeto_fkey" FOREIGN KEY ("routeto") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_hydrology" ADD CONSTRAINT "cat_hydrology_infiltration_id_fkey" FOREIGN KEY ("infiltration") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_files" ADD CONSTRAINT "inp_files_actio_type_fkey" FOREIGN KEY ("actio_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_files" ADD CONSTRAINT "inp_files_file_type_fkey" FOREIGN KEY ("file_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_pollutant" ADD CONSTRAINT "inp_pollutant_units_type_fkey" FOREIGN KEY ("units_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_buildup_land_x_pol" ADD CONSTRAINT "inp_buildup_land_x_pol_funcb_type_fkey" FOREIGN KEY ("funcb_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_curve_id" ADD CONSTRAINT "inp_curve_id_curve_type_fkey" FOREIGN KEY ("curve_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_divider" ADD CONSTRAINT "inp_divider_divider_type_fkey" FOREIGN KEY ("divider_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_evaporation" ADD CONSTRAINT "inp_evaporation_evap_type_fkey" FOREIGN KEY ("evap_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_lid_control" ADD CONSTRAINT "inp_lid_control_lidco_type_fkey" FOREIGN KEY ("lidco_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_allow_ponding_fkey" FOREIGN KEY ("allow_ponding") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_normal_flow_limited_fkey" FOREIGN KEY ("normal_flow_limited") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_inertial_damping_fkey" FOREIGN KEY ("inertial_damping") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_skip_steady_state_fkey" FOREIGN KEY ("skip_steady_state") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_quality_fkey" FOREIGN KEY ("ignore_quality") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_routing_fkey" FOREIGN KEY ("ignore_routing") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_groundwater_fkey" FOREIGN KEY ("ignore_groundwater") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_snowmelt_fkey" FOREIGN KEY ("ignore_snowmelt") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_rainfall_fkey" FOREIGN KEY ("ignore_rainfall") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_force_main_equation_fkey" FOREIGN KEY ("force_main_equation") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_link_offsets_fkey" FOREIGN KEY ("link_offsets") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_flow_routing_fkey" FOREIGN KEY ("flow_routing") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_flow_units_fkey" FOREIGN KEY ("flow_units") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "inp_outfall" ADD CONSTRAINT "inp_outfall_type_fkey" FOREIGN KEY ("outfall_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "inp_outlet" ADD CONSTRAINT "inp_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pattern" ADD CONSTRAINT "inp_pattern_pattern_type_fkey" FOREIGN KEY ("pattern_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_controls_fkey" FOREIGN KEY ("controls") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_input_fkey" FOREIGN KEY ("input") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_continuity_fkey" FOREIGN KEY ("continuity") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_flowstats_fkey" FOREIGN KEY ("flowstats") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "inp_storage" ADD CONSTRAINT "inp_storage_storage_type_fkey" FOREIGN KEY ("storage_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_temperature" ADD CONSTRAINT "inp_temperature_temp_type_fkey" FOREIGN KEY  ("temp_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_timser_id" ADD CONSTRAINT "inp_timser_id_timser_type_fkey" FOREIGN KEY ("timser_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_timser_id" ADD CONSTRAINT "inp_timser_id_times_type_fkey" FOREIGN KEY ("times_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_washoff_land_x_pol" ADD CONSTRAINT "inp_washoff_land_x_pol_funcw_type_fkey" FOREIGN KEY ("funcw_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

*/

-- ADD CHECK

ALTER TABLE inp_typevalue_timeseries ADD CONSTRAINT inp_typevalue_timeseries_check CHECK (id IN ('ABSOLUTE','FILE','RELATIVE'));
--ALTER TABLE inp_timser_id ADD CONSTRAINT inp_timser_id_check CHECK (id IN ('T10-5m','T5-5m'));
ALTER TABLE inp_value_files_actio ADD CONSTRAINT inp_value_files_actio_check CHECK (id IN ('SAVE','USE'));
ALTER TABLE inp_typevalue_storage ADD CONSTRAINT inp_typevalue_storage_check CHECK (id IN ('FUNCTIONAL','TABULAR'));
ALTER TABLE inp_value_weirs ADD CONSTRAINT inp_value_weirs_check CHECK (id IN ('SIDEFLOW','TRANSVERSE','TRAPEZOIDAL','V-NOTCH'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_check CHECK (id IN (1));
ALTER TABLE inp_value_curve ADD CONSTRAINT inp_value_curve_check CHECK (id IN ('CONTROL','DIVERSION','PUMP1','PUMP2','PUMP3','PUMP4','RATING','SHAPE','STORAGE','TIDAL'));
ALTER TABLE inp_typevalue_divider ADD CONSTRAINT inp_typevalue_divider_check CHECK (id IN ('CUTOFF','OVERFLOW','TABULAR','WEIR'));
ALTER TABLE inp_value_routeto ADD CONSTRAINT inp_value_routeto_check CHECK (id IN ('IMPERVIOUS','OUTLET','PERVIOUS'));
ALTER TABLE inp_typevalue_outlet ADD CONSTRAINT inp_typevalue_outlet_check CHECK (id IN ('FUNCTIONAL/DEPTH','FUNCTIONAL/HEAD','TABULAR/DEPTH','TABULAR/HEAD'));
ALTER TABLE inp_typevalue_orifice ADD CONSTRAINT inp_typevalue_orifice_check CHECK (id IN ('BOTTOM','SIDE'));
ALTER TABLE inp_typevalue_pattern ADD CONSTRAINT inp_typevalue_pattern_check CHECK (id IN ('DAILY','HOURLY','MONTHLY','WEEKEND'));
ALTER TABLE inp_value_catarc ADD CONSTRAINT inp_value_catarc_check CHECK (id IN ('ARCH','BASKETHANDLE','CIRCULAR','CUSTOM','DUMMY','EGG','FILLED_CIRCULAR','FORCE_MAIN','HORIZ_ELLIPSE','HORSESHOE','IRREGULAR','MODBASKETHANDLE','PARABOLIC','POWER','RECT_CLOSED','RECT_OPEN','RECT_ROUND','RECT_TRIANGULAR','SEMICIRCULAR','SEMIELLIPTICAL','TRAPEZOIDAL','TRIANGULAR','VIRTUAL'));
ALTER TABLE inp_typevalue_windsp ADD CONSTRAINT inp_typevalue_windsp_check CHECK (id IN ('FILE','MONTHLY'));
ALTER TABLE inp_value_files_type ADD CONSTRAINT inp_value_files_type_check CHECK (id IN ('HOTSTART','INFLOWS','OUTFLOWS','RAINFALL','RDII','RUNOFF'));
ALTER TABLE inp_value_lidcontrol ADD CONSTRAINT inp_value_lidcontrol_check CHECK (id IN ('BC','DRAIN','DRAINMAT','GR','IT','PAVEMENT','PP','RB','SOIL','STORAGE','SURFACE','VS'));
ALTER TABLE inp_typevalue_evap ADD CONSTRAINT inp_typevalue_evap_check CHECK (id IN ('CONSTANT','FILE','MONTHLY','RECOVERY','TEMPERATURE','TIMESERIES'));
ALTER TABLE inp_value_treatment ADD CONSTRAINT inp_value_treatment_check CHECK (id IN ('CONCEN','RATE','REMOVAL'));
ALTER TABLE inp_typevalue_temp ADD CONSTRAINT inp_typevalue_temp_check CHECK (id IN ('FILE','TIMESERIES'));
ALTER TABLE inp_value_orifice ADD CONSTRAINT inp_value_orifice_check CHECK (id IN ('CIRCULAR','RECT-CLOSED'));
ALTER TABLE inp_typevalue_outfall ADD CONSTRAINT inp_typevalue_outfall_check CHECK (id IN ('FIXED','FREE','NORMAL','TIDAL','TIMESERIES'));
ALTER TABLE inp_value_pollutants ADD CONSTRAINT inp_value_pollutants_check CHECK (id IN ('#/L','MG/L','UG/L'));
ALTER TABLE inp_value_inflows ADD CONSTRAINT inp_value_inflows_check CHECK (id IN ('CONCEN','MASS'));
ALTER TABLE inp_value_status ADD CONSTRAINT inp_value_status_check CHECK (id IN ('OFF','ON'));
ALTER TABLE inp_value_raingage ADD CONSTRAINT inp_value_raingage_check CHECK (id IN ('CUMULATIVE','INTENSITY','VOLUME'));
ALTER TABLE inp_value_washoff ADD CONSTRAINT inp_value_washoff_check CHECK (id IN ('EMC','EXP','RC'));
ALTER TABLE inp_value_yesno ADD CONSTRAINT inp_value_yesno_check CHECK (id IN ('NO','YES'));
ALTER TABLE inp_value_buildup ADD CONSTRAINT inp_value_buildup_check CHECK (id IN ('EXP','EXT','POW','SAT'));
ALTER TABLE inp_value_allnone ADD CONSTRAINT inp_value_allnone_check CHECK (id IN ('ALL','NONE'));
ALTER TABLE inp_typevalue_raingage ADD CONSTRAINT inp_typevalue_raingage_check CHECK (id IN ('FILE','TIMESERIES'));
ALTER TABLE inp_value_options_fr ADD CONSTRAINT inp_value_options_fr_check CHECK (id IN ('DYNWAVE','KINWAVE','STEADY'));
ALTER TABLE inp_value_options_lo ADD CONSTRAINT inp_value_options_lo_check CHECK (id IN ('DEPTH','ELEVATION'));
ALTER TABLE inp_value_mapunits ADD CONSTRAINT inp_value_mapunits_check CHECK (id IN ('DEGREES','FEET','METERS','NONE'));
ALTER TABLE inp_value_options_fme ADD CONSTRAINT inp_value_options_fme_check CHECK (id IN ('D-W','H-W'));
ALTER TABLE inp_value_options_nfl ADD CONSTRAINT inp_value_options_nfl_check CHECK (id IN ('BOTH','FROUD','SLOPE'));
ALTER TABLE inp_value_options_id ADD CONSTRAINT inp_value_options_id_check CHECK (id IN ('FULL','NONE','PARTIAL'));
ALTER TABLE inp_arc_type ADD CONSTRAINT inp_arc_type_check CHECK (id IN ('CONDUIT','NOT DEFINED','ORIFICE','OUTLET','PUMP','VIRTUAL','WEIR'));
ALTER TABLE inp_node_type ADD CONSTRAINT inp_node_type_check CHECK (id IN ('DIVIDER','JUNCTION','NOT DEFINED','OUTFALL','STORAGE'));
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_check CHECK (flwreg_id IN (1,2,3,4,5,6,7,8,9));
ALTER TABLE inp_flwreg_orifice ADD CONSTRAINT inp_flwreg_orifice_check CHECK (flwreg_id IN (1,2,3,4,5,6,7,8,9));
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_check CHECK (flwreg_id IN (1,2,3,4,5,6,7,8,9));
ALTER TABLE inp_flwreg_outlet ADD CONSTRAINT inp_flwreg_outlet_check CHECK (flwreg_id IN (1,2,3,4,5,6,7,8,9));

ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_check_status CHECK (status IN ('ON', 'OFF'));
ALTER TABLE inp_flwreg_orifice ADD CONSTRAINT inp_flwreg_orifice_check_ory_type CHECK (ori_type IN ('SIDE', 'BOTTOM'));
ALTER TABLE inp_flwreg_orifice ADD CONSTRAINT inp_flwreg_orifice_check_shape CHECK (shape IN ('CIRCULAR', 'RECT-CLOSED'));
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_check_type CHECK (weir_type IN ('SIDEFLOW', 'TRANSVERSE','TRAPEZOIDAL'));
ALTER TABLE inp_flwreg_outlet ADD CONSTRAINT inp_flwreg_outlet_check_type CHECK (outlet_type IN ('FUNCTIONAL/DEPTH', 'FUNCTIONAL/HEAD', 'TABULAR/DEPTH', 'TABULAR/HEAD'));