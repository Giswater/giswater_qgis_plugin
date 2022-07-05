/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/08
CREATE OR REPLACE VIEW v_plan_arc AS 
 SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.expl_id,
    d.sector_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
        CASE
            WHEN d.other_budget IS NOT NULL THEN (d.budget + d.other_budget)::numeric(14,2)
            ELSE d.budget
        END AS total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_arc.arc_id,
                            v_arc.y1,
                            v_arc.y2,
                                CASE
                                    WHEN (v_arc.y1 * v_arc.y2) = 0::numeric OR (v_arc.y1 * v_arc.y2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_arc.y1 + v_arc.y2) / 2::numeric)::numeric(12,2)
                                END AS mean_y,
                            v_arc.arccat_id,
                            COALESCE(v_price_x_catarc.geom1, 0::numeric)::numeric(12,4) AS geom1,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.bulk / 1000::numeric, 0::numeric)::numeric(12,2) AS bulk,
                            v_price_x_catarc.cost_unit,
                            COALESCE(v_price_x_catarc.cost, 0::numeric)::numeric(12,2) AS arc_cost,
                            COALESCE(v_price_x_catarc.m2bottom_cost, 0::numeric)::numeric(12,2) AS m2bottom_cost,
                            COALESCE(v_price_x_catarc.m3protec_cost, 0::numeric)::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            COALESCE(v_price_x_catsoil.y_param, 10::numeric)::numeric(5,2) AS y_param,
                            COALESCE(v_price_x_catsoil.b, 0::numeric)::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, 0::numeric) AS trenchlining,
                            COALESCE(v_price_x_catsoil.m3exc_cost, 0::numeric)::numeric(12,2) AS m3exc_cost,
                            COALESCE(v_price_x_catsoil.m3fill_cost, 0::numeric)::numeric(12,2) AS m3fill_cost,
                            COALESCE(v_price_x_catsoil.m3excess_cost, 0::numeric)::numeric(12,2) AS m3excess_cost,
                            COALESCE(v_price_x_catsoil.m2trenchl_cost, 0::numeric)::numeric(12,2) AS m2trenchl_cost,
                            COALESCE(v_plan_aux_arc_pavement.thickness, 0::numeric)::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, 0::numeric) AS m2pav_cost,
                            v_arc.state,
                            v_arc.expl_id,
                            v_arc.the_geom
                           FROM v_arc
                             LEFT JOIN v_price_x_catarc ON v_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON v_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_arc.arc_id::text
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.y1,
                    v_plan_aux_arc_ml.y2,
                    v_plan_aux_arc_ml.mean_y,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.geom1,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_y,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            arc.arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            v_plan_aux_arc_cost.expl_id,
            arc.sector_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.y1,
            v_plan_aux_arc_cost.y2,
            v_plan_aux_arc_cost.mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_y + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_y - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.geom1)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.geom1 + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
                END::numeric(12,3) AS pav_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
                END::numeric(12,3) AS exc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
                END::numeric(12,3) AS trenchl_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
                END::numeric(12,3) AS base_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
                END::numeric(12,3) AS protec_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
                END::numeric(12,3) AS fill_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
                END::numeric(12,3) AS excess_cost,
            v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
                END::numeric(12,2) AS cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
                END::numeric(12,2) AS length,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
                END::numeric(14,2) AS budget,
            COALESCE(v_plan_aux_arc_connec.connec_total_cost, 0::numeric) + COALESCE(v_plan_aux_arc_gully.gully_total_cost, 0::numeric) AS other_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON v_plan_aux_arc_cost.arc_id::text = arc.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS gully_total_cost
                   FROM v_edit_gully c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d;
				  
--2022/06/11

CREATE OR REPLACE VIEW vu_gully AS 
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
    epa_type,
    groove_height,
    groove_length,
    cat_grate.width as grate_width,
    cat_grate.length as grate_length,
    units_placement
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text;


CREATE OR REPLACE VIEW v_gully AS 
 SELECT vu_gully.*
 FROM vu_gully
 JOIN v_state_gully USING (gully_id);

CREATE OR REPLACE VIEW v_edit_gully AS 
 SELECT *
 FROM v_gully;

CREATE OR REPLACE VIEW ve_gully AS 
 SELECT *
 FROM v_gully;


