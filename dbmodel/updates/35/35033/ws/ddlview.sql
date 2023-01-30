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


CREATE VIEW v_om_waterbalance_report as 
WITH met_in AS (SELECT string_agg (node_id, ', ') as meters, dma_id FROM om_waterbalance_dma_graph WHERE flow_sign = 1 group by dma_id),
met_out AS (SELECT string_agg (node_id, ', ') as meters, dma_id FROM om_waterbalance_dma_graph WHERE flow_sign = -1 group by dma_id)
SELECT 
w.expl_id,
e.name as expl_name,
w.dma_id,
d.name as dma_name,
cat_period_id as period,
concat(startdate,' - ',enddate) as period_dates,
mi.meters as meters_in,
mo.meters as meters_out,
n_connec,
n_hydro,
arc_length,
link_length,
total_in,
total_out,
COALESCE(w.total_sys_input, 0::double precision)::numeric(12,2) AS total,
NULL AS auth,
NULL AS nrw,
dma_rw_eff,
dma_nrw_eff,
dma_ili,
dma_nightvol,
dma_m4day
from om_waterbalance w
join exploitation e using (expl_id)
join dma d using (dma_id)
join ext_cat_period p on w.cat_period_id = p.id
join met_in mi on w.dma_id = mi.dma_id
join met_out mo on w.dma_id = mo.dma_id;