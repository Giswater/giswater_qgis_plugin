/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table SET notify_action=
'[{"channel":"user","name":"set_layer_index", "enabled":"true", "trg_fields":"state","featureType":["gully", "v_edit_link"]}]'
WHERE id ='plan_psector_x_gully';
