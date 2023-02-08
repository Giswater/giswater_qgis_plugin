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
    e.real_flow_max,
    e.real_flow_min,
    e.real_flow_avg,
    e.real_vel_max,
    e.real_vel_min,
    e.real_vel_avg
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
SELECT vu_arc.* FROM vu_arc
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;



CREATE OR REPLACE VIEW vu_node AS 
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id AS node_type,
    cat_feature.system_id AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.minsector_id,
    node.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    node.presszone_id,
    presszone.name AS presszone_name,
    node.staticpressure,
    node.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.buildercat_id,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.district_id,
    a.descript::character varying(100) AS streetname,
    node.postnumber,
    node.postcomplement,
    b.descript::character varying(100) AS streetname2,
    node.postnumber2,
    node.postcomplement2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(cat_feature.link_path, node.link) AS link,
    node.verified,
    node.undelete,
    cat_node.label,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    node.hemisphere,
    node.num_value,
    cat_node.nodetype_id,
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user,
    node.the_geom,
    node.adate,
    node.adescript,
    node.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    node.workcat_id_plan,
    node.asset_id,
    node.om_state,
    node.conserv_state,
    node.access_type,
    node.placement_type,
    e.demand_max, 
    e.demand_min, 
    e.demand_avg, 
    e.press_max, 
    e.press_min, 
    e.press_avg, 
    e.head_max, 
    e.head_min, 
    e.head_avg, 
    e.quality_max, 
    e.quality_min, 
    e.quality_avg,
    e.real_press_max,
    e.real_press_min,
    e.real_press_avg
   FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id
     LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = node.presszone_id::text
     LEFT JOIN v_ext_streetaxis a ON a.id::text = node.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis b ON b.id::text = node.streetaxis2_id::text
     LEFT JOIN node_add e ON e.node_id = node.node_id;


CREATE OR REPLACE VIEW v_node AS 
SELECT vu_node.*
FROM vu_node
JOIN v_state_node USING (node_id)
JOIN v_expl_node e on e.node_id = vu_node.node_id;

CREATE OR REPLACE VIEW v_edit_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.sector_name,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.minsector_id,
    v_node.dma_id,
    v_node.dma_name,
    v_node.macrodma_id,
    v_node.presszone_id,
    v_node.presszone_name,
    v_node.staticpressure,
    v_node.dqa_id,
    v_node.dqa_name,
    v_node.macrodqa_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.buildercat_id,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.hemisphere,
    v_node.num_value,
    v_node.nodetype_id,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.the_geom,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    v_node.dma_style,
    v_node.presszone_style,
    man_valve.closed AS closed_valve,
    man_valve.broken AS broken_valve,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.om_state,
    v_node.conserv_state,
    v_node.access_type,
    v_node.placement_type,
    v_node.demand_max, 
    v_node.demand_min, 
    v_node.demand_avg, 
    v_node.press_max, 
    v_node.press_min, 
    v_node.press_avg, 
    v_node.head_max, 
    v_node.head_min, 
    v_node.head_avg, 
    v_node.quality_max, 
    v_node.quality_min, 
    v_node.quality_avg,
    v_node.real_press_max,
    v_node.real_press_min,
    v_node.real_press_avg
   FROM v_node
     LEFT JOIN man_valve USING (node_id);

CREATE OR REPLACE VIEW ve_node AS 
SELECT * FROM v_node;

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_arc"], "fieldName":"real_flow_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_arc"], "fieldName":"real_flow_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_arc"], "fieldName":"real_flow_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_arc"], "fieldName":"real_vel_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_arc"], "fieldName":"real_vel_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_arc"], "fieldName":"real_vel_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_node"], "fieldName":"real_press_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_node"], "fieldName":"real_press_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{}, "data":{"viewName":["v_edit_node"], "fieldName":"real_press_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);