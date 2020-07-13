/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/02

UPDATE sys_foreignkey  SET target_field = 'priority' WHERE typevalue_name = 'value_priority';

UPDATE  config_form_fields set dv_querytext = 'SELECT id as id,idval FROM plan_typevalue WHERE typevalue=''value_priority'''
where columnname='priority' and formname='v_edit_plan_psector';

-- update priority when updateing from older verions where priority has the idval of the typevalue
UPDATE plan_psector SET priority=id FROM plan_typevalue WHERE plan_typevalue.idval=plan_psector.priority AND plan_typevalue.typevalue='value_priority';

INSERT INTO config_toolbox (id, alias, isparametric, functionparams, inputparams, active)
VALUES (2826,'LRS', true, '{"featureType":[]}', '[{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"1"}]', FALSE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_param_system (parameter, value, datatype, descript, isenabled)
VALUES ('grafanalytics_lrs_feature', '{"arc":{"costField":""}, "nodeChild":{"valueField":"", "headerField":""}}', 'json',  'List of fields updated during the process of calculating linear reference',false)
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, datatype, descript, isenabled)
VALUES ('grafanalytics_lrs_graf', '{"headers":[{"node": "", "toArc": [""]}],"ignoreArc":[""]}', 'json',  'Configuration of starting points(headers) and arc which indicate direction of calculating linear reference', false)
ON CONFLICT (parameter) DO NOTHING;

--07/07/2020
UPDATE  config_form_fields set dv_querytext = 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL AND expl_id != 0  ' WHERE formname='v_edit_dimensions' AND columnname='expl_id';

INSERT INTO sys_function(id, function_name, project_type, function_type, sys_role)
VALUES (2972, 'gw_trg_ui_plan_psector','utils', 'trigger function', 'role_master')
ON CONFLICT (id) DO NOTHING;

DELETE FROM config_form_fields where formname = 'v_ui_hydrometer';

UPDATE sys_param_user SET layoutname = 'lyt_reports_2' WHERE  layoutname = 'grl_reports_18';

UPDATE config_form_fields set dv_querytext = 'SELECT id, idval FROM plan_typevalue 
WHERE typevalue = ''price_units'''  WHERE dv_querytext like'%price_value%';

UPDATE config_form_fields set dv_querytext = 'SELECT id, idval FROM plan_typevalue 
WHERE typevalue = ''psector_type'''  WHERE dv_querytext like'%psector_cat_type%';

UPDATE config_form_fields set dv_querytext = 'SELECT id, id AS idval FROM inp_curve 
WHERE id IS NOT NULL'  WHERE dv_querytext like'%inp_curve_id%';

INSERT INTO config_typevalue VALUES ('formtype_typevalue', 'form_print', 'form_print', 'formPrint');

UPDATE config_form_fields SET formtype='form_feature' WHERE formtype='form_generic';
UPDATE config_form_fields SET formtype='form_print' WHERE formname='print';

UPDATE config_form_fields SET widgettype='combo' WHERE columnname='macroexpl_id' AND formname='v_edit_exploitation';

UPDATE config_form_fields SET 
dv_querytext = 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL'
WHERE columnname = 'dma_id' AND widgettype = 'combo';