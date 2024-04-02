/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system
SET descript='If true, connec''s label and symbol will be rotated using the angle of link. 
Label must be configured with "CASE WHEN label_x = ''R'' THEN ''    '' ||  "connec_id" ELSE  "connec_id"  || ''    ''  END" as ''Expression'', label_x as ''Position priotiry'' and label_rotation as ''Rotation'''
WHERE "parameter"='edit_link_update_connecrotation';
