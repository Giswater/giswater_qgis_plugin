/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table SET isdeprecated=true WHERE id='price_simple';



UPDATE sys_csv2pg_cat SET readheader=false, orderby=1 WHERE id=1;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=1 WHERE id=1;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=2 WHERE id=3;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=3  WHERE id=4;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=4  WHERE id=8;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=5  WHERE id=9;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=6  WHERE id=10;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=7  WHERE id=11;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=8  WHERE id=12;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=9  WHERE id=13;
UPDATE sys_csv2pg_cat SET name='Import node visits', name_i18n='Import node visits', readheader=false, orderby=10  WHERE id=14;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=11  WHERE id=15;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=12  WHERE id=16;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=13  WHERE id=17;
UPDATE sys_csv2pg_cat SET name='Import visit file', name_i18n='import visit file', csv_structure='Import visit file', readheader=true, orderby=14  WHERE id=18;

--28/06/2019
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2716, 'gw_fct_admin_manage_child_views', 'utils', 'function', 'Create ve_* custom views', 'role_admin',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2718, 'gw_trg_edit_foreignkey', 'utils', 'trigger', 'Trigger to manage foreign keys with not possibility to create an automatic db fk', 'role_edit',false,false,false);

UPDATE audit_cat_function SET isdeprecated=true WHERE function_name='gw_trg_man_addfields_value_control';

UPDATE config_api_form_fields SET dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue=''listlimit''' WHERE id='102718';
