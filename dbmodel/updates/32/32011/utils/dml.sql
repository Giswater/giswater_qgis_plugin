/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/02/27
SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('om_visit_duration_vdefault','{"class1":"1 hours","class2":"1 hours","class3":"1 hours","class4":"1 hours","class5":"1 hours","class6":"1 hours","class7":"1 hours","class8":"1 hours","class9":"1 hours","class10":"1 hours"}','json', 'om_visit', 'Parameters used for visits');


INSERT INTO om_visit_type VALUES (1, 'planned') ON CONFLICT (id) DO NOTHING;
INSERT INTO om_visit_type VALUES (2, 'unspected') ON CONFLICT (id) DO NOTHING;



-- add function gw_api_get_filtervalues_vdef

--03/04/2019 - activate audit_cat_param_user for new visit
UPDATE audit_cat_param_user SET isdeprecated=true, isenabled=false where id='om_param_type_vdefault';
UPDATE audit_cat_param_user SET isdeprecated=true, isenabled=false where id='parameter_vdefault';

--2019/04/04

INSERT INTO audit_cat_param_user VALUES ('visitextcode_vdefault', 'config', 'Default value of external code of a visit', 'role_om', NULL, NULL, 'Visit external code:', NULL, NULL, true, 2, 10, 'utils', false, NULL, NULL, NULL, false, 'string', 'linetext', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitstatus_vdefault', 'config', 'Default value of visit status', 'role_om', NULL, NULL, 'Visit status:', 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_cat_status''', NULL, true, 2, 9, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitenddate_vdefault', 'config', 'Default value of visit end date', 'role_om', NULL, NULL, 'Visit end date:', NULL, NULL, true, 2, 6, 'utils', false, NULL, NULL, NULL, false, 'date', 'datepickertime', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitstartdate_vdefault', 'config', 'Default value of visit start date', 'role_om', NULL, NULL, 'Visit start date:', NULL, NULL, true, 2, 7, 'utils', false, NULL, NULL, NULL, false, 'date', 'datepickertime', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitparameter_vdefault', 'dynamic_param', 'Default value of parameter of an event', 'role_om', NULL, NULL, 'Visit parameter:', NULL, NULL, false, NULL, NULL, 'utils', false, NULL, NULL, NULL, false, 'string', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitclass_vdefault', 'config', 'Default value of visit class', 'role_om', NULL, NULL, 'Visit class:', 'SELECT id, idval FROM om_visit_class WHERE feature_type IS NULL AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 1, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitclass_vdefault_connec', 'config', 'Default value of visit class for connec', 'role_om', NULL, NULL, 'Visit class of connec:', 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 4, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visit_duration_vdef', 'config', 'Default duration of a visit', 'role_om', NULL, NULL, 'Visit duration', NULL, NULL, true, 2, 8, 'utils', false, NULL, NULL, NULL, false, 'integer', 'linetext', false, NULL, '24 hours', 'grl_om', NULL, true, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitclass_vdefault_node', 'config', 'Default value of visit class for node', 'role_om', NULL, NULL, 'Visit class of node:', 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 3, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitclass_vdefault_arc', 'config', 'Default value of visit class for arc', 'role_om', NULL, NULL, 'Visit class of arc:', 'SELECT id, idval FROM om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 2, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO audit_cat_param_user VALUES ('visitcat_vdefault', 'dynamic_param', 'Default value of visit catalog', 'role_om', NULL, NULL, 'Visit catalog:', 'SELECT id AS id, name as idval  FROM om_visit_cat WHERE id IS NOT NULL', NULL, true, NULL, NULL, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);

INSERT INTO value_state_type VALUES (99, 2, 'FICTICIUS', true, false) ON CONFLICT (id) DO NOTHING;

update audit_cat_table SET context=a.text
FROM (select case when lower(value)='true' then 'view from external schema' ELSE 'external_table' END AS text from config_param_system where parameter = 'sys_utils_schema')a 
where audit_cat_table.id like 'ext_%';