/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_node", "column":"inflow", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


CREATE OR REPLACE VIEW vu_arc
 AS
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END AS sys_elev1,
        CASE
            WHEN
            CASE
                WHEN arc.custom_y1 IS NULL THEN arc.y1
                ELSE arc.custom_y1
            END IS NULL THEN arc.node_sys_top_elev_1 - arc.sys_elev1
            ELSE
            CASE
                WHEN arc.custom_y1 IS NULL THEN arc.y1
                ELSE arc.custom_y1
            END
        END AS sys_y1,
    arc.node_sys_top_elev_1 -
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - cat_arc.geom1 AS r1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - arc.node_sys_elev_1 AS z1,
    arc.node_2,
    arc.nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END AS sys_elev2,
        CASE
            WHEN
            CASE
                WHEN arc.custom_y2 IS NULL THEN arc.y2
                ELSE arc.custom_y2
            END IS NULL THEN arc.node_sys_top_elev_2 - arc.sys_elev2
            ELSE
            CASE
                WHEN arc.custom_y2 IS NULL THEN arc.y2
                ELSE arc.custom_y2
            END
        END AS sys_y2,
    arc.node_sys_top_elev_2 -
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - cat_arc.geom1 AS r2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - arc.node_sys_elev_2 AS z2,
    arc.sys_slope AS slope,
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
    arc.expl_id2
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     JOIN dma m USING (dma_id)
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;


drop view vi_outlets;
CREATE OR REPLACE VIEW vi_outlets
AS SELECT arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    case when f.offsetval is null then '*' else f.offsetval::text end as offsetval,
    f.outlet_type,
        CASE
            WHEN f.curve_id IS NULL THEN f.cd1::text::character varying
            ELSE f.curve_id
        END AS other1,
    f.cd2::text AS other2,
    f.flap::character varying AS other3
   FROM temp_arc_flowregulator f
     JOIN temp_arc USING (arc_id)
  WHERE f.type::text = 'OUTLET'::text;