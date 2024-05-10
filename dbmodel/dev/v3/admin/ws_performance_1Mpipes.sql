/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
 
 -- remove join to nodes on arc view
 create or replace view ws1_2802.vu_arc as
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    null::numeric(12,4) AS elevation1,
    null::numeric(12,4) AS depth1,
    null::numeric(12,4) AS elevation2,
    null::numeric(12,4) AS depth2,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.minsector_id,
    arc.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    arc.presszone_id,
    presszone.name AS presszone_name,
    arc.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    c.descript::character varying(100) AS streetname2,
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
    arc.num_value,
    cat_arc.arctype_id AS cat_arctype_id,
    null::varchar(30) AS nodetype_1,
    null::numeric(12,3) AS staticpress1,
    null::varchar(30) AS nodetype_2,
    null::numeric(12,3) AS staticpress2,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.depth,
    arc.adate,
    arc.adescript,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    arc.workcat_id_plan,
    arc.asset_id,
	arc.pavcat_id
   FROM ws1_2802.arc
     LEFT JOIN ws1_2802.sector ON arc.sector_id = sector.sector_id
     LEFT JOIN ws1_2802.exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN ws1_2802.cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN ws1_2802.cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
     LEFT JOIN ws1_2802.dma ON arc.dma_id = dma.dma_id
     LEFT JOIN ws1_2802.dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN ws1_2802.presszone ON presszone.presszone_id::text = arc.presszone_id::text
     LEFT JOIN ws1_2802.v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN ws1_2802.v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text
  
 -- remove plan psector strategy
CREATE OR REPLACE VIEW ws1_2802.v_state_arc AS 
         SELECT arc.arc_id
           FROM ws1_2802.selector_state,
            ws1_2802.selector_expl,
            ws1_2802.arc
          WHERE arc.state = selector_state.state_id AND arc.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text
		  AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ws1_2802.v_state_node AS 
         SELECT node.node_id
           FROM ws1_2802.selector_state,
            ws1_2802.selector_expl,
            ws1_2802.node
          WHERE node.state = selector_state.state_id AND node.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text
		  AND selector_expl.cur_user = "current_user"()::text;

   
   CREATE OR REPLACE VIEW ws1_2802.v_state_connec AS 
                SELECT connec.connec_id,
                    connec.arc_id
                   FROM ws1_2802.selector_state,
                    ws1_2802.selector_expl,
                    ws1_2802.connec
                  WHERE connec.state = selector_state.state_id AND connec.expl_id = selector_expl.expl_id 
				  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text


-- refactor of v_edit_link 
create or replace view ws1_2802.v_edit_link as
SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    null::integer as macrosector_id,
    null::integer as macrodma_id,
    link.exit_type,
    link.exit_id,
    c.sector_id,
    c.dma_id,
    c.expl_id,
    c.state,
    st_length2d(link.the_geom) AS gis_length,
    NULL::boolean AS userdefined_geom,
    link.the_geom,
    1 AS link_class,
    NULL::integer AS psector_rowid,
    c.fluid_type,
    link.vnode_topelev
   FROM ws1_2802.selector_state,ws1_2802.selector_expl,
    ws1_2802.link
     JOIN ws1_2802.connec c ON link.feature_id::text = c.connec_id::text
  WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = link.state
    and selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = c.expl_id;

