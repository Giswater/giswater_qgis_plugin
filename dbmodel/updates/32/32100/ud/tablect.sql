/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- incorporate constraints not defined on 3.1
--------------------------------------------
ALTER TABLE gully ALTER COLUMN state SET NOT NULL;
ALTER TABLE gully ALTER COLUMN state_type SET NOT NULL;


--DROP
--INP
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_form_type_fkey";
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_rgage_type_fkey" ;

ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_routeto_fkey";

ALTER TABLE "cat_hydrology" DROP CONSTRAINT IF EXISTS "cat_hydrology_infiltration_id_fkey";

ALTER TABLE "inp_files" DROP CONSTRAINT  IF EXISTS "inp_files_actio_type_fkey";
ALTER TABLE "inp_files" DROP CONSTRAINT IF EXISTS  "inp_files_file_type_fkey";



ALTER TABLE "inp_pollutant" DROP CONSTRAINT IF EXISTS"inp_pollutant_units_type_fkey";


ALTER TABLE "inp_buildup_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_buildup_land_x_pol_funcb_type_fkey";


ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_divider_type_fkey";



ALTER TABLE "inp_evaporation" DROP CONSTRAINT IF EXISTS "inp_evaporation_evap_type_fkey";

ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_form_type_fkey";


ALTER TABLE "inp_lid_control" DROP CONSTRAINT IF EXISTS "inp_lid_control_lidco_type_fkey";


ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_allow_ponding_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_normal_flow_limited_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_inertial_damping_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_skip_steady_state_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_quality_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_routing_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_groundwater_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_snowmelt_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_rainfall_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_force_main_equation_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_link_offsets_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_flow_routing_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_flow_units_fkey";

ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_shape_fkey";
ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_ori_type_fkey";

ALTER TABLE "inp_outfall" DROP CONSTRAINT IF EXISTS "inp_outfall_type_fkey";

ALTER TABLE "inp_outlet" DROP CONSTRAINT IF EXISTS "inp_outlet_outlet_type_fkey";

ALTER TABLE "inp_pattern" DROP CONSTRAINT IF EXISTS "inp_pattern_pattern_type_fkey";

ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_status_fkey";

ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_controls_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_input_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_continuity_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_flowstats_fkey";

ALTER TABLE "inp_storage" DROP CONSTRAINT IF EXISTS "inp_storage_storage_type_fkey";

ALTER TABLE "inp_temperature" DROP CONSTRAINT IF EXISTS "inp_temperature_temp_type_fkey";

ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_timser_type_fkey";
ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_times_type_fkey";


ALTER TABLE "inp_washoff_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_washoff_land_x_pol_funcw_type_fkey";

ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_weir_type_fkey";
ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_flap_fkey";


--FLOW REGULATOR
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_shape_fkey";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_ori_type_fkey";

ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_outlet_type_fkey";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_to_arc_fkey";

ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_status_fkey";

ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_weir_type_fkey";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_flap_fkey";


--DROP CHECK

