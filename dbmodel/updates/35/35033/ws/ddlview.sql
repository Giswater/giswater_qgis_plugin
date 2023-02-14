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



CREATE OR REPLACE VIEW vu_arc AS 
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    arc.elevation1,
    arc.depth1,
    arc.elevation2,
    arc.depth2,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.minsector_id,
    arc.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    arc.presszone_id,
    presszone.name AS presszone_name,
    arc.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.num_value,
    cat_arc.arctype_id AS cat_arctype_id,
    arc.nodetype_1,
    arc.staticpress1,
    arc.nodetype_2,
    arc.staticpress2,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.depth,
    arc.adate,
    arc.adescript,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id,
    arc.om_state,
    arc.conserv_state,
    e.flow_max, 
    e.flow_min, 
    e.flow_avg, 
    e.vel_max, 
    e.vel_min, 
    e.vel_avg,
    arc.parent_id
   FROM arc
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = arc.presszone_id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN arc_add e ON arc.arc_id=e.arc_id;


CREATE OR REPLACE VIEW v_arc AS 
SELECT vu_arc.*
FROM vu_arc
JOIN v_state_arc USING (arc_id)
JOIN v_expl_arc e on e.arc_id = vu_arc.arc_id;


CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"parent_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);

CREATE OR REPLACE VIEW v_edit_inp_inlet
 AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    n.the_geom,
    inp_inlet.overflow,
    inp_inlet.head
   FROM v_sector_node sn
     JOIN v_node n USING (node_id)
     JOIN inp_inlet USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_junction
 AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom,
    inp_junction.peak_factor,
    n.expl_id
   FROM v_sector_node sn
     JOIN v_edit_node n USING (node_id)
     JOIN inp_junction USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_pump
 AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    n.dma_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    n.the_geom
   FROM v_sector_node sn
   JOIN v_node n USING (node_id)
     JOIN inp_pump USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_reservoir
 AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    n.the_geom
   FROM v_sector_node sn
   JOIN v_node n USING (node_id)
     JOIN inp_reservoir USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_shortpipe
 AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status,
    n.the_geom
   FROM v_sector_node sn
   JOIN v_node n USING (node_id)
     JOIN inp_shortpipe USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_tank
 AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    n.the_geom,
    inp_tank.overflow
   FROM v_sector_node sn
   JOIN v_node n USING (node_id)
     JOIN inp_tank USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_valve
 AS
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status,
    v_node.the_geom,
    inp_valve.custom_dint,
    inp_valve.add_settings
   FROM v_sector_node sn
   JOIN v_node USING (node_id)
     JOIN inp_valve USING (node_id)
     JOIN value_state_type vs ON vs.id = v_node.state_type
  WHERE vs.is_operative IS TRUE;
