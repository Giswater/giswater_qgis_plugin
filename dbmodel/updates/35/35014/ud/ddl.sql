/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/05
ALTER TABLE gully ALTER COLUMN state_type SET NOT NULL;

DROP TRIGGER if exists gw_trg_scenario_management ON cat_hydrology;
DROP TRIGGER if exists gw_trg_scenario_management ON cat_dwf_scenario;
DROP FUNCTION IF EXISTS gw_trg_scenario_management();

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_lid_usage", "column":"hydrology_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_loadings_pol_x_subc", "column":"hydrology_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_groundwater", "column":"hydrology_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_coverage_land_x_subc", "column":"hydrology_id", "dataType":"integer", "isUtils":"False"}}$$);

-- alter primary keys in order to enhance scenario management
ALTER TABLE inp_lid_usage DROP CONSTRAINT inp_lid_usage_subc_id_fkey;
ALTER TABLE inp_loadings_pol_x_subc DROP CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey;
ALTER TABLE inp_groundwater DROP CONSTRAINT inp_groundwater_subc_id_fkey;
ALTER TABLE inp_coverage_land_x_subc DROP CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey;
ALTER TABLE inp_subcatchment DROP CONSTRAINT subcatchment_pkey;

ALTER TABLE inp_subcatchment ADD CONSTRAINT subcatchment_pkey PRIMARY KEY(subc_id, hydrology_id);

ALTER TABLE inp_lid_usage ADD CONSTRAINT inp_lid_usage_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_loadings_pol_x_subc ADD CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_groundwater ADD CONSTRAINT inp_groundwater_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_coverage_land_x_subc ADD CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_lid_usage DROP CONSTRAINT inp_lid_usage_pkey;
ALTER TABLE inp_lid_usage ADD CONSTRAINT inp_lid_usage_pkey PRIMARY KEY(subc_id, lidco_id, hydrology_id);

ALTER TABLE inp_loadings_pol_x_subc DROP CONSTRAINT inp_loadings_pol_x_subc_pkey;
ALTER TABLE inp_loadings_pol_x_subc ADD CONSTRAINT inp_loadings_pol_x_subc_pkey PRIMARY KEY(subc_id, poll_id, hydrology_id);

ALTER TABLE inp_groundwater DROP CONSTRAINT inp_groundwater_pkey;
ALTER TABLE inp_groundwater ADD CONSTRAINT inp_groundwater_pkey PRIMARY KEY(subc_id, hydrology_id);

ALTER TABLE inp_coverage_land_x_subc DROP CONSTRAINT inp_coverage_land_x_subc_pkey;
ALTER TABLE inp_coverage_land_x_subc ADD CONSTRAINT inp_coverage_land_x_subc_pkey PRIMARY KEY(subc_id, landus_id, hydrology_id);

INSERT INTO cat_dwf_scenario VALUES (1, 'Default values') ON CONFLICT (id) DO NOTHING;

UPDATE inp_dwf SET dwfscenario_id = 1 WHERE dwfscenario_id IS NULL;

ALTER TABLE inp_dwf DROP CONSTRAINT IF EXISTS inp_dwf_pkey;
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_pkey PRIMARY KEY(node_id, dwfscenario_id);

DROP VIEW IF EXISTS v_edit_inp_dwf;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dwf", "column":"id"}}$$);

DROP RULE IF EXISTS insert_inp_dwf ON man_manhole;
DROP RULE IF EXISTS insert_inp_dwf ON man_chamber;
DROP RULE IF EXISTS insert_inp_dwf ON man_netinit;
DROP RULE IF EXISTS insert_inp_dwf ON man_wjump;


