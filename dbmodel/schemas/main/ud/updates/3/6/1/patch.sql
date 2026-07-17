/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;




-- create active for non visual objects
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_lid", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"addparam", "dataType":"boolean", "isUtils":"False"}}$$);


-- create vdefault
ALTER TABLE inp_timeseries ALTER column active SET default true;
ALTER TABLE inp_curve ALTER column active SET default true;
ALTER TABLE inp_lid ALTER column active SET default true;
ALTER TABLE inp_pattern ALTER column active SET default true;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_conduit", "column":"bottom_mat", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_chamber", "column":"bottom_mat", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"bottom_mat", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_chamber", "column":"slope", "dataType":"numeric", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"siphon_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"odorflap", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_arc", "column":"visitability", "dataType":"boolean", "isUtils":"False"}}$$);


DROP VIEW IF EXISTS v_edit_man_chamber_pol;
DROP VIEW IF EXISTS v_edit_man_storage_pol;
DROP VIEW IF EXISTS v_edit_man_wwtp_pol;
DROP VIEW IF EXISTS v_edit_man_netgully_pol;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_chamber", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_storage", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_wwtp", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netgully", "column":"_pol_id_", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);

ALTER TABLE drainzone ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE drainzone ALTER COLUMN insert_user SET DEFAULT current_user;

-- add minelev for subcatchments
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_subcatchment", "column":"minelev", "dataType":"float", "isUtils":"False"}}$$);

CREATE OR REPLACE VIEW ve_epa_junction AS
SELECT inp_junction.*,
aver_depth as depth_average,max_depth as depth_max,
d.time_days as depth_max_day,
d.time_hour as depth_max_hour,
hour_surch as surcharge_hour,
max_height as surgarge_max_height,
hour_flood as flood_hour,
max_rate as flood_max_rate,
f.time_days as time_day,
f.time_hour as time_hour,
tot_flood as flood_total,
max_ponded as flood_max_ponded
FROM inp_junction
LEFT JOIN v_rpt_nodedepth_sum d USING (node_id)
LEFT JOIN v_rpt_nodesurcharge_sum s USING (node_id)
LEFT JOIN v_rpt_nodeflooding_sum f USING (node_id);

CREATE OR REPLACE VIEW ve_epa_storage AS
SELECT inp_storage.*,
aver_vol,
avg_full,
ei_loss,
max_vol,
max_full,
time_days,
time_hour,
max_out
FROM inp_storage
LEFT JOIN v_rpt_storagevol_sum USING (node_id);

CREATE OR REPLACE VIEW ve_epa_outfall AS
SELECT inp_outfall.*,
flow_freq,
avg_flow,
max_flow,
total_vol
FROM inp_outfall
LEFT JOIN v_rpt_outfallflow_sum USING (node_id);

CREATE OR REPLACE VIEW ve_epa_conduit AS
SELECT inp_conduit.*,
max_flow,
time_days,
time_hour,
max_veloc,
mfull_flow,
mfull_dept,
max_shear,
max_hr,
max_slope,
day_max,
time_max,
min_shear,
day_min,
time_min
FROM inp_conduit LEFT JOIN v_rpt_arcflow_sum USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_gully AS
SELECT inp_gully.*
FROM inp_gully;


CREATE OR REPLACE VIEW ve_epa_pump AS
SELECT inp_pump.*,
percent,
num_startup,
min_flow,
avg_flow,
max_flow,
vol_ltr,
powus_kwh,
timoff_min,
timoff_max
FROM inp_pump
LEFT JOIN v_rpt_pumping_sum USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_virtual AS
SELECT inp_virtual.*
FROM inp_virtual;

CREATE OR REPLACE VIEW ve_epa_netgully AS
SELECT inp_netgully.*
FROM inp_netgully;

CREATE OR REPLACE VIEW ve_epa_orifice AS
SELECT inp_orifice.*,
max_flow,
time_days,
time_hour,
max_veloc,
mfull_flow,
mfull_dept,
max_shear,
max_hr,
max_slope,
day_max,
time_max,
min_shear,
day_min,
time_min
FROM inp_orifice
LEFT JOIN rpt_arcflow_sum USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_weir AS
SELECT inp_weir.*,
max_flow,
time_days,
time_hour,
max_veloc,
mfull_flow,
mfull_dept,
max_shear,
max_hr,
max_slope,
day_max,
time_max,
min_shear,
day_min,
time_min
FROM inp_weir
LEFT JOIN rpt_arcflow_sum USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_outlet AS
SELECT inp_outlet.*,
max_flow,
time_days,
time_hour,
max_veloc,
mfull_flow,
mfull_dept,
max_shear,
max_hr,
max_slope,
day_max,
time_max,
min_shear,
day_min,
time_min
FROM inp_outlet
LEFT JOIN rpt_arcflow_sum USING (arc_id);


CREATE OR REPLACE VIEW vu_arc AS
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
    (CASE WHEN arc.sys_elev1 IS NULL THEN node_sys_elev_1::numeric(12,3) ELSE arc.sys_elev1 END) AS sys_elev1,
    CASE WHEN (CASE WHEN arc.custom_y1 IS NULL THEN y1::numeric(12,3) ELSE custom_y1 END) IS NULL THEN (node_sys_top_elev_1 - arc.sys_elev1)
    ELSE  (CASE WHEN arc.custom_y1 IS NULL THEN y1::numeric(12,3) ELSE custom_y1 END) END AS sys_y1,
    node_sys_top_elev_1 - (CASE WHEN arc.sys_elev1 IS NULL THEN node_sys_elev_1::numeric(12,3) ELSE arc.sys_elev1 END) - cat_arc.geom1 AS r1,
    (CASE WHEN arc.sys_elev1 IS NULL THEN node_sys_elev_1::numeric(12,3) ELSE arc.sys_elev1 END) - node_sys_elev_1 AS z1,
    arc.node_2,
    nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
   (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) AS sys_elev2,
    CASE WHEN (CASE WHEN arc.custom_y2 IS NULL THEN y2::numeric(12,3) ELSE custom_y2 END) IS NULL THEN (node_sys_top_elev_2 - arc.sys_elev2)
    ELSE  (CASE WHEN arc.custom_y2 IS NULL THEN y2::numeric(12,3) ELSE custom_y2 END) END AS sys_y2,
    node_sys_top_elev_2 - (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) - cat_arc.geom1 AS r2,
    (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) - node_sys_elev_2 AS z2,
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
    (CASE WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id ELSE arc.matcat_id END) AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    e.macroexpl_id,
    arc.sector_id,
    s.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    m.macrodma_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
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
    arc.uncertain,
    arc.num_value,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id,
    arc.drainzone_id,
    cat_arc.area AS cat_area,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
    mu.region_id,
    mu.province_id,
    arc.adate,
    arc.adescript,
    cat_arc.visitability
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     JOIN dma m  USING (dma_id)
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id;



