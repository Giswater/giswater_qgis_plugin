/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 16/12/24

CREATE OR REPLACE VIEW vu_element_x_node
AS SELECT element_x_node.id,
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


CREATE OR REPLACE VIEW vu_element_x_connec
AS SELECT element_x_connec.id,
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


CREATE OR REPLACE VIEW vu_element_x_arc
AS SELECT element_x_arc.id,
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


--23/12/2024
create or replace view v_edit_node as
WITH
    typevalue AS
        (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'presszone_type'::character varying::text, 'dma_type'::character varying::text, 'dqa_type'::character varying::text])
        ),
	sector_table as
		(
		select sector_id, name as sector_name, macrosector_id, stylesheet, id::varchar(16) as sector_type
		from sector left JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table as
		(
		select dma_id, name as dma_name, macrodma_id, stylesheet, id::varchar(16) as dma_type from dma
		left JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
		),
	presszone_table as
		(
		select presszone_id, name as presszone_name, head as presszone_head, stylesheet, id::varchar(16) as presszone_type
		from presszone left JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
		),
	dqa_table as
		(
		select dqa_id, name as dqa_name, stylesheet, id::varchar(16) as dqa_type, macrodqa_id from dqa
		left JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
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
        LEFT JOIN (SELECT node_id FROM node_psector WHERE p_state = 0) a using (node_id) where a.node_id is null
        union all
        SELECT node_id FROM node_psector
        WHERE p_state = 1
        ),
    node_selected AS
        ( SELECT node.node_id,
	    node.code,
	    node.elevation,
	    node.depth,
	    cat_node.nodetype_id AS node_type,
	    cat_feature.system_id AS sys_type,
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
	    sector_name,
	    macrosector_id,
	    sector_type,
	    node.presszone_id,
	    presszone_name,
	    presszone_type,
	    presszone_head,
	    node.dma_id,
	    dma_name,
	    dma_type,
	    macrodma_id,
	    node.dqa_id,
	    dqa_name,
	    dqa_type,
	    macrodqa_id,
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
	    node.buildercat_id,
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
	    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
	    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
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
  		sector_table.stylesheet ->> 'featureColor'::text AS sector_style
        FROM node_selector
        JOIN node ON node.node_id = node_selector.node_id
        JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = node.expl_id) or (se.cur_user = current_user AND se.expl_id = node.expl_id2)
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = node.sector_id)
        JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
	    JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
		JOIN value_state_type vst ON vst.id = node.state_type
	    JOIN exploitation ON node.expl_id = exploitation.expl_id
	    JOIN ext_municipality mu ON node.muni_id = mu.muni_id
		JOIN sector_table ON sector_table.sector_id = node.sector_id
	    LEFT JOIN presszone_table ON presszone_table.presszone_id = node.presszone_id
	    LEFT JOIN dma_table ON dma_table.dma_id = node.dma_id
	    LEFT JOIN dqa_table ON dqa_table.dqa_id = node.dqa_id
	    LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
        LEFT JOIN man_valve m ON m.node_id = node.node_id
        )
	SELECT n.*
	FROM node_selected n;