DROP VIEW IF EXISTS v_edit_inp_gully;
CREATE OR REPLACE VIEW v_edit_inp_gully AS 
 SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gratecat_id,
    (g.grate_width/100)::NUMERIC(12,2) AS grate_width,
    (g.grate_length/100)::NUMERIC(12,2) AS grate_length,
    g.arc_id,
    a.node_2 as node_id,
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
    a_param,
    b_param,
    (case when units_placement = 'LENGTH-SIDE' THEN (coalesce(units,1)*grate_width/100)::NUMERIC(12,3) 
         when units_placement = 'WIDTH-SIDE' THEN (coalesce(units,1)*grate_length/100)::NUMERIC(12,3)
         else (width/100)::NUMERIC(12,3) end) as total_width,
    (case when units_placement = 'LENGTH-SIDE' THEN (coalesce(units,1)*grate_width/100)::NUMERIC(12,3)
         when units_placement = 'WIDTH-SIDE' THEN (coalesce(units,1)*grate_length/100)::NUMERIC(12,3)
         else (length/100)::NUMERIC(12,3) end) as total_length,
    ymax - coalesce(sandbox,0) as depth,
    g.annotation,
    outlet_type,
	custom_top_elev,
    custom_width,
    i.custom_length,
    custom_depth,
    method,
    weir_cd,
    orifice_cd,
    custom_a_param,
    custom_b_param,
    efficiency
   FROM selector_sector s,
    v_edit_gully g
     JOIN inp_gully i USING (gully_id)
     JOIN cat_grate ON gratecat_id = id
     JOIN arc a USING (arc_id)
  WHERE g.sector_id = s.sector_id AND s.cur_user = CURRENT_USER::text;


DROP VIEW IF EXISTS v_edit_inp_netgully;
CREATE OR REPLACE VIEW v_edit_inp_netgully AS 
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
    nodecat_id,
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
   FROM selector_sector s,
    v_node n
     JOIN inp_netgully i USING (node_id)
     LEFT JOIN man_netgully USING (node_id)
     LEFT JOIN cat_grate ON man_netgully.gratecat_id::text = cat_grate.id::text
  WHERE n.sector_id = s.sector_id AND s.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_gully2node AS 
SELECT gully_id, node_id, n.expl_id, st_makeline(g.the_geom, n.the_geom) the_geom
FROM v_edit_inp_gully g join node n USING (node_id);


DROP VIEW IF EXISTS vi_gully;
CREATE OR REPLACE VIEW vi_gully AS 
 SELECT gully_id,
    outlet_type,
    coalesce(node_id::text, '-9999') as node_id,
    (st_x(the_geom))::numeric(12,3) as xcoord,
    (st_y(the_geom))::numeric(12,3) as ycoord,
    coalesce(top_elev::numeric(12,3),-9999) as zcoord,
    width::numeric(12,3),
    length::numeric(12,3),
    coalesce(depth::numeric(12,3),-9999) as depth,
    method,
    weir_cd::numeric(12,3),
    orifice_cd::numeric(12,3),
    a_param::numeric(12,3),
    b_param::numeric(12,3),
    efficiency
   FROM temp_gully;
   
  
CREATE OR REPLACE VIEW v_edit_inp_pattern_value AS 
SELECT
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
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
   FROM selector_expl s, inp_pattern p
     JOIN inp_pattern_value USING (pattern_id)
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY 1;

drop view if exists vi_patterns;
 CREATE OR REPLACE VIEW vi_patterns AS 
  SELECT p.pattern_id, p.pattern_type, 
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
   from selector_expl s, inp_pattern p JOIN inp_pattern_value USING (pattern_id) 
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY 1;


CREATE OR REPLACE VIEW vi_timeseries AS 
SELECT timser_id, other1, other2, other3 FROM selector_expl s ,(
 SELECT a.timser_id,
    a.other1,
    a.other2,
    a.other3,
    expl_id
   FROM ( SELECT inp_timeseries_value.id,
            inp_timeseries_value.timser_id,
            inp_timeseries_value.date AS other1,
            inp_timeseries_value.hour AS other2,
            inp_timeseries_value.value AS other3,
            expl_id
           FROM inp_timeseries_value
             JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
          WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text
        UNION
         SELECT inp_timeseries_value.id,
            inp_timeseries_value.timser_id,
            concat('FILE', ' ', inp_timeseries.fname) AS other1,
            NULL::character varying AS other2,
            NULL::numeric AS other3,
            expl_id
           FROM inp_timeseries_value
             JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
          WHERE inp_timeseries.times_type::text = 'FILE'::text
        UNION
         SELECT inp_timeseries_value.id,
            inp_timeseries_value.timser_id,
            inp_timeseries_value."time" AS other1,
            inp_timeseries_value.value::text AS other2,
            NULL::numeric AS other3,
            expl_id
           FROM inp_timeseries_value
             JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
          WHERE inp_timeseries.times_type::text = 'RELATIVE'::text) a
  ORDER BY a.id) t
  WHERE t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL;


CREATE OR REPLACE VIEW vi_curves AS 
 SELECT inp_curve_value.curve_id,
        CASE
            WHEN inp_curve_value.id = (( SELECT min(sub.id) AS min
               FROM inp_curve_value sub
              WHERE sub.curve_id::text = inp_curve_value.curve_id::text)) THEN inp_typevalue.idval
            ELSE NULL::character varying
        END AS curve_type,
    inp_curve_value.x_value,
    inp_curve_value.y_value
   FROM selector_expl s, inp_curve c
     JOIN inp_curve_value ON c.id::text = inp_curve_value.curve_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = c.curve_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_curve'::text
  AND c.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR c.expl_id IS NULL
  ORDER BY inp_curve_value.id;


