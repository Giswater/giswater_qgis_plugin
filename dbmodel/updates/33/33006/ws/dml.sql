/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 14/10/2019
UPDATE config_param_system SET value='TRUE' where parameter='om_mincut_use_pgrouting';

UPDATE  audit_cat_param_user SET label='Quality mode:', layout_id=1, layout_order=9, layoutname='grl_general_1' WHERE id = 'inp_options_quality_mode';
UPDATE  audit_cat_param_user SET layout_id=2, layout_order=9, layoutname='grl_general_2' WHERE id = 'inp_options_node_id';