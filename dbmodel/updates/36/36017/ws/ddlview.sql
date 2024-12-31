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
	    presszone_name as preszone_name,
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
		presszone_name as preszone_name,
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
        SELECT pp.connec_id, pp.psector_id, pp.state AS p_state, 
        FIRST_VALUE(pp.link_id) OVER (PARTITION BY pp.connec_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS link_id,
        FIRST_VALUE(pp.arc_id) OVER (PARTITION BY pp.connec_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS arc_id 
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ),
    connec_selector AS
        (
        SELECT connec_id, arc_id::varchar(16), null::integer as link_id 
        FROM connec 
        JOIN selector_state ss ON ss.cur_user =current_user AND connec.state =ss.state_id
        left join (SELECT connec_id, arc_id FROM connec_psector WHERE p_state = 0) a using (connec_id, arc_id) where a.connec_id is null
       	union all
        SELECT DISTINCT connec_id, connec_psector.arc_id::varchar(16), link_id FROM connec_psector
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
			ELSE connec.arc_id
		END AS pjoint_id,
		CASE
			WHEN link_planned.link_id IS NULL THEN connec.pjoint_type
			ELSE 'ARC'::character varying(16)
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
		sector_table.stylesheet ->> 'featureColor'::text AS sector_style
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
        SELECT pp.connec_id AS feature_id, 'CONNEC' AS feature_type, pp.psector_id, pp.state AS p_state, FIRST_VALUE(pp.link_id)
        OVER (PARTITION BY pp.connec_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS link_id  
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
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
	

CREATE OR REPLACE VIEW vu_om_mincut as
select distinct on (m.id) m.* from om_mincut m
JOIN config_user_x_expl USING (expl_id)
where username = current_user and m.id > 0;

CREATE OR REPLACE VIEW vu_sector as
SELECT DISTINCT ON (s.sector_id) s.sector_id,
    s.name,
    s.macrosector_id,
    m.name AS macrosector_name,
    et.idval,
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
     JOIN ( SELECT DISTINCT node.sector_id, node.expl_id FROM node  WHERE node.state > 0) a USING (sector_id)
     JOIN config_user_x_expl USING (expl_id)
     LEFT JOIN macrosector m USING (macrosector_id)
     LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  WHERE config_user_x_expl.username::text = CURRENT_USER AND s.sector_id > 0
  UNION
  select s.sector_id,
    s.name,
    s.macrosector_id,
    m.name AS macrosector_name,
    et.idval,
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
     LEFT JOIN ( SELECT DISTINCT node.sector_id, node.expl_id FROM node  WHERE node.state > 0) a USING (sector_id)
     LEFT JOIN macrosector m USING (macrosector_id)
     LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  where s.sector_id > 0 and a.sector_id is null  
   ORDER BY 1;
   
  
  CREATE OR REPLACE VIEW v_edit_sector
AS SELECT vu_sector.sector_id,
    vu_sector.name,
    vu_sector.macrosector_id,
    vu_sector.macrosector_name,
    vu_sector.idval,
    vu_sector.descript,
    vu_sector.parent_id,
    vu_sector.pattern_id,
    vu_sector.graphconfig,
    vu_sector.stylesheet,
    vu_sector.link,
    vu_sector.avg_press,
    vu_sector.active,
    vu_sector.undelete,
    vu_sector.tstamp,
    vu_sector.insert_user,
    vu_sector.lastupdate,
    vu_sector.lastupdate_user,
    vu_sector.the_geom
   FROM vu_sector,
    selector_sector
  WHERE vu_sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  and active is true;
  