CREATE OR REPLACE VIEW v_edit_arc
AS WITH
	typevalue AS
        (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'presszone_type'::character varying::text, 'dma_type'::character varying::text, 'dqa_type'::character varying::text])
        ),
	sector_table as
		(
		select sector_id, name as sector_name, macrosector_id, stylesheet, id::varchar(16) as sector_type
		from sector left JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table as
		(
		select dma_id, name as dma_name, macrodma_id, stylesheet, id::varchar(16) as dma_type from dma
		left JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
		),
	presszone_table as
		(
		select presszone_id, name as presszone_name, head as presszone_head, stylesheet, id::varchar(16) as presszone_type
		from presszone left JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
		),
	dqa_table as
		(
		select dqa_id, name as dqa_name, stylesheet, id::varchar(16) as dqa_type, macrodqa_id from dqa
		left JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
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
        left JOIN (SELECT arc_id FROM arc_psector WHERE p_state = 0) a using (arc_id)  where a.arc_id is null
        union all
        SELECT arc_id FROM arc_psector
        WHERE p_state = 1
        ),
    arc_selected AS (
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
		cat_arc.arctype_id AS arc_type,
		cat_feature.system_id AS sys_type,
		cat_arc.matcat_id AS cat_matcat_id,
		cat_arc.pnom AS cat_pnom,
		cat_arc.dnom AS cat_dnom,
		cat_arc.dint AS cat_dint,
		arc.epa_type,
		arc.state,
		arc.state_type,
		arc.expl_id,
		exploitation.macroexpl_id,
		arc.sector_id,
		sector_name,
		macrosector_id,
		sector_type,
		arc.presszone_id,
		presszone_name,
		presszone_type,
		presszone_head,
		arc.dma_id,
		dma_name,
		dma_type,
		macrodma_id,
		arc.dqa_id,
		dqa_name,
		dqa_type,
		macrodqa_id,
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
		arc.buildercat_id,
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
		dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
		presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
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
			WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
			ELSE NULL::character varying(16)
		END AS inp_type,
		sector_table.stylesheet ->> 'featureColor'::text AS sector_style
	    FROM arc_selector
   		JOIN arc ON arc.arc_id::text = arc_selector.arc_id::text
   		JOIN selector_expl se ON ((se.cur_user = CURRENT_USER AND se.expl_id = arc.expl_id) OR (se.cur_user = CURRENT_USER and se.expl_id = arc.expl_id2))
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = arc.sector_id)
		JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
		JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
		JOIN exploitation ON arc.expl_id = exploitation.expl_id
		JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
		JOIN sector_table ON sector_table.sector_id = arc.sector_id
	    LEFT JOIN presszone_table ON presszone_table.presszone_id = arc.presszone_id
	    LEFT JOIN dma_table ON dma_table.dma_id = arc.dma_id
	    LEFT JOIN dqa_table ON dqa_table.dqa_id = arc.dqa_id
		LEFT JOIN arc_add e ON e.arc_id::text = arc.arc_id::text
		LEFT JOIN value_state_type vst ON vst.id = arc.state_type
        )
	SELECT arc_selected.*
	FROM arc_selected;


