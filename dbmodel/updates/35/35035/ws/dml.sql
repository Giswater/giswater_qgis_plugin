/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function(   id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3230, 'gw_fct_setmapzonestrigger', 'ws', 'function', 'json', 'json', 'Function that executes mapzone calculation if valve is being closed or opened', 'role_edit', null, 'core')
ON CONFLICT (id) DO NOTHING;
 
update config_function set id = 3230 where function_name='gw_fct_setmapzonestrigger';

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('om_streetaxis', 'Segmented streetaxis table, used for hydrant analysis', 'role_edit', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_om_waterbalance_report', 'View to show the general water balance report by period and DMA', 'role_edit', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'wjoin_type', 'lyt_data_2', max(layoutorder)+1, 
'string', 'text', 'wjoin_type', 'wjoin_type',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'NETWJOIN' AND layoutname = 'lyt_data_2' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
