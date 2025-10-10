/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DELETE FROM sys_message WHERE id = 4026;
DELETE FROM sys_message WHERE id = 4028;

-- 10/10/2025
UPDATE config_form_fields SET ismandatory=false
WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_none';

UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_none';

UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';
UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';
UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';
UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='ve_inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';

UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_air_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_check_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_fl_contr_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_gen_purp_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_green_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_outfall_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_pr_break_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_pr_reduc_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_pr_susta_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_shutoff_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_throttle_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