create or replace view v_edit_connec as
WITH
    typevalue AS
        (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'presszone_type'::character varying::text, 'dma_type'::character varying::text, 'dqa_type'::character varying::text])
        ),
	sector_table as
		(
		select sector_id, name as sector_name, macrosector_id, stylesheet, id::varchar(16) as sector_type
		from sector left JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table as
		(
		select dma_id, name as dma_name, macrodma_id, stylesheet, id::varchar(16) as dma_type from dma
		left JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
		),
	presszone_table as
		(
		select presszone_id, name as presszone_name, head as presszone_head, stylesheet, id::varchar(16) as presszone_type
		from presszone left JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
		),
	dqa_table as
		(
		select dqa_id, name as dqa_name, stylesheet, id::varchar(16) as dqa_type, macrodqa_id from dqa
		left JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
		),
    inp_network_mode AS
    	(
         select value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ),
    link_planned as
    	(
    	select link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_name, macrosector_id, l.dma_id, dma_name, macrodma_id,
    	l.presszone_id, presszone_name, presszone_head, l.dqa_id, dqa_name, dqa_table.macrodqa_id, fluid_type,
    	minsector_id, staticpressure, null::integer as macrominsector_id ,
    	sector_type, presszone_type,  dma_type, dqa_type
    	from link l
    	join exploitation using (expl_id)
		JOIN sector_table ON sector_table.sector_id = l.sector_id
		LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
		LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
		LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
		where l.state = 2
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
        JOIN selector_state ss ON ss.cur_user =current_user AND connec.state =ss.state_id
        left join (SELECT connec_id, arc_id FROM connec_psector WHERE p_state = 0) a using (connec_id, arc_id) where a.connec_id is null
       	union all
        SELECT connec_id, connec_psector.arc_id::varchar(16), link_id FROM connec_psector
        WHERE p_state = 1
        ),
    connec_selected AS
    	(
		select connec.connec_id,
		connec.code,
		connec.elevation,
		connec.depth,
		cat_connec.connectype_id AS connec_type,
		cat_feature.system_id AS sys_type,
		connec.connecat_id,
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
			WHEN link_planned.sector_name IS NULL THEN sector_table.sector_name
			ELSE link_planned.sector_name
		END AS sector_name,
		CASE
			WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
			ELSE link_planned.macrosector_id
		END AS macrosector_id,
		--CASE
		  --  WHEN link_planned.sector_type IS NULL THEN sector.sector_type
		   -- ELSE link_planned.sector_type
		--END AS sector_type,
		CASE
			WHEN link_planned.presszone_id IS NULL THEN presszone_table.presszone_id
			ELSE link_planned.presszone_id::varchar
		END AS presszone_id,
		CASE
			WHEN link_planned.presszone_name IS NULL THEN presszone_table.presszone_name
			ELSE link_planned.presszone_name
		END AS presszone_name,
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
			WHEN link_planned.dma_name IS NULL THEN dma_table.dma_name
			ELSE link_planned.dma_name
		END AS dma_name,
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
			WHEN link_planned.dqa_name IS NULL THEN dqa_table.dqa_name
			ELSE link_planned.dqa_name
		END AS dqa_name,
		CASE
			WHEN link_planned.dqa_type IS NULL THEN dqa_table.dqa_type
			ELSE link_planned.dqa_type
		END AS dqa_type,
		CASE
			WHEN link_planned.macrodqa_id IS NULL THEN dqa_table.macrodqa_id
			ELSE link_planned.macrodqa_id
		END AS macrodqa_id,
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
		connec.buildercat_id,
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
		dqa_table.stylesheet ->> 'featureColor'::text AS dma_style,
		presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
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
		e.demand,
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
		sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
		connec.n_inhabitants
	    FROM inp_network_mode, connec_selector
        JOIN connec ON connec.connec_id = connec_selector.connec_id
        JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = connec.expl_id) or (se.cur_user =current_user and se.expl_id = connec.expl_id2)
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = connec.sector_id)
        JOIN cat_connec ON cat_connec.id::text = connec.connecat_id::text
	    JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	    JOIN exploitation ON connec.expl_id = exploitation.expl_id
	    JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
	    JOIN sector_table ON sector_table.sector_id = connec.sector_id
	    LEFT JOIN presszone_table ON presszone_table.presszone_id = connec.presszone_id
	    LEFT JOIN dma_table ON dma_table.dma_id = connec.dma_id
	    LEFT JOIN dqa_table ON dqa_table.dqa_id = connec.dqa_id
	    LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
   	    LEFT JOIN link_planned using (link_id)
	    LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
	    LEFT JOIN value_state_type vst ON vst.id = connec.state_type
	    )
	SELECT c.*
	FROM connec_selected c;


create or replace view v_edit_link as
WITH
	typevalue AS
        (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'presszone_type'::character varying::text, 'dma_type'::character varying::text, 'dqa_type'::character varying::text])
        ),
	sector_table as
		(
		select sector_id, name as sector_name, macrosector_id, stylesheet, id::varchar(16) as sector_type
		from sector left JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table as
		(
		select dma_id, name as dma_name, macrodma_id, stylesheet, id::varchar(16) as dma_type from dma
		left JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
		),
	presszone_table as
		(
		select presszone_id, name as presszone_name, head as presszone_head, stylesheet, id::varchar(16) as presszone_type
		from presszone left JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
		),
	dqa_table as
		(
		select dqa_id, name as dqa_name, stylesheet, id::varchar(16) as dqa_type, macrodqa_id from dqa
		left JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
		),
    inp_network_mode AS
    	(
         select value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ),
    link_psector AS
        (
        SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id desc nulls last
        ),
    link_selector as
        (
        SELECT l.link_id
        FROM link l
        JOIN selector_state s ON s.cur_user =current_user AND l.state =s.state_id
        left join (SELECT link_id FROM link_psector WHERE p_state = 0) a using (link_id) where a.link_id is null
        UNION ALL
        SELECT link_id FROM link_psector
        WHERE p_state = 1
        ),
    link_selected as
    	(
		SELECT l.link_id,
	    l.feature_type,
	    l.feature_id,
	    l.exit_type,
	    l.exit_id,
	    l.state,
	    l.expl_id,
	    l.sector_id,
	    sector_name,
	    sector_type,
	    macrosector_id,
	    l.presszone_id,
	    presszone_name,
	    presszone_type,
	    presszone_head,
	    l.dma_id,
	    dma_name,
	    dma_type,
	    macrodma_id,
	    l.dqa_id,
	    dqa_name,
	    dqa_type,
	    macrodqa_id,
	    l.exit_topelev,
	    l.exit_elev,
	    l.fluid_type,
	    st_length(l.the_geom)::numeric(12,3) as gis_length,
	    l.the_geom,
	    l.muni_id,
	    l.expl_id2,
	    l.epa_type,
	    l.is_operative,
	    l.staticpressure,
	    l.connecat_id,
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
	    END AS inp_type
		FROM inp_network_mode, link_selector
	    JOIN link l using (link_id)
	    JOIN selector_expl se ON ((se.cur_user =current_user AND se.expl_id = l.expl_id) or (se.cur_user =current_user AND se.expl_id = l.expl_id2))
        JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = l.sector_id)
		JOIN sector_table ON sector_table.sector_id = l.sector_id
	    LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
	    LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
	    LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
		)
    SELECT l.*
	FROM link_selected l;

DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS vu_sector;
CREATE OR REPLACE VIEW vu_sector
AS SELECT s.sector_id,
    s.name,
    s.macrosector_id,
    et.idval as sector_type,
    s.descript,
    s.parent_id,
    s.pattern_id,
    s.graphconfig::text AS graphconfig,
    s.stylesheet::text AS stylesheet,
    s.link,
    s.avg_press,
    s.active,
    s.undelete,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.the_geom
   FROM sector s
     LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  ORDER BY s.sector_id;

-- 10/01/2025
DROP VIEW IF EXISTS v_ui_sector;
CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.name,
    s.sector_type,
    ms.name AS macrosector,
    s.descript,
    s.active,
    s.undelete,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
	s.avg_press,
	s.link
   FROM selector_sector ss,
    sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0 AND ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER
  ORDER BY s.sector_id;

DROP VIEW IF EXISTS v_edit_sector;
CREATE OR REPLACE VIEW v_edit_sector
AS SELECT s.sector_id,
    s.name,
    s.sector_type,
    ms.name AS macrosector,
    s.descript,
    s.undelete,
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
	s.the_geom
   FROM selector_sector,
    sector s
    LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_ui_dma;
CREATE OR REPLACE VIEW v_ui_dma
AS SELECT d.dma_id,
    d.name,
    d.dma_type,
    md.name AS macrodma,
    d.descript,
    d.active,
    d.undelete,
    d.expl_id,
    d.minc,
    d.maxc,
    d.effc,
    d.pattern_id,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.avg_press,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user
   FROM selector_expl s,
    dma d
     LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  WHERE d.dma_id > 0 AND s.expl_id = d.expl_id AND s.cur_user = CURRENT_USER
  ORDER BY d.dma_id;

DROP VIEW IF EXISTS v_edit_dma;
CREATE OR REPLACE VIEW v_edit_dma
AS SELECT d.dma_id,
    d.name,
    d.dma_type,
    md.name AS macrodma,
    d.descript,
    d.undelete,
    d.expl_id,
    d.minc,
    d.maxc,
    d.effc,
    d.pattern_id,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.avg_press,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.the_geom
   FROM
    selector_expl,
    dma d
    LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  WHERE d.expl_id = selector_expl.expl_id AND d.active AND selector_expl.cur_user = "current_user"()::text OR d.expl_id IS NULL
  ORDER BY d.dma_id;

DROP VIEW IF EXISTS v_ui_presszone;
CREATE OR REPLACE VIEW v_ui_presszone
AS SELECT p.presszone_id,
    p.name,
    p.presszone_type,
    p.descript,
    p.active,
    p.expl_id,
    p.link,
    p.head,
    p.graphconfig,
    p.stylesheet,
    p.tstamp,
    p.insert_user,
    p.lastupdate,
    p.lastupdate_user,
    p.avg_press
   FROM selector_expl s,
    presszone p
  WHERE (p.presszone_id::text <> ALL (ARRAY['0'::character varying::text, '-1'::character varying::text])) AND s.expl_id = p.expl_id AND s.cur_user = CURRENT_USER
  ORDER BY p.presszone_id;


