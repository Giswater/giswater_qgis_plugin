/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"num_valve", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"meters_in", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"meters_out", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"n_connec", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"n_hydro", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"arc_length", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"link_length", "dataType":"double precision"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"dma_rw_eff", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"dma_nrw_eff", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"dma_ili", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"dma_nightvol", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"dma_m4day", "dataType":"double precision"}}$$);



