/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 01/09/2025
UPDATE sys_table SET descript='ve_inp_frorifice',alias='Inp flwreg orifice' WHERE id='ve_inp_frorifice';
UPDATE sys_table SET descript='ve_inp_frpump',alias='Inp flwreg pump' WHERE id='ve_inp_frpump';
UPDATE sys_table SET descript='ve_inp_froutlet',alias='Inp flwreg outlet' WHERE id='ve_inp_froutlet';
UPDATE sys_table SET descript='ve_inp_frweir',alias='Inp flwreg weir' WHERE id='ve_inp_frweir';

-- 02/09/2025
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'gully_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'descript', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'link_id', 9, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'insert_tstamp', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'insert_user', 11, false, NULL, NULL, NULL);


UPDATE sys_table SET context = '{"levels": ["EPA", "HYDROLOGY"]}' WHERE id = 've_raingage';

UPDATE sys_param_user SET id='inp_options_hydrology_current' WHERE id='inp_options_hydrology_scenario';

UPDATE config_toolbox SET inputparams = replace(inputparams::text, '''ALL VISIBLE SECTORS''', '''ALL VISIBLE SECTORS''')::json WHERE id = '3102' or id = '3100';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_orifice'''
WHERE formname='ve_epa_frorifice' AND formtype='form_feature' AND columnname='orifice_type' AND tabname='tab_epa';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_weir'''
WHERE formname='ve_epa_frweir' AND formtype='form_feature' AND columnname='weir_type' AND tabname='tab_epa';
