/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/29
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"log", "dataType":"text", "isUtils":"False"}}$$);

DROP VIEW vi_options;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_param_user", "column":"epaversion", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_hydrology", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dwf_scenario", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_hydrology", "column":"log", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dwf_scenario", "column":"log", "dataType":"text", "isUtils":"False"}}$$);


ALTER TABLE cat_hydrology DROP CONSTRAINT IF EXISTS cat_hydrology_expl_id_fkey;
ALTER TABLE cat_hydrology ADD CONSTRAINT cat_hydrology_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_dwf_scenario DROP CONSTRAINT IF EXISTS cat_dwf_scenario_expl_id_fkey;
ALTER TABLE cat_dwf_scenario ADD CONSTRAINT cat_dwf_scenario_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT IF EXISTS inp_dscenario_conduit_dscenario_id_fkey;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_junction DROP CONSTRAINT IF EXISTS inp_dscenario_junction_dscenario_id_fkey;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_raingage DROP CONSTRAINT IF EXISTS iinp_dscenario_raingage_dscenario_id_fkey;
ALTER TABLE inp_dscenario_raingage ADD CONSTRAINT iinp_dscenario_raingage_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

