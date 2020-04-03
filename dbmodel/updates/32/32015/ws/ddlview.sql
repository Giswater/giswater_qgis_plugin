/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_coordinates AS 
 SELECT rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
   FROM rpt_inp_node, inp_selector_result a
   WHERE a.result_id=rpt_inp_node.result_id AND cur_user=current_user;
   

CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN rpt_inp_arc.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE rpt_inp_arc.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text
  AND (rpt_inp_arc.arc_type = 'VARC' or rpt_inp_arc.arc_type = 'PIPE')
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN inp_shortpipe.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE inp_shortpipe.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_shortpipe.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text;

  
CREATE OR REPLACE VIEW vu_node AS 
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id,
    node_type.type AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.dma_id,
    node.presszonecat_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.buildercat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.streetaxis_id,
    node.postnumber,
    node.postcomplement,
    node.postcomplement2,
    node.streetaxis2_id,
    node.postnumber2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(node_type.link_path, node.link) AS link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    dma.macrodma_id,
    node.expl_id,
    node.hemisphere,
    node.num_value,
    node.minsector_id,
    node.dqa_id,
    dqa.macrodqa_id,
    node.staticpressure,
    cat_node.label
   FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN node_type ON node_type.id::text = cat_node.nodetype_id::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id; 

CREATE OR REPLACE VIEW v_arc AS 
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    a.elevation AS elevation1,
    a.depth AS depth1,
    b.elevation AS elevation2,
    b.depth AS depth2,
    arc.arccat_id,
    cat_arc.arctype_id,
    arc_type.type AS sys_type,
    cat_arc.matcat_id,
    cat_arc.pnom,
    cat_arc.dnom,
    arc.epa_type,
    arc.sector_id,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.dma_id,
    arc.presszonecat_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.streetaxis_id,
    arc.postnumber,
    arc.postcomplement,
    arc.postcomplement2,
    arc.streetaxis2_id,
    arc.postnumber2,
    arc.descript,
    concat(arc_type.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    dma.macrodma_id,
    arc.expl_id,
    arc.num_value,
    arc.builtdate,
        CASE
            WHEN arc.custom_length IS NOT NULL THEN arc.custom_length::numeric(12,3)
            ELSE st_length2d(arc.the_geom)::numeric(12,3)
        END AS length,
    arc.the_geom,
    arc.minsector_id,
    arc.dqa_id,
    dqa.macrodqa_id,
    cat_arc.label,
    cat_arc.arctype_id AS arc_type,
    a.nodetype_id AS nodetype_1,
    a.staticpressure AS staticpress1,
    b.nodetype_id AS nodetype_2,
    b.staticpressure AS staticpress2,
    arc.lastupdate,
    arc.lastupdate_user,
    arc.insert_user
   FROM arc
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     JOIN v_state_arc ON arc.arc_id::text = v_state_arc.arc_id::text
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN arc_type ON arc_type.id::text = cat_arc.arctype_id::text
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id;

	 
	 
CREATE OR REPLACE VIEW v_edit_arc AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.arccat_id,
    v_arc.arctype_id AS cat_arctype_id,
    v_arc.sys_type,
    v_arc.matcat_id AS cat_matcat_id,
    v_arc.pnom AS cat_pnom,
    v_arc.dnom AS cat_dnom,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.label,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.presszonecat_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetaxis_id,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.postcomplement2,
    v_arc.streetaxis2_id,
    v_arc.postnumber2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value,
    v_arc.minsector_id,
    v_arc.dqa_id,
    v_arc.macrodqa_id,
    v_arc.arc_type,
    v_arc.nodetype_1,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.staticpress1,   
    v_arc.nodetype_2,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.staticpress2,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.insert_user
   FROM v_arc;
	 
	 
CREATE OR REPLACE VIEW v_node AS 
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id,
    node_type.type AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.dma_id,
    node.presszonecat_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.buildercat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.streetaxis_id,
    node.postnumber,
    node.postcomplement,
    node.postcomplement2,
    node.streetaxis2_id,
    node.postnumber2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(node_type.link_path, node.link) AS link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    dma.macrodma_id,
    node.expl_id,
    node.hemisphere,
    node.num_value,
	node.minsector_id,
	node.dqa_id,
	dqa.macrodqa_id,
	node.staticpressure,
	cat_node.label,
    cat_node.nodetype_id AS node_type,
    node.lastupdate,
    node.lastupdate_user,
    node.insert_user
   FROM node
     JOIN v_state_node ON v_state_node.node_id::text = node.node_id::text
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN node_type ON node_type.id::text = cat_node.nodetype_id::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id
     LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id;


	 
CREATE OR REPLACE VIEW v_edit_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.label,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.buildercat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
	v_node.minsector_id,
	v_node.dqa_id,
	v_node.macrodqa_id,
	v_node.staticpressure,
    v_node.node_type,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.insert_user
   FROM v_node;


CREATE OR REPLACE VIEW v_state_connec AS 
SELECT DISTINCT ON (connec_id) 
connec_id, arc_id FROM (SELECT connec.connec_id,
            connec.arc_id,
            1 as flag
           FROM selector_state,
            selector_expl,
            connec
          WHERE connec.state = selector_state.state_id AND connec.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
        EXCEPT
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.arc_id,
            1 as flag
           FROM selector_psector,
            selector_expl,
            plan_psector_x_connec
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
          WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 
		  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
      UNION
 SELECT plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    2 as flag
   FROM selector_psector,
    selector_expl,
    plan_psector_x_connec
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 
  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text ORDER BY 1 ,3 DESC)a;
  

CREATE OR REPLACE VIEW v_edit_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec_type.type AS sys_type,
    connec.connecat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    cat_connec.label,
    connec.dma_id,
    connec.presszonecat_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    v_state_connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
	connec.minsector_id,
	connec.dqa_id,
	dqa.macrodqa_id,
	connec.staticpressure,
    cat_connec.connectype_id AS connec_type,
	connec.featurecat_id,
	connec.feature_id,
	connec.pjoint_type,
	connec.pjoint_id,
    connec.lastupdate,
    connec.lastupdate_user,
    connec.insert_user,
    a.n_hydrometer
	FROM connec
	   LEFT JOIN (SELECT connec.connec_id,
	   count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		FROM ext_rtc_hydrometer
		JOIN connec ON ext_rtc_hydrometer.connec_id::text=connec.customer_code
		GROUP BY connec.connec_id) a USING (connec_id)
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text     
	 LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id;
	 

DROP VIEW IF EXISTS v_edit_link;
CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
	    sector.macrosector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
	    dma.macrodma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
        CASE
            WHEN plan_psector_x_connec.link_geom IS NULL THEN link.the_geom
            ELSE plan_psector_x_connec.link_geom
        END AS the_geom
   FROM link
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     JOIN v_edit_connec ON link.feature_id::text = v_edit_connec.connec_id::text
     JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = v_edit_connec.sector_id::text
     JOIN dma ON dma.dma_id::text = v_edit_connec.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id);
	 

