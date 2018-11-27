This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;




ALTER TABLE config_web_layer ADD COLUMN is_tiled boolean;


CREATE TABLE config_web_composer_scale(
  id integer NOT NULL,
  idval text,
  descript text,
  orderby integer,
  CONSTRAINT config_web_composer_scale_pkey PRIMARY KEY (id));

  
CREATE TABLE selector_composer(
  field_id text NOT NULL,
  field_value text,
  user_name text NOT NULL,
  CONSTRAINT selector_composer_pkey PRIMARY KEY (field_id, user_name));
  
  

UPDATE config_web_fields_cat_type SET id='datepikertime' WHERE id='date';


INSERT INTO config_web_fields_cat_type VALUES ('formDivider');

  
INSERT INTO config_web_composer_scale VALUES (100, '1:100', NULL, 1);
INSERT INTO config_web_composer_scale VALUES (200, '1:200', NULL, 2);
INSERT INTO config_web_composer_scale VALUES (500, '1:500', NULL, 3);
INSERT INTO config_web_composer_scale VALUES (1000, '1:1000', NULL, 4);
INSERT INTO config_web_composer_scale VALUES (2000, '1:2000', NULL, 5);
INSERT INTO config_web_composer_scale VALUES (10000, '1:10000', NULL, 6);
INSERT INTO config_web_composer_scale VALUES (50000, '1:50000', NULL, 7);
INSERT INTO config_web_composer_scale VALUES (5000, '1:5000', NULL, NULL);



INSERT INTO config_web_fields VALUES (297, 'F32', 'composer', true, 'string', NULL, NULL, NULL, 'Composer:', 'combo', 'config_web_composer', 'id', 'id', NULL, true, 1);
INSERT INTO config_web_fields VALUES (295, 'F32', 'descript', true, 'string', NULL, NULL, 'descript', 'Descripcio:', 'textarea', NULL, NULL, NULL, NULL, true, 5);
INSERT INTO config_web_fields VALUES (300, 'F32', 'scale', true, 'string', NULL, NULL, NULL, 'Escala:', 'combo', 'config_web_composer_scale', 'id', 'idval', NULL, true, 2);
INSERT INTO config_web_fields VALUES (294, 'F32', 'title', true, 'string', NULL, NULL, 'title', 'Titol:', 'text', NULL, NULL, NULL, NULL, true, 4);
INSERT INTO config_web_fields VALUES (296, 'F32_', 'date', true, 'date', NULL, NULL, NULL, 'Data:', 'datepikertime', NULL, NULL, NULL, NULL, true, 6);
INSERT INTO config_web_fields VALUES (304, 'F32', 'divider', false, 'string', NULL, NULL, NULL, NULL, 'formDivider', NULL, NULL, NULL, NULL, true, 3);


INSERT INTO audit_cat_table VALUES ('config_web_composer_scale', 'web', '', 'role_basic', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_web_composer', 'web', '', 'role_basic', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('selector_composer', 'web', '', 'role_basic', 0, NULL, NULL, 0, NULL, NULL, NULL);
