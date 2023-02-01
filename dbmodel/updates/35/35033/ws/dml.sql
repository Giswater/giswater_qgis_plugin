/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later versio
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_report set query_text = 'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(12,2) as "Total inlet",
total_out::numeric(12,2) as "Total outlet",
total::numeric(12,2) as "Total inyected",
auth_bill as "Auth. Bill", auth_unbill as "Auth. Unbill", auth as "Authorized", 
loss_app as "Losses App", loss_real as "Losses Real",loss as "Losses", 
(case when total > 0 then (auth/total)::numeric(12,2) else 0 end) as "Losses Efficiency" ,
rw as "Revenue", nrw as "Non Revenue", 
(case when total > 0 then (rw/total)::numeric(12,2) else 0.00 end) as "Revenue Efficiency",
w.ili::numeric(12,2) as "ILI"
FROM v_om_waterbalance w' WHERE id=102;


UPDATE config_report set query_text = replace (query_text,'v_om_waterbalance_efficiency','v_om_waterbalance') WHERE id=103 or id=104;

