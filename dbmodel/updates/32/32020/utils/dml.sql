/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO audit_cat_param_user (id,formname,description,sys_role_id,qgis_message,label,dv_querytext,dv_parent_id,isenabled,layout_id,layout_order,project_type,isparent,dv_querytext_filterc,feature_field_id,feature_dv_parent_value,isautoupdate,datatype,widgettype,ismandatory,widgetcontrols,vdefault,layout_name,reg_exp) VALUES('visitclass_vdefault_connec', 'config', NULL, 'role_om', NULL, 'Visit class vdefault connec:', 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 6, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user (id,formname,description,sys_role_id,qgis_message,label,dv_querytext,dv_parent_id,isenabled,layout_id,layout_order,project_type,isparent,dv_querytext_filterc,feature_field_id,feature_dv_parent_value,isautoupdate,datatype,widgettype,ismandatory,widgetcontrols,vdefault,layout_name,reg_exp) VALUES('visitclass_vdefault_arc', 'config', NULL, 'role_om', NULL, 'Visit class vdefault arc:', 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 4, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user (id,formname,description,sys_role_id,qgis_message,label,dv_querytext,dv_parent_id,isenabled,layout_id,layout_order,project_type,isparent,dv_querytext_filterc,feature_field_id,feature_dv_parent_value,isautoupdate,datatype,widgettype,ismandatory,widgetcontrols,vdefault,layout_name,reg_exp) VALUES('visitclass_vdefault_node', 'config', NULL, 'role_om', NULL, 'Visit class vdefault node:', 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 5, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL);


-- 2019/02/27
SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('om_visit_duration_vdefault','{"class1":"1 hours","class2":"1 hours","class3":"1 hours","class4":"1 hours","class5":"1 hours","class6":"1 hours","class7":"1 hours","class8":"1 hours","class9":"1 hours","class10":"1 hours"}','json', 'om_visit', 'Parameters used for visits');


INSERT INTO sys_combo_cat VALUES (1, 'om_visit_clean');
INSERT INTO sys_combo_cat VALUES (2, 'om_visit_desperfect');
INSERT INTO sys_combo_cat VALUES (3, 'om_visit_status');
INSERT INTO sys_combo_cat VALUES (4, 'incidency');
INSERT INTO sys_combo_cat VALUES (5, 'om_lot_status');



-- add function gw_api_get_filtervalues_vdef