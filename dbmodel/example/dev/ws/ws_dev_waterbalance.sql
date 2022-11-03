/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


UPDATE ws_sample.om_waterbalance SET  auth_bill_met_export = 0, auth_unbill_met = 0, auth_unbill_unmet = auth_bill_met_hydro*0.03, auth_bill_unmet = auth_bill_met_hydro*0.015;
UPDATE ws_sample.om_waterbalance SET loss_app_met_error = 0.01*total_in;
UPDATE ws_sample.om_waterbalance SET loss_app_data_error = 0.001*total_in;
UPDATE ws_sample.om_waterbalance SET loss_real_leak_main = total_in*0.01;
UPDATE ws_sample.om_waterbalance SET loss_real_leak_service = auth_bill_met_hydro*0.005;
UPDATE ws_sample.om_waterbalance SET loss_app_unath = null;

UPDATE ws_sample.om_waterbalance SET loss_real_storage = 
(total_sys_input - auth_bill_met_export - auth_bill_met_hydro - auth_bill_unmet - auth_unbill_unmet- auth_unbill_met - loss_app_met_error - loss_app_data_error - loss_real_leak_main -  loss_real_leak_service)::numeric(12,2)
WHERE dma_id IN (4,5);

UPDATE ws_sample.om_waterbalance SET loss_real_storage = 0 WHERE dma_id NOT IN (4,5);

