/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;


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
    l.is_operative,
    l.drainzone_id,
    r.name as drainzone_name,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN drainzone r USING (drainzone_id);

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

drop view if exists v_ui_arc_x_relations;
CREATE OR REPLACE VIEW v_ui_arc_x_relations as
  WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
             where l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,  
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    a.state as arc_state,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link l ON v_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id = v_connec.arc_id
  WHERE v_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 and a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state as arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_connec c ON c.connec_id::text = n.feature_id::text
UNION
 SELECT row_number() OVER () + 3000000 AS rid, 
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    a.state as arc_state,
    v_gully.state AS feature_state,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     JOIN link l ON v_gully.gully_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id = v_gully.arc_id
  WHERE v_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 and a.state =  1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid, 
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gratecat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state as arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_gully g ON g.gully_id::text = n.feature_id::text;

--27/10/2023
CREATE OR REPLACE VIEW v_edit_plan_psector_x_connec AS 
SELECT plan_psector_x_connec.id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user,
    exit_type
   FROM plan_psector_x_connec
   LEFT JOIN link USING (link_id);


CREATE OR REPLACE VIEW v_edit_plan_psector_x_gully AS 
SELECT plan_psector_x_gully.id,
    plan_psector_x_gully.gully_id,
    plan_psector_x_gully.arc_id,
    plan_psector_x_gully.psector_id,
    plan_psector_x_gully.state,
    plan_psector_x_gully.doable,
    plan_psector_x_gully.descript,
    plan_psector_x_gully.link_id,
    plan_psector_x_gully.active,
    plan_psector_x_gully.insert_tstamp,
    plan_psector_x_gully.insert_user,
    exit_type
   FROM plan_psector_x_gully
   LEFT JOIN link USING (link_id);


-- 30/10/2023
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
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link
           JOIN selector_expl USING (expl_id) WHERE cur_user =current_user AND vu_link.state = 2) 
           a ON a.feature_id::text = vu_connec.connec_id::text;


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
         CASE
            WHEN a.sector_id IS NULL THEN vu_gully.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_gully.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_gully.state,
    vu_gully.state_type,
    vu_gully.annotation,
    vu_gully.observ,
    vu_gully.comment,
	CASE
            WHEN a.dma_id IS NULL THEN vu_gully.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_gully.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
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
	CASE
            WHEN a.exit_id IS NULL THEN vu_gully.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_gully.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
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
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link
           JOIN selector_expl USING (expl_id) WHERE cur_user =current_user AND vu_link.state = 2) 
           a ON a.feature_id::text = vu_gully.gully_id::text;

CREATE OR REPLACE VIEW ve_pol_connec AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM v_connec
     JOIN polygon ON polygon.feature_id::text = v_connec.connec_id::text;

CREATE OR REPLACE VIEW ve_pol_gully AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    fluid_type,
    polygon.trace_featuregeom
   FROM v_gully
     JOIN polygon ON polygon.feature_id::text = v_gully.gully_id::text;

CREATE OR REPLACE VIEW ve_pol_node AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM v_node
     JOIN polygon ON polygon.feature_id::text = v_node.node_id::text;



