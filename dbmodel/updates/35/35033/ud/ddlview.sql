/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW vi_subcatchments AS 
 SELECT DISTINCT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.rg_id,
    b.outlet_id,
    v_edit_inp_subcatchment.area,
    v_edit_inp_subcatchment.imperv,
    v_edit_inp_subcatchment.width,
    v_edit_inp_subcatchment.slope,
    v_edit_inp_subcatchment.clength,
    v_edit_inp_subcatchment.snow_id
   FROM v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id);


CREATE OR REPLACE VIEW vi_subareas AS 
 SELECT DISTINCT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.nimp,
    v_edit_inp_subcatchment.nperv,
    v_edit_inp_subcatchment.simp,
    v_edit_inp_subcatchment.sperv,
    v_edit_inp_subcatchment.zero,
    v_edit_inp_subcatchment.routeto,
    v_edit_inp_subcatchment.rted
   FROM v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id);

DROP VIEW IF EXISTS vi_timeseries;
CREATE OR REPLACE VIEW vi_timeseries AS 
SELECT DISTINCT t.timser_id,
    t.other1,
    t.other2,
    t.other3
   FROM selector_expl s,
    ( SELECT a.timser_id,
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
                  WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    concat('FILE', ' ', inp_timeseries.fname) AS other1,
                    NULL::character varying AS other2,
                    NULL::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'FILE'::text
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    NULL::TEXT AS other1,
                    inp_timeseries_value."time" AS other2,
                    inp_timeseries_value.value::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'RELATIVE'::text) a
          ORDER BY a.id) t
  WHERE t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL ORDER BY 1,2,3;



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
    node_sys_top_elev_2 - (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) - cat_arc.geom2 AS r2,
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
    arc.parent_id
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     JOIN dma m  USING (dma_id)
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;



CREATE OR REPLACE VIEW v_arc AS 
SELECT vu_arc.* FROM vu_arc
JOIN v_state_arc USING (arc_id)
JOIN v_expl_arc e on e.arc_id = vu_arc.arc_id;

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"parent_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);



CREATE OR REPLACE VIEW v_edit_inp_junction
 AS
 SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    n.the_geom
   FROM v_sector_node 
    JOIN  v_edit_node n USING (node_id)
     JOIN inp_junction USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
  WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet
 AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), 25831)::geometry(LineString,25831) AS the_geom
   FROM v_sector_node 
    JOIN inp_flwreg_outlet f USING (node_id)
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_orifice
 AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.close_time,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), 25831)::geometry(LineString,25831) AS the_geom
   FROM v_sector_node
    join inp_flwreg_orifice f  USING (node_id)
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE vs.is_operative IS TRUE;

  CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet
 AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), 25831)::geometry(LineString,25831) AS the_geom
   FROM v_sector_node
    JOIN inp_flwreg_outlet f USING (node_id)
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_weir
 AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.ec,
    f.cd2,
    f.flap,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), 25831)::geometry(LineString,25831) AS the_geom
   FROM v_sector_node 
    JOIN inp_flwreg_weir f USING (node_id)
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE  vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump
 AS
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), 25831)::geometry(LineString,25831) AS the_geom
   FROM v_sector_node
    JOIN inp_flwreg_pump f USING (node_id)
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE  vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_divider
 AS
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    v_node.the_geom
   FROM v_sector_node
    JOIN v_node USING (node_id)
     JOIN inp_divider ON v_node.node_id::text = inp_divider.node_id::text
     JOIN value_state_type ON value_state_type.id = v_node.state_type
  WHERE value_state_type.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_netgully
 AS
 SELECT n.node_id,
    n.code,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.node_type,
    n.nodecat_id,
    man_netgully.gratecat_id,
    (cat_grate.width / 100::numeric)::numeric(12,3) AS grate_width,
    (cat_grate.length / 100::numeric)::numeric(12,3) AS grate_length,
    n.sector_id,
    n.macrosector_id,
    n.expl_id,
    n.state,
    n.state_type,
    n.the_geom,
    man_netgully.units,
    man_netgully.units_placement,
    man_netgully.groove,
    man_netgully.groove_height,
    man_netgully.groove_length,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    n.ymax - COALESCE(man_netgully.sander_depth, 0::numeric) AS depth,
    n.annotation,
    i.y0,
    i.ysur,
    i.apond,
    i.outlet_type,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM v_sector_node
    join v_node n USING (node_id)
     JOIN inp_netgully i USING (node_id)
     JOIN value_state_type vs ON vs.id = n.state_type
     LEFT JOIN man_netgully USING (node_id)
     LEFT JOIN cat_grate ON man_netgully.gratecat_id::text = cat_grate.id::text
  WHERE  vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_outfall
 AS
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    v_node.the_geom
   FROM v_sector_node
    join v_node USING (node_id)
     JOIN inp_outfall USING (node_id)
     JOIN value_state_type ON value_state_type.id = v_node.state_type
  WHERE  value_state_type.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_storage
 AS
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_storage.storage_type,
    inp_storage.curve_id,
    inp_storage.a1,
    inp_storage.a2,
    inp_storage.a0,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    inp_storage.y0,
    inp_storage.ysur,
    inp_storage.apond,
    v_node.the_geom
   FROM v_sector_node
    join v_node USING (node_id)
     JOIN inp_storage USING (node_id)
     JOIN value_state_type ON value_state_type.id = v_node.state_type
  WHERE value_state_type.is_operative IS TRUE;

DROP VIEW vi_gully2node;

drop view if exists v_edit_inp_gully;
CREATE OR REPLACE VIEW v_edit_inp_gully
 AS
 SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gratecat_id,
    (g.grate_width / 100::numeric)::numeric(12,2) AS grate_width,
    (g.grate_length / 100::numeric)::numeric(12,2) AS grate_length,
    g.arc_id,
    s.sector_id,
    g.expl_id,
    g.state,
    g.state_type,
    g.the_geom,
    g.units,
    g.units_placement,
    g.groove,
    g.groove_height,
    g.groove_length,
    g.pjoint_id,
    g.pjoint_type,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    g.ymax - COALESCE(g.sandbox, 0::numeric) AS depth,
    g.annotation,
    i.outlet_type,
    i.custom_top_elev,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM selector_sector s,
    v_edit_gully g
     JOIN inp_gully i USING (gully_id)
     JOIN cat_grate ON g.gratecat_id::text = cat_grate.id::text
     JOIN value_state_type vs ON vs.id = g.state_type
  WHERE g.sector_id = s.sector_id AND s.cur_user = "current_user"()::text AND vs.is_operative IS TRUE;

  
CREATE OR REPLACE VIEW vi_gully2node AS 
 SELECT *, 
    st_makeline(a.the_geom, n.the_geom) AS the_geom FROM 
    (SELECT g.gully_id,
    case when pjoint_type = 'NODE' then pjoint_id else a.node_2 END AS node_id, 
    a.expl_id,
    g.the_geom
   FROM v_edit_inp_gully g
     LEFT JOIN arc a USING (arc_id))a
     JOIN node n USING (node_id);
