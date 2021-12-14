/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/30
UPDATE sys_table SET id = 'inp_snowpack_value' WHERE id = 'inp_snowpack_values';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, descript AS idval FROM cat_mat_arc WHERE id IS NOT NULL',
iseditable=true, dv_isnullvalue=true
WHERE formname='v_edit_connec' AND columnname='matcat_id';