/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/02
CREATE OR REPLACE VIEW v_edit_inp_coverage AS 
SELECT subc_id,
landus_id,
percent,
c.hydrology_id
FROM selector_sector, config_param_user,inp_coverage c
JOIN inp_subcatchment s USING (subc_id)
WHERE s.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND c.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text AND
config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;


CREATE OR REPLACE VIEW vu_arc AS 
 WITH vu_node AS (
         SELECT node.node_id,
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
                    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_ymax IS NOT NULL THEN
                    CASE
                        WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev - node.custom_ymax
                        ELSE node.top_elev - node.custom_ymax
                    END
                    WHEN node.ymax IS NOT NULL THEN
                    CASE
                        WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev - node.ymax
                        ELSE node.top_elev - node.ymax
                    END
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.node_type,
            exploitation.macroexpl_id
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    a.node_type AS nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN a.sys_elev::numeric(12,3)
            ELSE arc.sys_elev1
        END AS sys_elev1,
    a.sys_top_elev - arc.sys_elev1 AS sys_y1,
    a.sys_top_elev - arc.sys_elev1 - cat_arc.geom1 AS r1,
        CASE
            WHEN a.sys_elev IS NOT NULL THEN arc.sys_elev1 - a.sys_elev
            ELSE (arc.sys_elev1 - (a.sys_top_elev - a.sys_ymax))::numeric(12,3)
        END AS z1,
    arc.node_2,
    b.node_type AS nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN b.sys_elev::numeric(12,3)
            ELSE arc.sys_elev2
        END AS sys_elev2,
    b.sys_top_elev - arc.sys_elev2 AS sys_y2,
    b.sys_top_elev - arc.sys_elev2 - cat_arc.geom1 AS r2,
        CASE
            WHEN b.sys_elev IS NOT NULL THEN arc.sys_elev2 - b.sys_elev
            ELSE (arc.sys_elev2 - (b.sys_top_elev - b.sys_ymax))::numeric(12,3)
        END AS z2,
        CASE
            WHEN arc.sys_slope IS NULL AND st_length(arc.the_geom) > 1::double precision THEN ((a.sys_elev - b.sys_elev)::double precision / st_length(arc.the_geom))::numeric(12,4)
            ELSE arc.sys_slope
        END AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
        CASE
            WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
            ELSE arc.matcat_id
        END AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    a.macroexpl_id,
    arc.sector_id,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    dma.macrodma_id,
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
    arc.pavcat_id
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
     JOIN sector ON sector.sector_id = arc.sector_id
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;