CREATE OR REPLACE VIEW v_arc AS
SELECT vu_arc.* FROM vu_arc
JOIN v_state_arc USING (arc_id)
JOIN v_expl_arc e on e.arc_id = vu_arc.arc_id;

CREATE OR REPLACE VIEW v_edit_arc AS
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW vu_connec AS
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id AS sys_type,
    connec.private_connecat_id,
        CASE
            WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
        CASE
            WHEN ((connec.y1 + connec.y2) / 2::numeric) IS NOT NULL THEN ((connec.y1 + connec.y2) / 2::numeric)::numeric(12,3)
            ELSE connec.connec_depth
        END AS connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    dma.macrodma_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    d.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.workcat_id_plan,
    connec.asset_id,
    connec.drainzone_id,
    connec.expl_id2,
    vst.is_operative,
    mu.region_id,
    mu.province_id,
    connec.adate,
    connec.adescript
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = connec.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW v_connec AS
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.customer_code,
    vu_connec.top_elev,
    vu_connec.y1,
    vu_connec.y2,
    vu_connec.connecat_id,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.private_connecat_id,
    vu_connec.matcat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_connec.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_connec.demand,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.connec_depth,
    vu_connec.connec_length,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.accessibility,
    vu_connec.diagonal,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.uncertain,
    vu_connec.num_value,
        CASE
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.drainzone_id,
    vu_connec.expl_id2,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id,
    vu_connec.adate,
    vu_connec.adescript
   FROM vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (v_link_connec.feature_id) v_link_connec.link_id,
            v_link_connec.feature_type,
            v_link_connec.feature_id,
            v_link_connec.exit_type,
            v_link_connec.exit_id,
            v_link_connec.state,
            v_link_connec.expl_id,
            v_link_connec.sector_id,
            v_link_connec.dma_id,
            v_link_connec.exit_topelev,
            v_link_connec.exit_elev,
            v_link_connec.fluid_type,
            v_link_connec.gis_length,
            v_link_connec.the_geom,
            v_link_connec.sector_name,
            v_link_connec.macrosector_id,
            v_link_connec.macrodma_id
           FROM v_link_connec WHERE v_link_connec.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text;



