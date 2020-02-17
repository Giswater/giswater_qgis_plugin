/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/13
UPDATE config_api_layer SET is_editable = TRUE WHERE layer_id = ANY(ARRAY['v_edit_arc', 'v_edit_node','v_edit_connec']);

--17/02/2020
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='verified' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='ownercat_id' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='buildercat_id' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='streetaxis_id' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='streetaxis2_id' AND formtype='feature';
