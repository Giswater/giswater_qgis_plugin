/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

WITH numbered AS (
    SELECT id,
        typevalue,
        (ROW_NUMBER() OVER (ORDER BY id)) - 1 AS new_id
    FROM config_typevalue
    WHERE typevalue = 'sys_table_context'
)
UPDATE config_typevalue c
SET idval = c.id, id = n.new_id
FROM numbered n
WHERE c.id = n.id AND c.typevalue = n.typevalue AND c.typevalue = 'sys_table_context';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('widgettype_typevalue', 'multiple_checkbox', 'multiple_checkbox', 'multipleCheckbox', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('widgettype_typevalue', 'multiple_option', 'multiple_option', 'multipleOption', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3516, 'gw_fct_manage_inserts_by_ids', 'utils', 'function', 'integer, text, text, integer[]', 'integer', 'Function to manage batch inserts of features into various relation tables (campaign, lot, psector, element, visit) based on relation type and feature type. Returns the number of inserted features.', NULL, NULL, 'core', NULL);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4408, 'There are no nodes to be repaired.', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4410, '%v_count% nodes have been created to repair topology.', NULL, 0, true, 'utils', 'core', 'AUDIT');

-- activate matcat_id and sys_elev null values checks.
UPDATE sys_fprocess
SET isaudit=true, active=true
WHERE fid=569;

UPDATE sys_fprocess
SET isaudit=true,active=true
WHERE fid=584;

INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('man_vlink', 'Additional information for vlink management', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL) ON CONFLICT DO NOTHING;
