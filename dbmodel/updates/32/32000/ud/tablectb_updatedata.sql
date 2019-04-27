/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- update data
/*
UPDATE raingage SET rgage_type='TIMESERIES_RAIN' WHERE rgage_type='TIMESERIES';
UPDATE raingage SET rgage_type='FILE_RAIN' WHERE rgage_type='FILE';
UPDATE inp_timser_id SET times_type='FILE_TIMES' WHERE times_type='FILE';
UPDATE inp_timser_id SET timser_type='Temperature time' WHERE timser_type='Temperature';
UPDATE inp_storage SET storage_type='TABULAR_STORAGE' WHERE storage_type='TABULAR';
UPDATE inp_divider SET divider_type='TABULAR_DIVIDER' WHERE divider_type='TABULAR';
UPDATE inp_outfall SET outfall_type='TIDAL_OUTFALL' WHERE outfall_type='TIDAL';
UPDATE inp_curve_id SET curve_type='TIDAL_CURVE' WHERE curve_type='TIDAL';
UPDATE inp_curve_id SET curve_type='STORAGE_CURVE' WHERE curve_type='STORAGE';

UPDATE inp_orifice SET ori_type='RECTCLOSED_ORIFICE' WHERE ori_type='RECT-CLOSED';
UPDATE inp_orifice SET ori_type='CIRCULAR_ORIFICE' WHERE ori_type='CIRCULAR';
UPDATE inp_flwreg_orifice SET ori_type='RECTCLOSED_ORIFICE' WHERE ori_type='RECT-CLOSED';
UPDATE inp_flwreg_orifice SET ori_type='CIRCULAR_ORIFICE' WHERE ori_type='CIRCULAR';
UPDATE inp_flwreg_weir SET weir_type='TRAPEZOIDAL_WEIR' WHERE weir_type='TRAPEZOIDAL';
UPDATE inp_weir SET weir_type='TRAPEZOIDAL_WEIR' WHERE weir_type='TRAPEZOIDAL';
UPDATE inp_buildup_land_x_pol SET funcb_type='EXP_BUILDUP' WHERE funcb_type='EXP';
UPDATE inp_washoff_land_x_pol SET funcw_type='EXP_WHASOFF' WHERE funcw_type='EXP';
*/

-- refactor patterns
INSERT INTO inp_pattern
SELECT DISTINCT ON (pattern_id) pattern_id, (case when pattern_type='MONTHLY' THEN 'MONTHLY_PATTERN' ELSE pattern_type END) FROM _inp_pattern_;

INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, 
factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) 
SELECT pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, 
factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM _inp_pattern_;


/*
-- Refactor lidcontrols
INSERT INTO inp_lid_control 
SELECT id, lidco_id, (CASE WHEN lidco_type='STORAGE' THEN 'STORAGE_LID' WHEN lidco_type='SURFACE' THEN 'SURFACE_LID' ELSE lidco_type END)
value_2, value_3,  value_4, value_5, value_6, value_7, value_8 FROM _inp_lid_control;
*/
  
-- TODO: Refactor snowpack, hydrograph, inflows, temperature, evaporation