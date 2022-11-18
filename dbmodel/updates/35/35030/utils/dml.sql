/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/09/27
UPDATE config_param_system SET value =
'{"table":"cat_dscenario","selector":"selector_inp_dscenario","table_id":"dscenario_id","selector_id":"dscenario_id","label":"dscenario_id,'' - '', name, '' ('', dscenario_type,'')''","orderBy":"dscenario_id","manageAll":true,"query_filter":" AND dscenario_id > 0 AND active is true AND (expl_id IS NULL OR expl_id IN (SELECT expl_id FROM selector_expl where cur_user = current_user))","typeaheadFilter":" AND lower(concat(dscenario_id, '' - '', name,'' ('',  dscenario_type,'')''))","typeaheadForced":true}'
WHERE parameter = 'basic_selector_tab_dscenario';

UPDATE sys_param_user SET formname='config', descript='Allow automatic delete of planified features when a psector is deleted and this feature is not present in another psector',
isenabled=true, layoutorder=10, project_type='utils', "datatype"='boolean', widgettype='check', vdefault='false', layoutname='lyt_masterplan', iseditable=true
WHERE id='plan_psector_force_delete';

--2022/09/26
UPDATE config_param_system SET value = (value::jsonb - 'manageConflict')::text 
WHERE parameter='utils_graphanalytics_status';

UPDATE config_toolbox SET inputparams = b.inp FROM
(SELECT json_agg(a.inputs::json) AS inp FROM
(SELECT json_array_elements_text(inputparams) as inputs
FROM   config_toolbox
WHERE id=2768
union select concat('{"widgetname":"checkData" , "label":"Check data", "widgettype":"combo","datatype":"text","tooltip": "Execute graphanalytics_check or/and om_check data function", "layoutname":"grl_option_parameters","layoutorder":"',maxord+1,'",
"comboIds":["FULL","PARTIAL","NONE"],
"comboNames":["FULL","PARTIAL","NONE"], "selectedId":""}')
from (select max(d.layoutord::integer) as maxord from
(SELECT json_extract_path_text(json_array_elements(inputparams),'layoutorder') as layoutord
FROM   config_toolbox
WHERE id=2768)d where layoutord is not null)e)a)b WHERE  id=2768;


UPDATE config_form_fields cff set web_layoutorder = row FROM (SELECT ROW_NUMBER() OVER (PARTITION BY formname ORDER BY formname,
    CASE WHEN layoutname='lyt_none' THEN 1 WHEN layoutname='lyt_top_1' THEN 2 WHEN layoutname='lyt_bot_1' THEN 3
    WHEN layoutname='lyt_data_1' THEN 4 WHEN layoutname='lyt_data_2' THEN 5 WHEN layoutname='lyt_data_3' THEN 6
    ELSE 7 END, layoutorder) as row,* FROM (
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_node%' and layoutname='lyt_none' and hidden is false
union 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_node%' and layoutname='lyt_top_1' and hidden is false 
UNION 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_node%' and layoutname='lyt_bot_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_node%' and layoutname='lyt_data_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_node%' and layoutname='lyt_data_2' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_node%' and layoutname='lyt_data_3' and hidden is false 
) a)b WHERE cff.formname=b.formname and cff.columnname=b.columnname;



UPDATE config_form_fields cff set web_layoutorder = row FROM (SELECT ROW_NUMBER() OVER (PARTITION BY formname ORDER BY formname,
    CASE WHEN layoutname='lyt_none' THEN 1 WHEN layoutname='lyt_top_1' THEN 2 WHEN layoutname='lyt_bot_1' THEN 3
    WHEN layoutname='lyt_data_1' THEN 4 WHEN layoutname='lyt_data_2' THEN 5 WHEN layoutname='lyt_data_3' THEN 6
    ELSE 7 END, layoutorder) as row,* FROM (
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_arc%' and layoutname='lyt_none' and hidden is false
union 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_arc%' and layoutname='lyt_top_1' and hidden is false 
UNION 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_arc%' and layoutname='lyt_bot_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_arc%' and layoutname='lyt_data_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_arc%' and layoutname='lyt_data_2' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_arc%' and layoutname='lyt_data_3' and hidden is false 
) a)b WHERE cff.formname=b.formname and cff.columnname=b.columnname;



