/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_report SET query_text = 
'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(20,2) as "Total inlet",
total_out::numeric(20,2) as "Total outlet",
total::numeric(20,2) as "Total injected",
auth_bill as "Auth. Bill", auth_unbill as "Auth. Unbill", auth as "Authorized", 
loss_app as "Losses App", loss_real as "Losses Real",loss as "Losses", 
(case when total > 0 then (auth/total)::numeric(20,2) else 0 end) as "Losses Efficiency" ,
rw as "Revenue", nrw as "Non Revenue", 
(case when total > 0 then (rw/total)::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
w.ili::numeric(20,2) as "ILI"
FROM v_om_waterbalance w' where id = 102;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation",
(sum(n.total))::numeric(20,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(20,2) else 0.00 end) as "Losses Efficiency"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL' where id = 103;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation", n.dma as "Dma", 
(sum(n.total))::numeric(20,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(20,2) else 0.00 end) as "Losses Efficiency",
(avg(n.ili))::numeric(20,2) as "ILI"
FROM v_om_waterbalance n WHERE n.dma IS NOT NULL' where id = 104;

DELETE FROM sys_function WHERE id = 3106;