ALTER TABLE "inp_typevalue_timeseries" DROP CONSTRAINT IF EXISTS "inp_typevalue_timeseries_check";
ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_check";
ALTER TABLE "inp_value_files_actio" DROP CONSTRAINT IF EXISTS "inp_value_files_actio_check";
ALTER TABLE "inp_typevalue_storage" DROP CONSTRAINT IF EXISTS "inp_typevalue_storage_check";
ALTER TABLE "inp_value_weirs" DROP CONSTRAINT IF EXISTS "inp_value_weirs_check";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_check";
ALTER TABLE "inp_value_curve" DROP CONSTRAINT IF EXISTS "inp_value_curve_check";
ALTER TABLE "inp_typevalue_divider" DROP CONSTRAINT IF EXISTS "inp_typevalue_divider_check";
ALTER TABLE "inp_value_routeto" DROP CONSTRAINT IF EXISTS "inp_value_routeto_check";
ALTER TABLE "inp_typevalue_outlet" DROP CONSTRAINT IF EXISTS "inp_typevalue_outlet_check";
ALTER TABLE "inp_typevalue_orifice" DROP CONSTRAINT IF EXISTS "inp_typevalue_orifice_check";
ALTER TABLE "inp_typevalue_pattern" DROP CONSTRAINT IF EXISTS "inp_typevalue_pattern_check";
ALTER TABLE "inp_value_catarc" DROP CONSTRAINT IF EXISTS "inp_value_catarc_check";
ALTER TABLE "inp_typevalue_windsp" DROP CONSTRAINT IF EXISTS "inp_typevalue_windsp_check";
ALTER TABLE "inp_value_files_type" DROP CONSTRAINT IF EXISTS "inp_value_files_type_check";
ALTER TABLE "inp_value_lidcontrol" DROP CONSTRAINT IF EXISTS "inp_value_lidcontrol_check";
ALTER TABLE "inp_typevalue_evap" DROP CONSTRAINT IF EXISTS "inp_typevalue_evap_check";
ALTER TABLE "inp_value_treatment" DROP CONSTRAINT IF EXISTS "inp_value_treatment_check";
ALTER TABLE "inp_typevalue_temp" DROP CONSTRAINT IF EXISTS "inp_typevalue_temp_check";
ALTER TABLE "inp_value_orifice" DROP CONSTRAINT IF EXISTS "inp_value_orifice_check";
ALTER TABLE "inp_typevalue_outfall" DROP CONSTRAINT IF EXISTS "inp_typevalue_outfall_check";
ALTER TABLE "inp_value_pollutants" DROP CONSTRAINT IF EXISTS "inp_value_pollutants_check";
ALTER TABLE "inp_value_inflows" DROP CONSTRAINT IF EXISTS "inp_value_inflows_check";
ALTER TABLE "inp_value_status" DROP CONSTRAINT IF EXISTS "inp_value_status_check";
ALTER TABLE "inp_value_raingage" DROP CONSTRAINT IF EXISTS "inp_value_raingage_check";
ALTER TABLE "inp_value_washoff" DROP CONSTRAINT IF EXISTS "inp_value_washoff_check";
ALTER TABLE "inp_value_yesno" DROP CONSTRAINT IF EXISTS "inp_value_yesno_check";
ALTER TABLE "inp_value_buildup" DROP CONSTRAINT IF EXISTS "inp_value_buildup_check";
ALTER TABLE "inp_value_allnone" DROP CONSTRAINT IF EXISTS "inp_value_allnone_check";
ALTER TABLE "inp_typevalue_raingage" DROP CONSTRAINT IF EXISTS "inp_typevalue_raingage_check";
ALTER TABLE "inp_value_options_fr" DROP CONSTRAINT IF EXISTS "inp_value_options_fr_check";
ALTER TABLE "inp_value_options_lo" DROP CONSTRAINT IF EXISTS "inp_value_options_lo_check";
ALTER TABLE "inp_value_mapunits" DROP CONSTRAINT IF EXISTS "inp_value_mapunits_check";
ALTER TABLE "inp_value_options_fme" DROP CONSTRAINT IF EXISTS "inp_value_options_fme_check";
ALTER TABLE "inp_value_options_nfl" DROP CONSTRAINT IF EXISTS "inp_value_options_nfl_check";
ALTER TABLE "inp_value_options_id" DROP CONSTRAINT IF EXISTS "inp_value_options_id_check";
ALTER TABLE "inp_arc_type" DROP CONSTRAINT IF EXISTS "inp_arc_type_check";
ALTER TABLE "inp_node_type" DROP CONSTRAINT IF EXISTS "inp_node_type_check";
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_check";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_check";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_check" ;
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_check" ;


-- DROP UNIQUE
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_unique";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_unique";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_unique";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_unique";


--ADD
--INP
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



--FLOW REGULATOR

ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;





-- ADD CHECK

ALTER TABLE inp_typevalue_timeseries ADD CONSTRAINT inp_typevalue_timeseries_check CHECK (id IN ('ABSOLUTE','FILE','RELATIVE'));
ALTER TABLE inp_timser_id ADD CONSTRAINT inp_timser_id_check CHECK (id IN ('T10-5m','T5-5m'));
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


-- ADD UNIQUE
ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_unique" UNIQUE (node_id, to_arc, flwreg_id);
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_unique" UNIQUE (node_id, to_arc, flwreg_id);
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_unique" UNIQUE (node_id, to_arc, flwreg_id);
ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_unique" UNIQUE (node_id, to_arc, flwreg_id);
