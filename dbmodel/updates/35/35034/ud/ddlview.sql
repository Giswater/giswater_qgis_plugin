/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_plan_arc
AS SELECT d.arc_id,
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
                             where v_plan_aux_arc_pavement.arc_id is not null

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
				   where v_plan_aux_arc_ml.arc_id is not null

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
                     where arc_id is not null
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS gully_total_cost
                   FROM v_edit_gully c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                     where arc_id is not null
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d;
                  
                  
DROP VIEW IF EXISTS v_ui_arc_x_relations;

CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
WITH links_node as (select n.node_id, l.feature_id, l.exit_type AS proceed_from, l.exit_id AS proceed_from_id,
l.state as l_state,n.state as n_state
FROM v_node n
JOIN v_edit_link l ON n.node_id::text = l.exit_id::text)
SELECT row_number() OVER () + 1000000 AS rid,
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN v_edit_link l ON v_connec.connec_id::text = l.feature_id::text
  WHERE v_connec.arc_id IS NOT NULL AND l.exit_type<>'NODE'
UNION
  SELECT distinct on (feature_id)
  	row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    connec_type AS featurecat_id,
    connecat_id AS catalog,
    connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
     proceed_from,
     proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_arc a
   	JOIN links_node n on a.node_1=n.node_id
    JOIN v_connec c ON c.connec_id::text = n.feature_id::text
UNION
 SELECT row_number() OVER () + 3000000 AS rid,
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    v_gully.state AS feature_state,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     JOIN v_edit_link l ON v_gully.gully_id::text = l.feature_id::text
  WHERE v_gully.arc_id IS NOT NULL AND l.state = v_gully.state
	 AND l.exit_type<>'NODE'
UNION
  SELECT distinct on (feature_id)
  	row_number() OVER () + 4000000 AS rid,
    a.arc_id,
    gully_type AS featurecat_id,
    gratecat_id AS catalog,
    gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    proceed_from,
    proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_arc a
   	JOIN links_node n on a.node_1=n.node_id
    JOIN v_gully g ON g.gully_id::text = n.feature_id::text;
    
    
CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream
AS SELECT row_number() OVER (ORDER BY v_arc.node_2) + 1000000 AS rid,
    v_arc.node_2 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y1 AS depth,
    st_length2d(v_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_arc.y2 AS upstream_depth,
    v_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_arc
     JOIN node ON v_arc.node_1::text = node.node_id::text
     LEFT JOIN cat_arc ON v_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_arc.state = value_state.id
UNION
 SELECT DISTINCT ON (feature_id)
 	row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_connec.connec_id AS feature_id,
    v_connec.code::text AS feature_code,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS arccat_id,
    v_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_connec.connec_id AS upstream_id,
    v_connec.code AS upstream_code,
    v_connec.connec_type AS upstream_type,
    v_connec.y2 AS upstream_depth,
    v_connec.sys_type,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link ON link.feature_id::text = v_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON v_connec.pjoint_id::text = node.node_id::text AND v_connec.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_connec.connecat_id::text = cat_connec.id::text
     JOIN value_state ON v_connec.state = value_state.id
 UNION
 SELECT DISTINCT ON (v_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_connec.connec_id AS feature_id,
    v_connec.code::text AS feature_code,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS arccat_id,
    v_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_connec.connec_id AS upstream_id,
    v_connec.code AS upstream_code,
    v_connec.connec_type AS upstream_type,
    v_connec.y2 AS upstream_depth,
    v_connec.sys_type,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link ON link.feature_id::text = v_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text AND link.exit_type='CONNEC'
     join connec on connec.connec_id=link.exit_id AND connec.pjoint_type::text = 'NODE'::text
     JOIN node ON connec.pjoint_id::text = node.node_id::text
     LEFT JOIN cat_connec ON v_connec.connecat_id::text = cat_connec.id::text
     JOIN value_state ON v_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (v_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 4000000 AS rid,
    node.node_id,
    v_gully.gully_id AS feature_id,
    v_gully.code::text AS feature_code,
    v_gully.gully_type AS featurecat_id,
    v_gully.connec_arccat_id AS arccat_id,
    v_gully.ymax - v_gully.sandbox AS depth,
    v_gully.connec_length AS length,
    v_gully.gully_id AS upstream_id,
    v_gully.code AS upstream_code,
    v_gully.gully_type AS upstream_type,
    v_gully.connec_depth AS upstream_depth,
    v_gully.sys_type,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     JOIN link ON link.feature_id::text = v_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON v_gully.pjoint_id::text = node.node_id::text AND v_gully.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_gully.state = value_state.id
 UNION
 SELECT DISTINCT ON (v_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 5000000 AS rid,
    node.node_id,
    v_gully.gully_id AS feature_id,
    v_gully.code::text AS feature_code,
    v_gully.gully_type AS featurecat_id,
    v_gully.connec_arccat_id AS arccat_id,
    v_gully.ymax - v_gully.sandbox AS depth,
    v_gully.connec_length AS length,
    v_gully.gully_id AS upstream_id,
    v_gully.code AS upstream_code,
    v_gully.gully_type AS upstream_type,
    v_gully.connec_depth AS upstream_depth,
    v_gully.sys_type,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     JOIN link ON link.feature_id::text = v_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text AND link.exit_type='GULLY'
     join gully on gully.gully_id=link.exit_id AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id::text = node.node_id::text
     LEFT JOIN cat_connec ON v_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_gully.state = value_state.id;