DROP VIEW IF EXISTS v_edit_vnode;
CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT DISTINCT ON (vnode_id) vnode.vnode_id,
    vnode.vnode_type,
	vnode.elev,
    vnode.sector_id,
    vnode.dma_id,
    vnode.state,
    vnode.annotation,
    case when plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom ELSE plan_psector_x_connec.vnode_geom END AS the_geom, 
    vnode.expl_id,
    vnode.rotation
   FROM vnode 
   JOIN v_edit_link ON exit_id::integer=vnode_id AND exit_type='VNODE'
   join v_edit_connec ON v_edit_link.feature_id=connec_id
   join arc USING (arc_id)
   left join plan_psector_x_connec USING (arc_id, connec_id);
   
CREATE OR REPLACE VIEW v_plan_node AS 
SELECT
v_edit_node.node_id,
nodecat_id,
sys_type AS node_type,
elevation AS top_elev,
elevation-depth as elev,
epa_type,
sector_id,
state,
annotation,
the_geom,
v_price_x_catnode.cost_unit,
v_price_compost.descript,
v_price_compost.price as cost,
CASE WHEN v_price_x_catnode.cost_unit::text = 'u' THEN (CASE WHEN sys_type='PUMP' THEN (CASE WHEN pump_number IS NOT NULL THEN pump_number ELSE 1 END) ELSE 1 END)
     WHEN v_price_x_catnode.cost_unit::text = 'm3' THEN (CASE WHEN sys_type='TANK' THEN vmax ELSE NULL END)
     WHEN v_price_x_catnode.cost_unit::text = 'm' THEN (CASE WHEN v_edit_node.depth = 0 THEN v_price_x_catnode.estimated_depth 
															 WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth ELSE v_edit_node.depth END)
END::numeric(12,2) AS measurement,
CASE WHEN v_price_x_catnode.cost_unit::text = 'u' THEN (CASE WHEN sys_type='PUMP' THEN (CASE WHEN pump_number IS NOT NULL THEN pump_number ELSE 1 END) ELSE 1 END)*v_price_x_catnode.cost
     WHEN v_price_x_catnode.cost_unit::text = 'm3' THEN (CASE WHEN sys_type='TANK' THEN vmax ELSE NULL END)*v_price_x_catnode.cost
     WHEN v_price_x_catnode.cost_unit::text = 'm' THEN (CASE WHEN v_edit_node.depth = 0 THEN v_price_x_catnode.estimated_depth
															 WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth ELSE v_edit_node.depth END)*v_price_x_catnode.cost
END::numeric(12,2) AS budget,
expl_id
FROM v_edit_node
LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
LEFT JOIN man_tank ON man_tank.node_id=v_edit_node.node_id
LEFT JOIN man_pump ON man_pump.node_id=v_edit_node.node_id
JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text;



