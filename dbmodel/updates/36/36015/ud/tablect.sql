/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE cat_dwf_scenario ADD CONSTRAINT cat_dwf_scenario_unique_idval UNIQUE(idval);
ALTER TABLE cat_hydrology ADD CONSTRAINT cat_hydrology_unique_name UNIQUE(name);

ALTER TABLE inp_dscenario_lid_usage DROP CONSTRAINT inp_dscenario_lid_usage_pkey;

ALTER TABLE inp_dscenario_lid_usage ADD CONSTRAINT inp_dscenario_lid_usage_pkey PRIMARY KEY(dscenario_id, subc_id);

ALTER TABLE inp_dscenario_lid_usage ALTER COLUMN lidco_id DROP NOT NULL;

SELECT * FROM config_form_fields where columnname = 'lidco_id';

ALTER TABLE temp_lid_usage DROP CONSTRAINT temp_lid_usage_pkey ;

ALTER TABLE temp_lid_usage ADD CONSTRAINT temp_lid_usage_pkey PRIMARY KEY(subc_id);

ALTER TABLE temp_lid_usage ALTER COLUMN lidco_id DROP NOT NULL;

INSERT INTO config_fprocess VALUES (140,'rpt_lidperformance_sum', 'LID Performance Summary', 88);

ALTER TABLE rpt_runoff_quant ADD CONSTRAINT rpt_runoff_quant_unique_result_id UNIQUE (result_id);

ALTER TABLE rpt_flowrouting_cont ADD CONSTRAINT rpt_flowrouting_cont_unique_result_id UNIQUE (result_id);

ALTER TABLE temp_lid_usage DROP CONSTRAINT temp_lid_usage_pkey;
ALTER TABLE temp_lid_usage  ADD CONSTRAINT temp_lid_usage_pkey PRIMARY KEY(subc_id,lidco_id);
