/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--23/10/2019
UPDATE audit_cat_table SET notify_action=replace(notify_action::text,'action','channel')::json where notify_action is not null;
UPDATE audit_cat_table SET notify_action=replace(notify_action::text,'desktop','user')::json where notify_action::text ilike '%refresh_canvas%';

--25/10/2019
UPDATE config_param_user SET parameter='qgis_toggledition_forceopen' WHERE parameter ='cf_keep_opened_edition';
UPDATE audit_cat_param_user SET id='qgis_toggledition_forceopen' WHERE id ='cf_keep_opened_edition';
UPDATE config_param_system SET parameter='sys_mincutalerts_enable' WHERE parameter ='custom_action_sms';


-- 25/10/2019
INSERT INTO sys_fprocess_cat VALUES (69,'Check exported pipes with status CV', 'epa','Check exported pipes with status CV','ws');
INSERT INTO sys_fprocess_cat VALUES (70,'Check exported valves where to_arc is not according with closest arcs', 'epa','Check exported valves where to_arc is not according with closest arcs','ws');
INSERT INTO sys_fprocess_cat VALUES (71,'Check exported pumps where to_arc is not one of the two closest arcs', 'epa','Check exported pumps where to_arc is not one of the two closest arcs','ws');
INSERT INTO sys_fprocess_cat VALUES (72,'Pump curve with 3 points', 'epa','Pump curve with 3 points','ws');
INSERT INTO sys_fprocess_cat VALUES (73,'go2crm connec.dma values', 'epa','go2crm connec.dma values','ws');
INSERT INTO sys_fprocess_cat VALUES (74,'crm2pg connec_x_data flow values', 'epa','crm2pg connec_x_data flow values','ws');