CREATE OR REPLACE VIEW ve_arc AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.arccat_id,
    v_arc.arctype_id AS cat_arctype_id,
    v_arc.sys_type,
    v_arc.matcat_id AS cat_matcat_id,
    v_arc.pnom AS cat_pnom,
    v_arc.dnom AS cat_dnom,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.label,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.presszonecat_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetaxis_id,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.postcomplement2,
    v_arc.streetaxis2_id,
    v_arc.postnumber2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value,
    v_arc.minsector_id,
    v_arc.dqa_id,
    v_arc.macrodqa_id,
    v_arc.arc_type,
    v_arc.nodetype_1,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.staticpress2,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.insert_user
   FROM v_arc;

	 
CREATE OR REPLACE VIEW ve_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.label,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.buildercat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
	v_node.minsector_id,
	v_node.dqa_id,
	v_node.macrodqa_id,
	v_node.staticpressure,
    v_node.node_type,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.insert_user
   FROM v_node;

   
CREATE OR REPLACE VIEW ve_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec_type.type AS sys_type,
    connec.connecat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    cat_connec.label,
    connec.dma_id,
    connec.presszonecat_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    connec.minsector_id,
    connec.dqa_id,
    dqa.macrodqa_id,
    connec.staticpressure,
    connec.featurecat_id,
    connec.feature_id,
    connec.pjoint_type,
    connec.pjoint_id,
    cat_connec.connectype_id as connec_type,
    connec.lastupdate,
    connec.lastupdate_user,
    connec.insert_user,
    a.n_hydrometer	
   FROM connec
	   LEFT JOIN (SELECT connec.connec_id,
	   count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		FROM ext_rtc_hydrometer
		JOIN connec ON ext_rtc_hydrometer.connec_id::text=connec.customer_code
		GROUP BY connec.connec_id) a USING (connec_id)
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id;
	 
	 
CREATE OR REPLACE VIEW v_edit_man_fountain AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec.connecat_id,
    cat_connec.matcat_id,
    cat_connec.pnom,
    cat_connec.dnom,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    a.n_hydrometer,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    connec.presszonecat_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.connec_length,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    man_fountain.pol_id,
    man_fountain.linked_connec,
    man_fountain.vmax,
    man_fountain.vtotal,
    man_fountain.container_number,
    man_fountain.pump_number,
    man_fountain.power,
    man_fountain.regulation_tank,
    man_fountain.chlorinator,
    man_fountain.arq_patrimony,
    man_fountain.name
   FROM connec
	 LEFT JOIN (SELECT connec.connec_id,
	   count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		FROM ext_rtc_hydrometer
		JOIN connec ON ext_rtc_hydrometer.connec_id::text=connec.customer_code
		GROUP BY connec.connec_id) a USING (connec_id)    
   LEFT JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
   JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
   JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
   JOIN dma ON connec.dma_id = dma.dma_id
   LEFT JOIN sector ON connec.sector_id = sector.sector_id
   JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text;




CREATE OR REPLACE VIEW v_edit_man_greentap AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec.connecat_id,
    cat_connec.matcat_id,
    cat_connec.pnom,
    cat_connec.dnom,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    a.n_hydrometer,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    connec.presszonecat_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.connec_length,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    man_greentap.linked_connec
   FROM connec
	 LEFT JOIN (SELECT connec.connec_id,
	   count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		FROM ext_rtc_hydrometer
		JOIN connec ON ext_rtc_hydrometer.connec_id::text=connec.customer_code
		GROUP BY connec.connec_id) a USING (connec_id)    
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     JOIN man_greentap ON man_greentap.connec_id::text = connec.connec_id::text;


CREATE OR REPLACE VIEW v_edit_man_tap AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec.connecat_id,
    cat_connec.matcat_id,
    cat_connec.pnom,
    cat_connec.dnom,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    a.n_hydrometer,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    connec.presszonecat_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.connec_length,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    man_tap.linked_connec,
    man_tap.cat_valve,
    man_tap.drain_diam,
    man_tap.drain_exit,
    man_tap.drain_gully,
    man_tap.drain_distance,
    man_tap.arq_patrimony,
    man_tap.com_state
   FROM connec
	 LEFT JOIN (SELECT connec.connec_id,
	   count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		FROM ext_rtc_hydrometer
		JOIN connec ON ext_rtc_hydrometer.connec_id::text=connec.customer_code
		GROUP BY connec.connec_id) a USING (connec_id)  
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     JOIN man_tap ON man_tap.connec_id::text = connec.connec_id::text;



CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec.connecat_id,
    cat_connec.matcat_id,
    cat_connec.pnom,
    cat_connec.dnom,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    a.n_hydrometer,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    connec.presszonecat_id,
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
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.connec_length,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    man_wjoin.top_floor,
    man_wjoin.cat_valve
   FROM connec
	 LEFT JOIN (SELECT connec.connec_id,
	   count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		FROM ext_rtc_hydrometer
		JOIN connec ON ext_rtc_hydrometer.connec_id::text=connec.customer_code
		GROUP BY connec.connec_id) a USING (connec_id)    
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     JOIN man_wjoin ON man_wjoin.connec_id::text = connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id;
	 
	 
-- DROP commented on 19/10/2019 becasuse it is used on corporate environtment. On 3.3.007 will be created again for those of that was removed
-- DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
	 
	
	



