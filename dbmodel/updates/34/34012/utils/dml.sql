/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_param_user SET dv_querytext = replace(dv_querytext, 'fprocesscat_id', 'fid') WHERE id = 'edit_cadtools_baselayer_vdefault';
UPDATE sys_param_user SET dv_querytext = replace(dv_querytext, 'om_visit_parameter', 'config_visit_parameter') WHERE id = 'om_visit_parameter_vdefault';

DELETE FROM config_csv WHERE fid IN(2,5,6,7, 140, 141, 239,240, 246,247);

UPDATE config_info_table_x_type SET infotype_id = 1 WHERE infotype_id = 100;
UPDATE config_info_table_x_type SET infotype_id = 2 WHERE infotype_id = 0;