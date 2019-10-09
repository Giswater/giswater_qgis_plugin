/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 09/10/2019

UPDATE sys_csv2pg_config SET target='{Node Results, MINIMUM Node}' WHERE tablename='rpt_node';
UPDATE sys_csv2pg_config SET target='{MINIMUM Link, Link Results}' WHERE tablename='rpt_arc';
UPDATE sys_csv2pg_config SET target='{Pump Factor}' WHERE tablename='rpt_energy_usage';
UPDATE sys_csv2pg_config SET target='{Hydraulic Status:}' WHERE tablename='rpt_hydraulic_status';
UPDATE sys_csv2pg_config SET target='{Input Data}' WHERE tablename='rpt_cat_result';