CREATE OR REPLACE VIEW v_edit_connec AS
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW ve_connec AS
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW vu_gully
 AS
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.system_id AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    gully.units,
    gully.groove,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
        CASE
            WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
            ELSE gully.connec_depth
        END AS connec_depth,
    gully.arc_id,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.district_id,
    c.descript::character varying(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    d.descript::character varying(100) AS streetname2,
    gully.postnumber2,
    gully.postcomplement2,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.verified,
    gully.undelete,
    cat_grate.label,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
    gully.workcat_id_plan,
    gully.asset_id,
        CASE
            WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
    gully.gratecat2_id,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
    gully.epa_type,
    gully.groove_height,
    gully.groove_length,
    cat_grate.width AS grate_width,
    cat_grate.length AS grate_length,
    gully.units_placement,
    gully.drainzone_id,
    gully.expl_id2,
    vst.is_operative,
    mu.region_id,
    mu.province_id,
    gully.adate,
    gully.adescript,
    gully.siphon_type,
    gully.odorflap
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
     LEFT JOIN value_state_type vst ON vst.id = state_type
     LEFT JOIN ext_municipality mu ON gully.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW v_gully AS
 SELECT vu_gully.gully_id,
    vu_gully.code,
    vu_gully.top_elev,
    vu_gully.ymax,
    vu_gully.sandbox,
    vu_gully.matcat_id,
    vu_gully.gully_type,
    vu_gully.sys_type,
    vu_gully.gratecat_id,
    vu_gully.cat_grate_matcat,
    vu_gully.units,
    vu_gully.groove,
    vu_gully.siphon,
    vu_gully.connec_arccat_id,
    vu_gully.connec_length,
    vu_gully.connec_depth,
    v_state_gully.arc_id,
    vu_gully.expl_id,
    vu_gully.macroexpl_id,
    vu_gully.sector_id,
    vu_gully.macrosector_id,
    vu_gully.state,
    vu_gully.state_type,
    vu_gully.annotation,
    vu_gully.observ,
    vu_gully.comment,
    vu_gully.dma_id,
    vu_gully.macrodma_id,
    vu_gully.soilcat_id,
    vu_gully.function_type,
    vu_gully.category_type,
    vu_gully.fluid_type,
    vu_gully.location_type,
    vu_gully.workcat_id,
    vu_gully.workcat_id_end,
    vu_gully.buildercat_id,
    vu_gully.builtdate,
    vu_gully.enddate,
    vu_gully.ownercat_id,
    vu_gully.muni_id,
    vu_gully.postcode,
    vu_gully.district_id,
    vu_gully.streetname,
    vu_gully.postnumber,
    vu_gully.postcomplement,
    vu_gully.streetname2,
    vu_gully.postnumber2,
    vu_gully.postcomplement2,
    vu_gully.descript,
    vu_gully.svg,
    vu_gully.rotation,
    vu_gully.link,
    vu_gully.verified,
    vu_gully.undelete,
    vu_gully.label,
    vu_gully.label_x,
    vu_gully.label_y,
    vu_gully.label_rotation,
    vu_gully.publish,
    vu_gully.inventory,
    vu_gully.uncertain,
    vu_gully.num_value,
    vu_gully.pjoint_id,
    vu_gully.pjoint_type,
    vu_gully.tstamp,
    vu_gully.insert_user,
    vu_gully.lastupdate,
    vu_gully.lastupdate_user,
    vu_gully.the_geom,
    vu_gully.workcat_id_plan,
    vu_gully.asset_id,
    vu_gully.connec_matcat_id,
    vu_gully.gratecat2_id,
    vu_gully.connec_y1,
    vu_gully.connec_y2,
    vu_gully.epa_type,
    vu_gully.groove_height,
    vu_gully.groove_length,
    vu_gully.grate_width,
    vu_gully.grate_length,
    vu_gully.units_placement,
    vu_gully.drainzone_id,
    vu_gully.expl_id2,
    vu_gully.is_operative,
    vu_gully.region_id,
    vu_gully.province_id,
    vu_gully.adate,
    vu_gully.adescript,
    vu_gully.siphon_type,
    vu_gully.odorflap
   FROM vu_gully
     JOIN v_state_gully USING (gully_id)
     LEFT JOIN ( SELECT DISTINCT ON (v_link_gully.feature_id) v_link_gully.link_id,
            v_link_gully.feature_type,
            v_link_gully.feature_id,
            v_link_gully.exit_type,
            v_link_gully.exit_id,
            v_link_gully.state,
            v_link_gully.expl_id,
            v_link_gully.sector_id,
            v_link_gully.dma_id,
            v_link_gully.exit_topelev,
            v_link_gully.exit_elev,
            v_link_gully.fluid_type,
            v_link_gully.gis_length,
            v_link_gully.the_geom,
            v_link_gully.sector_name,
            v_link_gully.macrosector_id,
            v_link_gully.macrodma_id
           FROM v_link_gully WHERE v_link_gully.state = 2) a ON a.feature_id::text = vu_gully.gully_id::text;



CREATE OR REPLACE VIEW v_edit_gully AS
SELECT * FROM v_gully;

CREATE OR REPLACE VIEW ve_gully AS
SELECT * FROM v_gully;

CREATE OR REPLACE VIEW vu_node AS
 WITH vu_node AS (
         SELECT node.node_id,
            node.code,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.ymax,
            node.custom_ymax,
                CASE
                    WHEN node.custom_ymax IS NOT NULL THEN node.custom_ymax
                    ELSE node.ymax
                END AS sys_ymax,
            node.elev,
            node.custom_elev,
                CASE
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
            node.node_type,
            cat_feature.system_id AS sys_type,
            node.nodecat_id,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.epa_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector.macrosector_id,
            node.state,
            node.state_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma.macrodma_id,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.fluid_type,
            node.location_type,
            node.workcat_id,
            node.workcat_id_end,
            node.buildercat_id,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.muni_id,
            node.postcode,
            node.district_id,
            c.descript::character varying(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            d.descript::character varying(100) AS streetname2,
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
            node.uncertain,
            node.xyz_date,
            node.unconnected,
            node.num_value,
            date_trunc('second'::text, node.tstamp) AS tstamp,
            node.insert_user,
            date_trunc('second'::text, node.lastupdate) AS lastupdate,
            node.lastupdate_user,
            node.the_geom,
            node.workcat_id_plan,
            node.asset_id,
            node.drainzone_id,
            node.parent_id,
            node.arc_id,
            node.expl_id2,
            vst.is_operative,
            mu.region_id,
            mu.province_id,
            node.adate,
            node.adescript
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             LEFT JOIN dma ON node.dma_id = dma.dma_id
             LEFT JOIN sector ON node.sector_id = sector.sector_id
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
             LEFT JOIN v_ext_streetaxis c ON c.id::text = node.streetaxis_id::text
             LEFT JOIN v_ext_streetaxis d ON d.id::text = node.streetaxis2_id::text
             LEFT JOIN value_state_type vst ON vst.id = state_type
             LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id
        )
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.top_elev,
    vu_node.custom_top_elev,
    vu_node.sys_top_elev,
    vu_node.ymax,
    vu_node.custom_ymax,
        CASE
            WHEN vu_node.sys_ymax IS NOT NULL THEN vu_node.sys_ymax
            ELSE (vu_node.sys_top_elev - vu_node.sys_elev)::numeric(12,3)
        END AS sys_ymax,
    vu_node.elev,
    vu_node.custom_elev,
        CASE
            WHEN vu_node.sys_elev IS NOT NULL THEN vu_node.sys_elev
            ELSE (vu_node.sys_top_elev - vu_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.matcat_id,
    vu_node.epa_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.macrosector_id,
    vu_node.state,
    vu_node.state_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.dma_id,
    vu_node.macrodma_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.buildercat_id,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.the_geom,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.publish,
    vu_node.inventory,
    vu_node.uncertain,
    vu_node.xyz_date,
    vu_node.unconnected,
    vu_node.num_value,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.drainzone_id,
    vu_node.parent_id,
    vu_node.arc_id,
    vu_node.expl_id2,
    vu_node.is_operative,
    vu_node.region_id,
    vu_node.province_id,
    vu_node.adate,
    vu_node.adescript
   FROM vu_node;


CREATE OR REPLACE VIEW v_node AS
SELECT vu_node.* FROM vu_node
JOIN v_state_node USING (node_id)
JOIN v_expl_node e on e.node_id = vu_node.node_id;

CREATE OR REPLACE VIEW v_edit_node AS
SELECT * FROM v_node;

CREATE OR REPLACE VIEW ve_node AS
SELECT * FROM v_node;

CREATE OR REPLACE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id);

create or replace view v_link_connec as
select distinct on (link_id) * from vu_link_connec
JOIN v_state_link_connec USING (link_id);

create or replace view v_link_gully as
select distinct on (link_id) * from vu_link_gully
JOIN v_state_link_gully USING (link_id);

create or replace view v_link as
select distinct on (link_id) * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;


CREATE OR REPLACE VIEW vi_curves as
select curve_id, curve_type, x_value, y_value from (
with qt as (SELECT inp_curve_value.id, inp_curve_value.curve_id,
        CASE
            WHEN inp_curve_value.id = (( SELECT min(sub.id) AS min
               FROM inp_curve_value sub
              WHERE sub.curve_id::text = inp_curve_value.curve_id::text)) THEN inp_typevalue.idval
            ELSE NULL::character varying
        END AS curve_type,
    inp_curve_value.x_value,
    inp_curve_value.y_value,
    expl_id
   FROM inp_curve c
     JOIN inp_curve_value ON c.id::text = inp_curve_value.curve_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = c.curve_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_curve'::text and active)
  select qt.* from qt join selector_expl s using (expl_id) where s.cur_user = "current_user"()::text
  union
  select qt.* from qt where expl_id is null) a
  ORDER BY id;


CREATE OR REPLACE VIEW vi_timeseries as
select timser_id,  other1,   other2,   other3 from (
SELECT
    t.id,
    t.timser_id,
    t.other1,
    t.other2,
    t.other3
   FROM selector_expl s,
    ( select a.id,
            a.timser_id,
            a.other1,
            a.other2,
            a.other3,
            a.expl_id
           FROM ( SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    inp_timeseries_value.date AS other1,
                    inp_timeseries_value.hour AS other2,
                    inp_timeseries_value.value AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text and active
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    concat('FILE', ' ', inp_timeseries.fname) AS other1,
                    NULL::character varying AS other2,
                    NULL::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'FILE'::text and active
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    NULL::text AS other1,
                    inp_timeseries_value."time" AS other2,
                    inp_timeseries_value.value::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'RELATIVE'::text and active) a
          ORDER BY a.id) t
  WHERE (t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL))b
  ORDER BY id;


CREATE OR REPLACE VIEW vi_patterns
AS SELECT p.pattern_id,
    p.pattern_type,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18,
    inp_pattern_value.factor_19,
    inp_pattern_value.factor_20,
    inp_pattern_value.factor_21,
    inp_pattern_value.factor_22,
    inp_pattern_value.factor_23,
    inp_pattern_value.factor_24
   FROM selector_expl s,
    inp_pattern p
     JOIN inp_pattern_value USING (pattern_id)
  WHERE active and p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.pattern_id;



cREATE OR REPLACE VIEW vi_lid_controls
AS SELECT a.lidco_id,
    a.lidco_type,
    a.other1,
    a.other2,
    a.other3,
    a.other4,
    a.other5,
    a.other6,
    a.other7
   FROM ( SELECT 0 AS id,
            inp_lid.lidco_id,
            inp_lid.lidco_type,
            NULL::numeric AS other1,
            NULL::numeric AS other2,
            NULL::numeric AS other3,
            NULL::numeric AS other4,
            NULL::text AS other5,
            NULL::text AS other6,
            NULL::text AS other7
           FROM inp_lid
		   WHERE active
        UNION
         SELECT inp_lid_value.id,
            inp_lid_value.lidco_id,
            inp_typevalue.idval AS lidco_type,
            inp_lid_value.value_2 AS other1,
            inp_lid_value.value_3 AS other2,
            inp_lid_value.value_4 AS other3,
            inp_lid_value.value_5 AS other4,
            inp_lid_value.value_6 AS other5,
            inp_lid_value.value_7 AS other6,
            inp_lid_value.value_8 AS other7
           FROM inp_lid_value join inp_lid using (lidco_id)
             LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_lid_value.lidlayer::text
          WHERE active and inp_typevalue.typevalue::text = 'inp_value_lidlayer'::text) a
  ORDER BY a.lidco_id, a.id;

CREATE OR REPLACE VIEW v_edit_inp_pattern
 AS
 SELECT DISTINCT p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    p.log,
    p.active
   FROM selector_expl s,
    inp_pattern p
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.pattern_id;


CREATE OR REPLACE VIEW v_edit_inp_curve
 AS
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.expl_id,
    c.log,
    c.active
   FROM selector_expl s,
    inp_curve c
  WHERE c.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR c.expl_id IS NULL
  ORDER BY c.id;


CREATE OR REPLACE VIEW v_edit_inp_timeseries
 AS
 SELECT DISTINCT p.id,
    p.timser_type,
    p.times_type,
    p.idval,
    p.descript,
    p.fname,
    p.expl_id,
    p.log,
    p.active
   FROM selector_expl s,
    inp_timeseries p
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.id;

drop view if exists vi_subcatch2outlet;
CREATE OR REPLACE VIEW vi_subcatch2outlet
AS
SELECT subc_id, outlet_id, outlet_type, st_length2d(the_geom) as length, hydrology_id, the_geom FROM (
SELECT s1.subc_id,
	s1.outlet_id,
	'JUNCTION' as outlet_type,
    s1.hydrology_id,
    st_makeline(st_centroid(s1.the_geom), node.the_geom)::geometry(LineString,SRID_VALUE) AS the_geom
   FROM v_edit_inp_subcatchment s1
     JOIN node ON node.node_id::text = s1.outlet_id::text
UNION
 SELECT s1.subc_id,
	s1.outlet_id,
	'SUBCATCHMENT' as outlet_type,
	s1.hydrology_id,
    st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))::geometry(LineString,SRID_VALUE) AS the_geom
   FROM v_edit_inp_subcatchment s1
     JOIN v_edit_inp_subcatchment s2 ON s1.outlet_id::text = s2.subc_id::text) a;



-- TAB CONNECTIONS 
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_1', 'lyt_connection_1','lytConnection1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_2', 'lyt_connection_2','lytConnection2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_3', 'lyt_connection_3','lytConnection3');

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_connection_upstream', 'SELECT * FROM v_ui_node_x_connection_upstream WHERE rid IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_connection_downstream', 'SELECT * FROM v_ui_node_x_connection_downstream WHERE rid IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('node', 'form_feature', 'tab_connections', 'tbl_upstream', 'lyt_connection_2', 1, 'tableview', 'Upstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_upstream', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('node', 'form_feature', 'tab_connections', 'tbl_downstream', 'lyt_connection_3', 1, 'tableview', 'Downstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_downstream', 2);


INSERT INTO config_form_tabs(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('v_edit_gully', 'tab_epa', 'EPA inp', NULL, 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}, 
{"actionName":"actionGetArcId", "disabled":false}]'::json, 8, '{4}') ON CONFLICT (formname, tabname) DO NOTHING;

--junction
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_junction', 'SELECT dscenario_id, y0, ysur, apond, outfallparam, elev, ymax FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'y0', 'lyt_epa_data_1', 1, 'string', 'text', 'y0:', 'y0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'ysur', 'lyt_epa_data_1', 2, 'string', 'text', 'ysur:', 'ysur', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'apond', 'lyt_epa_data_1', 3, 'string', 'text', 'apond:', 'apond', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'outfallparam', 'lyt_epa_data_1', 4, 'string', 'text', 'outfallparam:', 'outfallparam', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_average', 'lyt_epa_data_2', 1, 'string', 'text', 'Average depth:', 'Average depth', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max', 'lyt_epa_data_2', 2, 'string', 'text', 'Max depth:', 'Max depth', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max_day', 'lyt_epa_data_2', 3, 'string', 'text', 'Max depth/day:', 'Max depth per day', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max_hour', 'lyt_epa_data_2', 4, 'string', 'text', 'Max depth/hour:', 'Max depth per hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'surcharge_hour', 'lyt_epa_data_2', 5, 'string', 'text', 'Surcharge/hour:', 'Surcharge per hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'surgarge_max_height', 'lyt_epa_data_2', 6, 'string', 'text', 'max height of surgarge:', 'Max height of surgarge', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'Flood hour:', 'Flood hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_max_rate', 'lyt_epa_data_2', 8, 'string', 'text', 'Maximum food rate:', 'Maximum food rate', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'time_day', 'lyt_epa_data_2', 9, 'string', 'text', 'Day:', 'Day', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 10, 'string', 'text', 'Hour:', 'Hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_total', 'lyt_epa_data_2', 11, 'string', 'text', 'Total flood:', 'Total flood', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_max_ponded', 'lyt_epa_data_2', 12, 'string', 'text', 'Max ponded flood :', 'Max ponded flood', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'tbl_inp_junction', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_junction');

--outfall

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_outfall', 'SELECT dscenario_id, elev, ymax, outfall_type, stage, curve_id, timser_id, gate FROM v_edit_inp_dscenario_outfall WHERE node_id IS NOT NULL', 4, 'tab', 'list'); 

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'outfall_type', 'lyt_epa_data_1', 1, 'string', 'combo', 'Outfall type:', 'Outfall type', false, false, true, false, 'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outfall''','{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'stage', 'lyt_epa_data_1', 2, 'string', 'text', 'stage:', 'stage', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 3, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'timser_id', 'lyt_epa_data_1', 4, 'string', 'combo', 'timser_id:', 'timser_id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'gate', 'lyt_epa_data_1', 5, 'string', 'text', 'gate:', 'gate', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'flow_freq', 'lyt_epa_data_2', 1, 'string', 'text', 'Flow frequency:', 'Flow frequency', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'avg_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Average flow:', 'Average flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Max flow:', 'Max flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'total_vol', 'lyt_epa_data_2', 4, 'string', 'text', 'Total volume:', 'Total volume', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'tbl_inp_outfall', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_outfall');

--storage
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_storage', 'SELECT dscenario_id, elev, ymax, storage_type, curve_id, a1, 
       a2, a0, fevap, sh, hc, imd, y0, ysur, apond FROM v_edit_inp_dscenario_storage WHERE node_id IS NOT NULL', 4, 'tab', 'list'); 
 
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'storage_type', 'lyt_epa_data_1', 1, 'string', 'text', 'Storage type:', 'Storage type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);     
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a1', 'lyt_epa_data_1', 3, 'string', 'text', 'a1:', 'a1', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a2', 'lyt_epa_data_1', 4, 'string', 'text', 'a2:', 'a2', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a0', 'lyt_epa_data_1', 5, 'string', 'text', 'a0:', 'a0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'fevap', 'lyt_epa_data_1', 6, 'string', 'text', 'fevap:', 'fevap', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'sh', 'lyt_epa_data_1', 7, 'string', 'text', 'sh:', 'sh', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'hc', 'lyt_epa_data_1', 8, 'string', 'text', 'hc:', 'hc', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'imd', 'lyt_epa_data_1', 9, 'string', 'text', 'imd:', 'imd', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'y0', 'lyt_epa_data_1', 10, 'string', 'text', 'y0:', 'y0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'ysur', 'lyt_epa_data_1', 11, 'string', 'text', 'ysur:', 'ysur', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'apond', 'lyt_epa_data_1', 12, 'string', 'text', 'apond:', 'apond', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'aver_vol', 'lyt_epa_data_2', 1, 'string', 'text', 'aver_vol:', 'aver_vol', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'avg_full', 'lyt_epa_data_2', 2, 'string', 'text', 'avg_full :', 'avg_full', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'ei_loss', 'lyt_epa_data_2', 3, 'string', 'text', 'ei_loss:', 'ei_loss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_vol', 'lyt_epa_data_2', 4, 'string', 'text', 'max_vol:', 'max_vol', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_full', 'lyt_epa_data_2', 5, 'string', 'text', 'max_full:', 'max_full', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'time_days', 'lyt_epa_data_2', 6, 'string', 'text', 'time_days:', 'time_days', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'time_hour:', 'time_hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_out', 'lyt_epa_data_2', 8, 'string', 'text', 'max_out:', 'max_out', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'tbl_inp_storage', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_storage');


--conduit
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_conduit', 'SELECT dscenario_id, arccat_id, matcat_id, elev1, elev2, custom_n, 
       barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage FROM v_edit_inp_dscenario_conduit WHERE arc_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'barrels', 'lyt_epa_data_1', 1, 'string', 'text', 'barrels:', 'barrels', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'culvert', 'lyt_epa_data_1', 2, 'string', 'text', 'culvert:', 'culvert', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kentry', 'lyt_epa_data_1', 3, 'string', 'text', 'kentry:', 'kentry', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kexit', 'lyt_epa_data_1', 4, 'string', 'text', 'kexit:', 'kexit', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kavg', 'lyt_epa_data_1', 5, 'string', 'text', 'kavg:', 'kavg', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'flap', 'lyt_epa_data_1', 6, 'string', 'text', 'flap:', 'flap', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'q0', 'lyt_epa_data_1', 7, 'string', 'text', 'q0:', 'q0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'qmax', 'lyt_epa_data_1', 8, 'string', 'text', 'qmax:', 'qmax', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'seepage', 'lyt_epa_data_1', 9, 'string', 'text', 'seepage:', 'seepage', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'custom_n', 'lyt_epa_data_1', 10, 'string', 'text', 'custom_n:', 'custom_n', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 1, 'string', 'text', 'max_flow:', 'max_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_days', 'lyt_epa_data_2', 2, 'string', 'text', 'time_days:', 'time_days', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 3, 'string', 'text', 'time_hour:', 'time_hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_veloc', 'lyt_epa_data_2', 4, 'string', 'text', 'max_veloc:', 'max_veloc', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'mfull_flow', 'lyt_epa_data_2', 5, 'string', 'text', 'mfull_flow:', 'mfull_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'mfull_dept', 'lyt_epa_data_2', 6, 'string', 'text', 'mfull_dept:', 'mfull_dept', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'tbl_inp_conduit', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_conduit');

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_storage' AND a.columnname='curve_id' AND c.columnname='curve_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_storage' AND a.columnname='storage_type' AND c.columnname='storage_type' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_outfall' AND a.columnname='timser_id' AND c.columnname='timser_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_outfall' AND a.columnname='outfall_type' AND c.columnname='outfall_type' AND c.formname ILIKE 've_epa%';

