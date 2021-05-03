/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27


ALTER TABLE IF EXISTS inp_rules_controls_importinp RENAME TO _inp_rules_controls_importinp_ ;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_node", "column":"epa_table"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_arc", "column":"epa_table"}}$$);

DROP TABLE IF EXISTS inp_node_type;
DROP TABLE IF EXISTS inp_arc_type;


-- 2021/04/24
ALTER TABLE inp_valve ALTER COLUMN status SET DEFAULT 'ACTIVE';
ALTER TABLE inp_rules_importinp RENAME TO _inp_rules_importinp_;

-- 2021/05/01
ALTER TABLE inp_rules_x_sector DROP CONSTRAINT inp_rules_x_sector_sector_id_fkey;
ALTER TABLE inp_controls_x_arc RENAME TO _inp_controls_x_arc_;
ALTER TABLE inp_rules_x_arc RENAME TO _inp_rules_x_arc_;
ALTER TABLE inp_rules_x_node RENAME TO _inp_rules_x_node_;

ALTER TABLE inp_rules_x_sector RENAME TO inp_rules;
ALTER SEQUENCE inp_rules_x_sector_id_seq RENAME TO inp_rules_id_seq;


CREATE TABLE inp_controls
(
  id serial NOT NULL,
  sector_id integer NOT NULL,
  text text NOT NULL,
  active boolean,
  CONSTRAINT inp_controls_pkey PRIMARY KEY (id),
  CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id)
      REFERENCES sector (sector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT);

    









