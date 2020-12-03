/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2018/10/27
ALTER TABLE om_visit_parameter ADD COLUMN ismultifeature boolean;

DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;
CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS ON INSERT TO arc DO  
INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent) 
VALUES (new.arc_id,  (SELECT value FROM config_param_user WHERE parameter='pavementcat_vdefault' and cur_user="current_user"()LIMIT 1), '1'::numeric);

-- 2018/10/29
ALTER TABLE node_type ADD COLUMN isarcdivide boolean DEFAULT TRUE;


-- 2018/11/11
CREATE TABLE dattrib(
  dattrib_type integer,
  feature_id character varying(30),
  feature_type varchar(30),
  idval text,
  CONSTRAINT dattrib_pkey PRIMARY KEY (dattrib_type, feature_id));

  
CREATE TABLE dattrib_type(
  id INTEGER PRIMARY KEY,
  idval varchar(30),
  observ text,
  project_type varchar (30));

ALTER TABLE dattrib ADD CONSTRAINT dattrib_dattrib_type_fkey FOREIGN KEY (dattrib_type)
REFERENCES dattrib_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE INDEX dattrib_feature_id_index ON dattrib USING btree (feature_id COLLATE pg_catalog."default");

CREATE INDEX dattrib_dattrib_type_index ON dattrib USING btree (dattrib_type);


-- 2018/11/28
ALTER TABLE ext_cat_period RENAME starttime TO start_date;
ALTER TABLE ext_cat_period RENAME endtime TO end_date;

ALTER TABLE ext_rtc_hydrometer_x_data ADD COLUMN value_date date;

-- 2018/12/6
CREATE INDEX rtc_hydrometer_x_connec_index_connec_id ON rtc_hydrometer_x_connec  USING btree  (connec_id);
CREATE INDEX ext_rtc_hydrometer_x_data_index_hydrometer_id ON ext_rtc_hydrometer_x_data USING btree (hydrometer_id);
CREATE INDEX ext_rtc_hydrometer_x_data_index_cat_period_id ON ext_rtc_hydrometer_x_data USING btree (cat_period_id);

-- 2018/12/25
ALTER TABLE audit_cat_table ADD COLUMN isdeprecated boolean DEFAULT FALSE;
ALTER TABLE audit_cat_function ADD COLUMN isdeprecated boolean DEFAULT FALSE;


CREATE TABLE audit_cat_sequence (
  id text PRIMARY KEY,
  isdeprecated boolean DEFAULT false );
  
 
-- 20129/01/20
ALTER TABLE ext_rtc_scada_dma_period ADD COLUMN m3_total_period_hydro double precision;
ALTER TABLE ext_rtc_scada_dma_period ADD COLUMN effc double precision;
ALTER TABLE ext_rtc_scada_dma_period ADD COLUMN minc double precision;
ALTER TABLE ext_rtc_scada_dma_period ADD COLUMN maxc double precision;
ALTER TABLE ext_rtc_scada_dma_period ADD COLUMN isscada boolean;

ALTER TABLE dma ADD COLUMN minc double precision;
ALTER TABLE dma ADD COLUMN maxc double precision;


