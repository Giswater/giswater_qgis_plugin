/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_state", "column":"is_operative", "dataType":"boolean"}}$$);

ALTER TABLE ext_rtc_hydrometer_state ALTER COLUMN is_operative SET DEFAULT true;

drop view v_anl_graphanalytics_mapzones;
drop view v_anl_graphanalytics_upstream;
drop view v_anl_graph;