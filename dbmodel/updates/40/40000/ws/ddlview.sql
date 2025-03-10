/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_state_arc AS
WITH
p AS (SELECT arc_id, psector_id, state FROM plan_psector_x_arc WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
a as (SELECT arc_id, state FROM arc)
SELECT arc.arc_id FROM selector_state,arc WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
	UNION ALL
SELECT DISTINCT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 1;


CREATE OR REPLACE VIEW v_state_node AS
WITH
p AS (SELECT node_id, psector_id, state FROM plan_psector_x_node WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
n AS (SELECT node_id, state FROM node)
SELECT n.node_id FROM selector_state,n WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.node_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT p.node_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND p.state = 1 AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_link AS
WITH
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user),
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM cf, sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT p.link_id FROM cf, sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text
AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_connec AS
WITH
p AS (SELECT connec_id, psector_id, state, arc_id FROM plan_psector_x_connec WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
c as (SELECT connec_id, state, arc_id FROM connec)
SELECT c.connec_id, c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.connec_id, p.arc_id FROM cf, s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text
AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT ON (p.connec_id) p.connec_id, p.arc_id FROM cf, s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text
AND p.state = 1 AND cf.value is TRUE;


CREATE OR REPLACE VIEW vu_arc
AS WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying, 'presszone_type'::character varying, 'dma_type'::character varying, 'dqa_type'::character varying]::text[])
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.elevation1,
    arc.depth1,
    arc.staticpress1,
    arc.node_2,
    arc.nodetype_2,
    arc.staticpress2,
    arc.elevation2,
    arc.depth2,
    ((COALESCE(arc.depth1) + COALESCE(arc.depth2)) / 2::numeric)::numeric(12,2) AS depth,
    arc.arccat_id,
    cat_arc.arc_type,
    cat_feature.feature_class AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    cat_arc.dint AS cat_dint,
    cat_arc.dr AS cat_dr,
    arc.epa_type,
    arc.state,
    arc.state_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name as sector_name,
    sector.macrosector_id,
    et1.idval::varchar(16) as sector_type,
    arc.presszone_id,
    presszone.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    presszone.head AS presszone_head,
    arc.dma_id,
    dma.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    dma.macrodma_id,
    arc.dqa_id,
    dqa.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    dqa.macrodqa_id,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.workcat_id_plan,
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
    mu.region_id,
    mu.province_id,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.label_quadrant,
    arc.publish,
    arc.inventory,
    arc.num_value,
    arc.adate,
    arc.adescript,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    arc.asset_id,
    arc.pavcat_id,
    arc.om_state,
    arc.conserv_state,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
        CASE
            WHEN arc.brand_id IS NULL THEN cat_arc.brand_id
            ELSE arc.brand_id
        END AS brand_id,
        CASE
            WHEN arc.model_id IS NULL THEN cat_arc.model_id
            ELSE arc.model_id
        END AS model_id,
    arc.serial_number,
    arc.minsector_id,
    arc.macrominsector_id,
    e.flow_max,
    e.flow_min,
    e.flow_avg,
    e.vel_max,
    e.vel_min,
    e.vel_avg,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
        CASE
            WHEN vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    arc.is_scadamap
   FROM arc
     LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id = arc.presszone_id
     LEFT JOIN streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN arc_add e ON arc.arc_id::text = e.arc_id::text
     LEFT JOIN value_state_type vst ON vst.id = arc.state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 ON et1.id::text = sector.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = presszone.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = dma.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = dqa.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;

CREATE OR REPLACE VIEW v_edit_arc
AS WITH
  typevalue AS
    (
      SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
      FROM edit_typevalue
      WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text])
    ),
	sector_table AS
		(
      SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
      FROM sector
      LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table AS
		(
      SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
      FROM dma
      LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
		),
	presszone_table AS
		(
      SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
      FROM presszone
      LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
		),
	dqa_table AS
		(
      SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
      FROM dqa
      LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
		),
  supplyzone_table AS
    (
      SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
      FROM supplyzone
      LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
    ),
	arc_psector AS
		(
      SELECT pp.arc_id, pp.state AS p_state
      FROM plan_psector_x_arc pp
      JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
		),
  arc_selector AS
		(
      SELECT arc.arc_id
      FROM arc
      JOIN selector_state s ON s.cur_user = CURRENT_USER AND arc.state = s.state_id
      LEFT JOIN (SELECT arc_id FROM arc_psector WHERE p_state = 0) a USING (arc_id)  WHERE a.arc_id IS NULL
      UNION ALL
      SELECT arc_id FROM arc_psector
      WHERE p_state = 1
    ),
  arc_selected AS
    (
      SELECT arc.arc_id,
      arc.code,
      arc.datasource,
      arc.node_1,
      arc.nodetype_1,
      arc.elevation1,
      arc.depth1,
      arc.staticpress1,
      arc.node_2,
      arc.nodetype_2,
      arc.staticpress2,
      arc.elevation2,
      arc.depth2,
      ((COALESCE(arc.depth1) + COALESCE(arc.depth2)) / 2::numeric)::numeric(12,2) AS depth,
      arc.arccat_id,
      cat_arc.arc_type,
      cat_feature.feature_class AS sys_type,
      cat_arc.matcat_id AS cat_matcat_id,
      cat_arc.pnom AS cat_pnom,
      cat_arc.dnom AS cat_dnom,
      cat_arc.dint AS cat_dint,
      cat_arc.dr AS cat_dr,
      arc.epa_type,
      arc.state,
      arc.state_type,
      arc.expl_id,
      exploitation.macroexpl_id,
      arc.sector_id,
      sector_table.macrosector_id,
      sector_table.sector_type,
      arc.presszone_id,
      presszone_table.presszone_type,
      presszone_table.presszone_head,
      arc.dma_id,
      dma_table.dma_type,
      dma_table.macrodma_id,
      arc.dqa_id,
      dqa_table.dqa_type,
      dqa_table.macrodqa_id,
      arc.supplyzone_id,
      supplyzone_table.supplyzone_type,
      arc.annotation,
      arc.observ,
      arc.comment,
      st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
      arc.custom_length,
      arc.soilcat_id,
      arc.function_type,
      arc.category_type,
      arc.fluid_type,
      arc.location_type,
      arc.workcat_id,
      arc.workcat_id_end,
      arc.workcat_id_plan,
      arc.builtdate,
      arc.enddate,
      arc.ownercat_id,
      arc.muni_id,
      arc.postcode,
      arc.district_id,
      streetname,
      arc.postnumber,
      arc.postcomplement,
      streetname2,
      arc.postnumber2,
      arc.postcomplement2,
      mu.region_id,
      mu.province_id,
      arc.descript,
      concat(cat_feature.link_path, arc.link) AS link,
      arc.verified,
      arc.undelete,
      cat_arc.label,
      arc.label_x,
      arc.label_y,
      arc.label_rotation,
      arc.label_quadrant,
      arc.publish,
      arc.inventory,
      arc.num_value,
      arc.adate,
      arc.adescript,
      sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
      dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
      presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
      dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
      supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
      arc.asset_id,
      arc.pavcat_id,
      arc.om_state,
      arc.conserv_state,
      arc.parent_id,
      arc.expl_id2,
      vst.is_operative,
      CASE
        WHEN arc.brand_id IS NULL THEN cat_arc.brand_id
        ELSE arc.brand_id
      END AS brand_id,
      CASE
        WHEN arc.model_id IS NULL THEN cat_arc.model_id
        ELSE arc.model_id
      END AS model_id,
      arc.serial_number,
      arc.minsector_id,
      arc.macrominsector_id,
      e.flow_max,
      e.flow_min,
      e.flow_avg,
      e.vel_max,
      e.vel_min,
      e.vel_avg,
      date_trunc('second'::text, arc.tstamp) AS tstamp,
      arc.insert_user,
      date_trunc('second'::text, arc.lastupdate) AS lastupdate,
      arc.lastupdate_user,
      arc.the_geom,
      arc.lock_level,
      CASE
        WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
        ELSE NULL::character varying(16)
      END AS inp_type,
      arc.is_scadamap
      FROM arc_selector
      JOIN arc ON arc.arc_id::text = arc_selector.arc_id::text
      JOIN selector_expl se ON ((se.cur_user = CURRENT_USER AND se.expl_id = arc.expl_id) OR (se.cur_user = CURRENT_USER and se.expl_id = arc.expl_id2))
      JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = arc.sector_id)
      JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
      JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
      JOIN exploitation ON arc.expl_id = exploitation.expl_id
      JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
      JOIN sector_table ON sector_table.sector_id = arc.sector_id
      LEFT JOIN presszone_table ON presszone_table.presszone_id = arc.presszone_id
      LEFT JOIN dma_table ON dma_table.dma_id = arc.dma_id
      LEFT JOIN dqa_table ON dqa_table.dqa_id = arc.dqa_id
      LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = arc.supplyzone_id
      LEFT JOIN arc_add e ON e.arc_id::text = arc.arc_id::text
      LEFT JOIN value_state_type vst ON vst.id = arc.state_type
    )
  SELECT arc_selected.*
  FROM arc_selected;


CREATE OR REPLACE VIEW vu_node
AS WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying, 'presszone_type'::character varying, 'dma_type'::character varying, 'dqa_type'::character varying]::text[])
        )
 SELECT node.node_id,
    node.code,
    node.top_elev,
    node.custom_top_elev,
    CASE
      WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
      ELSE node.top_elev
    END AS sys_top_elev,
    node.depth,
    cat_node.node_type,
    cat_feature.feature_class AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    cat_node.dint AS cat_dint,
    node.epa_type,
    node.state,
    node.state_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    et1.idval::character varying(16) AS sector_type,
    node.presszone_id,
    presszone.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    presszone.head AS presszone_head,
    node.dma_id,
    dma.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    dma.macrodma_id,
    node.dqa_id,
    dqa.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    dqa.macrodqa_id,
    node.arc_id,
    node.parent_id,
    node.annotation,
    node.observ,
    node.comment,
    node.staticpressure,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.workcat_id_plan,
    node.builtdate,
    node.enddate,
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
    mu.region_id,
    mu.province_id,
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
    node.label_quadrant,
    node.publish,
    node.inventory,
    node.hemisphere,
    node.num_value,
    node.adate,
    node.adescript,
    node.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    node.asset_id,
    node.om_state,
    node.conserv_state,
    node.access_type,
    node.placement_type,
    node.expl_id2,
    vst.is_operative,
    CASE
      WHEN node.brand_id IS NULL THEN cat_node.brand_id
      ELSE node.brand_id
    END AS brand_id,
    CASE
      WHEN node.model_id IS NULL THEN cat_node.model_id
      ELSE node.model_id
    END AS model_id,
    node.serial_number,
    node.minsector_id,
    node.macrominsector_id,
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
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user,
    node.the_geom,
    CASE
      WHEN vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
      ELSE NULL::character varying(16)
    END AS inp_type,
    node.pavcat_id,
    node.is_scadamap
   FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id
     LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id = node.presszone_id
     LEFT JOIN streetaxis a ON a.id::text = node.streetaxis_id::text
     LEFT JOIN streetaxis b ON b.id::text = node.streetaxis2_id::text
     LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
     LEFT JOIN value_state_type vst ON vst.id = node.state_type
     LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 ON et1.id::text = sector.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = presszone.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = dma.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = dqa.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;


