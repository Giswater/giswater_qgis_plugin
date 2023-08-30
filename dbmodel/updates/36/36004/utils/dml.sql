/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_param_user SET value = value::jsonb - 'autoRepair'
WHERE  parameter = 'inp_options_debug';

UPDATE config_param_user SET value = value::jsonb - 'steps'
WHERE  parameter = 'inp_options_debug';

UPDATE sys_table SET context='{"level_1":"OM","level_2":"VISIT"}', orderby=3, alias='Visit Catalog' WHERE id='om_visit_cat';
UPDATE sys_table SET context='{"level_1":"OM","level_2":"VISIT"}', orderby=4, alias='Parameter Catalog' WHERE id='config_visit_parameter';