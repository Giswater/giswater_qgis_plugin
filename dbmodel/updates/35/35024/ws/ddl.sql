/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
CREATE TABLE inp_dscenario_rules
(id serial PRIMARY KEY,
dscenario_id integer NOT NULL,
sector_id integer NOT NULL,
text text NOT NULL,
active boolean);

ALTER TABLE inp_dscenario_rules ADD CONSTRAINT inp_dscenario_rules_sector_id_fkey FOREIGN KEY (sector_id)
REFERENCES sector (sector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_rules ADD CONSTRAINT inp_dscenario_rules_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE crm_zone
(id INTEGER PRIMARY KEY,
name TEXT,
descript TEXT,
the_geom geometry(multipolygon, SRID_VALUE)
);


--2022/04/17
ALTER TABLE IF EXISTS rtc_scada_node RENAME TO _rtc_scada_node_;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rtc_scada_x_dma", "column":"scada_id", "newName":"node_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rtc_scada_x_sector", "column":"scada_id", "newName":"node_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rtc_scada_x_sector", "column":"id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rtc_scada_x_dma", "column":"id"}}$$);

ALTER TABLE rtc_scada_x_dma ADD CONSTRAINT rtc_scada_x_dma_pkey PRIMARY KEY(node_id, dma_id);
ALTER TABLE rtc_scada_x_sector ADD CONSTRAINT rtc_scada_x_sector_pkey PRIMARY KEY(node_id, sector_id);

ALTER TABLE rtc_scada_x_sector RENAME TO _ext_rtc_scada_x_sector_;

ALTER TABLE rtc_scada_x_dma RENAME TO om_waterbalance_dma_graf;

DROP TABLE IF EXISTS _ext_rtc_scada_x_data_;
DROP TABLE IF EXISTS _ext_rtc_scada_;

CREATE TABLE IF NOT EXISTS ext_rtc_scada (
scada_id varchar(30),
source varchar(30),
source_id varchar(30),
node_id varchar(16),
code varchar(50),
type_id varchar(50),
class_id varchar(50),
category_id varchar(50),
catalog_id varchar(50),
descript text,
CONSTRAINT ext_rtc_scada_pkey PRIMARY KEY (scada_id),
CONSTRAINT ext_rtc_scada_unique UNIQUE (source, source_id)
);


CREATE TABLE IF NOT EXISTS ext_rtc_scada_x_data (
node_id varchar(16),
cat_period_id varchar(16),
value double precision,
value_type integer,
value_status integer,
value_state integer,
value_date timestamp,
data_type text,
CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY (node_id, cat_period_id)
);


CREATE TABLE IF NOT EXISTS om_waterbalance (
expl_id integer,
dma_id integer,
cat_period_id varchar(16),
total_sys_input double precision,
auth_bill_met_export double precision,
auth_bill_met_hydro double precision,
auth_bill_unmet double precision,
auth_unbill_met double precision,
auth_unbill_unmet double precision,
loss_app_unath double precision,
loss_app_met_error double precision,
loss_app_data_error double precision,
loss_real_leak_main double precision,
loss_real_leak_service double precision,
loss_real_storage double precision,
type varchar(50),
descript text,
CONSTRAINT om_waterbalance_pkey PRIMARY KEY (dma_id, cat_period_id)
);

ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_dma_id_fkey FOREIGN KEY (dma_id)
REFERENCES dma (dma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE dma DROP CONSTRAINT dma_pattern_id_fkey;

ALTER TABLE dma ADD CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE restrict;


ALTER TABLE ext_rtc_sector_period RENAME TO _ext_rtc_sector_period_; 