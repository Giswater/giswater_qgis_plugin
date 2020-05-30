/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


cal renombrar el utils.audit_log.fprocesscat_id -> fid

-- 2020/05/25

-- sys_fprocess
ALTER TABLE sys_fprocess RENAME id TO fid;
ALTER TABLE sys_fprocess ADD column parameters JSON;
ALTER TABLE sys_fprocess DROP column context;

-- config_csv
DELETE FROM config_csv WHERE id IN(14,15,16);
ALTER TABLE config_csv RENAME id TO fid;
ALTER TABLE config_csv RENAME isdeprecated TO active;
ALTER TABLE config_csv RENAME csv_structure TO descpript;
ALTER TABLE config_csv DROP column formname;
ALTER TABLE config_csv ADD COLUMN addparam JSON;
UPDATE config_csv SET active = TRUE;


-- config_info_layer
ALTER TABLE config_info_layer RENAME add_param TO addparam;

-- temp_csv
ALTER TABLE temp_csv2pg RENAME TO temp_csv;
ALTER TABLE temp_csv DROP CONSTRAINT temp_csv2pg_csv2pgcat_id_fkey2;
ALTER TABLE temp_csv DROP CONSTRAINT temp_csv2pg_pkey1;
ALTER TABLE temp_csv RENAME csv2pgcat_id TO fid;
ALTER TABLE temp_csv ADD CONSTRAINT temp_csv_pkey PRIMARY KEY(id);
ALTER TABLE temp_csv ADD CONSTRAINT temp_csv_fkey FOREIGN KEY (fid) REFERENCES sys_fprocess (fid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


-- config_fprocess
ALTER TABLE config_csv_param RENAME TO config_fprocess;
ALTER TABLE config_fprocess RENAME pg2csvcat_id TO fid;
ALTER TABLE config_fprocess RENAME reverse_pg2csvcat_id TO fid2;
ALTER TABLE config_fprocess DROP column csvversion;
ALTER TABLE config_fprocess ADD column addparam JSON;


-- sys_feature_type
ALTER TABLE sys_feature_type RENAME net_category TO classlevel;
UPDATE sys_feature_type SET classlevel = 5 WHERE classlevel  = 4;
UPDATE sys_feature_type SET classlevel = 4 WHERE classlevel  = 3;
UPDATE sys_feature_type SET classlevel = 3 WHERE classlevel  = 2;
UPDATE sys_feature_type SET classlevel = 2 WHERE id IN ('CONNEC' , 'GULLY');

-- sys_feature_cat
UPDATE sys_feature_cat SET epa_default = 'NONE' WHERE epa_default IS NULL;

-- fid
ALTER TABLE audit_check_data RENAME fprocesscat_id TO fid;
ALTER TABLE audit_log_data RENAME fprocesscat_id TO fid;
ALTER TABLE anl_arc RENAME fprocesscat_id TO fid;
ALTER TABLE anl_arc_x_node RENAME fprocesscat_id TO fid;
ALTER TABLE anl_connec RENAME fprocesscat_id TO fid;
ALTER TABLE anl_node RENAME fprocesscat_id TO fid;
ALTER TABLE temp_table RENAME fprocesscat_id TO fid;

-- sys_foreingkey
ALTER TABLE sys_foreingkey DROP constraint typevalue_fk_pkey ;
ALTER TABLE sys_foreingkey DROP constraint sys_foreingkey_unique; 
ALTER TABLE sys_foreingkey ADD CONSTRAINT sys_foreingkey_pkey PRIMARY KEY (typevalue_table, typevalue_name, target_table, target_field);
ALTER TABLE sys_foreingkey DROP column id;


-- sys_typevalue
ALTER TABLE sys_typevalue DROP constraint sys_typevalue_cat_pkey;
ALTER TABLE sys_typevalue DROP constraint sys_typevalue_unique;
ALTER TABLE sys_typevalue ADD CONSTRAINT sys_typevalue_pkey PRIMARY KEY (typevalue_table, typevalue_name);
ALTER TABLE sys_typevalue DROP column id;


-- active
ALTER TABLE config_toolbox ADD column active boolean;
ALTER TABLE config_file ADD column active boolean;
ALTER TABLE config_visit_parameter_action ADD column active boolean;
ALTER TABLE config_visit_parameter ADD column active boolean;
ALTER TABLE config_user_x_expl ADD column active boolean;
ALTER TABLE config_visit_class_x_feature ADD column active boolean;
ALTER TABLE config_visit_class_x_parameter ADD column active boolean;
ALTER TABLE config_visit_class_x_workorder ADD column active boolean;

ALTER TABLE sys_foreingkey ADD column active boolean;

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

DELETE FROM sys_fprocess WHERE fid = 42;

INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(234,'Import db prices','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(235,'Import elements','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(236,'Import addfields','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(237,'Import dxf blocks','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(238,'Import om visit','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(239,'Import inp','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(240,'Import arc visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(241,'Import node visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(242,'Import connec visits','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(243,'Import gully visits','ud');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(244,'Import timeseries','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(245,'Import visit file','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(246,'Export ui','utils');
INSERT INTO sys_fprocess (fid, fprocess_name , project_type) VALUES(247,'Import ui','utils');



