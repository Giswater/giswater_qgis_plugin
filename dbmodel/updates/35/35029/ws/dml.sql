/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21
INSERT INTO config_form_fields(formname, formtype, tabname, columnname,  datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate,  dv_querytext,  dv_isnullvalue, hidden)
VALUES ('v_edit_dma', 'form_feature', 'data', 'avg_press', 'numeric', 'text', 'average pressure', null,
null, false, false, true, false, null,null, false);

UPDATE sys_table SET id=replace(id, 'graf','graph') WHERE id ilike '%graf%';
UPDATE sys_table SET descript=replace(descript, 'graf','graph') WHERE descript ilike '%graf%';
UPDATE config_form_fields SET columnname=replace(columnname, 'graf','graph') WHERE columnname ilike '%graf%';
UPDATE config_form_fields SET label=replace(label, 'graf','graph') WHERE label ilike '%graf%';
UPDATE config_function SET function_name=replace(function_name, 'graf','graph') WHERE function_name ilike '%graf%';
UPDATE config_form_fields SET columnname=replace(columnname, 'graf','graph') WHERE columnname ilike '%graf%';
UPDATE config_function SET function_name=replace(function_name, 'graf','graph') WHERE function_name ilike '%graf%';
UPDATE config_form_fields SET label=replace(label, 'graf','graph') WHERE label ilike '%graf%';
UPDATE config_form_fields SET label=replace(label, 'Graf','Graph') WHERE label ilike '%Graf%';
UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'graf','graph') WHERE dv_querytext ilike '%graf%';

UPDATE edit_typevalue SET typevalue=replace(typevalue, 'graf','graph') WHERE typevalue = 'grafdelimiter_type';

UPDATE config_param_system SET parameter='utils_graphanalytics_lrs_graph' WHERE parameter = 'utils_grafanalytics_lrs_graf';

UPDATE config_param_system SET value=replace(value,'ignoreGrafanalytics','ignoreGraphanalytics') WHERE parameter = 'admin_checkproject';
UPDATE config_param_system SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';
UPDATE config_param_system SET label=replace(label,'graf','graph') WHERE label ilike '%graf%';

UPDATE dma SET descript=replace(label,'graf','graph') WHERE descript ilike '%graf%';
UPDATE dqa SET descript=replace(label,'graf','graph') WHERE descript ilike '%graf%';
UPDATE presszone SET descript=replace(label,'graf','graph') WHERE descript ilike '%graf%';
UPDATE sector SET descript=replace(label,'graf','graph') WHERE descript ilike '%graf%';

UPDATE sys_function SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';

UPDATE sys_message SET error_message=replace(error_message,'graf','graph') WHERE error_message ilike '%graf%';

UPDATE sys_param_user SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';

UPDATE sys_fprocess SET fprocess_name=replace(fprocess_name,'graf','graph') WHERE fprocess_name ilike '%graf%';
UPDATE sys_fprocess SET fprocess_name=replace(fprocess_name,'Graf','Graph') WHERE fprocess_name ilike '%Graf%';