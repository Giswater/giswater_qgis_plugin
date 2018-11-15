/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


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



