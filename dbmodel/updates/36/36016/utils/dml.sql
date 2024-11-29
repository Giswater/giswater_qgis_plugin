/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3328, 'gw_trg_edit_municipality', 'utils', 'function', 'json', 'json', 'Trigger to insert or update elements in v_ext_municipality table.', 'role_edit', NULL, 'core');

UPDATE config_toolbox SET inputparams='[{"widgetname":"updateValues", "label":"Values to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["allValues", "nullValues"], "comboNames":["ALL VALUES", "NULL ELEVATION VALUES"], "selectedId":"nullValues"}]'::json WHERE id=2760;
