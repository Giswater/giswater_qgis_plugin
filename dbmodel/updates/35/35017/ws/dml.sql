/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/30
ALTER TABLE cat_arc ALTER COLUMN shape SET DEFAULT 'CIRCULAR';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (414, 'Cat connec rows without dint','ws', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/03
update sys_param_user set layoutname='lyt_edit', layoutorder=1 where id='edit_elementcat_vdefault';

--2021/11/06
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"valueRelation":{', '"valueRelation":{"nullValue":false, '))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL;

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"valueRelation": {', '"valueRelation":{"nullValue":false, '))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL;

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false', '"nullValue":true'))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL AND formname IN ('v_edit_inp_reservoir', 'v_edit_inp_dscenario_reservoir') AND columnname IN('pattern_id');

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false', '"nullValue":true'))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL AND formname IN ('v_edit_inp_tank', 'v_edit_inp_dscenario_tank') AND columnname IN('pattern_id', 'curve_id');

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false', '"nullValue":true'))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL AND formname IN ('v_edit_inp_inlet') AND columnname IN('pattern_id', 'curve_id');

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false', '"nullValue":true'))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL AND formname IN ('v_edit_inp_junction', 'v_edit_inp_dscenario_junction') AND columnname IN('pattern_id');

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false', '"nullValue":true'))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL AND formname IN ('v_edit_inp_pump', 'v_edit_inp_dscenario_pump', 'inp_pump_additional') AND columnname IN('pattern');

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false', '"nullValue":true'))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL AND formname IN ('v_edit_inp_valve', 'v_edit_inp_dscenario_valve', 'v_edit_inp_virtualvalve') AND columnname IN('curve_id');