CREATE OR REPLACE VIEW v_edit_node
AS WITH
    typevalue AS
      (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text])
      ),
    sector_table AS
      (
        SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
        FROM sector
        LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
      ),
    dma_table AS
      (
        SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
        FROM dma
        LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
      ),
    presszone_table AS
      (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
      ),
    dqa_table AS
      (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
      ),
    supplyzone_table AS
      (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    node_psector AS
      (
        SELECT pp.node_id, pp.state AS p_state
        FROM plan_psector_x_node pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
      ),
    node_selector AS
      (
        SELECT node_id
        FROM node
        JOIN selector_state s ON s.cur_user =current_user AND node.state =s.state_id
        LEFT JOIN (SELECT node_id FROM node_psector WHERE p_state = 0) a using (node_id) where a.node_id IS NULL
        UNION ALL
        SELECT node_id FROM node_psector
        WHERE p_state = 1
      ),
    node_selected AS
      (
        SELECT node.node_id,
        node.code,
        node.top_elev,
        node.custom_top_elev,
        CASE
            WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
            ELSE node.top_elev
        END AS sys_top_elev,
        node.datasource,
        node.depth,
        cat_node.node_type,
        cat_feature.feature_class AS sys_type,
        node.nodecat_id,
        cat_node.matcat_id AS cat_matcat_id,
        cat_node.pnom AS cat_pnom,
        cat_node.dnom AS cat_dnom,
        cat_node.dint AS cat_dint,
        node.epa_type,
        node.state,
        node.state_type,
        node.expl_id,
        exploitation.macroexpl_id,
        node.sector_id,
        sector_table.macrosector_id,
        sector_table.sector_type,
        node.presszone_id,
        presszone_table.presszone_type,
        presszone_table.presszone_head,
        node.dma_id,
        dma_table.dma_type,
        dma_table.macrodma_id,
        node.dqa_id,
        dqa_table.dqa_type,
        dqa_table.macrodqa_id,
        node.supplyzone_id,
        supplyzone_table.supplyzone_type,
        node.arc_id,
        node.parent_id,
        node.annotation,
        node.observ,
        node.comment,
        node.staticpressure,
        node.soilcat_id,
        node.function_type,
        node.category_type,
        node.fluid_type,
        node.location_type,
        node.workcat_id,
        node.workcat_id_end,
        node.workcat_id_plan,
        node.builtdate,
        node.enddate,
        node.ownercat_id,
        node.muni_id,
        node.postcode,
        node.district_id,
        streetname,
        node.postnumber,
        node.postcomplement,
        streetname2,
        node.postnumber2,
        node.postcomplement2,
        mu.region_id,
        mu.province_id,
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
        node.label_quadrant,
        node.publish,
        node.inventory,
        node.hemisphere,
        node.num_value,
        node.adate,
        node.adescript,
        node.accessibility,
        sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
        dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
        presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
        dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
        supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
        node.asset_id,
        node.om_state,
        node.conserv_state,
        node.access_type,
        node.placement_type,
        node.expl_id2,
        vst.is_operative,
        CASE
          WHEN node.brand_id IS NULL THEN cat_node.brand_id
          ELSE node.brand_id
        END AS brand_id,
        CASE
          WHEN node.model_id IS NULL THEN cat_node.model_id
          ELSE node.model_id
        END AS model_id,
        node.serial_number,
        node.minsector_id,
        node.macrominsector_id,
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
        date_trunc('second'::text, node.tstamp) AS tstamp,
        node.insert_user,
        date_trunc('second'::text, node.lastupdate) AS lastupdate,
        node.lastupdate_user,
        node.the_geom,
        CASE
          WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
          ELSE NULL::character varying(16)
        END AS inp_type,
        m.closed as closed_valve,
        m.broken as broken_valve,
        node.pavcat_id,
        node.lock_level,
        node.is_scadamap,
        (SELECT ST_X(node.the_geom)) AS xcoord,
        (SELECT ST_Y(node.the_geom)) AS ycoord,
        (SELECT ST_Y(ST_Transform(node.the_geom, 4326))) AS lat,
        (SELECT ST_X(ST_Transform(node.the_geom, 4326))) AS long
        FROM node_selector
        JOIN node ON node.node_id = node_selector.node_id
        JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = node.expl_id) or (se.cur_user = current_user AND se.expl_id = node.expl_id2)
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = node.sector_id)
        JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
        JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
        JOIN value_state_type vst ON vst.id = node.state_type
        JOIN exploitation ON node.expl_id = exploitation.expl_id
        JOIN ext_municipality mu ON node.muni_id = mu.muni_id
        JOIN sector_table ON sector_table.sector_id = node.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = node.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = node.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = node.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = node.supplyzone_id
        LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
        LEFT JOIN man_valve m ON m.node_id = node.node_id
      )
    SELECT n.*
    FROM node_selected n;



CREATE OR REPLACE VIEW vu_link AS
 WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying, 'presszone_type'::character varying, 'dma_type'::character varying, 'dqa_type'::character varying]::text[])
        ),inp_netw_mode AS (
         WITH inp_netw_mode_aux AS (
                 SELECT count(*) AS t
                   FROM config_param_user
                  WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
                )
         SELECT
                CASE
                    WHEN inp_netw_mode_aux.t > 0 THEN ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER)
                    ELSE NULL::text
                END AS value
           FROM inp_netw_mode_aux
        )
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    s.name AS sector_name,
    et1.idval::character varying(16) AS sector_type,
    s.macrosector_id,
    presszone_id,
    p.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    p.head AS presszone_head,
    l.dma_id,
    d.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    d.macrodma_id,
    l.dqa_id,
    q.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    q.macrodqa_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    l.muni_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure,
    l.conneccat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain,
    l.verified,
    l.minsector_id,
    l.macrominsector_id,
    CASE
            WHEN s.sector_id > 0 AND is_operative = true AND epa_type = 'JUNCTION'::character varying(16)::text AND cpu.value = '4' THEN epa_type::character varying
            ELSE NULL::character varying(16)
        END AS inp_type,
    l.n_hydrometer
     FROM ( SELECT inp_netw_mode.value FROM inp_netw_mode) cpu, link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id)
     LEFT JOIN typevalue et1 ON et1.id::text = s.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = p.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = d.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = q.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;


CREATE OR REPLACE VIEW v_edit_link
AS WITH
    typevalue AS
      (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text])
      ),
    sector_table AS
      (
        SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
        FROM sector
        LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
      ),
    dma_table AS
      (
        SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
        FROM dma
        LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
      ),
    presszone_table AS
      (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
      ),
    dqa_table AS
      (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
      ),
    supplyzone_table AS
      (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    inp_network_mode AS
      (
        SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
      ),
    link_psector AS
      (
        SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
      ),
    link_selector AS
      (
        SELECT l.link_id
        FROM link l
        JOIN selector_state s ON s.cur_user =current_user AND l.state =s.state_id
        LEFT JOIN (SELECT link_id FROM link_psector WHERE p_state = 0) a USING (link_id) WHERE a.link_id IS NULL
        UNION ALL
        SELECT link_id FROM link_psector
        WHERE p_state = 1
      ),
    link_selected AS
      (
        SELECT l.link_id,
        l.feature_type,
        l.feature_id,
        l.exit_type,
        l.exit_id,
        l.state,
        l.expl_id,
        l.sector_id,
        sector_table.sector_type,
        sector_table.macrosector_id,
        l.presszone_id,
        presszone_table.presszone_type,
        presszone_table.presszone_head,
        l.dma_id,
        dma_table.dma_type,
        dma_table.macrodma_id,
        l.dqa_id,
        dqa_table.dqa_type,
        dqa_table.macrodqa_id,
        l.supplyzone_id,
        supplyzone_table.supplyzone_type,
        l.exit_topelev,
        l.exit_elev,
        l.fluid_type,
        st_length(l.the_geom)::numeric(12,3) AS gis_length,
        l.the_geom,
        l.muni_id,
        l.expl_id2,
        l.epa_type,
        l.is_operative,
        l.staticpressure,
        l.conneccat_id,
        l.workcat_id,
        l.workcat_id_end,
        l.builtdate,
        l.enddate,
        l.lastupdate,
        l.lastupdate_user,
        l.uncertain,
        l.minsector_id,
        l.macrominsector_id,
        CASE
          WHEN l.sector_id > 0 AND l.is_operative = true AND l.epa_type = 'JUNCTION'::character varying(16)::text AND inp_network_mode.value = '4'::text
          THEN l.epa_type::character varying
          ELSE NULL::character varying(16)
        END AS inp_type,
        l.verified,
        l.n_hydrometer
        FROM inp_network_mode, link_selector
        JOIN link l using (link_id)
        JOIN selector_expl se ON ((se.cur_user =current_user AND se.expl_id = l.expl_id) or (se.cur_user =current_user AND se.expl_id = l.expl_id2))
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = l.sector_id)
        JOIN sector_table ON sector_table.sector_id = l.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
      )
    SELECT l.*
    FROM link_selected l;


CREATE OR REPLACE VIEW vu_connec AS
 WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying, 'presszone_type'::character varying, 'dma_type'::character varying, 'dqa_type'::character varying]::text[])
        ), inp_netw_mode AS (
         WITH inp_netw_mode_aux AS (
                 SELECT count(*) AS t
                   FROM config_param_user
                  WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
                )
         SELECT
                CASE
                    WHEN inp_netw_mode_aux.t > 0 THEN ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER)
                    ELSE NULL::text
                END AS value
           FROM inp_netw_mode_aux
        )
 SELECT connec.connec_id,
    connec.code,
    connec.top_elev,
    connec.depth,
    cat_connec.connec_type,
    cat_feature.feature_class AS sys_type,
    connec.conneccat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    cat_connec.dint AS cat_dint,
    connec.epa_type,
    connec.state,
    connec.state_type,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    et1.idval::character varying(16) AS sector_type,
    connec.presszone_id,
    presszone.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    presszone.head AS presszone_head,
    connec.dma_id,
    dma.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    dma.macrodma_id,
    connec.dqa_id,
    dqa.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    dqa.macrodqa_id,
    connec.crmzone_id,
    crm_zone.name AS crmzone_name,
    connec.customer_code,
    connec.connec_length,
    connec.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.staticpressure,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.workcat_id_plan,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    b.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    mu.region_id,
    mu.province_id,
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
    connec.label_quadrant,
    connec.publish,
    connec.inventory,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    connec.asset_id,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.expl_id2,
    vst.is_operative,
    connec.plot_code,
    CASE
      WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
      ELSE connec.brand_id
    END AS brand_id,
    CASE
      WHEN connec.model_id IS NULL THEN cat_connec.model_id
      ELSE connec.model_id
    END AS model_id,
    connec.serial_number,
    connec.cat_valve,
    connec.minsector_id,
    connec.macrominsector_id,
    e.demand_base,
    e.demand_max,
    e.demand_min,
    e.demand_avg,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    e.flow_max,
    e.flow_min,
    e.flow_avg,
    e.vel_max,
    e.vel_min,
    e.vel_avg,
    e.result_id,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    CASE
      WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::character varying(16)::text AND cpu.value = '4' THEN connec.epa_type::character varying
      ELSE NULL::character varying(16)
    END AS inp_type,
    connec.block_zone
   FROM  (SELECT inp_netw_mode.value FROM inp_netw_mode) cpu, connec
     JOIN cat_connec ON connec.conneccat_id::text = cat_connec.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id = connec.presszone_id
     LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
     LEFT JOIN streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN streetaxis b ON b.id::text = connec.streetaxis2_id::text
     LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 ON et1.id::text = sector.sector_type AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = presszone.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = dma.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = dqa.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;


