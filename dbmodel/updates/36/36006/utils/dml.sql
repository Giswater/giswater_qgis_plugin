/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (518, 'Set end feature', 'utils', null, 'core', true, 'Function process', null) 
ON CONFLICT (fid) DO NOTHING;

-- 21/10/2023
INSERT INTO config_typevalue (typevalue, id, addparam) VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}', '{"orderBy":99}');
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Category type' WHERE id = 'man_type_category';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Fluid type' WHERE id = 'man_type_fluid';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Location type' WHERE id = 'man_type_location';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Function type' WHERE id = 'man_type_function';

-- 24/10/23
UPDATE sys_param_user SET ismandatory = True WHERE id = 'plan_psector_vdefault';

-- 27/10/23
UPDATE sys_message SET error_message = 'IT iS IMPOSSIBLE TO UPDATE ARC_ID FROM PSECTOR DIALOG BECAUSE THIS PLANNED LINK HAS NOT ARC AS EXIT-TYPE',
hint_message = 'TO UPDATE IT USE ARC_ID CONNECT(CONNEC or GULLY) DIALOG OR EDIT THE ENDPOINT OF LINK''S GEOMETRY ON CANVAS'
where id = 3212;

UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='ve_arc_pipe' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='ve_arc_varc' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