UPDATE config_form_fields cff set web_layoutorder = row FROM (SELECT ROW_NUMBER() OVER (PARTITION BY formname ORDER BY formname,
    CASE WHEN layoutname='lyt_none' THEN 1 WHEN layoutname='lyt_top_1' THEN 2 WHEN layoutname='lyt_bot_1' THEN 3
    WHEN layoutname='lyt_data_1' THEN 4 WHEN layoutname='lyt_data_2' THEN 5 WHEN layoutname='lyt_data_3' THEN 6
    ELSE 7 END, layoutorder) as row,* FROM (
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_connec%' and layoutname='lyt_none' and hidden is false
union 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_connec%' and layoutname='lyt_top_1' and hidden is false 
UNION 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_connec%' and layoutname='lyt_bot_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_connec%' and layoutname='lyt_data_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_connec%' and layoutname='lyt_data_2' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_connec%' and layoutname='lyt_data_3' and hidden is false 
) a)b WHERE cff.formname=b.formname and cff.columnname=b.columnname;



UPDATE config_form_fields cff set web_layoutorder = row FROM (SELECT ROW_NUMBER() OVER (PARTITION BY formname ORDER BY formname,
    CASE WHEN layoutname='lyt_none' THEN 1 WHEN layoutname='lyt_top_1' THEN 2 WHEN layoutname='lyt_bot_1' THEN 3
    WHEN layoutname='lyt_data_1' THEN 4 WHEN layoutname='lyt_data_2' THEN 5 WHEN layoutname='lyt_data_3' THEN 6
    ELSE 7 END, layoutorder) as row,* FROM (
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_gully%' and layoutname='lyt_none' and hidden is false
union 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_gully%' and layoutname='lyt_top_1' and hidden is false 
UNION 
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_gully%' and layoutname='lyt_bot_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_gully%' and layoutname='lyt_data_1' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_gully%' and layoutname='lyt_data_2' and hidden is false 
union
SELECT formname, columnname, layoutname, layoutorder, hidden 
FROM config_form_fields WHERE formname ilike 've_gully%' and layoutname='lyt_data_3' and hidden is false 
) a)b WHERE cff.formname=b.formname and cff.columnname=b.columnname;


UPDATE config_param_system SET datatype='json', widgettype='linetext', iseditable=TRUE, layoutorder=9 WHERE parameter='admin_raster_dem';

UPDATE config_param_system SET layoutorder=10 WHERE parameter='admin_config_control_trigger';

INSERT INTO sys_message( id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3198,'Field defined as target for DEM data is not related to elevation', 
'Configure correctly parameter admin_raster_dem on config_param_system table or using configuration button',2, TRUE, 'utils','core') ON CONFLICT (id) DO NOTHING;

update config_toolbox SET inputparams=
'[{"widgetname":"updateValues", "label":"Nodes to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["allValues", "nullValues"], "comboNames":["ALL NODES", "NODES NULL ELEV"], "selectedId":"nullValues"}]'
WHERE id=2760;

UPDATE config_param_system SET value=replace(value, 'ignoregraphanalytics','ignoreGraphanalytics') WHERE parameter = 'admin_checkproject';
UPDATE config_param_system SET value=replace(value, 'ignoreGrafanalytics','ignoreGraphanalytics') WHERE parameter = 'admin_checkproject';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_arc', 'form_feature', 'data', 'pavcat_id', 'lyt_data_2', 13, 'string', 'combo', 'pavcat_id', NULL, NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_pavement', TRUE, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_arc', 'form_feature', 'data', 'pavcat_id', 'lyt_data_2', 13, 'string', 'combo', 'pavcat_id', NULL, NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_pavement', TRUE, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3200, 'Workspace is not editable you can''t modify it nor delete it', NULL, 2, TRUE, 'utils',NULL) ON CONFLICT (id) DO NOTHING;

UPDATE cat_workspace SET iseditable=TRUE WHERE iseditable IS NULL;

UPDATE sys_message SET log_level=2 WHERE id=3142;
