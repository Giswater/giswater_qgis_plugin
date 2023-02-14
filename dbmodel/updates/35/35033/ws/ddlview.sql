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


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_node"], "fieldName":"real_press_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_node"], "fieldName":"real_press_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_node"], "fieldName":"real_press_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);


DROP VIEW IF EXISTS v_rpt_arc_all;
CREATE OR REPLACE VIEW v_rpt_arc_all
AS SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    now()::date + rpt_arc."time"::interval AS "time",
    arc.the_geom
   FROM selector_rpt_main,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_arc.setting, arc.arc_id;
  
 
DROP VIEW IF EXISTS v_rpt_arc_hourly;
CREATE OR REPLACE VIEW v_rpt_arc_hourly
AS SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_main.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND rpt_arc."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_main.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_arc."time", arc.arc_id;
 
 
DROP VIEW IF EXISTS v_rpt_comp_arc;
CREATE OR REPLACE VIEW v_rpt_comp_arc
AS SELECT arc.arc_id,
	arc.sector_id,
    selector_rpt_compare.result_id,
    max(rpt_arc.flow) AS max_flow,
    min(rpt_arc.flow) AS min_flow,
    max(rpt_arc.vel) AS max_vel,
    min(rpt_arc.vel) AS min_vel,
    max(rpt_arc.headloss) AS max_headloss,
    min(rpt_arc.headloss) AS min_headloss,
    max(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS max_uheadloss,
    min(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS min_uheadloss,
    max(rpt_arc.setting) AS max_setting,
    min(rpt_arc.setting) AS min_setting,
    max(rpt_arc.reaction) AS max_reaction,
    min(rpt_arc.reaction) AS min_reaction,
    max(rpt_arc.ffactor) AS max_ffactor,
    min(rpt_arc.ffactor) AS min_ffactor,
    arc.the_geom
   FROM selector_rpt_compare,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_compare.result_id::text
  GROUP BY arc.arc_id, arc.sector_id, arc.arc_type, arc.arccat_id, selector_rpt_compare.result_id, arc.the_geom
  ORDER BY arc.arc_id;
 
 
DROP VIEW IF EXISTS v_rpt_comp_arc_hourly;
CREATE OR REPLACE VIEW v_rpt_comp_arc_hourly
AS SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_compare.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_compare,
    selector_rpt_main_tstep,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text AND rpt_arc."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_compare.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_compare.result_id::text;


DROP VIEW IF EXISTS v_rpt_comp_node;
CREATE OR REPLACE VIEW v_rpt_comp_node
AS SELECT node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    avg(rpt_node.press) AS avg_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    node.the_geom
   FROM selector_rpt_compare,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_compare.result_id::text
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_compare.result_id, node.the_geom
  ORDER BY node.node_id;
 
 
DROP VIEW IF EXISTS v_rpt_comp_node_hourly;
CREATE OR REPLACE VIEW v_rpt_comp_node_hourly
AS SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_compare.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_compare,
    selector_rpt_main_tstep,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text AND rpt_node."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_compare.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_compare.result_id::text;

 
DROP VIEW IF EXISTS v_rpt_node_all;
CREATE OR REPLACE VIEW v_rpt_node_all
AS SELECT rpt_node.id,
    node.node_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    selector_rpt_main.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    now()::date + rpt_node."time"::interval AS "time",
    node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_node.press, node.node_id;
 
 
DROP VIEW IF EXISTS v_rpt_node_hourly;
CREATE OR REPLACE VIEW v_rpt_node_hourly
AS SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_main.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND rpt_node."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_main.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_node."time", node.node_id;