DROP VIEW v_edit_cat_feature_gully;
CREATE OR REPLACE VIEW v_edit_cat_feature_gully AS 
 SELECT cat_feature.id,
    cat_feature.system_id,
    cat_feature_gully.epa_default,
    cat_feature.code_autofill,
    cat_feature_gully.double_geom::text AS double_geom,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_gully USING (id);


CREATE OR REPLACE VIEW vi_subcatchments AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.rg_id,
    b.outlet_id,
    v_edit_inp_subcatchment.area,
    v_edit_inp_subcatchment.imperv,
    v_edit_inp_subcatchment.width,
    v_edit_inp_subcatchment.slope,
    v_edit_inp_subcatchment.clength,
    v_edit_inp_subcatchment.snow_id
   FROM v_edit_inp_subcatchment
   JOIN (
	SELECT subc_id, outlet_id 
	FROM ( SELECT unnest(outlet_id::varchar[]) AS outlet_id, subc_id FROM inp_subcatchment
	       JOIN temp_node ON outlet_id = node_id WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
	UNION
	SELECT outlet_id, subc_id FROM inp_subcatchment WHERE "left"(inp_subcatchment.outlet_id::text, 1) != '{'::text)a) b
	USING (outlet_id);


CREATE OR REPLACE VIEW vi_subareas AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.nimp,
    v_edit_inp_subcatchment.nperv,
    v_edit_inp_subcatchment.simp,
    v_edit_inp_subcatchment.sperv,
    v_edit_inp_subcatchment.zero,
    v_edit_inp_subcatchment.routeto,
    v_edit_inp_subcatchment.rted
FROM v_edit_inp_subcatchment
   JOIN (
	SELECT subc_id, outlet_id 
	FROM ( SELECT unnest(outlet_id::varchar[]) AS outlet_id, subc_id FROM inp_subcatchment
	       JOIN temp_node ON outlet_id = node_id WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
	UNION
	SELECT outlet_id, subc_id FROM inp_subcatchment WHERE "left"(inp_subcatchment.outlet_id::text, 1) != '{'::text)a) b
	USING (outlet_id);


CREATE OR REPLACE VIEW vi_infiltration AS 
SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM ud_inp.v_edit_inp_subcatchment
   JOIN ud1.cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
   JOIN (
	SELECT subc_id, outlet_id 
	FROM ( SELECT unnest(outlet_id::varchar[]) AS outlet_id, subc_id FROM inp_subcatchment
	       JOIN temp_node ON outlet_id = node_id WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
	UNION
	SELECT outlet_id, subc_id FROM inp_subcatchment WHERE "left"(inp_subcatchment.outlet_id::text, 1) != '{'::text)a) b
	USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
union
SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.suction AS other1,
    v_edit_inp_subcatchment.conduct AS other2,
    v_edit_inp_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM ud_inp.v_edit_inp_subcatchment
   JOIN ud1.cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
   JOIN (
	SELECT subc_id, outlet_id 
	FROM ( SELECT unnest(outlet_id::varchar[]) AS outlet_id, subc_id FROM inp_subcatchment
	       JOIN temp_node ON outlet_id = node_id WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
	UNION
	SELECT outlet_id, subc_id FROM inp_subcatchment WHERE "left"(inp_subcatchment.outlet_id::text, 1) != '{'::text)a) b
	USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
union
SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.maxrate AS other1,
    v_edit_inp_subcatchment.minrate AS other2,
    v_edit_inp_subcatchment.decay AS other3,
    v_edit_inp_subcatchment.drytime AS other4,
    v_edit_inp_subcatchment.maxinfil AS other5
   FROM ud_inp.v_edit_inp_subcatchment
    JOIN ud1.cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
      JOIN (
	SELECT subc_id, outlet_id 
	FROM ( SELECT unnest(outlet_id::varchar[]) AS outlet_id, subc_id FROM inp_subcatchment
	       JOIN temp_node ON outlet_id = node_id WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
	UNION
	SELECT outlet_id, subc_id FROM inp_subcatchment WHERE "left"(inp_subcatchment.outlet_id::text, 1) != '{'::text)a) b
	USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
union
  SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM ud_inp.v_edit_inp_subcatchment
   JOIN ud1.cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
   JOIN (
	SELECT subc_id, outlet_id 
	FROM ( SELECT unnest(outlet_id::varchar[]) AS outlet_id, subc_id FROM inp_subcatchment
	       JOIN temp_node ON outlet_id = node_id WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
	UNION
	SELECT outlet_id, subc_id FROM inp_subcatchment WHERE "left"(inp_subcatchment.outlet_id::text, 1) != '{'::text)a) b
	USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = ANY (ARRAY['MODIFIED_HORTON'::text, 'HORTON'::text]);


CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT temp_node.node_id,
    temp_node.elev,
    temp_node.ymax,
    temp_node.y0,
    temp_node.ysur,
    temp_node.apond,
    concat(';', temp_node.sector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE temp_node.epa_type::text IN('JUNCTION', 'NETGULLY');