DROP VIEW IF EXISTS v_edit_presszone;
CREATE OR REPLACE VIEW v_edit_presszone
AS SELECT p.presszone_id,
    p.name,
    p.presszone_type,
    p.descript,
    p.expl_id,
    p.link,
    p.head,
    p.graphconfig,
    p.stylesheet,
    p.tstamp,
    p.insert_user,
    p.lastupdate,
    p.lastupdate_user,
    p.avg_press,
    p.the_geom
   FROM
    selector_expl,
    vu_presszone p
  WHERE p.expl_id = selector_expl.expl_id AND p.active AND selector_expl.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.presszone_id;


DROP VIEW IF EXISTS v_ui_dqa;
CREATE OR REPLACE VIEW v_ui_dqa
AS SELECT d.dqa_id,
    d.name,
    d.dqa_type,
    md.name AS macrodqa_id,
    d.descript,
    d.active,
    d.undelete,
    d.expl_id,
    d.pattern_id,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user
   FROM selector_expl s,
    vu_dqa d
     LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  WHERE d.dqa_id > 0 AND s.expl_id = d.expl_id AND s.cur_user = CURRENT_USER
  ORDER BY d.dqa_id;


DROP VIEW IF EXISTS v_edit_dqa;
CREATE OR REPLACE VIEW v_edit_dqa
AS SELECT d.dqa_id,
    d.name,
    d.dqa_type,
    md.name AS macrodqa_id,
    d.descript,
    d.undelete,
    d.expl_id,
    d.pattern_id,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.the_geom
   FROM selector_expl,
    vu_dqa d
    LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  WHERE d.expl_id = selector_expl.expl_id AND d.active AND selector_expl.cur_user = "current_user"()::text OR d.expl_id IS NULL
  ORDER BY d.dqa_id;


-- 18/01/2025
DROP VIEW IF EXISTS ve_epa_pump;
DROP VIEW IF EXISTS ve_epa_pump_additional;
DROP VIEW IF EXISTS ve_epa_valve;
DROP VIEW IF EXISTS ve_epa_shortpipe;
DROP VIEW IF EXISTS ve_epa_pipe;
DROP VIEW IF EXISTS ve_epa_virtualvalve;
DROP VIEW IF EXISTS ve_epa_virtualpump;

DROP VIEW IF EXISTS v_rpt_arc;
DROP VIEW IF EXISTS v_rpt_arc_all;

CREATE OR REPLACE VIEW v_rpt_arc as
select arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    max(rpt_arc.flow) AS flow_max,
    min(rpt_arc.flow) AS flow_min,
    avg(rpt_arc.flow)::numeric(12,2) AS flow_avg,
    max(rpt_arc.vel) AS vel_max,
    min(rpt_arc.vel) AS vel_min,
    avg(rpt_arc.vel)::numeric(12,2) AS vel_avg,
    max(rpt_arc.headloss) AS headloss_max,
    min(rpt_arc.headloss) AS headloss_min,
    max(rpt_arc.setting) AS setting_max,
    min(rpt_arc.setting) AS setting_min,
    max(rpt_arc.reaction) AS reaction_max,
    min(rpt_arc.reaction) AS reaction_min,
    max(rpt_arc.ffactor) AS ffactor_max,
    min(rpt_arc.ffactor) AS ffactor_min,
    rpt_arc.length,
    max(rpt_arc.headloss*rpt_arc.length/1000)::numeric(12,2) AS tot_headloss_max,
    min(rpt_arc.headloss*rpt_arc.length/1000)::numeric(12,2) AS tot_headloss_min,
    arc.the_geom
   FROM selector_rpt_main,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  GROUP BY arc.arc_id, arc.arc_type, arc.sector_id, arc.arccat_id, selector_rpt_main.result_id, arc.the_geom, rpt_arc.length;

CREATE OR REPLACE VIEW v_rpt_arc_all as
SELECT rpt_arc.id,
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
    rpt_arc.headloss*rpt_arc.length/1000 as tot_headloss,
    arc.the_geom
   FROM selector_rpt_main,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_arc.setting, arc.arc_id;