CREATE OR REPLACE VIEW v_edit_connec
AS WITH
    typevalue AS
      (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text])
      ),
    sector_table AS
      (
        SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
        FROM sector
        LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
      ),
    dma_table AS
      (
        SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
        FROM dma
        LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
      ),
    presszone_table AS
      (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
      ),
    dqa_table AS
      (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
      ),
    supplyzone_table AS
      (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    inp_network_mode AS
      (
        SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
      ),
    link_planned as
      (
        SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id,
        l.dma_id, dma_type, macrodma_id, l.presszone_id, presszone_type, presszone_head, l.dqa_id, dqa_type, dqa_table.macrodqa_id,
        l.supplyzone_id, supplyzone_type, fluid_type,
        minsector_id, staticpressure, null::integer AS macrominsector_id
        FROM link l
        JOIN exploitation USING (expl_id)
        JOIN sector_table ON sector_table.sector_id = l.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
        WHERE l.state = 2
      ),
    connec_psector AS
      (
        SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id, pp.state AS p_state, pp.psector_id, pp.arc_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id desc nulls last
      ),
    connec_selector AS
      (
        SELECT connec_id, arc_id::varchar(16), null::integer as link_id
        FROM connec
        JOIN selector_state ss ON ss.cur_user =current_user AND connec.state = ss.state_id
        LEFT JOIN (SELECT connec_id, arc_id FROM connec_psector WHERE p_state = 0) a USING (connec_id, arc_id) WHERE a.connec_id IS NULL
        UNION ALL
        SELECT connec_id, connec_psector.arc_id::varchar(16), link_id FROM connec_psector
        WHERE p_state = 1
      ),
    connec_selected AS
      (
        select connec.connec_id,
        connec.code,
        connec.top_elev,
        connec.datasource,
        connec.depth,
        cat_connec.connec_type,
        cat_feature.feature_class AS sys_type,
        connec.conneccat_id,
        cat_connec.matcat_id AS cat_matcat_id,
        cat_connec.pnom AS cat_pnom,
        cat_connec.dnom AS cat_dnom,
        cat_connec.dint AS cat_dint,
        connec.epa_type,
        CASE
          WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::character varying(16)::text AND inp_network_mode.value = '4'::text THEN connec.epa_type::character varying
          ELSE NULL::character varying(16)
        END AS inp_type,
        connec.state,
        connec.state_type,
        connec.expl_id,
        exploitation.macroexpl_id,
        CASE
          WHEN link_planned.sector_id IS NULL THEN connec.sector_id
          ELSE link_planned.sector_id
        END AS sector_id,
        CASE
          WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
          ELSE link_planned.macrosector_id
        END AS macrosector_id,
        CASE
          WHEN link_planned.sector_type IS NULL THEN sector_table.sector_type
          ELSE link_planned.sector_type
        END AS sector_type,
        CASE
          WHEN link_planned.presszone_id IS NULL THEN presszone_table.presszone_id
          ELSE link_planned.presszone_id
        END AS presszone_id,
        CASE
          WHEN link_planned.presszone_type IS NULL THEN presszone_table.presszone_type
          ELSE link_planned.presszone_type
        END AS presszone_type,
        CASE
          WHEN link_planned.presszone_head IS NULL THEN presszone_table.presszone_head
          ELSE link_planned.presszone_head
        END AS presszone_head,
        CASE
          WHEN link_planned.dma_id IS NULL THEN dma_table.dma_id
          ELSE link_planned.dma_id
        END AS dma_id,
        CASE
          WHEN link_planned.dma_type IS NULL then dma_table.dma_type
          ELSE link_planned.dma_type::varchar
        END AS dma_type,
        CASE
          WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
          ELSE link_planned.macrodma_id
        END AS macrodma_id,
        CASE
          WHEN link_planned.dqa_id IS NULL THEN dqa_table.dqa_id
          ELSE link_planned.dqa_id
        END AS dqa_id,
        CASE
          WHEN link_planned.dqa_type IS NULL THEN dqa_table.dqa_type
          ELSE link_planned.dqa_type
        END AS dqa_type,
        CASE
          WHEN link_planned.macrodqa_id IS NULL THEN dqa_table.macrodqa_id
          ELSE link_planned.macrodqa_id
        END AS macrodqa_id,
        CASE
          WHEN link_planned.supplyzone_id IS NULL THEN supplyzone_table.supplyzone_id
          ELSE link_planned.supplyzone_id
        END AS supplyzone_id,
        connec.crmzone_id,
        crm_zone.name AS crmzone_name,
        connec.customer_code,
        connec.connec_length,
        connec.n_hydrometer,
        connec_selector.arc_id,
        connec.annotation,
        connec.observ,
        connec.comment,
        CASE
          WHEN link_planned.staticpressure IS NULL THEN connec.staticpressure
          ELSE link_planned.staticpressure
        END AS staticpressure,
        connec.soilcat_id,
        connec.function_type,
        connec.category_type,
        CASE
          WHEN link_planned.fluid_type IS NULL THEN connec.fluid_type
          ELSE link_planned.fluid_type::character varying(50)
        END AS fluid_type,
        connec.location_type,
        connec.workcat_id,
        connec.workcat_id_end,
        connec.workcat_id_plan,
        connec.builtdate,
        connec.enddate,
        connec.ownercat_id,
        connec.muni_id,
        connec.postcode,
        connec.district_id,
        streetname,
        connec.postnumber,
        connec.postcomplement,
        streetname2,
        connec.postnumber2,
        connec.postcomplement2,
        mu.region_id,
        mu.province_id,
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
        connec.label_quadrant,
        connec.publish,
        connec.inventory,
        connec.num_value,
        CASE
          WHEN link_planned.link_id IS NULL THEN connec.pjoint_id
          ELSE link_planned.exit_id
        END AS pjoint_id,
        CASE
          WHEN link_planned.link_id IS NULL THEN connec.pjoint_type
          ELSE link_planned.exit_type
        END AS pjoint_type,
        connec.adate,
        connec.adescript,
        connec.accessibility,
        connec.asset_id,
        sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
        dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
        presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
        dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
        supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
        connec.priority,
        connec.valve_location,
        connec.valve_type,
        connec.shutoff_valve,
        connec.access_type,
        connec.placement_type,
        connec.om_state,
        connec.conserv_state,
        connec.expl_id2,
        vst.is_operative,
        connec.plot_code,
        CASE
          WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
          ELSE connec.brand_id
        END AS brand_id,
        CASE
          WHEN connec.model_id IS NULL THEN cat_connec.model_id
          ELSE connec.model_id
        END AS model_id,
        connec.serial_number,
        connec.cat_valve,
        CASE
          WHEN link_planned.minsector_id IS NULL THEN connec.minsector_id
          ELSE link_planned.minsector_id
        END AS minsector_id,
        CASE
          WHEN link_planned.macrominsector_id IS NULL THEN connec.macrominsector_id
          ELSE link_planned.macrominsector_id
        END AS macrominsector_id,
        e.demand_base,
        e.demand_max,
        e.demand_min,
        e.demand_avg,
        e.press_max,
        e.press_min,
        e.press_avg,
        e.quality_max,
        e.quality_min,
        e.quality_avg,
        date_trunc('second'::text, connec.tstamp) AS tstamp,
        connec.insert_user,
        date_trunc('second'::text, connec.lastupdate) AS lastupdate,
        connec.lastupdate_user,
        connec.the_geom,
        connec.n_inhabitants,
        connec.lock_level,
        connec.block_zone,
        (SELECT ST_X(connec.the_geom)) AS xcoord,
        (SELECT ST_Y(connec.the_geom)) AS ycoord,
        (SELECT ST_Y(ST_Transform(connec.the_geom, 4326))) AS lat,
        (SELECT ST_X(ST_Transform(connec.the_geom, 4326))) AS long
        FROM inp_network_mode, connec_selector
        JOIN connec ON connec.connec_id = connec_selector.connec_id
        JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = connec.expl_id) or (se.cur_user =current_user and se.expl_id = connec.expl_id2)
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = connec.sector_id)
        JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
        JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
        JOIN exploitation ON connec.expl_id = exploitation.expl_id
        JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
        JOIN sector_table ON sector_table.sector_id = connec.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = connec.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = connec.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = connec.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = connec.supplyzone_id
        LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
        LEFT JOIN link_planned using (link_id)
        LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
        LEFT JOIN value_state_type vst ON vst.id = connec.state_type
      )
    SELECT c.*
    FROM connec_selected c;

CREATE OR REPLACE VIEW v_edit_presszone
AS SELECT p.presszone_id,
    p.name,
    p.presszone_type,
    p.descript,
    p.graphconfig,
    p.stylesheet,
    p.head,
    p.tstamp,
    p.insert_user,
    p.lastupdate,
    p.lastupdate_user,
    p.avg_press,
    p.link,
    p.the_geom,
    p.muni_id,
    p.expl_id,
    p.sector_id,
    p.lock_level
   FROM presszone p,
    selector_expl
  WHERE selector_expl.expl_id = ANY(p.expl_id) AND selector_expl.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.presszone_id;


CREATE OR REPLACE VIEW v_edit_dma
AS SELECT d.dma_id,
    d.name,
    d.dma_type,
    d.macrodma_id,
    d.descript,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.minc,
    d.maxc,
    d.effc,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.avg_press,
    d.link,
    d.the_geom,
    d.muni_id,
    d.expl_id,
    d.sector_id,
    d.lock_level
   FROM dma d,
    selector_expl
  WHERE selector_expl.expl_id = ANY(d.expl_id) AND selector_expl.cur_user = "current_user"()::text OR d.expl_id IS NULL
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW v_edit_supplyzone
 AS
 SELECT s.supplyzone_id,
    s.name,
    s.supplyzone_type,
    ms.name AS macrosector,
    s.descript,
    s.graphconfig::text AS graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
	  s.avg_press,
	  s.link,
	  s.the_geom,
    s.muni_id,
    s.expl_id,
    et.idval,
    s.lock_level
   FROM selector_supplyzone,
    supplyzone s
    LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
    LEFT JOIN edit_typevalue et ON et.id::text = s.supplyzone_type::text AND et.typevalue::text = 'supplyzone_type'::text
  WHERE s.supplyzone_id = selector_supplyzone.supplyzone_id AND selector_supplyzone.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_dqa
AS SELECT d.dqa_id,
    d.name,
    d.dqa_type,
    d.macrodqa_id,
    d.descript,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.avg_press,
    d.link,
    d.the_geom,
    d.muni_id,
    d.expl_id,
    d.sector_id,
    d.lock_level
   FROM dqa d,
    selector_expl
  WHERE selector_expl.expl_id = ANY(d.expl_id) AND selector_expl.cur_user = "current_user"()::text OR d.expl_id IS NULL
  ORDER BY d.dqa_id;


