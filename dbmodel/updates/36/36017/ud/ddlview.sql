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

CREATE OR REPLACE VIEW vu_element_x_gully
AS SELECT element_x_gully.id,
    element_x_gully.gully_id,
    element_x_gully.element_id,
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
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_gully
     JOIN element ON element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;


create or replace view v_edit_node as
WITH 
   	typevalue AS 
       (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	drainzone_table as
		(
		select drainzone_id, name as drainzone_name, stylesheet, id::varchar(16) as drainzone_type from drainzone
		left JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
    node_psector AS
        (
        SELECT pp.node_id, pp.state AS p_state 
        FROM plan_psector_x_node pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ),
    node_state AS
        (
        SELECT n.node_id 
        FROM node n
        JOIN selector_state s ON s.cur_user =current_user AND n.state =s.state_id
      --  except ALL
       -- SELECT node_id FROM node_psector WHERE p_state = 0
       -- UNION ALL
       -- SELECT node_id FROM node_psector WHERE p_state = 1
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
            node.state,
            node.state_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector_type,
            macrosector_id,
            node.drainzone_id,
            drainzone_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            macrodma_id,
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
            node.the_geom,
            node.undelete,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
            node.label_quadrant,
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
            node.workcat_id_plan,          
            node.asset_id,
            node.parent_id,
            node.arc_id,
            node.expl_id2,
            vst.is_operative,
            node.minsector_id,
            node.macrominsector_id,
            node.adate,
            node.adescript,
            node.placement_type,
            node.access_type,
            CASE
              WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
              ELSE NULL::character varying(16)
            END AS inp_type,
            node.brand_id,
            node.model_id,
            node.serial_number
             FROM node_state nn
             join node using (node_id)
             JOIN selector_expl se ON se.cur_user =current_user AND se.expl_id IN (node.expl_id, node.expl_id2)
       		 JOIN selector_municipality sm ON sm.cur_user = current_user AND sm.muni_id =node.muni_id 
       		 JOIN selector_sector ss ON ss.cur_user = current_user AND ss.sector_id=node.sector_id
             JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             JOIN exploitation ON node.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON node.muni_id = mu.muni_id
             JOIN value_state_type vst ON vst.id = node.state_type
	  		 JOIN sector_table on sector_table.sector_id = node.sector_id
		     left join dma_table on dma_table.dma_id = node.dma_id 
	   	     left join drainzone_table ON node.dma_id = drainzone_table.drainzone_id        )
SELECT node_selected.*
FROM node_selected;


CREATE OR REPLACE VIEW v_edit_arc
AS WITH  
 	typevalue AS 
       (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	drainzone_table as
		(
		select drainzone_id, name as drainzone_name, stylesheet, id::varchar(16) as drainzone_type from drainzone
		left JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	arc_psector AS (
         SELECT pp.arc_id,
            pp.state AS p_state
           FROM plan_psector_x_arc pp
             JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
        ), 
    arc_state AS (
         SELECT n.arc_id
           FROM arc n
             JOIN selector_state s ON s.cur_user = CURRENT_USER AND n.state = s.state_id
          --   except ALL
       	  --   SELECT arc_id FROM arc_psector WHERE p_state = 0
       	--	 UNION ALL
         --    SELECT arc_id FROM arc_psector WHERE p_state = 1
           ),
         arc_selected AS (
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
	    cat_arc.width AS cat_width,
	    cat_arc.area AS cat_area,
	    arc.epa_type,
	    arc.state,
	    arc.state_type,
	    arc.expl_id,
	    e.macroexpl_id,
	    arc.sector_id,
	    sector_type,
	    macrosector_id,
	    arc.drainzone_id,
	    drainzone_type,
	    arc.annotation,
	    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
	    arc.custom_length,
	    arc.inverted_slope,
	    arc.observ,
	    arc.comment,
	    arc.dma_id,
	    macrodma_id,
	    dma_type,
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
	    arc.buildercat_id,
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
	    arc.uncertain,
	    arc.num_value,
	    arc.asset_id,
	    arc.pavcat_id,
	    arc.parent_id,
	    arc.expl_id2,
	    vst.is_operative,
	    arc.minsector_id,
	    arc.macrominsector_id,
	    arc.adate,
	    arc.adescript,
	    arc.visitability,
	    date_trunc('second'::text, arc.tstamp) AS tstamp,
	    arc.insert_user,
	    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
	    arc.lastupdate_user,
	    arc.the_geom,
	        CASE
	            WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
	            ELSE NULL::character varying(16)
	        END AS inp_type,
	    arc.brand_id,
	    arc.model_id,
	    arc.serial_number
    FROM arc_state
     join arc using (arc_id)
     JOIN selector_expl se ON se.cur_user =current_user AND se.expl_id IN (arc.expl_id, arc.expl_id2)
     JOIN selector_municipality sm ON sm.cur_user = current_user AND sm.muni_id =arc.muni_id 
     JOIN selector_sector ss ON ss.cur_user = current_user AND ss.sector_id=arc.sector_id
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN exploitation e on e.expl_id = arc.expl_id
     JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
     JOIN value_state_type vst ON vst.id = arc.state_type 
     JOIN sector_table on sector_table.sector_id = arc.sector_id
	 left join dma_table on dma_table.dma_id = arc.dma_id 
	 left join drainzone_table ON arc.dma_id = drainzone_table.drainzone_id
	 )
	SELECT arc_selected.*
	FROM arc_selected;
	

create or replace view v_edit_connec as
with
	typevalue AS 
       (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY(ARRAY['sector_type'::text, 'drainzone_type'::text, 'dma_type'::text, 'dwfzone_type'::text])
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
	drainzone_table as
		(
		select drainzone_id, name as drainzone_name, stylesheet, id::varchar(16) as drainzone_type from drainzone
		left JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
    link_planned as 
    	(   	   	
    	select link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_name, macrosector_id, l.dma_id, dma_name, macrodma_id, 
    	l.drainzone_id, drainzone_name, fluid_type,
    	sector_type, drainzone_type, dma_type    	
    	from link l
    	join exploitation using (expl_id)
		JOIN sector_table ON l.sector_id = sector_table.sector_id
		left JOIN dma_table ON l.dma_id = dma_table.dma_id
	    left join drainzone_table ON l.dma_id = drainzone_table.drainzone_id
    	where l.state = 2
    	),   	
    connec_psector AS
        (
        SELECT pp.connec_id, pp.psector_id, pp.state AS p_state, FIRST_VALUE(pp.arc_id) OVER (PARTITION BY pp.connec_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS arc_id 
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ),
    connec_state AS
        (
        SELECT connec_id, arc_id FROM connec c JOIN selector_state s ON s.cur_user =current_user AND c.state =s.state_id
       -- except ALL
       -- SELECT connec_id, arc_id FROM connec_psector WHERE p_state = 0
       -- UNION ALL
       -- SELECT connec_id, arc_id FROM connec_psector WHERE p_state = 1
        ),
    connec_selected AS 
    	(
    	 SELECT connec.connec_id,
            connec.code,
            connec.customer_code,
            connec.top_elev,
            connec.y1,
            connec.y2,
            connec.connecat_id,
            connec.connec_type,
            cat_feature.system_id as sys_type,
            connec.private_connecat_id,
            connec.matcat_id,
            connec.state,
            connec.state_type,
            connec.expl_id,
            exploitation.macroexpl_id,
            CASE
                WHEN link_planned.sector_id IS NULL THEN connec.sector_id
                ELSE link_planned.sector_id
            END AS sector_id,
            sector_table.sector_type,
            CASE
                WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
                ELSE link_planned.macrosector_id
            END AS macrosector_id,
            CASE
                WHEN link_planned.drainzone_id IS NULL THEN connec.drainzone_id
                ELSE link_planned.drainzone_id
            END AS drainzone_id,
            CASE
                WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
                ELSE link_planned.drainzone_type
            END AS drainzone_type,
            connec.demand,
            connec.connec_depth,
            connec.connec_length,
            nn.arc_id,
            connec.annotation,
            connec.observ,
            connec.comment,
                CASE
                    WHEN link_planned.dma_id IS NULL THEN connec.dma_id
                    ELSE link_planned.dma_id
                END AS dma_id,
                CASE
                    WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
                    ELSE link_planned.macrodma_id
                END AS macrodma_id,
                CASE
                    WHEN link_planned.dma_type IS NULL THEN dma_table.dma_type
                    ELSE link_planned.dma_type
                END AS dma_type,
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
            connec.streetname,
            connec.postnumber,
            connec.postcomplement,
            connec.streetname2,
            connec.postnumber2,
            connec.postcomplement2,
            mu.region_id,
            mu.province_id,
            connec.descript,
            cat_connec.svg,
            connec.rotation,
            connec.link::text,
            connec.verified,
            connec.undelete,
            cat_connec.label,
            connec.label_x,
            connec.label_y,
            connec.label_rotation,
            connec.label_quadrant,
            connec.accessibility,
            connec.diagonal,
            connec.publish,
            connec.inventory,
            connec.uncertain,
            connec.num_value,
                CASE
                    WHEN link_planned.exit_id IS NULL THEN connec.pjoint_id
                    ELSE link_planned.exit_id
                END AS pjoint_id,
                CASE
                    WHEN link_planned.exit_type IS NULL THEN connec.pjoint_type
                    ELSE link_planned.exit_type
                END AS pjoint_type,
            connec.tstamp,
            connec.insert_user,
            connec.lastupdate,
            connec.lastupdate_user,
            connec.the_geom,
            connec.workcat_id_plan,
            connec.asset_id,
            connec.expl_id2,
            vst.is_operative,
            connec.minsector_id,
            connec.macrominsector_id,
            connec.adate,
            connec.adescript,
            connec.plot_code,
            connec.placement_type,
            connec.access_type
		   FROM connec_state nn
	       JOIN connec ON connec.connec_id = nn.connec_id
	       JOIN selector_expl se ON se.cur_user =current_user AND se.expl_id IN (connec.expl_id, connec.expl_id2)
	       JOIN selector_municipality sm ON sm.cur_user = current_user AND sm.muni_id =connec.muni_id 
	       JOIN selector_sector ss ON ss.cur_user = current_user AND ss.sector_id=connec.sector_id
	   	   JOIN cat_connec ON cat_connec.id::text = connec.connecat_id::text
		   JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
		   JOIN exploitation ON connec.expl_id = exploitation.expl_id
		   JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
		   JOIN value_state_type vst ON vst.id = connec.state_type
		   JOIN sector_table on sector_table.sector_id = connec.sector_id
		   left join dma_table on dma_table.dma_id = connec.dma_id 
	   	   left join drainzone_table ON connec.dma_id = drainzone_table.drainzone_id
	   	   left join link_planned on connec.connec_id = feature_id
	   )
	 SELECT connec_selected.*
	 FROM connec_selected;
	 
create or replace view v_edit_gully as
with
	typevalue AS 
       (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY(ARRAY['sector_type'::text, 'drainzone_type'::text, 'dma_type'::text, 'dwfzone_type'::text])
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
	drainzone_table as
		(
		select drainzone_id, name as drainzone_name, stylesheet, id::varchar(16) as drainzone_type from drainzone
		left JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	inp_network_mode AS 
    	(
         select value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ),  
    link_planned as 
    	(   	   	
    	select link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_name, macrosector_id, l.dma_id, dma_name, macrodma_id, 
    	l.drainzone_id, drainzone_name, fluid_type,
    	sector_type, drainzone_type, dma_type    	
    	from link l
    	join exploitation using (expl_id)
		JOIN sector_table ON l.sector_id = sector_table.sector_id
		left JOIN dma_table ON l.dma_id = dma_table.dma_id
	    left join drainzone_table ON l.dma_id = drainzone_table.drainzone_id
    	where l.state = 2
    	),   	
    gully_psector AS
        (
        SELECT pp.gully_id, pp.psector_id, pp.state AS p_state, FIRST_VALUE(pp.arc_id) OVER (PARTITION BY pp.gully_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS arc_id 
        FROM plan_psector_x_gully pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ),
    gully_state AS
        (
        SELECT gully_id, arc_id FROM gully c JOIN selector_state s ON s.cur_user =current_user AND c.state =s.state_id
       -- except ALL
       -- SELECT gully_id, arc_id FROM gully_psector WHERE p_state = 0
       -- UNION ALL
       -- SELECT gully_id, arc_id FROM gully_psector WHERE p_state = 1
        ),
    gully_selected AS 
    	(
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
	    gully.groove_height,
	    gully.groove_length,
	    gully.siphon,
	    gully.connec_arccat_id,
	    gully.connec_length,
	    CASE
	       WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
	       ELSE gully.connec_depth
	    END AS connec_depth,
	    CASE
            WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
	    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
	    gully.connec_y2,   
	    cat_grate.width AS grate_width,
	    cat_grate.length AS grate_length,
	    gully.arc_id,
	    gully.epa_type,
	    CASE
	       WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND inp_network_mode.value = '2'::text THEN gully.epa_type
	       ELSE NULL::character varying(16)
	    END AS inp_type,
		gully.state,
	    gully.state_type,    
 		gully.expl_id,
        exploitation.macroexpl_id,
		CASE
			WHEN link_planned.sector_id IS NULL THEN sector_table.sector_id
			ELSE link_planned.sector_id
		END AS sector_id,
		CASE
			WHEN link_planned.sector_id IS NULL THEN sector_table.sector_type
			ELSE link_planned.sector_type
		END AS sector_type,
		CASE
			WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
			ELSE link_planned.macrosector_id
		END AS macrosector_id,
		CASE
			WHEN link_planned.drainzone_id IS NULL THEN drainzone_table.drainzone_id
			ELSE link_planned.drainzone_id
		END AS drainzone_id,
		CASE
			WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
			ELSE link_planned.drainzone_type
		end as drainzone_type,
		CASE
			WHEN link_planned.dma_id IS NULL THEN dma_table.dma_id
			ELSE link_planned.dma_id
		END AS dma_id,           
		CASE
			WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
			ELSE link_planned.macrodma_id
		END AS macrodma_id,  
	    gully.annotation,
	    gully.observ,
	    gully.comment,
	    gully.soilcat_id,
	    gully.function_type,
	    gully.category_type,
	    gully.fluid_type,
	    gully.location_type,
	    gully.workcat_id,
	    gully.workcat_id_end,
	    gully.workcat_id_plan,
	    gully.buildercat_id,
	    gully.builtdate,
	    gully.enddate,
	    gully.ownercat_id,
	    gully.muni_id,
	    gully.postcode,
	    gully.district_id,
	    streetname,
	    gully.postnumber,
	    gully.postcomplement,
	    streetname2,
	    gully.postnumber2,
	    gully.postcomplement2,
	    mu.region_id,
	    mu.province_id,
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
	    gully.label_quadrant,
	    gully.publish,
	    gully.inventory,
	    gully.uncertain,
	    gully.num_value,
	   CASE
           WHEN link_planned.exit_id IS NULL THEN gully.pjoint_id
           ELSE link_planned.exit_id
       END AS pjoint_id,
       CASE
           WHEN link_planned.exit_type IS NULL THEN gully.pjoint_type
           ELSE link_planned.exit_type
       END AS pjoint_type,    
	    gully.asset_id,
	    gully.gratecat2_id,
	    gully.units_placement,    
	    gully.expl_id2,
	    vst.is_operative,
	    gully.minsector_id,
	    gully.macrominsector_id,
	    gully.adate,
	    gully.adescript,
	    gully.siphon_type,
	    gully.odorflap,
	    gully.placement_type,
	    gully.access_type,
	    date_trunc('second'::text, gully.tstamp) AS tstamp,
	    gully.insert_user,
	    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
	    gully.lastupdate_user,
	    gully.the_geom
	   FROM inp_network_mode, gully_state nn
	   JOIN gully ON gully.gully_id = nn.gully_id
	   JOIN selector_expl se ON se.cur_user =current_user AND se.expl_id IN (gully.expl_id, gully.expl_id2)
	   JOIN selector_municipality sm ON sm.cur_user = current_user AND sm.muni_id =gully.muni_id 
	   JOIN selector_sector ss ON ss.cur_user = current_user AND ss.sector_id=gully.sector_id
	   JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
	   JOIN exploitation ON gully.expl_id = exploitation.expl_id
	   JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
	   JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
	   JOIN value_state_type vst ON vst.id = gully.state_type
	   JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
	   JOIN sector_table ON gully.sector_id = sector_table.sector_id
	   LEFT JOIN dma_table ON gully.dma_id = dma_table.dma_id  
	   LEFT JOIN drainzone_table ON gully.dma_id = drainzone_table.drainzone_id
	   LEFT JOIN link_planned on gully.gully_id = feature_id
	   )
	 SELECT gully_selected.*
	 FROM gully_selected;
	 

create or replace view v_edit_link as
WITH 
	 typevalue AS 
       (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	drainzone_table as
		(
		select drainzone_id, name as drainzone_name, stylesheet, id::varchar(16) as drainzone_type from drainzone
		left JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
     inp_network_mode AS 
    	(
         select value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ),
     link_psector AS
        (
        SELECT pp.connec_id AS feature_id, 'CONNEC' AS feature_type, pp.psector_id, pp.state AS p_state, pp.arc_id as arc_id_original, pp.link_id as link_id_original, 
        FIRST_VALUE(pp.link_id) OVER (PARTITION BY pp.connec_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS link_id   
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        UNION ALL 
        SELECT pp.gully_id AS feature_id, 'GULLY' AS feature_type, pp.psector_id, pp.state AS p_state, pp.arc_id as arc_id_original, pp.link_id as link_id_original, 
        FIRST_VALUE(pp.link_id) OVER (PARTITION BY pp.gully_id, pp.state ORDER BY link_id DESC NULLS LAST, arc_id::int DESC NULLS LAST) AS link_id
        FROM plan_psector_x_gully pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ),
    link_state AS
        (
        SELECT n.link_id 
        FROM link n
        JOIN selector_state s ON s.cur_user =current_user AND n.state =s.state_id
       -- except ALL
       -- SELECT link_id FROM link_psector WHERE p_state = 0
       -- UNION ALL
       -- SELECT link_id FROM link_psector WHERE p_state = 1
        ),
    link_selected as
    	(select DISTINCT ON (l.link_id) l.link_id,
	    l.feature_type,
	    l.feature_id,
	    l.exit_type,
	    l.exit_id,
	    l.state,
	    l.expl_id,
	    macroexpl_id,
	    l.sector_id,
	    sector_type,
	    macrosector_id,
	    l.muni_id,
	    l.drainzone_id,
	    drainzone_type,
	    l.dma_id,
	    macrodma_id,
	    l.exit_topelev,
	    l.exit_elev,
	    l.fluid_type,
	    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
	    l.the_geom,
	    sector_name,
	    dma_name,
	    l.expl_id2,
	    l.epa_type,
	    l.is_operative,
	    l.connecat_id,
	    l.workcat_id,
	    l.workcat_id_end,
	    l.builtdate,
	    l.enddate,
	    date_trunc('second'::text, l.lastupdate) AS lastupdate,
	    l.lastupdate_user,
	    l.uncertain
	    from inp_network_mode, link_state
	    JOIN link l using (link_id)
	    JOIN selector_expl se ON se.cur_user =current_user AND se.expl_id IN (l.expl_id, l.expl_id2)
        JOIN selector_municipality sm ON sm.cur_user = current_user AND sm.muni_id =l.muni_id 
	    JOIN selector_sector ss ON ss.cur_user = current_user AND ss.sector_id=l.sector_id
	    JOIN exploitation ON l.expl_id = exploitation.expl_id
	    JOIN ext_municipality mu ON l.muni_id = mu.muni_id
	    JOIN sector_table ON l.sector_id = sector_table.sector_id
	    LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id  
	    LEFT join drainzone_table ON l.dma_id = drainzone_table.drainzone_id)
     SELECT link_selected.*
	 FROM link_selected;	
  
	drop view v_edit_link_connec;
	create or replace view v_edit_link_connec as select * from v_edit_link where feature_type = 'CONNEC';

	drop view v_edit_link_gully;
	create or replace view v_edit_link_gully as select * from v_edit_link where feature_type = 'GULLY'; 
	
	