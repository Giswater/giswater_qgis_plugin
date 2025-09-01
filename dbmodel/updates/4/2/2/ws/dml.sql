/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 01/09/2025
INSERT INTO sys_table (id,descript,sys_role,alias, context) VALUES ('ve_inp_frshortpipe','ve_inp_frshortpipe','role_edit','Inp flwreg shortpipe', '{"levels": ["EPA", "HYDRAULICS"]}');
UPDATE sys_table SET descript='ve_inp_frpump', context = '{"levels": ["EPA", "HYDRAULICS"]}', alias = 'Inp flwreg pump' WHERE id='ve_inp_frpump';
UPDATE sys_table SET descript='ve_inp_frvalve', context = '{"levels": ["EPA", "HYDRAULICS"]}', alias = 'Inp flwreg valve' WHERE id='ve_inp_frvalve';

UPDATE config_form_fields SET dv_isnullvalue = true WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET dv_isnullvalue = true WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