CREATE OR REPLACE VIEW v_edit_element AS
SELECT e.* FROM ( SELECT element.element_id,
    element.code,
    element.datasource,
    element.elementcat_id,
    cat_element.element_type,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2,
    element.trace_featuregeom,
    element.muni_id,
    element.sector_id,
    element.lock_level
   FROM selector_expl, element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.element_type::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  LEFT JOIN selector_sector s USING (sector_id)
  LEFT JOIN selector_municipality m USING (muni_id)
  WHERE (s.cur_user = current_user OR s.sector_id IS NULL)
  AND (m.cur_user = current_user OR e.muni_id IS NULL);

CREATE OR REPLACE VIEW v_edit_minsector
AS SELECT m.minsector_id,
    m.code,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.descript,
    m.addparam::text AS addparam,
    m.the_geom
   FROM selector_expl,
    minsector m
  WHERE m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_samplepoint
AS SELECT sm.sample_id,
    sm.code,
    sm.lab_code,
    sm.feature_id,
    sm.featurecat_id,
    sm.dma_id,
    sm.macrodma_id,
    sm.presszone_id,
    sm.state,
    sm.builtdate,
    sm.enddate,
    sm.workcat_id,
    sm.workcat_id_end,
    sm.rotation,
    sm.muni_id,
    sm.streetaxis_id,
    sm.postnumber,
    sm.postcode,
    sm.district_id,
    sm.streetaxis2_id,
    sm.postnumber2,
    sm.postcomplement,
    sm.postcomplement2,
    sm.place_name,
    sm.cabinet,
    sm.observations,
    sm.verified,
    sm.the_geom,
    sm.expl_id,
    sm.link,
    sm.sector_id
   FROM ( SELECT samplepoint.sample_id,
            samplepoint.code,
            samplepoint.lab_code,
            samplepoint.feature_id,
            samplepoint.featurecat_id,
            samplepoint.dma_id,
            dma.macrodma_id,
            samplepoint.presszone_id,
            samplepoint.state,
            samplepoint.builtdate,
            samplepoint.enddate,
            samplepoint.workcat_id,
            samplepoint.workcat_id_end,
            samplepoint.rotation,
            samplepoint.muni_id,
            samplepoint.streetaxis_id,
            samplepoint.postnumber,
            samplepoint.postcode,
            samplepoint.district_id,
            samplepoint.streetaxis2_id,
            samplepoint.postnumber2,
            samplepoint.postcomplement,
            samplepoint.postcomplement2,
            samplepoint.place_name,
            samplepoint.cabinet,
            samplepoint.observations,
            samplepoint.verified,
            samplepoint.the_geom,
            samplepoint.expl_id,
            samplepoint.link,
            samplepoint.sector_id
           FROM selector_expl,
            samplepoint
             JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
             LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
          WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) sm
     JOIN selector_sector s USING (sector_id)
     LEFT JOIN selector_municipality m USING (muni_id)
  WHERE s.cur_user = CURRENT_USER AND (m.cur_user = CURRENT_USER OR sm.muni_id IS NULL);

-- dependent views
CREATE OR REPLACE VIEW v_plan_netscenario_arc
AS SELECT n.netscenario_id,
    n.arc_id,
    n.presszone_id,
    n.dma_id,
    n.the_geom,
    a.arccat_id,
    a.epa_type,
    a.state,
    a.state_type
   FROM config_param_user,
    plan_netscenario_arc n
   LEFT JOIN arc a USING (arc_id)
  WHERE config_param_user.cur_user::text = "current_user"()::text
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_plan_netscenario_node
AS SELECT n.netscenario_id,
    n.node_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    nd.nodecat_id,
    cn.node_type,
    nd.epa_type,
    nd.state,
    nd.state_type
   FROM config_param_user,
   plan_netscenario_node n
     LEFT JOIN node nd USING (node_id)
     LEFT JOIN cat_node cn ON nd.nodecat_id::text = cn.id::text
  WHERE config_param_user.cur_user::text = "current_user"()::text
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_plan_netscenario_connec
AS SELECT n.netscenario_id,
    n.connec_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    c.conneccat_id,
    cc.connec_type,
    c.epa_type,
    c.state,
    c.state_type
   FROM config_param_user,
   plan_netscenario_connec n
     LEFT JOIN connec c USING (connec_id)
     LEFT JOIN cat_connec cc ON cc.id::text = c.conneccat_id::text
  WHERE config_param_user.cur_user::text = "current_user"()::text
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_plan_aux_arc_pavement
AS SELECT plan_arc_x_pavement.arc_id,
    sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2) AS thickness,
    sum(v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id)
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT v_edit_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_edit_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM v_edit_arc
     JOIN cat_pavement c ON c.id::text = v_edit_arc.pavcat_id::text
     JOIN v_price_x_catpavement USING (pavcat_id)
     LEFT JOIN v_price_compost p ON c.m2_cost::text = p.id::text
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id)
  WHERE a.arc_id IS NULL;

CREATE OR REPLACE VIEW v_plan_arc
AS SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.sector_id,
    d.expl_id,
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
    d.total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_edit_arc.arc_id,
                            v_edit_arc.depth1,
                            v_edit_arc.depth2,
                                CASE
                                    WHEN (v_edit_arc.depth1 * v_edit_arc.depth2) = 0::numeric OR (v_edit_arc.depth1 * v_edit_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_edit_arc.depth1 + v_edit_arc.depth2) / 2::numeric)::numeric(12,2)
                                END AS mean_depth,
                            v_edit_arc.arccat_id,
                            COALESCE(v_price_x_catarc.dint / 1000::numeric, 0::numeric)::numeric(12,4) AS dint,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.bulk / 1000::numeric, 0::numeric)::numeric(12,4) AS bulk,
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
                            v_edit_arc.state,
                            v_edit_arc.expl_id,
                            v_edit_arc.the_geom
                           FROM v_edit_arc
                             LEFT JOIN v_price_x_catarc ON v_edit_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON v_edit_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_edit_arc.arc_id::text
                          WHERE v_plan_aux_arc_pavement.arc_id IS NOT NULL
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.depth1,
                    v_plan_aux_arc_ml.depth2,
                    v_plan_aux_arc_ml.mean_depth,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.dint,
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
                    (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_depth,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            v_plan_aux_arc_cost.arccat_id AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            arc.sector_id,
            v_plan_aux_arc_cost.expl_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.depth1 AS y1,
            v_plan_aux_arc_cost.depth2 AS y2,
            v_plan_aux_arc_cost.mean_depth AS mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.dint AS geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_depth - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.dint)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.dint + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_depth AS calculed_y,
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
            v_plan_aux_arc_connec.connec_total_cost AS other_budget,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                END::numeric(14,2) AS total_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON arc.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (p.price * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d
  WHERE d.arc_id IS NOT NULL;


CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
   FROM v_ext_municipality a, ext_raster_dem r
   JOIN ext_cat_raster c ON c.id = r.rastercat_id
   WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);

CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM v_edit_element e
    JOIN polygon USING (pol_id);

CREATE OR REPLACE VIEW v_ui_presszone
AS SELECT p.presszone_id,
    p.name,
    p.presszone_type,
    p.descript,
    p.active,
    p.graphconfig,
    p.stylesheet,
    p.head,
    p.tstamp,
    p.insert_user,
    p.lastupdate,
    p.lastupdate_user,
    p.avg_press,
    p.link,
    p.muni_id,
    p.expl_id,
    p.sector_id
   FROM selector_expl s,
    presszone p
  WHERE p.presszone_id <> ALL (ARRAY[0, -1]::integer[])
  ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW vu_element_x_arc
AS SELECT
    element_x_arc.arc_id,
    element_x_arc.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_arc
     JOIN element ON element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;


CREATE OR REPLACE VIEW vu_element_x_connec
AS SELECT
    element_x_connec.connec_id,
    element_x_connec.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_connec
     JOIN element ON element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW vu_element_x_node
AS SELECT
    element_x_node.node_id,
    element_x_node.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_node
     JOIN element ON element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_node
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;


CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_connec
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;


CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_arc
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    v_edit_connec.arc_id,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.conneccat_id AS catalog,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code AS feature_code,
    v_edit_connec.sys_type,
    a.state AS arc_state,
    v_edit_connec.state AS feature_state,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link l ON v_edit_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_connec.arc_id::text
  WHERE v_edit_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.conneccat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_connec c ON c.connec_id::text = n.feature_id::text;

CREATE OR REPLACE VIEW v_ui_arc_x_node
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    st_x(a.the_geom) AS x1,
    st_y(a.the_geom) AS y1,
    v_edit_arc.node_2,
    st_x(b.the_geom) AS x2,
    st_y(b.the_geom) AS y2
   FROM v_edit_arc
     LEFT JOIN node a ON a.node_id::text = v_edit_arc.node_1::text
     LEFT JOIN node b ON b.node_id::text = v_edit_arc.node_2::text;

CREATE OR REPLACE VIEW v_ui_node_x_relations AS
SELECT row_number() OVER (ORDER BY v_edit_node.node_id) AS rid,
    v_edit_node.parent_id AS node_id,
    v_edit_node.node_type,
    v_edit_node.nodecat_id,
    v_edit_node.node_id AS child_id,
    v_edit_node.code,
    v_edit_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_edit_node
  WHERE v_edit_node.parent_id IS NOT NULL;


CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM v_edit_connec c
    JOIN polygon ON polygon.feature_id::text = c.connec_id::text;

CREATE OR REPLACE VIEW v_rtc_period_hydrometer
AS SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_arc ON v_edit_connec.arc_id::text = temp_arc.arc_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON concat('VN', v_edit_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON v_edit_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text));


CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


CREATE OR REPLACE VIEW ve_pol_node as
SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM polygon
   JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text;

CREATE OR REPLACE VIEW v_plan_node
AS SELECT a.node_id,
    a.nodecat_id,
    a.node_type,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_edit_node.node_id,
            v_edit_node.nodecat_id,
            v_edit_node.sys_type AS node_type,
            v_edit_node.top_elev,
            v_edit_node.custom_top_elev,
            v_edit_node.top_elev - v_edit_node.depth AS elev,
            v_edit_node.epa_type,
            v_edit_node.state,
            v_edit_node.sector_id,
            v_edit_node.expl_id,
            v_edit_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END * v_price_x_catnode.cost
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            v_edit_node.the_geom
           FROM v_edit_node
             LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_tank ON man_tank.node_id::text = v_edit_node.node_id::text
             LEFT JOIN man_pump ON man_pump.node_id::text = v_edit_node.node_id::text
             LEFT JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
             LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text) a;

CREATE OR REPLACE VIEW v_ui_plan_node_cost
AS SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    NULL::double precision AS length
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;

CREATE OR REPLACE VIEW v_plan_result_node
AS SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE plan_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND plan_rec_result_node.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE v_plan_node.state = 2;


CREATE OR REPLACE VIEW v_edit_inp_junction
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    inp_junction.peak_factor,
    inp_junction.emitter_coeff,
    inp_junction.init_quality,
    inp_junction.source_type,
    inp_junction.source_quality,
    inp_junction.source_pattern_id,
    n.the_geom
   FROM v_edit_node n
   JOIN inp_junction USING (node_id)
   WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction
AS SELECT p.dscenario_id,
    p.node_id,
    p.demand,
    p.pattern_id,
    p.emitter_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_junction p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
    WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    man_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    n.the_geom
	FROM v_edit_node n
	JOIN inp_pump USING (node_id)
	JOIN man_pump USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pipe AS
 SELECT a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.expl_id,
    a.sector_id,
    a.dma_id,
    a.state,
    a.state_type,
    a.custom_length,
    a.annotation,
    inp_pipe.minorloss,
    inp_pipe.status,
    a.cat_matcat_id,
    a.builtdate,
    inp_pipe.custom_roughness,
    a.cat_dint,
    inp_pipe.custom_dint,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    a.the_geom
   FROM v_edit_arc a
     JOIN inp_pipe USING (arc_id)
  WHERE a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_rpt_node_stats
AS SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_main s
  WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rpt_node
AS SELECT rpt_node.id,
    node.node_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    selector_rpt_main.result_id,
    rpt_node.top_elev,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    '2001-01-01'::date + rpt_node."time"::interval AS "time",
    node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_node.press, node.node_id;

CREATE OR REPLACE VIEW v_rpt_arc_stats
AS SELECT r.arc_id,
    r.result_id,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.length,
    r.tot_headloss_max,
    r.tot_headloss_min,
    r.the_geom
   FROM rpt_arc_stats r,
    selector_rpt_main s
  WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rpt_arc
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
    rpt_arc.length,
    rpt_arc.headloss * rpt_arc.length / 1000 AS tot_headloss,
    arc.the_geom
   FROM selector_rpt_main,
   rpt_inp_arc arc
   JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
   WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
   ORDER BY rpt_arc.setting, arc.arc_id;


CREATE OR REPLACE VIEW ve_epa_junction
AS SELECT inp_junction.node_id,
    inp_junction.demand,
    inp_junction.pattern_id,
    inp_junction.peak_factor,
    inp_junction.emitter_coeff,
    inp_junction.init_quality,
    inp_junction.source_type,
    inp_junction.source_quality,
    inp_junction.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_junction
     LEFT JOIN v_rpt_node_stats USING (node_id);

CREATE OR REPLACE VIEW ve_epa_tank
AS SELECT inp_tank.node_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    inp_tank.overflow,
    inp_tank.mixing_model,
    inp_tank.mixing_fraction,
    inp_tank.reaction_coeff,
    inp_tank.init_quality,
    inp_tank.source_type,
    inp_tank.source_quality,
    inp_tank.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_tank
     LEFT JOIN v_rpt_node_stats USING (node_id);

CREATE OR REPLACE VIEW ve_epa_reservoir
AS SELECT inp_reservoir.node_id,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    inp_reservoir.init_quality,
    inp_reservoir.source_type,
    inp_reservoir.source_quality,
    inp_reservoir.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_reservoir
     LEFT JOIN v_rpt_node_stats USING (node_id);

CREATE OR REPLACE VIEW ve_epa_connec
AS SELECT inp_connec.connec_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    inp_connec.status,
    inp_connec.minorloss,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_connec
     LEFT JOIN v_rpt_node_stats ON inp_connec.connec_id::text = v_rpt_node_stats.node_id::text;

