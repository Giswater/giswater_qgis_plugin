/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/27
DELETE FROM config_fprocess WHERE target IN ('[ADJUSTMENTS]', '[GWF]');


UPDATE sys_param_user SET formname = 'epaoptions', project_type='ud', label='Default values', datatype = 'json', layoutorder = 16, layoutname = 'grl_general_2',
iseditable = 'true', epaversion = '{"from":"5.0.022", "to":null,"language":"english"}' , descript = 'Default values on go2epa generation inp file'
WHERE id = 'inp_options_vdefault';


UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_edit_macrosector';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_edit_macrodma';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_ext_streetaxis';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_ext_plot';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_ext_address';


UPDATE sys_table SET qgis_criticity = 0 WHERE id like '%v_rpt_%';

UPDATE sys_table SET qgis_criticity = 2 WHERE id ='v_rpt_arcflow_sum';
UPDATE sys_table SET qgis_criticity = 2 WHERE id ='v_rpt_nodeflooding_sum';
UPDATE sys_table SET qgis_criticity = 2 WHERE id ='v_rpt_nodesurcharge_sum';

-- 2020/06/29
UPDATE config_form_fields SET dv_querytext = 'SELECT distinct  NULL AS id,  NULL  AS idval FROM cat_grate WHERE id IS NOT NULL' 
WHERE formname='upsert_catalog_gully' AND columnname IN ('geom1','shape');


INSERT INTO sys_table VALUES ('rpt_summary_raingage', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('cat_mat_gully', 'Catalog of gully materials', 'role_edit', 0);
INSERT INTO sys_table VALUES ('ext_hydrometer_category', 'External table of hydrometer categories', 'role_edit', 0);
INSERT INTO sys_table VALUES ('ext_rtc_hydrometer', 'Table of hydrometer receivers', 'role_edit', 0);
INSERT INTO sys_table VALUES ('ext_cat_hydrometer', 'Catalog of hydrometer receivers', 'role_edit', 0);
INSERT INTO sys_table VALUES ('inp_snowpack_id', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('inp_pattern_value', 'Defines time patterns values', 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_arc', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_node', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_subcatchment', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_summary_subcatchment', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_summary_node', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_summary_arc', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_summary_crossection', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('ext_rtc_dma_period', NULL, 'role_edit', 0);
INSERT INTO sys_table VALUES ('inp_controls_importinp', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('cat_dwf_scenario', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('ext_rtc_hydrometer_x_data', NULL, 'role_edit', 0);
INSERT INTO sys_table VALUES ('inp_controls_x_node', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('ext_cat_period', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('rpt_control_actions_taken', NULL, 'role_epa', 0);
DELETE FROM sys_table WHERE id='inp_typevalue_divider';
DELETE FROM sys_table WHERE id='inp_typevalue_evap';
DELETE FROM sys_table WHERE id='inp_typevalue_orifice';
DELETE FROM sys_table WHERE id='inp_typevalue_outfall';
DELETE FROM sys_table WHERE id='inp_typevalue_outlet';
DELETE FROM sys_table WHERE id='inp_typevalue_pattern';
DELETE FROM sys_table WHERE id='inp_typevalue_raingage';
DELETE FROM sys_table WHERE id='inp_typevalue_storage';
DELETE FROM sys_table WHERE id='inp_typevalue_temp';
DELETE FROM sys_table WHERE id='inp_typevalue_timeseries';
DELETE FROM sys_table WHERE id='inp_typevalue_windsp';
DELETE FROM sys_table WHERE id='inp_value_allnone';
DELETE FROM sys_table WHERE id='inp_value_catarc';
DELETE FROM sys_table WHERE id='inp_value_curve';
DELETE FROM sys_table WHERE id='inp_value_files_actio';
DELETE FROM sys_table WHERE id='inp_value_files_type';
DELETE FROM sys_table WHERE id='inp_value_inflows';
DELETE FROM sys_table WHERE id='inp_value_lidcontrol';
DELETE FROM sys_table WHERE id='inp_value_mapunits';
DELETE FROM sys_table WHERE id='inp_value_options_fme';
DELETE FROM sys_table WHERE id='inp_value_options_fr';
DELETE FROM sys_table WHERE id='inp_value_options_fu';
DELETE FROM sys_table WHERE id='inp_value_options_id';
DELETE FROM sys_table WHERE id='inp_value_options_in';
DELETE FROM sys_table WHERE id='inp_value_options_lo';
DELETE FROM sys_table WHERE id='inp_value_options_nfl';
DELETE FROM sys_table WHERE id='inp_value_orifice';
DELETE FROM sys_table WHERE id='inp_value_pollutants';
DELETE FROM sys_table WHERE id='inp_value_raingage';
DELETE FROM sys_table WHERE id='inp_value_routeto';
DELETE FROM sys_table WHERE id='inp_value_status';
DELETE FROM sys_table WHERE id='inp_value_timserid';
DELETE FROM sys_table WHERE id='inp_value_treatment';
DELETE FROM sys_table WHERE id='inp_value_washoff';
DELETE FROM sys_table WHERE id='inp_value_weirs';
DELETE FROM sys_table WHERE id='inp_value_yesno';
DELETE FROM sys_table WHERE id='inp_windspeed';