UPDATE link l SET epa_type = c.epa_type, is_operative = v.is_operative 
FROM gully c
JOIN value_state_type v ON v.id = c.state_type WHERE l.feature_id = c.gully_id;

UPDATE link l SET is_operative = v.is_operative 
FROM connec c
JOIN value_state_type v ON v.id = c.state_type WHERE l.feature_id = c.connec_id;

UPDATE config_form_fields SET iseditable= true WHERE columnname='order_id' AND formname='v_edit_inp_inflows';

UPDATE sys_param_user SET dv_isnullvalue= true WHERE id='inp_options_dwfscenario';

INSERT INTO config_function(id, function_name, "style", layermanager, actions)
VALUES(2928, 'gw_fct_getstylemapzones', '{"DRAINZONE":{"mode":"Random", "column":"drainzone_id"}}'::json, NULL, NULL);

UPDATE config_toolbox SET
inputparams = '[{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":1, "selectedId":""},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["DELETE & COPY", "KEEP & COPY", "DELETE ONLY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"DELETE-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":4, "selectedId":"$userHydrology"}  ]'::json WHERE
id = 3100;


INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3234, 'gw_fct_settimeseries', 'utils', 'function', 'varchar', 'json', 'Set timeseries values for any objects (1st version for raingage)', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'bottom_mat', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'bottom_mat', 'bottom_mat',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'CONDUIT' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'bottom_mat', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'bottom_mat', 'bottom_mat',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'CHAMBER' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'bottom_mat', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'bottom_mat', 'bottom_mat',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'MANHOLE' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'slope', 'lyt_data_2', max(layoutorder)+1, 
'string', 'text', 'slope', 'slope',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'CHAMBER' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'adate', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Adate', 'adate', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'adescript', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Adescript', 'adescript', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'siphon_type', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Siphon_type', 'siphon_type', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_gully', 've_gully') AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'odorflap', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Odorflap', 'odorflap', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_gully', 've_gully') AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_arc', 've_arc') group by formname)
SELECT c.formname, formtype, tabname, 'visitability', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Visitability', 'visitability', NULL, false, false, false, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_arc', 've_arc') AND columnname='inventory'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET iseditable = true WHERE  formname ilike 'v_edit_inp_dscenario%' and columnname ='node_id';


    
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 1, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, 'SELECT id, id AS idval FROM inp_curve 
WHERE id IS NOT NULL','{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 2, 'string', 'combo', 'status:', 'status', false, false, true, false, 'SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status''','{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'startup', 'lyt_epa_data_1', 3, 'double', 'text', 'startup:', 'startup', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'shutoff', 'lyt_epa_data_1', 4, 'double', 'text', 'shutoff:', 'shutoff', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'percent', 'lyt_epa_data_2', 1, 'string', 'text', 'percent:', 'percent', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'num_startup', 'lyt_epa_data_2', 2, 'string', 'text', 'num_startup :', 'num_startup', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'min_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'min_flow:', 'min_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_flow', 'lyt_epa_data_2', 4, 'string', 'text', 'avg_flow:', 'avg_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 5, 'string', 'text', 'max_flow:', 'max_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'vol_ltr', 'lyt_epa_data_2', 6, 'string', 'text', 'vol_ltr:', 'vol_ltr', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'powus_kwh', 'lyt_epa_data_2', 7, 'string', 'text', 'powus_kwh:', 'powus_kwh', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'timoff_min', 'lyt_epa_data_2', 8, 'string', 'text', 'timoff_min:', 'timoff_min', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'timoff_max', 'lyt_epa_data_2', 9, 'string', 'text', 'timoff_max:', 'timoff_max', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_netgully', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_netgully' and columnname in ('y0', 'ysur', 'apond', 'outlet_type', 'custom_width', 'custom_length', 'custom_depth',
'method', 'weir_cd', 'orifice_cd', 'custom_a_param', 'custom_b_param', 'efficiency') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_netgully' AND table_name=formname AND columnname=column_name  ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_orifice', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_orifice' and columnname in ('ori_type', 'offsetval', 'cd', 'orate', 'flap', 'shape', 'geom1',
'geom2', 'geom3', 'geom4', 'close_time') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_orifice' AND table_name=formname AND columnname=column_name ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_orifice', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_conduit' and layoutname = 'lyt_epa_data_2' order by columnname ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_weir', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_weir' and columnname in ('weir_type', 'offsetval', 'cd', 'ec', 'cd2','flap',  'geom1',
'geom2', 'geom3', 'geom4', 'surcharge', 'road_width', 'road_surf', 'coef_curve') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_weir' AND table_name=formname AND columnname=column_name ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_weir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_conduit' and layoutname = 'lyt_epa_data_2' order by columnname ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_outlet', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_outlet' and columnname in ('outlet_type', 'offsetval', 'curve_id', 'cd1', 'cd2','flap') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_outlet' AND table_name=formname AND columnname=column_name ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_outlet', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_conduit' and layoutname = 'lyt_epa_data_2' order by columnname ;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
VALUES ('ve_epa_virtual', 'form_feature', 'epa', 'fusion_node', 'lyt_epa_data_1', 1, 'string', 'typeahead', 'fusion_node:', 'fusion_node', false, false, true, false, 'SELECT node_id as id, node_id as idval FROM v_edit_node WHERE 1=1 ','{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
VALUES ('ve_epa_virtual', 'form_feature', 'epa', 'add_length', 'lyt_epa_data_1', 2, 'boolean', 'check', 'add_length:', 'add_length', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

UPDATE sys_table SET context = NULL, orderby=NULL WHERE id='v_edit_inp_divider';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname,datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_inp_curve', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_inp_pattern', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname,datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_inp_timeseries', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('inp_lid', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);


-- search
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_tab_network_gully', '{"sys_display_name":"concat(gully_id, '' : '', gratecat_id)", "sys_tablename":"v_edit_gully", "sys_pk":"gully_id", "sys_fct":"gw_fct_getinfofromid", "sys_filter":""}', 'Search configuration parameteres', 'Gully:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

DELETE FROM config_toolbox where id IN (SELECT id FROM sys_function WHERE project_type  ='ws');


-- update sys_table registers according current relations
/*
SELECT * FROM information_schema.tables WHERE table_schema='SCHEMA_NAME' and table_name NOT IN (SELECT id FROM sys_table);
SELECT * FROM sys_table WHERE id NOT IN (SELECT table_name FROM information_schema.tables WHERE table_schema='SCHEMA_NAME');
*/

DELETE FROM sys_table where id not in (SELECT table_name FROM information_schema.tables WHERE table_schema='SCHEMA_NAME');

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ext_rtc_scada_x_data', 'Data for external data of scada', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_anl_graphanalytics_mapzones', 'View for graphanalytics', 'role_om', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_gully', 'Editable view for epa gully', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_junction', 'Editable view for epa junction', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_conduit', 'Editable view for epa counduit', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_outfall', 'Editable view for epa outfall', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_storage', 'Editable view for epa storage', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_pump', 'Editable view for epa pump', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_virtual', 'Editable view for epa virtual', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_netgully', 'Editable view for epa netgully', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_weir', 'Editable view for epa weir', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_orifice', 'Editable view for epa orifice', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_outlet', 'Editable view for epa outlet', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;


-- update sys_function registers according current relations
/*
SELECT routine_name FROM information_schema.routines WHERE routine_type='FUNCTION' AND specific_schema='SCHEMA_NAME' and routine_name not in (select function_name FROM sys_function);
select project_type, id, function_name FROM sys_function WHERE function_name NOT IN (SELECT routine_name FROM information_schema.routines WHERE routine_type='FUNCTION' AND specific_schema='SCHEMA_NAME');
*/

DELETE FROM config_toolbox WHERE id in (2302, 2706, 2712, 2790);

DELETE FROM sys_function WHERE project_type ='ws';

INSERT INTO sys_function (id, function_name, project_type, function_type) VALUES (3240, 'gw_fct_getvisit_manager', 'utils', 'function')ON CONFLICT (id) DO NOTHING;

-- harmonize tabs 24/05/2023
ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

UPDATE config_form_fields set tabname = 'tab_data' where tabname = 'data';
UPDATE config_form_fields set tabname = 'tab_documents' where tabname = 'document';
UPDATE config_form_fields set tabname = 'tab_hydrometer' where tabname = 'hydrometer';
UPDATE config_form_fields set tabname = 'tab_elements' where tabname = 'element';
UPDATE config_form_fields set tabname = 'tab_mincut' where tabname = 'mincut';
UPDATE config_form_fields set tabname = 'tab_epa' where tabname = 'epa';
UPDATE config_form_fields set tabname = 'tab_hydrometer_val' where tabname = 'hydro_val';
UPDATE config_form_fields set tabname = 'tab_none' where tabname = 'main';
UPDATE config_form_fields set tabname = 'tab_visit' where tabname = 'visit';
UPDATE config_form_fields set tabname = 'tab_event' where tabname = 'event';
UPDATE config_form_fields set tabname = 'tab_relation' where tabname = 'relation';

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(495, 'Set optimum outlet', 'ud', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (3242, 'gw_fct_epa_setoptimumoutlet', 'ud', 'function') ON CONFLICT (id) DO NOTHING;


-- FLWREG LISTS
-- orifice
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_orifice', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time FROM inp_flwreg_orifice WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_orifice', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.ori_type, d.offsetval, d.cd, d.orate, d.flap, d.shape, d.geom1, d.geom2, d.geom3, d.geom4, d.close_time 
FROM inp_dscenario_flwreg_orifice d
JOIN inp_flwreg_orifice f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
-- outlet
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_outlet', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, outlet_type, offsetval, curve_id, cd1, cd2, flap FROM inp_flwreg_outlet WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_outlet', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.outlet_type, d.offsetval, d.curve_id, d.cd1, d.cd2, d.flap 
FROM inp_dscenario_flwreg_outlet d
JOIN inp_flwreg_outlet f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
-- pump
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_pump', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, curve_id, status, startup, shutoff FROM inp_flwreg_pump WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_pump', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.curve_id, d.status, d.startup, d.shutoff 
FROM inp_dscenario_flwreg_pump d
JOIN inp_flwreg_pump f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
-- weir
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_weir', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve FROM inp_flwreg_weir WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_weir', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.weir_type, d.offsetval, d.cd, d.ec, d.cd2, d.flap, d.geom1, d.geom2, d.geom3, d.geom4, d.surcharge, d.road_width, d.road_surf, d.coef_curve 
FROM inp_dscenario_flwreg_weir d
JOIN inp_flwreg_weir f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

-- epa actions
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) 
VALUES('ve_epa_junction', 'tab_epa', 'EPA', NULL, 'role_basic', NULL, 
'[{"actionName":"actionEdit","actionTooltip":"Edit","disabled":false},
{"actionName":"actionZoom","actionTooltip":"Zoom In","disabled":false},
{"actionName":"actionCentered","actionTooltip":"Center","disabled":false},
{"actionName":"actionZoomOut","actionTooltip":"Zoom Out","disabled":false},
{"actionName":"actionCatalog","actionTooltip":"Change Catalog","disabled":false},
{"actionName":"actionWorkcat","actionTooltip":"Add Workcat","disabled":false},
{"actionName":"actionCopyPaste","actionTooltip":"Copy Paste","disabled":false},
{"actionName":"actionLink","actionTooltip":"Open Link","disabled":false},
{"actionName":"actionHelp","actionTooltip":"Help","disabled":false},
{"actionName":"actionInterpolate", "actionTooltip":"Interpolate", "disabled":false},
{"actionName":"actionSetToArc","actionTooltip":"Set to_arc","disabled":false},
{"actionName":"actionGetArcId","actionTooltip":"Set arc_id","disabled":false},
{"actionName":"actionOrifice","actionTooltip":"Orifice","disabled":false},
{"actionName":"actionOutlet","actionTooltip":"Outlet","disabled":false},
{"actionName":"actionPump","actionTooltip":"Pump","disabled":false},
{"actionName":"actionWeir","actionTooltip":"Weir","disabled":false},
{"actionName":"actionDemand","actionTooltip":"DWF","disabled":false}]'::json, 2, '{4}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) 
VALUES('ve_epa_storage', 'tab_epa', 'EPA', NULL, 'role_basic', NULL, 
'[{"actionName":"actionEdit","actionTooltip":"Edit","disabled":false},
{"actionName":"actionZoom","actionTooltip":"Zoom In","disabled":false},
{"actionName":"actionCentered","actionTooltip":"Center","disabled":false},
{"actionName":"actionZoomOut","actionTooltip":"Zoom Out","disabled":false},
{"actionName":"actionCatalog","actionTooltip":"Change Catalog","disabled":false},
{"actionName":"actionWorkcat","actionTooltip":"Add Workcat","disabled":false},
{"actionName":"actionCopyPaste","actionTooltip":"Copy Paste","disabled":false},
{"actionName":"actionInterpolate", "actionTooltip":"Interpolate", "disabled":false},
{"actionName":"actionLink","actionTooltip":"Open Link","disabled":false},
{"actionName":"actionHelp","actionTooltip":"Help","disabled":false},
{"actionName":"actionSetToArc","actionTooltip":"Set to_arc","disabled":false},
{"actionName":"actionGetArcId","actionTooltip":"Set arc_id","disabled":false},
{"actionName":"actionOrifice","actionTooltip":"Orifice","disabled":false},
{"actionName":"actionOutlet","actionTooltip":"Outlet","disabled":false},
{"actionName":"actionPump","actionTooltip":"Pump","disabled":false},
{"actionName":"actionWeir","actionTooltip":"Weir","disabled":false}]'::json, 2, '{4}');

-- add node_id widget
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_orifice','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_outlet','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_pump','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_weir','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);

