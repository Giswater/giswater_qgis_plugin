/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW v_minsector;
CREATE OR REPLACE VIEW v_minsector
 AS
 SELECT minsector.minsector_id,
 	minsector.num_valve,	
    minsector.dma_id,
    minsector.dqa_id,
    minsector.presszone_id AS presszonecat_id,
    minsector.sector_id,
    minsector.expl_id,
    minsector.the_geom
   FROM selector_expl,
    minsector
  WHERE minsector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_om_waterbalance_report as 
WITH expl_data AS (SELECT sum(w.auth) / sum(w.total) AS expl_rw_eff,  1 - (sum(w.auth) / sum(w.total)) AS expl_nrw_eff,
NULL AS expl_nightvol, 
CASE WHEN sum(arc_length) = 0 THEN NULL ELSE 
sum(w.nrw)/sum(arc_length)/(EXTRACT(epoch FROM AGE(end_date, start_date))/3600) END as expl_m4day,
CASE WHEN sum(arc_length) = 0 AND sum(n_connec) = 0 AND sum(link_length)=0 THEN NULL ELSE 
(sum(w.loss)*(365/extract(day from end_date - start_date))) / ((6.57 * sum(arc_length)) + (9.13 * sum(link_length)) + (0.256*sum(n_connec)) * avg(avg_press)) END as expl_ili, 
w.expl_id, cat_period_id, start_date
FROM om_waterbalance w
join ext_cat_period p on w.cat_period_id = p.id 
join dma d on d.dma_id = w.dma_id
GROUP BY w.expl_id, cat_period_id,end_date, start_date)
SELECT DISTINCT 
e.name as exploitation,
w.expl_id,
d.name as dma,
w.dma_id,
w.cat_period_id,
p.code as period,
p.start_date,
p.end_date,
w.meters_in,
w.meters_out,
n_connec,
n_hydro,
arc_length,
link_length,
w.total_in,
w.total_out,
w.total,
w.auth,
w.nrw,
CASE WHEN w.total != 0 then w.auth /w.total end AS dma_rw_eff,
CASE WHEN w.total != 0 then 1 - (w.auth /w.total) end AS dma_nrw_eff,
w.ili as dma_ili,
null as dma_nightvol,
w.nrw/arc_length/(EXTRACT(epoch FROM AGE(end_date, p.start_date))/3600) as dma_m4day,
ed.expl_rw_eff,
ed.expl_nrw_eff,
expl_nightvol,
expl_ili,
expl_m4day
from om_waterbalance w
join exploitation e using (expl_id)
join dma d using (dma_id)
join ext_cat_period p on w.cat_period_id = p.id
join expl_data ed on ed.expl_id=w.expl_id and w.cat_period_id = p.id where ed.start_date = p.start_date;

drop view v_om_waterbalance cascade;
CREATE OR REPLACE VIEW v_om_waterbalance AS
 SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    auth_bill,
    auth_unbill,
    loss_app,
    loss_real,
    total_in,
    total_out,
    total,
    p.start_date::date AS crm_startdate,
    p.end_date::date AS crm_enddate,
    startdate AS wbal_startdate,
    enddate AS wbal_enddate,
    ili,
    auth,
    loss,
        CASE
            WHEN total::double precision > 0::double precision THEN ((100::numeric * (auth_bill + auth_unbill))::double precision / total::double precision)::numeric(12,2)
            ELSE 0::numeric(12,2)
        END AS loss_eff,
    auth_bill AS rw,
    (total::double precision - auth_bill::double precision)::numeric(12,2) AS nrw,
        CASE
            WHEN total::double precision > 0::double precision THEN ((100::numeric * auth_bill)::double precision / total::double precision)::numeric(12,2)
            ELSE 0::numeric(12,2)
        END AS nrw_eff,
    d.the_geom
   FROM om_waterbalance
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON p.id::text = om_waterbalance.cat_period_id::text;