CREATE OR REPLACE VIEW ve_epa_virtualvalve
AS SELECT inp_virtualvalve.arc_id,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.diameter,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    inp_virtualvalve.init_quality,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
    FROM inp_virtualvalve
    LEFT JOIN v_rpt_arc USING (arc_id);

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
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM inp_virtualpump p
     LEFT JOIN v_rpt_arc USING (arc_id);

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
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM inp_pump
     LEFT JOIN v_rpt_arc ON concat(inp_pump.node_id, '_n2a') = v_rpt_arc.arc_id::text
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
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM inp_pump_additional
     LEFT JOIN v_rpt_arc ON concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id) = v_rpt_arc.arc_id::text;

CREATE OR REPLACE VIEW ve_epa_valve
AS SELECT inp_valve.node_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    vu_node.cat_dint,
    inp_valve.custom_dint,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.closed IS FALSE AND v.active IS TRUE THEN 'ACTIVE'::character varying(12)
            WHEN v.closed IS FALSE AND v.active IS FALSE THEN 'OPEN'::character varying(12)
            ELSE NULL::character varying(12)
        END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    concat(inp_valve.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM vu_node
     JOIN inp_valve USING (node_id)
     LEFT JOIN v_rpt_arc ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc.arc_id::text
     LEFT JOIN man_valve v ON v.node_id::text = inp_valve.node_id::text;

CREATE OR REPLACE VIEW ve_epa_shortpipe
AS SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    vu_node.cat_dint,
    inp_shortpipe.custom_dint,
    v.to_arc,
        CASE
            WHEN v.active IS TRUE AND v.to_arc IS NOT NULL THEN 'CV'::character varying(12)
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
            ELSE NULL::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM vu_node
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN v_rpt_arc ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc.arc_id::text
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
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max,
    v_rpt_arc.flow_min,
    v_rpt_arc.flow_avg,
    v_rpt_arc.vel_max,
    v_rpt_arc.vel_min,
    v_rpt_arc.vel_avg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM vu_arc a
     JOIN inp_pipe USING (arc_id)
     LEFT JOIN v_rpt_arc ON split_part(v_rpt_arc.arc_id::text, 'P'::text, 1) = inp_pipe.arc_id::text
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

CREATE OR REPLACE VIEW ve_epa_pipe
AS SELECT inp_pipe.arc_id,
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
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max,
    v_rpt_arc.flow_min,
    v_rpt_arc.flow_avg,
    v_rpt_arc.vel_max,
    v_rpt_arc.vel_min,
    v_rpt_arc.vel_avg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM vu_arc a
     JOIN inp_pipe USING (arc_id)
     LEFT JOIN v_rpt_arc ON split_part(v_rpt_arc.arc_id::text, 'P'::text, 1) = inp_pipe.arc_id::text
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

CREATE OR REPLACE VIEW v_edit_element
AS SELECT
	e.element_id,
    e.code,
    e.elementcat_id,
    e.elementtype_id,
    e.brand_id,
    e.model_id,
    e.serial_number,
    e.state,
    e.state_type,
    e.num_elements,
    e.observ,
    e.comment,
    e.function_type,
    e.category_type,
    e.location_type,
    e.fluid_type,
    e.workcat_id,
    e.workcat_id_end,
    e.buildercat_id,
    e.builtdate,
    e.enddate,
    e.ownercat_id,
    e.rotation,
    e.link,
    e.verified,
    e.the_geom,
    e.label_x,
    e.label_y,
    e.label_rotation,
    e.publish,
    e.inventory,
    e.undelete,
    e.expl_id,
    e.pol_id,
    e.lastupdate,
    e.lastupdate_user,
    e.elevation,
    e.expl_id2,
    e.trace_featuregeom,
    e.muni_id,
    e.sector_id
   FROM (
   		SELECT
   			element.element_id,
            element.code,
            element.elementcat_id,
            cat_element.elementtype_id,
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
            element.buildercat_id,
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
            element.elevation,
            element.expl_id2,
            element.trace_featuregeom,
            element.muni_id,
            element.sector_id
       FROM selector_expl, element
     	JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     	JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     	JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
         WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::TEXT
        ) e
     LEFT JOIN selector_sector s USING (sector_id)
     LEFT JOIN selector_municipality m USING (muni_id)
  WHERE (s.cur_user = CURRENT_USER OR e.sector_id IS NULL) AND (m.cur_user = CURRENT_USER OR e.muni_id IS NULL);


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