-- set layoutorder for flwreg widgets
UPDATE config_form_fields 
SET layoutorder = (SELECT attnum FROM pg_attribute WHERE attrelid = formname::regclass AND attname = columnname and attnum > 0 AND NOT attisdropped ORDER BY attnum LIMIT 1)
WHERE formname like 'v_edit_inp%flwreg%';
-- make widgets not editable
UPDATE config_form_fields 
SET iseditable = false 
WHERE formname like 'v_edit_inp%flwreg%' and columnname IN ('nodarc_id', 'node_id');

-- insert flwreg tables into config_form_tableview
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, addparam)
SELECT 'epa form', 'ud', v.table_name, c.column_name, c.ordinal_position, true, NULL
FROM information_schema.tables v
JOIN information_schema.columns c ON v.table_schema = c.table_schema AND v.table_name = c.table_name
WHERE v.table_schema = 'SCHEMA_NAME'
  AND v.table_name LIKE 'inp%flwreg%'
ORDER BY v.table_name, c.ordinal_position;

-- disable columns
UPDATE config_form_tableview SET addparam = '{"editable": false}' WHERE objectname like 'inp%flwreg%' AND columnname IN ('id', 'node_id', 'nodarc_id', 'dscenario_id');

-- config_form_fields
-- hide order_id in dscenarios
UPDATE config_form_fields
	SET hidden=true
	WHERE formname like 'v_edit_inp_dscenario_flwreg%' AND columnname='order_id';