CREATE OR REPLACE VIEW ve_epa_inlet
AS SELECT inp_inlet.node_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    inp_inlet.overflow,
    inp_inlet.head,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
    inp_inlet.demand,
    inp_inlet.demand_pattern_id,
    inp_inlet.emitter_coeff,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_inlet
     LEFT JOIN v_rpt_node_stats USING (node_id);

CREATE OR REPLACE VIEW ve_epa_pump
AS SELECT inp_pump.node_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    inp_pump.status,
    p.to_arc,
    inp_pump.energyparam,
    inp_pump.energyvalue,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    concat(inp_pump.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM inp_pump
     LEFT JOIN v_rpt_arc_stats ON concat(inp_pump.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_pump p ON p.node_id::text = inp_pump.node_id::text;

CREATE OR REPLACE VIEW ve_epa_pump_additional
AS SELECT inp_pump_additional.id,
    inp_pump_additional.node_id,
    inp_pump_additional.order_id,
    inp_pump_additional.power,
    inp_pump_additional.curve_id,
    inp_pump_additional.speed,
    inp_pump_additional.pattern_id,
    inp_pump_additional.status,
    inp_pump_additional.energyparam,
    inp_pump_additional.energyvalue,
    inp_pump_additional.effic_curve_id,
    inp_pump_additional.energy_price,
    inp_pump_additional.energy_pattern_id,
    concat(inp_pump_additional.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM inp_pump_additional
     LEFT JOIN v_rpt_arc_stats ON concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id) = v_rpt_arc_stats.arc_id::text;

CREATE OR REPLACE VIEW ve_epa_valve
AS SELECT inp_valve.node_id,
    inp_valve.valv_type,
    vu_node.cat_dint,
    inp_valve.custom_dint,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'ACTIVE'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    concat(inp_valve.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM vu_node
     JOIN inp_valve USING (node_id)
     LEFT JOIN v_rpt_arc_stats ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id::text = inp_valve.node_id::text;

CREATE OR REPLACE VIEW ve_epa_shortpipe
AS SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    vu_node.cat_dint,
    inp_shortpipe.custom_dint,
    v.to_arc,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'CV'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM vu_node
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN v_rpt_arc_stats ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id::text = inp_shortpipe.node_id::text;

CREATE OR REPLACE VIEW ve_epa_pipe AS
 SELECT inp_pipe.arc_id,
    inp_pipe.minorloss,
    inp_pipe.status,
    a.cat_matcat_id,
    a.builtdate,
    r.roughness AS cat_roughness,
    inp_pipe.custom_roughness,
	  a.cat_dint,
    inp_pipe.custom_dint,
    inp_pipe.reactionparam,
    inp_pipe.reactionvalue,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max,
    v_rpt_arc_stats.flow_min,
    v_rpt_arc_stats.flow_avg,
    v_rpt_arc_stats.vel_max,
    v_rpt_arc_stats.vel_min,
    v_rpt_arc_stats.vel_avg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.tot_headloss_max,
    v_rpt_arc_stats.tot_headloss_min
   FROM vu_arc a
     JOIN inp_pipe USING (arc_id)
     LEFT JOIN v_rpt_arc_stats ON split_part(v_rpt_arc_stats.arc_id::text, 'P'::text, 1) = inp_pipe.arc_id::text
  LEFT JOIN cat_mat_roughness r ON a.cat_matcat_id::text = r.matcat_id::text
  WHERE ((now()::date -
        CASE
            WHEN a.builtdate IS NULL THEN '1900-01-01'::date
            ELSE a.builtdate
        END) / 365) >= r.init_age AND ((now()::date -
        CASE
            WHEN a.builtdate IS NULL THEN '1900-01-01'::date
            ELSE a.builtdate
        END) / 365) < r.end_age AND r.active IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_demand
AS SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    node.sector_id,
    node.expl_id,
    node.presszone_id,
    node.dma_id,
    node.the_geom
   FROM inp_dscenario_demand
     JOIN node ON node.node_id::text = inp_dscenario_demand.feature_id::text
     JOIN selector_sector s ON s.sector_id = node.sector_id
     JOIN selector_inp_dscenario d USING (dscenario_id)
  WHERE s.cur_user = CURRENT_USER AND d.cur_user = CURRENT_USER
UNION
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    connec.sector_id,
    connec.expl_id,
    connec.presszone_id,
    connec.dma_id,
    connec.the_geom
   FROM inp_dscenario_demand
     JOIN connec ON connec.connec_id::text = inp_dscenario_demand.feature_id::text
     JOIN selector_sector s ON s.sector_id = connec.sector_id
     JOIN selector_inp_dscenario d USING (dscenario_id)
  WHERE s.cur_user = CURRENT_USER AND d.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_virtualpump
AS SELECT a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.sector_id,
    a.state,
    a.state_type,
    a.annotation,
    a.expl_id,
    a.dma_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    p.pump_type,
    a.the_geom
    FROM v_edit_arc a
    JOIN inp_virtualpump p USING (arc_id)
	WHERE a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_virtualvalve
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.arccat_id,
    v_edit_arc.expl_id,
    v_edit_arc.sector_id,
    v_edit_arc.dma_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.custom_length,
    v_edit_arc.annotation,
    v.valv_type,
    v.setting,
    v.curve_id,
    v.minorloss,
    v.status,
    v.init_quality,
    v_edit_arc.the_geom
	FROM v_edit_arc
	JOIN inp_virtualvalve v USING (arc_id)
	WHERE v_edit_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_epa_virtualvalve AS
 SELECT inp_virtualvalve.arc_id,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.diameter,
    inp_virtualvalve.setting,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    inp_virtualvalve.init_quality,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
    FROM inp_virtualvalve
    LEFT JOIN v_rpt_arc_stats USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_virtualpump
AS SELECT p.arc_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.pump_type,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM inp_virtualpump p
     LEFT JOIN v_rpt_arc_stats USING (arc_id);

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe
AS SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    p.bulk_coeff,
    p.wall_coeff,
    a.the_geom
	FROM selector_inp_dscenario, v_edit_arc a
    JOIN inp_dscenario_pipe p USING (arc_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualvalve
AS SELECT d.dscenario_id,
    p.arc_id,
    p.valv_type,
    p.diameter,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.init_quality,
    a.the_geom
    FROM selector_inp_dscenario, v_edit_arc a
    JOIN inp_dscenario_virtualvalve p USING (arc_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualpump
AS SELECT v.dscenario_id,
    p.arc_id,
    v.power,
    v.curve_id,
    v.speed,
    v.pattern_id,
    v.status,
    v.pump_type,
    v.effic_curve_id,
    v.energy_price,
    v.energy_pattern_id,
    p.the_geom
    FROM selector_inp_dscenario s, v_edit_inp_virtualpump p
    JOIN inp_dscenario_virtualpump v USING (arc_id)
    WHERE v.dscenario_id = s.dscenario_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_connec
AS SELECT v_edit_connec.connec_id,
    v_edit_connec.top_elev,
    v_edit_connec.depth,
    v_edit_connec.conneccat_id,
    v_edit_connec.arc_id,
    v_edit_connec.expl_id,
    v_edit_connec.sector_id,
    v_edit_connec.dma_id,
    v_edit_connec.state,
    v_edit_connec.state_type,
    v_edit_connec.pjoint_type,
    v_edit_connec.pjoint_id,
    v_edit_connec.annotation,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.status,
    inp_connec.minorloss,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_edit_connec.the_geom
    FROM v_edit_connec
    JOIN inp_connec USING (connec_id)
	WHERE v_edit_connec.is_operative IS TRUE;


CREATE OR REPLACE VIEW ve_pol_register
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'REGISTER'::text;

CREATE OR REPLACE VIEW ve_pol_fountain
AS SELECT polygon.pol_id,
    polygon.feature_id AS connec_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'FOUNTAIN'::text;

CREATE OR REPLACE VIEW ve_pol_tank
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'TANK'::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump as
SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_pump p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump_additional
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.dma_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_pump_additional p USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional
AS SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_pump_additional p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe
AS SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    p.bulk_coeff,
    p.wall_coeff,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_shortpipe p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_connec
AS SELECT d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.peak_factor,
    c.status,
    c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    c.emitter_coeff,
    c.init_quality,
    c.source_type,
    c.source_quality,
    c.source_pattern_id,
    connec.the_geom
    FROM selector_inp_dscenario, v_edit_inp_connec connec
    JOIN inp_dscenario_connec c USING (connec_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE c.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_shortpipe
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'CV'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_shortpipe using (node_id)
    LEFT JOIN man_valve v ON v.node_id::text = n.node_id::text
	WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank
AS SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_tank p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
    WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_tank
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    inp_tank.overflow,
    inp_tank.mixing_model,
    inp_tank.mixing_fraction,
    inp_tank.reaction_coeff,
    inp_tank.init_quality,
    inp_tank.source_type,
    inp_tank.source_quality,
    inp_tank.source_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_tank USING (node_id)
    WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir
AS SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_reservoir p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_reservoir
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    inp_reservoir.init_quality,
    inp_reservoir.source_type,
    inp_reservoir.source_quality,
    inp_reservoir.source_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_reservoir USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve
AS SELECT d.dscenario_id,
    p.node_id,
    concat(p.node_id, '_n2a') AS nodarc_id,
    p.valv_type,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    p.init_quality,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_valve p USING (node_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_valve
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_valve.valv_type,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'ACTIVE'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
	  n.cat_dint,
    inp_valve.custom_dint,
    inp_valve.add_settings,
    inp_valve.init_quality,
    n.the_geom
	FROM v_edit_node n
	JOIN inp_valve USING (node_id)
	JOIN man_valve v USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet
AS SELECT p.dscenario_id,
    n.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
	p.head,
    p.pattern_id,
	p.demand,
	p.demand_pattern_id,
	p.emitter_coeff,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_inlet p USING (node_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_inlet
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.overflow,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
	inp_inlet.pattern_id,
    inp_inlet.head,
	inp_inlet.demand,
	inp_inlet.demand_pattern_id,
	inp_inlet.emitter_coeff,
    n.the_geom
	FROM v_edit_node n
    JOIN inp_inlet USING (node_id)
	WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.sector_id,
            v_plan_arc.expl_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.arc_type,
            a.matcat_id,
            a.pnom,
            a.dnom,
            a.dint,
            a.dext,
            a.descript,
            a.link,
            a.brand_id,
            a.model_id,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.shape,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM v_plan_arc
             JOIN cat_arc a ON a.id::text = v_plan_arc.arccat_id::text
             JOIN cat_soil s ON s.id::text = v_plan_arc.soilcat_id::text
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    p.m2mlbottom * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2bottom_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    p.m3mlprotec * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3_protec_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    p.m3mlexc * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3exc_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    p.m3mlfill * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3fill_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    p.m3mlexcess * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3excess_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    p.m2mltrenchl * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2trenchl_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN a.price_id IS NULL THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id::text = p.arc_id::text
     JOIN cat_pavement c ON a.pavcat_id::text = c.id::text
     LEFT JOIN v_price_compost r ON a.price_id::text = c.m2_cost::text
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (min(v.price) * count(v_edit_connec.connec_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature
AS SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 1 AND arc.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 1 AND node.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.conneccat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 1 AND connec.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1 AND element.workcat_id IS NOT NULL;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end as
SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    v_edit_arc.arccat_id AS featurecat_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code,
    exploitation.name AS expl_name,
    v_edit_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_arc
     JOIN exploitation ON exploitation.expl_id = v_edit_arc.expl_id
  WHERE v_edit_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    v_edit_node.nodecat_id AS featurecat_id,
    v_edit_node.node_id AS feature_id,
    v_edit_node.code,
    exploitation.name AS expl_name,
    v_edit_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_node
     JOIN exploitation ON exploitation.expl_id = v_edit_node.expl_id
  WHERE v_edit_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    v_edit_connec.conneccat_id AS featurecat_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code,
    exploitation.name AS expl_name,
    v_edit_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_connec
     JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
  WHERE v_edit_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0;

CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.state,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.state,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE v_plan_arc.state = 2;

CREATE OR REPLACE VIEW v_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  WHERE plan_psector_x_arc.doable IS TRUE
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  WHERE plan_psector_x_node.doable IS TRUE
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_node
AS SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.node_type,
    cat_feature.feature_class,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.conneccat_id,
    cat_connec.connec_type,
    cat_feature.feature_class,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    cat_arc.arc_type,
    cat_feature.feature_class,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_current_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'plan_psector_current'::text AND config_param_user.value::integer = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_all
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2)::double precision + ((100::numeric + plan_psector.vat) / 100::numeric * (plan_psector.other / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM config_param_user,
    plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE config_param_user.cur_user::text = "current_user"()::text
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_valve
AS SELECT v.netscenario_id,
    v.node_id,
    v.closed,
    node.the_geom
   FROM config_param_user,
    plan_netscenario_valve v
     JOIN node USING (node_id)
  WHERE config_param_user.cur_user::text = "current_user"()::text
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = v.netscenario_id;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM config_param_user,
    plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE config_param_user.cur_user::text = "current_user"()::text
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_plan_psector_budget
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    (v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999 AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    v_edit_plan_psector_x_other.observ AS feature_id,
    v_edit_plan_psector_x_other.measurement AS length,
    v_edit_plan_psector_x_other.price AS unitary_cost,
    v_edit_plan_psector_x_other.total_budget
   FROM v_edit_plan_psector_x_other
  ORDER BY 1, 2, 4;

CREATE OR REPLACE VIEW v_plan_psector_budget_arc
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget_detail
AS SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


CREATE OR REPLACE VIEW v_om_waterbalance_report
AS WITH expl_data AS (
         SELECT sum(w_1.auth) / sum(w_1.total) AS expl_rw_eff,
            1::double precision - sum(w_1.auth) / sum(w_1.total) AS expl_nrw_eff,
            NULL::text AS expl_nightvol,
                CASE
                    WHEN sum(w_1.arc_length) = 0::double precision THEN NULL::double precision
                    ELSE sum(w_1.nrw) / sum(w_1.arc_length) / (EXTRACT(epoch FROM age(p_1.end_date, p_1.start_date)) / 3600::numeric)::double precision
                END AS expl_m4day,
                CASE
                    WHEN sum(w_1.arc_length) = 0::double precision AND sum(w_1.n_connec) = 0 AND sum(w_1.link_length) = 0::double precision THEN NULL::double precision
                    ELSE sum(w_1.loss) * (365::numeric / EXTRACT(day FROM p_1.end_date - p_1.start_date))::double precision / (6.57::double precision * sum(w_1.arc_length) + 9.13::double precision * sum(w_1.link_length) + (0.256 * sum(w_1.n_connec)::numeric * avg(d_1.avg_press))::double precision)
                END AS expl_ili,
            w_1.expl_id,
            w_1.cat_period_id,
            p_1.start_date
           FROM om_waterbalance w_1
             JOIN ext_cat_period p_1 ON w_1.cat_period_id::text = p_1.id::text
             JOIN dma d_1 ON d_1.dma_id = w_1.dma_id
          GROUP BY w_1.expl_id, w_1.cat_period_id, p_1.end_date, p_1.start_date
        )
 SELECT DISTINCT e.name AS exploitation,
    w.expl_id,
    d.name AS dma,
    w.dma_id,
    w.cat_period_id,
    p.code AS period,
    p.start_date,
    p.end_date,
    w.meters_in,
    w.meters_out,
    w.n_connec,
    w.n_hydro,
    w.arc_length,
    w.link_length,
    w.total_in,
    w.total_out,
    w.total,
    w.auth,
    w.nrw,
        CASE
            WHEN w.total <> 0::double precision THEN w.auth / w.total
            ELSE NULL::double precision
        END AS dma_rw_eff,
        CASE
            WHEN w.total <> 0::double precision THEN 1::double precision - w.auth / w.total
            ELSE NULL::double precision
        END AS dma_nrw_eff,
    w.ili AS dma_ili,
    NULL::text AS dma_nightvol,
    w.nrw / w.arc_length / (EXTRACT(epoch FROM age(p.end_date, p.start_date)) / 3600::numeric)::double precision AS dma_m4day,
    ed.expl_rw_eff,
    ed.expl_nrw_eff,
    ed.expl_nightvol,
    ed.expl_ili,
    ed.expl_m4day,
    w.n_inhabitants,
    w.avg_press
   FROM om_waterbalance w
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON w.cat_period_id::text = p.id::text
     JOIN expl_data ed ON ed.expl_id = w.expl_id AND w.cat_period_id::text = p.id::text
  WHERE ed.start_date = p.start_date;


CREATE OR REPLACE VIEW v_ui_dma
AS SELECT d.dma_id,
    d.name,
    d.dma_type,
    md.name AS macrodma,
    d.descript,
    d.active,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.minc,
    d.maxc,
    d.effc,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.avg_press,
    d.link,
    d.muni_id,
    d.expl_id,
    d.sector_id
   FROM selector_expl s,
    dma d
     LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  WHERE d.dma_id > 0
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW v_om_waterbalance
AS SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    om_waterbalance.auth_bill,
    om_waterbalance.auth_unbill,
    om_waterbalance.loss_app,
    om_waterbalance.loss_real,
    om_waterbalance.total_in,
    om_waterbalance.total_out,
    om_waterbalance.total,
    p.start_date::date AS crm_startdate,
    p.end_date::date AS crm_enddate,
    om_waterbalance.startdate AS wbal_startdate,
    om_waterbalance.enddate AS wbal_enddate,
    om_waterbalance.ili,
    om_waterbalance.auth,
    om_waterbalance.loss,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * (om_waterbalance.auth_bill + om_waterbalance.auth_unbill) / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS loss_eff,
    om_waterbalance.auth_bill AS rw,
    (om_waterbalance.total - om_waterbalance.auth_bill)::numeric(20,2) AS nrw,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * om_waterbalance.auth_bill / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS nrw_eff,
    d.the_geom,
    om_waterbalance.n_inhabitants,
    om_waterbalance.avg_press
   FROM om_waterbalance
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON p.id::text = om_waterbalance.cat_period_id::text;


CREATE OR REPLACE VIEW v_ui_supplyzone
 AS
 SELECT s.supplyzone_id,
    s.name,
    s.supplyzone_type,
    ms.name AS macrosector,
    s.descript,
    s.active,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
	  s.avg_press,
	  s.link,
    s.muni_id,
    s.expl_id
   FROM selector_supplyzone ss,
    supplyzone s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.supplyzone_id > 0 AND ss.supplyzone_id = s.supplyzone_id AND ss.cur_user = CURRENT_USER
  ORDER BY s.supplyzone_id;

CREATE OR REPLACE VIEW v_ui_macrodma
 AS
 SELECT m.macrodma_id,
  m.name,
	m.descript,
  m.active,
	m.expl_id
   FROM selector_expl s,
    macrodma m
	WHERE macrodma_id > 0 AND m.expl_id = s.expl_id AND s.cur_user = "current_user"()::text
  ORDER BY m.macrodma_id;

CREATE OR REPLACE VIEW v_ui_macrodqa
 AS
 SELECT m.macrodqa_id,
  m.name,
	m.descript,
  m.active,
	m.expl_id
   FROM selector_expl s,
    macrodqa m
	WHERE macrodqa_id > 0 AND m.expl_id = s.expl_id AND s.cur_user = "current_user"()::text
  ORDER BY m.macrodqa_id;


CREATE OR REPLACE VIEW v_ui_macrosector
  AS
  SELECT m.macrosector_id,
    m.name,
    m.descript,
    m.active
    FROM macrosector m
    WHERE m.macrosector_id > 0
  ORDER BY m.macrosector_id;


CREATE OR REPLACE VIEW v_ui_dqa
AS SELECT d.dqa_id,
    d.name,
    d.dqa_type,
    md.name AS macrodqa,
    d.descript,
    d.active,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.avg_press,
    d.link,
    d.muni_id,
    d.expl_id,
    d.sector_id
   FROM selector_expl s,
    dqa d
     LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  WHERE d.dqa_id > 0
  ORDER BY d.dqa_id;



CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.name,
    s.sector_type,
    ms.name AS macrosector,
    s.descript,
    s.active,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.avg_press,
    s.link,
    s.muni_id,
    s.expl_id
   FROM selector_sector ss,
    sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0 AND ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER
  ORDER BY s.sector_id;


CREATE OR REPLACE VIEW v_edit_sector
AS SELECT s.sector_id,
    s.name,
    s.sector_type,
    s.macrosector_id,
    s.descript,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.avg_press,
    s.link,
    s.the_geom,
    s.muni_id,
    s.expl_id,
    et.idval,
    s.lock_level
   FROM sector s
   LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text,
    selector_sector ss
  WHERE s.sector_id = ss.sector_id AND ss.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_value_cat_node
AS SELECT cat_node.id,
    cat_node.node_type,
    cat_feature.feature_class
   FROM cat_node
     JOIN cat_feature_node ON cat_feature_node.id::TEXT = cat_node.node_type::TEXT
     JOIN cat_feature ON cat_feature_node.id::TEXT = cat_feature.id::TEXT;

CREATE OR REPLACE VIEW v_value_cat_connec
AS SELECT cat_connec.id,
    cat_connec.connec_type,
    cat_feature.feature_class
   FROM cat_connec
     JOIN cat_feature_connec ON cat_feature_connec.id::TEXT = cat_connec.connec_type::TEXT
     JOIN cat_feature ON cat_feature_connec.id::TEXT = cat_feature.id::TEXT;

CREATE OR REPLACE VIEW v_edit_review_connec
AS SELECT review_connec.connec_id,
    review_connec.conneccat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.review_obs,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_date,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_connec.expl_id = selector_expl.expl_id;

-- 30/10//2024

CREATE OR REPLACE VIEW vcp_pipes AS
 SELECT p.arc_id,
    p.minorloss,
    p.dint, p.dscenario_id
   FROM config_param_user c, selector_inp_result r, rpt_inp_arc rpt
   JOIN inp_dscenario_pipe p ON rpt.arc_id = p.arc_id
   WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = p.dscenario_id::text
   AND c.cur_user = "current_user"()::text AND r.result_id = rpt.result_id AND r.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vcv_junction AS
SELECT rpt.node_id,
    rpt.dma_id
   FROM selector_inp_result r,
    rpt_inp_node rpt
  WHERE r.result_id::text = rpt.result_id::text AND r.cur_user = "current_user"()::text AND rpt.epa_type = 'JUNCTION';

CREATE OR REPLACE VIEW vcv_demands AS
 SELECT inp.feature_id, inp.demand, inp.pattern_id, inp.source, dscenario_id
   FROM config_param_user c, inp_dscenario_demand inp
   WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = inp.dscenario_id::text
   AND c.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vcv_patterns AS
 SELECT patt.*
   FROM selector_inp_result r, rpt_inp_pattern_value patt
   WHERE r.result_id = patt.result_id AND r.cur_user = "current_user"()::text;;

CREATE OR REPLACE VIEW vcv_emitters_log
 AS
 SELECT DISTINCT n.node_id, n.dma_id,
    sum(a.length / 10000::numeric) AS c0_default,
	NULL::numeric AS c0_updated
   FROM selector_inp_result r,
    rpt_inp_arc a
     JOIN rpt_inp_node n USING (result_id)
  WHERE (a.node_1::text = n.node_id::text OR a.node_2::text = n.node_id::text) AND r.result_id::text = n.result_id::text AND r.cur_user = "current_user"()::text
  GROUP BY n.node_id, n.dma_id;

CREATE OR REPLACE VIEW vcv_dma_log
 AS
 SELECT DISTINCT
    n.dma_id,
    NULL::numeric AS coef
   FROM selector_inp_result r,
    rpt_inp_arc a
     JOIN rpt_inp_node n USING (result_id)
  WHERE (a.node_1::text = n.node_id::text OR a.node_2::text = n.node_id::text) AND r.result_id::text = n.result_id::text AND r.cur_user = "current_user"()::text
  GROUP BY n.node_id, n.dma_id;


-- 19/11/24
DROP VIEW IF EXISTS v_edit_macrosector;
CREATE OR REPLACE VIEW v_edit_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    m.name,
    m.descript,
    m.the_geom,
    m.lock_level
   FROM selector_sector ss, macrosector m LEFT JOIN sector s USING (macrosector_id)
   WHERE (ss.sector_id = s.sector_id AND cur_user = current_user OR s.macrosector_id IS NULL)
   AND m.active IS true;


CREATE OR REPLACE VIEW v_edit_macrodma
AS SELECT DISTINCT ON (macrodma_id) macrodma_id,
    m.name,
    m.descript,
    m.the_geom,
    m.expl_id,
    m.lock_level
   FROM selector_expl ss, macrodma m
    WHERE m.expl_id = ss.expl_id AND ss.cur_user = "current_user"()::text AND m.active IS true;

CREATE OR REPLACE VIEW v_edit_macrodqa
AS SELECT DISTINCT ON (macrodqa_id) macrodqa_id,
    m.name,
    m.descript,
    m.the_geom,
    m.expl_id,
    m.lock_level
   FROM selector_expl ss, macrodqa m
    WHERE m.expl_id = ss.expl_id AND ss.cur_user = "current_user"()::text AND m.active IS true;

CREATE OR REPLACE VIEW v_edit_macroexploitation
AS SELECT DISTINCT ON (macroexpl_id) m.*
   FROM selector_expl ss, macroexploitation m JOIN exploitation s USING (macroexpl_id)
   WHERE (ss.expl_id = s.expl_id AND cur_user = current_user OR s.macroexpl_id IS NULL)
   AND m.active IS true;

-- 21/11/24
CREATE OR REPLACE VIEW v_minsector_graph AS
SELECT
    m.node_id,
    m.nodecat_id,
    m.minsector_1,
    m.minsector_2,
    m.macrominsector_id,
    n.expl_id
FROM minsector_graph m
JOIN node n ON n.node_id = m.node_id
JOIN selector_expl s ON s.expl_id = n.expl_id
WHERE s.cur_user = CURRENT_USER;


DROP VIEW IF EXISTS v_sector_node;

--05/12/2024
DROP  VIEW IF EXISTS v_rpt_comp_arc;

CREATE OR REPLACE VIEW v_rpt_comp_arc
AS
WITH main AS
	(SELECT r.arc_id,
    r.result_id,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.the_geom
   FROM rpt_arc_stats r, selector_rpt_main s
	WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text) ,
  compare AS
	(SELECT r.arc_id,
    r.result_id,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.the_geom
   FROM rpt_arc_stats r, selector_rpt_compare s
  WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text)
	SELECT main.arc_id,
	main.arc_type,
	main.sector_id,
	main.arccat_id,
	main.result_id as main_result,
	compare.result_id as compare_result,
	main.flow_max as flow_max_main,
	compare.flow_max as flow_max_compare,
	main.flow_max - compare.flow_max as flow_max_diff,
	main.flow_min as flow_min_main,
	compare.flow_min as flow_min_compare,
	main.flow_min - compare.flow_min as flow_min_diff,
	main.flow_avg as flow_avg_main,
	compare.flow_avg as flow_avg_compare,
	main.flow_avg - compare.flow_avg as flow_avg_diff,
	main.vel_max as vel_max_main,
	compare.vel_max as vel_max_compare,
	main.vel_max - compare.vel_max as vel_max_diff,
	main.vel_min as vel_min_main,
	compare.vel_min as vel_min_compare,
	main.vel_min - compare.vel_min as vel_min_diff,
	main.vel_avg as vel_avg_main,
	compare.vel_avg as vel_avg_compare,
	main.vel_avg - compare.vel_avg as vel_avg_diff,
	main.headloss_max as headloss_max_main,
	compare.headloss_max as headloss_max_compare,
	main.headloss_max - compare.headloss_max as headloss_max_diff,
	main.headloss_min as headloss_min_main,
	compare.headloss_min as headloss_min_compare,
	main.headloss_min - compare.headloss_min as headloss_min_diff,
	main.setting_max as setting_max_main,
	compare.setting_max as setting_max_compare,
	main.setting_max - compare.setting_max as setting_max_diff,
	main.setting_min as setting_min_main,
	compare.setting_min as setting_min_compare,
	main.setting_min - compare.setting_min as setting_min_diff,
	main.reaction_max as reaction_max_main,
	compare.reaction_max as reaction_max_compare,
	main.reaction_max - compare.reaction_max as reaction_max_diff,
	main.reaction_min as reaction_min_main,
	compare.reaction_min as reaction_min_compare,
	main.reaction_min - compare.reaction_min as reaction_min_diff,
	main.ffactor_max as ffactor_max_main,
	compare.ffactor_max as ffactor_max_compare,
	main.ffactor_max - compare.ffactor_max as ffactor_max_diff,
	main.ffactor_min as ffactor_min_main,
	compare.ffactor_min as ffactor_min_compare,
	main.ffactor_min - compare.ffactor_min as ffactor_min_diff,
	main.the_geom
	FROM main JOIN compare ON main.arc_id = compare.arc_id;


DROP VIEW IF EXISTS v_rpt_comp_node;

CREATE OR REPLACE VIEW v_rpt_comp_node
AS
WITH main AS (
SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_main s
    WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text),

compare AS (
SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_compare s
     WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text)

     SELECT main.node_id,
     main.node_type,
     main.sector_id,
     main.nodecat_id,
     main.result_id AS result_id_main,
     compare.result_id AS result_id_compare,
     main.top_elev,
     main.demand_max AS demand_max_main,
     compare.demand_max AS demand_max_compare,
     main.demand_max - compare.demand_max AS demand_max_diff,
     main.demand_min AS demand_min_main,
     compare.demand_min AS demand_min_compare,
     main.demand_min - compare.demand_min AS demand_min_diff,
     main.demand_avg AS demand_avg_main,
     compare.demand_avg AS demand_avg_compare,
     main.demand_avg - compare.demand_avg AS demand_avg_diff,
     main.head_max AS head_max_main,
     compare.head_max AS head_max_compare,
     main.head_max - compare.head_max AS head_max_diff,
     main.head_min AS head_min_main,
     compare.head_min AS head_min_compare,
     main.head_min - compare.head_min AS head_min_diff,
     main.head_avg AS head_avg_main,
     compare.head_avg AS head_avg_compare,
     main.head_avg - compare.head_avg AS head_avg_diff,
     main.press_max AS press_max_main,
     compare.press_max AS press_max_compare,
     main.press_max - compare.press_max AS press_max_diff,
     main.press_min AS press_min_main,
     compare.press_min AS press_min_compare,
     main.press_min - compare.press_min AS press_min_diff,
     main.press_avg AS press_avg_main,
     compare.press_avg AS press_avg_compare,
     main.press_avg - compare.press_avg AS press_avg_diff,
      main.quality_max AS quality_max_main,
     compare.quality_max AS quality_max_compare,
     main.quality_max - compare.quality_max AS quality_max_diff,
     main.quality_min AS quality_min_main,
     compare.quality_min AS quality_min_compare,
     main.quality_min - compare.quality_min AS quality_min_diff,
     main.quality_avg AS quality_avg_main,
     compare.quality_avg AS quality_avg_compare,
     main.quality_avg - compare.quality_avg AS quality_avg_diff,
     main.the_geom
     FROM main JOIN compare ON main.node_id = compare.node_id;

--10/12/2024
--v_rpt_comp_node_hourly--
DROP VIEW IF EXISTS v_rpt_comp_node_hourly;
CREATE OR REPLACE VIEW v_rpt_comp_node_hourly  AS
 WITH main AS (
  SELECT rpt_node.id,
         node.node_id,
         node.sector_id,
         selector_rpt_main.result_id,
         rpt_node.top_elev,
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
   WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text
     AND rpt_node."time"::text = selector_rpt_main_tstep.timestep::text
     AND selector_rpt_main.cur_user = "current_user"()::text
     AND selector_rpt_main_tstep.cur_user = "current_user"()::text
     AND node.result_id::text = selector_rpt_main.result_id::text
),
compare AS (
  SELECT rpt_node.id,
         node.node_id,
         node.sector_id,
         selector_rpt_compare.result_id,
         rpt_node.top_elev,
         rpt_node.demand,
         rpt_node.head,
         rpt_node.press,
         rpt_node.quality,
         rpt_node."time",
         node.the_geom
    FROM selector_rpt_compare,
         selector_rpt_compare_tstep,
         rpt_inp_node node
         JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
   WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text
     AND rpt_node."time"::text = selector_rpt_compare_tstep.timestep::text
     AND selector_rpt_compare.cur_user = "current_user"()::text
     AND selector_rpt_compare_tstep.cur_user = "current_user"()::text
     AND node.result_id::text = selector_rpt_compare.result_id::text
)
SELECT main.node_id,
       main.sector_id,
       main.top_elev,
       main.result_id AS result_id_main,
       compare.result_id AS result_id_compare,
       main.time AS time_main,
       compare.time AS time_compare,
       main.demand AS demand_main,
       compare.demand AS demand_compare,
       main.demand - compare.demand AS demand_diff,
       main.head AS head_main,
       compare.head AS head_compare,
       main.head - compare.head AS head_diff,
       main.press AS press_main,
       compare.press AS press_compare,
       main.press - compare.press AS press_diff,
       main.quality AS quality_main,
       compare.quality AS quality_compare,
       main.quality - compare.quality AS quality_diff,
       main.the_geom
  FROM main
  JOIN compare ON main.node_id = compare.node_id;


 --v_rpt_comp_arc_hourly--
DROP VIEW IF EXISTS v_rpt_comp_arc_hourly;
CREATE OR REPLACE VIEW v_rpt_comp_arc_hourly
AS
WITH main AS (
  SELECT rpt_arc.id,
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
   WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text
     AND rpt_arc."time"::text = selector_rpt_main_tstep.timestep::text
     AND selector_rpt_main.cur_user = "current_user"()::text
     AND selector_rpt_main_tstep.cur_user = "current_user"()::text
     AND arc.result_id::text = selector_rpt_main.result_id::TEXT
),
compare AS (
  SELECT rpt_arc.id,
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
         selector_rpt_compare_tstep,
         rpt_inp_arc arc
         JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
   WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text
     AND rpt_arc."time"::text = selector_rpt_compare_tstep.timestep::text
     AND selector_rpt_compare.cur_user = "current_user"()::text
     AND selector_rpt_compare_tstep.cur_user = "current_user"()::text
     AND arc.result_id::text = selector_rpt_compare.result_id::TEXT
)
SELECT main.arc_id,
       main.sector_id,
       main.result_id AS result_id_main,
       compare.result_id AS result_id_compare,
       main.time AS time_main,
       compare.time AS time_compare,
       main.flow AS flow_main,
       compare.flow AS flow_compare,
       main.flow - compare.flow AS flow_diff,
       main.vel AS vel_main,
       compare.vel AS vel_compare,
       main.vel - compare.vel AS vel_diff,
       main.headloss AS headloss_main,
       compare.headloss AS headloss_compare,
       main.headloss - compare.headloss AS headloss_diff,
       main.setting AS setting_main,
       compare.setting AS setting_compare,
       main.setting - compare.setting AS setting_diff,
       main.ffactor AS ffactor_main,
       compare.ffactor AS ffactor_compare,
       main.ffactor - compare.ffactor AS ffactor_diff,
       main.the_geom
  FROM main
  JOIN compare ON main.arc_id = compare.arc_id;

CREATE OR REPLACE VIEW v_om_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::text = ext_rtc_hydrometer.id::text
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_curve
AS SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.expl_id,
    c.log,
    c.active
   FROM selector_expl s,
    inp_curve c
  WHERE c.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR c.expl_id IS NULL
  ORDER BY c.id;

DROP VIEW IF EXISTS v_edit_inp_pattern;
DROP VIEW IF EXISTS v_edit_inp_pattern_value;
CREATE OR REPLACE VIEW v_edit_inp_pattern
AS SELECT DISTINCT
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tscode,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    p.log,
    p.active
   FROM selector_expl s,
    inp_pattern p
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.pattern_id;

CREATE OR REPLACE VIEW v_edit_inp_pattern_value
AS SELECT DISTINCT inp_pattern_value.id,
    p.pattern_id,
    p.observ,
    p.tscode,
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
    inp_pattern_value.factor_18
   FROM selector_expl s,
    inp_pattern p
     JOIN inp_pattern_value USING (pattern_id)
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY inp_pattern_value.id;

CREATE OR REPLACE VIEW v_anl_arc
AS SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom,
    anl_arc.result_id,
    anl_arc.descript
   FROM selector_audit,
    anl_arc
     JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
  WHERE anl_arc.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_arc_point
AS SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom_p
   FROM selector_audit,
    anl_arc
     JOIN sys_fprocess ON anl_arc.fid = sys_fprocess.fid
     JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
  WHERE anl_arc.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_arc_x_node
AS SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.state,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom
   FROM selector_audit,
    anl_arc_x_node
     JOIN exploitation ON anl_arc_x_node.expl_id = exploitation.expl_id
  WHERE anl_arc_x_node.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc_x_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_arc_x_node_point
AS SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom_p
   FROM selector_audit,
    anl_arc_x_node
     JOIN exploitation ON anl_arc_x_node.expl_id = exploitation.expl_id
  WHERE anl_arc_x_node.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc_x_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_connec
AS SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.conneccat_id AS connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux AS state_aux,
    anl_connec.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_connec.the_geom,
    anl_connec.result_id,
    anl_connec.descript
   FROM selector_audit,
    anl_connec
     JOIN exploitation ON anl_connec.expl_id = exploitation.expl_id
  WHERE anl_connec.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_connec.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_node
AS SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux AS state_aux,
    anl_node.num_arcs,
    anl_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_node.the_geom,
    anl_node.result_id,
    anl_node.descript
   FROM selector_audit,
    anl_node
     JOIN exploitation ON anl_node.expl_id = exploitation.expl_id
  WHERE anl_node.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_edit_anl_hydrant
AS SELECT anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.expl_id,
    anl_node.the_geom
   FROM anl_node
  WHERE anl_node.fid = 468 AND anl_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW vi_options
AS SELECT a.parameter,
    a.value
   FROM ( SELECT a_1.parameter,
            a_1.value,
                CASE
                    WHEN a_1.parameter = 'UNITS'::text THEN 1
                    ELSE 2
                END AS t
           FROM ( SELECT a_1_1.idval AS parameter,
                        CASE
                            WHEN a_1_1.idval = 'UNBALANCED'::text AND b.value = 'CONTINUE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE config_param_user.parameter::text = 'inp_options_unbalanced_n'::text AND config_param_user.cur_user::name = "current_user"()))
                            WHEN a_1_1.idval = 'QUALITY'::text AND b.value = 'TRACE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE config_param_user.parameter::text = 'inp_options_node_id'::text AND config_param_user.cur_user::name = "current_user"()))
                            WHEN a_1_1.idval = 'HYDRAULICS'::text AND (b.value = 'USE'::text OR b.value = 'SAVE'::text) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                               FROM config_param_user
                              WHERE config_param_user.parameter::text = 'inp_options_hydraulics_fname'::text AND config_param_user.cur_user::name = "current_user"()))
                            WHEN a_1_1.idval = 'HYDRAULICS'::text AND b.value = 'NONE'::text THEN NULL::text
                            ELSE b.value
                        END AS value
                   FROM sys_param_user a_1_1
                     JOIN config_param_user b ON a_1_1.id = b.parameter::text
                  WHERE (a_1_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text])) AND (a_1_1.idval <> ALL (ARRAY['UNBALANCED_N'::text, 'NODE_ID'::text, 'HYDRAULICS_FNAME'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL AND a_1_1.idval <> 'VALVE_MODE_MINCUT_RESULT'::text AND b.parameter::text <> 'PATTERN'::text AND b.value <> 'NULLVALUE'::text) a_1
          WHERE a_1.parameter <> 'HYDRAULICS'::text OR a_1.parameter = 'HYDRAULICS'::text AND a_1.value IS NOT NULL) a
  ORDER BY a.t;

CREATE OR REPLACE VIEW vi_report
AS SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_reports_1'::text, 'lyt_reports_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL;

CREATE OR REPLACE VIEW vi_times
AS SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_date_1'::text, 'lyt_date_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL;

CREATE OR REPLACE VIEW vi_reactions
AS SELECT 'BULK'::text AS param,
    inp_pipe.arc_id,
    inp_pipe.bulk_coeff::text AS coeff
   FROM inp_pipe
     LEFT JOIN temp_arc ON inp_pipe.arc_id::text = temp_arc.arc_id::text
  WHERE inp_pipe.bulk_coeff IS NOT NULL
UNION
 SELECT 'WALL'::text AS param,
    inp_pipe.arc_id,
    inp_pipe.wall_coeff::text AS coeff
   FROM inp_pipe
     JOIN temp_arc ON inp_pipe.arc_id::text = temp_arc.arc_id::text
  WHERE inp_pipe.wall_coeff IS NOT NULL
UNION
 SELECT 'BULK'::text AS param,
    p.arc_id,
    p.bulk_coeff::text AS coeff
   FROM inp_dscenario_pipe p
     LEFT JOIN temp_arc ON p.arc_id::text = temp_arc.arc_id::text
  WHERE p.bulk_coeff IS NOT NULL
UNION
 SELECT 'WALL'::text AS param,
    p.arc_id,
    p.wall_coeff::text AS coeff
   FROM inp_dscenario_pipe p
     JOIN temp_arc ON p.arc_id::text = temp_arc.arc_id::text
  WHERE p.wall_coeff IS NOT NULL
UNION
 SELECT sys_param_user.idval AS param,
    NULL::character varying AS arc_id,
    config_param_user.value::character varying AS coeff
   FROM config_param_user
     JOIN sys_param_user ON sys_param_user.id = config_param_user.parameter::text
  WHERE (config_param_user.parameter::text = 'inp_reactions_bulk_order'::text OR config_param_user.parameter::text = 'inp_reactions_wall_order'::text OR config_param_user.parameter::text = 'inp_reactions_global_bulk'::text OR config_param_user.parameter::text = 'inp_reactions_global_wall'::text OR config_param_user.parameter::text = 'inp_reactions_limit_concentration'::text OR config_param_user.parameter::text = 'inp_reactions_wall_coeff_correlation'::text) AND config_param_user.value IS NOT NULL AND config_param_user.cur_user::text = CURRENT_USER
  ORDER BY 1;

CREATE OR REPLACE VIEW vi_energy
AS SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'EFFIC'::text AS idval,
    inp_pump.effic_curve_id AS energyvalue
   FROM inp_pump
     LEFT JOIN temp_arc ON concat(inp_pump.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE inp_pump.effic_curve_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PRICE'::text AS idval,
    inp_pump.energy_price::text AS energyvalue
   FROM inp_pump
     LEFT JOIN temp_arc ON concat(inp_pump.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE inp_pump.energy_price IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PATTERN'::text AS idval,
    inp_pump.energy_pattern_id AS energyvalue
   FROM inp_pump
     LEFT JOIN temp_arc ON concat(inp_pump.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE inp_pump.energy_pattern_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'EFFIC'::text AS idval,
    inp_pump_additional.effic_curve_id AS energyvalue
   FROM inp_pump_additional
     LEFT JOIN temp_arc ON concat(inp_pump_additional.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE inp_pump_additional.effic_curve_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PRICE'::text AS idval,
    inp_pump_additional.energy_price::text AS energyvalue
   FROM inp_pump_additional
     LEFT JOIN temp_arc ON concat(inp_pump_additional.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE inp_pump_additional.energy_price IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PATTERN'::text AS idval,
    p.energy_pattern_id AS energyvalue
   FROM inp_pump_additional p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.energy_pattern_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'EFFIC'::text AS idval,
    p.effic_curve_id AS energyvalue
   FROM inp_dscenario_pump p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.effic_curve_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PRICE'::text AS idval,
    p.energy_price::text AS energyvalue
   FROM inp_dscenario_pump p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.energy_price IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PATTERN'::text AS idval,
    p.energy_pattern_id AS energyvalue
   FROM inp_dscenario_pump p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.energy_pattern_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'EFFIC'::text AS idval,
    p.effic_curve_id AS energyvalue
   FROM inp_dscenario_pump_additional p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.effic_curve_id IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PRICE'::text AS idval,
    p.energy_price::text AS energyvalue
   FROM inp_dscenario_pump_additional p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.energy_price IS NOT NULL
UNION
 SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id,
    'PATTERN'::text AS idval,
    p.energy_pattern_id AS energyvalue
   FROM inp_pump_additional p
     LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text
  WHERE p.energy_pattern_id IS NOT NULL
UNION
 SELECT sys_param_user.idval AS pump_id,
    config_param_user.value AS idval,
    NULL::text AS energyvalue
   FROM config_param_user
     JOIN sys_param_user ON sys_param_user.id = config_param_user.parameter::text
  WHERE (config_param_user.parameter::text = 'inp_energy_price'::text OR config_param_user.parameter::text = 'inp_energy_pump_effic'::text OR config_param_user.parameter::text = 'inp_energy_price_pattern'::text) AND config_param_user.value IS NOT NULL AND config_param_user.cur_user::name = CURRENT_USER
  ORDER BY 1;

CREATE OR REPLACE VIEW vcp_pipes
AS SELECT p.arc_id,
    p.minorloss,
    p.dint,
    p.dscenario_id
   FROM config_param_user c,
    selector_inp_result r,
    rpt_inp_arc rpt
     JOIN inp_dscenario_pipe p ON rpt.arc_id::text = p.arc_id::text
  WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = p.dscenario_id::text AND c.cur_user::text = "current_user"()::text AND r.result_id::text = rpt.result_id::text AND r.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vcv_demands
AS SELECT inp.feature_id,
    inp.demand,
    inp.pattern_id,
    inp.source,
    inp.dscenario_id
   FROM config_param_user c,
    inp_dscenario_demand inp
  WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = inp.dscenario_id::text AND c.cur_user::text = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_review_node;
CREATE OR REPLACE VIEW v_edit_review_node
AS SELECT review_node.node_id,
    review_node.top_elev,
    review_node.depth,
    review_node.nodecat_id,
    review_node.annotation,
    review_node.observ,
    review_node.review_obs,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_date,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_node.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW vp_basic_node AS
SELECT node_id AS nid,
node_type AS custom_type
FROM node
JOIN cat_node ON id=nodecat_id;

CREATE OR REPLACE VIEW v_rtc_hydrometer
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS feature_id,
    'CONNEC'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text
UNION
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN 'XXXX'::character varying
            ELSE node.node_id
        END AS feature_id,
    'NODE'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
     JOIN node ON node.node_id::text = man_netwjoin.node_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN 'XXXX'::character varying
            ELSE node.node_id
        END AS node_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS node_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
     JOIN node ON node.node_id::text = man_netwjoin.node_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = "current_user"()::text;

-- 10/02/2025
CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT
    doc_x_arc.arc_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT
    doc_x_connec.connec_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT
    doc_x_node.node_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_psector
AS SELECT
    plan_psector.name AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_psector
     JOIN doc ON doc.id::text = doc_x_psector.doc_id::text
     JOIN plan_psector ON plan_psector.psector_id::text = doc_x_psector.psector_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT
    doc_x_visit.visit_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

CREATE OR REPLACE VIEW v_ui_om_visit_x_doc
AS SELECT
    doc_x_visit.doc_id,
    doc_x_visit.visit_id
   FROM doc_x_visit;


-- 19/02/2025
CREATE OR REPLACE VIEW v_ui_hydroval
 AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_node.node_id as feature_id,
    node.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN rtc_hydrometer_x_node ON rtc_hydrometer_x_node.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN node ON rtc_hydrometer_x_node.node_id::text = node.node_id::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
UNION
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY 1;

-- 06/03/2025
CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s, rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text
  AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);

