/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- sys_param_user
UPDATE sys_param_user SET dv_querytext = replace(dv_querytext, 'fprocesscat_id', 'fid') WHERE id = 'edit_cadtools_baselayer_vdefault';
UPDATE sys_param_user SET dv_querytext = replace(dv_querytext, 'om_visit_parameter', 'config_visit_parameter') WHERE id = 'om_visit_parameter_vdefault';

-- config_csv
UPDATE config_csv SET active = TRUE;
DELETE FROM config_csv WHERE fid IN(2,5,6,7, 140, 141, 239,240, 246,247);

-- sys_table
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null where id ='config_csv';
UPDATE sys_table SET id = 'config_fprocess' WHERE id = 'config_csv_param';
UPDATE sys_table SET id = 'temp_csv' WHERE id = 'temp_csv2pg';
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null where id ='sys_foreingkey';
UPDATE sys_table SET sys_sequence = 'sys_addfields_id_seq', sys_sequence_field = 'id' where id ='sys_addfields';
INSERT INTO sys_table VALUES ('sys_typevalue', 'System', 'System typevalues', 'role_admin');
UPDATE sys_table SET isdeprecated = false WHERE id = 'sys_typevalue';

-- sys_feature_type
ALTER TABLE sys_feature_type RENAME net_category TO classlevel;
UPDATE sys_feature_type SET classlevel = 5 WHERE classlevel  = 4;
UPDATE sys_feature_type SET classlevel = 4 WHERE classlevel  = 3;
UPDATE sys_feature_type SET classlevel = 3 WHERE classlevel  = 2;
UPDATE sys_feature_type SET classlevel = 2 WHERE id IN ('CONNEC' , 'GULLY');

-- sys_feature_cat
UPDATE sys_feature_cat SET epa_default = 'NONE' WHERE epa_default IS NULL;

-- sys_fprocess
UPDATE sys_fprocess set fid = fid+100 WHERE fid > 99;
UPDATE sys_fprocess set fid = fid+100 WHERE fid < 100;
UPDATE config_csv SET fid =234	WHERE fid =1;
UPDATE config_csv SET fid =235	WHERE fid =3;
UPDATE config_csv SET fid =236	WHERE fid =4;
UPDATE config_csv SET fid =237	WHERE fid =8;
UPDATE config_csv SET fid =238	WHERE fid =9;
UPDATE config_csv SET fid =141	WHERE fid =10;
UPDATE config_csv SET fid =140	WHERE fid =11;
UPDATE config_csv SET fid =239	WHERE fid =12;
UPDATE config_csv SET fid =240	WHERE fid =13;
UPDATE config_csv SET fid =241	WHERE fid =14;
UPDATE config_csv SET fid =242	WHERE fid =15;
UPDATE config_csv SET fid =243	WHERE fid =16;
UPDATE config_csv SET fid =244	WHERE fid =17;
UPDATE config_csv SET fid =245	WHERE fid =18;
UPDATE config_csv SET fid =246	WHERE fid =19;
UPDATE config_csv SET fid =247	WHERE fid =20;
UPDATE config_csv SET fid =154	WHERE fid =21;

DELETE FROM sys_fprocess WHERE fid = 142;

INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (234,'Import db prices','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (235,'Import elements','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (236,'Import addfields','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (237,'Import dxf blocks','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (238,'Import om visit','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (239,'Import inp','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (240,'Import arc visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (241,'Import node visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (242,'Import connec visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (243,'Import gully visits','ud');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (244,'Import timeseries','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (245,'Import visit file','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (246,'Export ui','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES (247,'Import ui','utils');

-- 
UPDATE config_form_tabs SET device = 4 WHERE device = 9;

--
UPDATE config_info_table_x_type SET infotype_id = 1 WHERE infotype_id = 100;
UPDATE config_info_table_x_type SET infotype_id = 2 WHERE infotype_id = 0;

UPDATE config_toolbox SET inputparams = (replace (inputparams::text, 'layout_order', 'layoutorder'))::json;