-- nodarc_id combos
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_orifice WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_orifice' AND columnname='nodarc_id';
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_outlet WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_outlet' AND columnname='nodarc_id';
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_pump WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_pump' AND columnname='nodarc_id';
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_weir WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_weir' AND columnname='nodarc_id';



CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_junction
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_conduit INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_conduit
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('conduit');

CREATE TRIGGER gw_trg_edit_ve_epa_outfall INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_outfall
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('outfall');

CREATE TRIGGER gw_trg_edit_ve_epa_storage INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_storage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('storage');

CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_pump
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('pump');

CREATE TRIGGER gw_trg_edit_ve_epa_virtual INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_virtual
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('virtual');

CREATE TRIGGER gw_trg_edit_ve_epa_netgully INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_netgully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('netgully');

CREATE TRIGGER gw_trg_edit_ve_epa_weir INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_weir
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('weir');

CREATE TRIGGER gw_trg_edit_ve_epa_orifice INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_orifice
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('orifice');

CREATE TRIGGER gw_trg_edit_ve_epa_outlet INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_outlet
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('outlet');

DROP TRIGGER IF EXISTS gw_trg_vi_timeseries ON vi_timeseries;
CREATE TRIGGER   gw_trg_vi_timeseries
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON vi_timeseries
    FOR EACH ROW
    EXECUTE FUNCTION gw_trg_vi('vi_timeseries');

DROP TRIGGER IF EXISTS gw_trg_link_data ON gully;
CREATE TRIGGER gw_trg_link_data AFTER INSERT OR UPDATE OF epa_type, state_type, expl_id2
ON gully FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('gully');

DROP TRIGGER IF EXISTS gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data AFTER INSERT OR UPDATE OF  state_type, expl_id2
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('connec');
