/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--DROP commented on 19/10/2019 becasuse it is used on corporate environtment. On 3.3.007 will be created again for those of that was removed
--DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;

CREATE OR REPLACE VIEW v_state_connec AS 
SELECT DISTINCT ON (connec_id) 
connec_id::varchar(30), arc_id FROM (SELECT connec.connec_id,
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
  
  

CREATE OR REPLACE VIEW v_state_gully AS 
SELECT DISTINCT ON (gully_id) 
gully_id, arc_id FROM ( SELECT gully.gully_id, arc_id,
			1 as flag
           FROM selector_state,
            selector_expl,
            gully
          WHERE gully.state = selector_state.state_id AND gully.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
        EXCEPT
         SELECT plan_psector_x_gully.gully_id, plan_psector_x_gully.arc_id,
		1 as flag
           FROM selector_psector,
            selector_expl,
            plan_psector_x_gully
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
          WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
 UNION
 SELECT plan_psector_x_gully.gully_id, plan_psector_x_gully.arc_id,
    2 as flag
   FROM selector_psector,
    selector_expl,
    plan_psector_x_gully
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 1 
  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text ORDER BY 1 ,3 DESC)a;

  

CREATE OR REPLACE VIEW v_arc AS 
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    arc.y1,
    arc.y2,
    arc.custom_y1,
    arc.custom_y2,
    arc.elev1,
    arc.elev2,
    arc.custom_elev1,
    arc.custom_elev2,
    arc.sys_elev1,
    arc.sys_elev2,
    arc.sys_slope,
    arc.arc_type,
    arc.arccat_id,
    cat_arc.matcat_id,
    cat_arc.shape,
    cat_arc.geom1,
    cat_arc.geom2,
    cat_arc.width,
    arc.epa_type,
    arc.sector_id,
    arc.builtdate,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.observ,
    arc.comment,
    arc.inverted_slope,
    arc.custom_length,
    arc.dma_id,
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
    arc.link,
    arc.verified,
    arc.the_geom,
    arc.undelete,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.expl_id,
    arc.num_value,
    arc.lastupdate,
    arc.lastupdate_user,
    arc.insert_user
   FROM selector_expl,
    arc
     JOIN v_state_arc ON arc.arc_id::text = v_state_arc.arc_id::text
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
  WHERE arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_node AS 
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
    node_type.type AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    node.epa_type,
    node.sector_id,
    sector.macrosector_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.dma_id,
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
    node.uncertain,
    node.xyz_date,
    node.unconnected,
    dma.macrodma_id,
    node.expl_id,
    node.num_value,
    node.lastupdate,
    node.lastupdate_user,
    node.insert_user
   FROM node
     JOIN v_state_node ON node.node_id::text = v_state_node.node_id::text
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN node_type ON node_type.id::text = node.node_type::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id;

CREATE OR REPLACE VIEW v_edit_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    connec_type.type AS sys_type,
    connec.private_connecat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
    connec.connec_depth,
    connec.connec_length,
    v_state_connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    cat_connec.label,
    connec.dma_id,
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
    cat_connec.svg,
    connec.rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.featurecat_id,
    connec.feature_id,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
	pjoint_type,
	pjoint_id,
    connec.lastupdate,
    connec.lastupdate_user
   FROM connec
     JOIN v_state_connec ON connec.connec_id::text = v_state_connec.connec_id::text
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN connec_type ON connec.connec_type::text = connec_type.id::text; 

	 

CREATE OR REPLACE VIEW v_edit_gully AS 
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    gully_type.type AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    gully.units,
    gully.groove,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.connec_depth,
    v_state_gully.arc_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    cat_grate.label,
    gully.dma_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.streetaxis_id,
    gully.postnumber,
    gully.postcomplement,
    gully.streetaxis2_id,
    gully.postnumber2,
    gully.postcomplement2,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(gully_type.link_path, gully.link) AS link,
    gully.verified,
    gully.the_geom,
    gully.undelete,
    gully.featurecat_id,
    gully.feature_id,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.publish,
    gully.inventory,
    gully.expl_id,
    dma.macrodma_id,
    gully.uncertain,
    gully.num_value,
	pjoint_type,
	pjoint_id,
    gully.lastupdate,
    gully.lastupdate_user
   FROM gully
     JOIN v_state_gully ON gully.gully_id::text = v_state_gully.gully_id::text
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN gully_type ON gully.gully_type::text = gully_type.id::text;
  

-- View: v_edit_link

-- DROP VIEW v_edit_link;

CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    sector.macrosector_id,
    dma.macrodma_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
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
        END AS the_geom,
        CASE
            WHEN plan_psector_x_connec.link_geom IS NULL THEN false
            ELSE true
        END AS ispsectorgeom
   FROM link
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     JOIN v_edit_connec ON link.feature_id::text = v_edit_connec.connec_id::text
     JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = v_edit_connec.sector_id::text
     JOIN dma ON dma.dma_id::text = v_edit_connec.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
UNION
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    sector.macrosector_id,
    dma.macrodma_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
        CASE
            WHEN plan_psector_x_gully.link_geom IS NULL THEN link.the_geom
            ELSE plan_psector_x_gully.link_geom
        END AS the_geom,
        CASE
            WHEN plan_psector_x_gully.link_geom IS NULL THEN false
            ELSE true
        END AS ispsectorgeom
   FROM link
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     JOIN v_edit_gully ON link.feature_id::text = v_edit_gully.gully_id::text
     JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = v_edit_gully.sector_id::text
     JOIN dma ON dma.dma_id::text = v_edit_gully.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
     LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id);



DROP VIEW v_edit_vnode;
CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT DISTINCT ON (vnode_id) vnode.vnode_id,
    vnode.vnode_type,
    vnode.top_elev,
    vnode.sector_id,
    vnode.dma_id,
    vnode.state,
    vnode.annotation,
        CASE
            WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
            ELSE plan_psector_x_connec.vnode_geom
        END AS the_geom,
    vnode.expl_id,
    vnode.rotation
   FROM vnode
     JOIN v_edit_link ON v_edit_link.exit_id::integer = vnode.vnode_id AND v_edit_link.exit_type::text = 'VNODE'::text
     JOIN v_edit_connec ON v_edit_link.feature_id::text = v_edit_connec.connec_id::text
     JOIN arc USING (arc_id)
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
UNION
 SELECT vnode.vnode_id,
    vnode.vnode_type,
    vnode.top_elev,
    vnode.sector_id,
    vnode.dma_id,
    vnode.state,
    vnode.annotation,
        CASE
            WHEN plan_psector_x_gully.vnode_geom IS NULL THEN vnode.the_geom
            ELSE plan_psector_x_gully.vnode_geom
        END AS the_geom,
    vnode.expl_id,
    vnode.rotation
   FROM vnode
     JOIN v_edit_link ON v_edit_link.exit_id::integer = vnode.vnode_id AND v_edit_link.exit_type::text = 'VNODE'::text
     JOIN v_edit_gully ON v_edit_link.feature_id::text = v_edit_gully.gully_id::text
     JOIN arc USING (arc_id)
     LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id);
	 
	 
CREATE OR REPLACE VIEW v_arc_x_vnode AS
SELECT vnode_id, arc_id, a.feature_type, feature_id, 
node_1,
node_2,
(length*locate)::numeric(12,3) AS vnode_distfromnode1,
(length*(1-locate))::numeric(12,3) AS vnode_distfromnode2,
(top_elev1 - locate*(top_elev1-top_elev2))::numeric (12,3) as vnode_topelev,
(sys_y1 - locate*(sys_y1-sys_y2))::numeric (12,3) as vnode_ymax,
(sys_elev1 - locate*(sys_elev1-sys_elev2))::numeric (12,3) as vnode_elev
FROM (
SELECT vnode_id, arc_id, a.feature_type, feature_id,
st_length(v_edit_arc.the_geom) as length,
st_linelocatepoint (v_edit_arc.the_geom , vnode.the_geom)::numeric(12,3) as locate,
node_1,
node_2,
sys_elev1,
sys_elev2,
sys_y1,
sys_y2,
sys_elev1 + sys_y1 AS top_elev1,
sys_elev2 + sys_y2 AS top_elev2
from v_edit_arc , vnode 
JOIN v_edit_link a ON vnode_id=exit_id::integer
where st_dwithin ( v_edit_arc.the_geom, vnode.the_geom, 0.01) 
and v_edit_arc.state>0 and vnode.state>0
) a
order by 2,6 desc;
   
  
 CREATE OR REPLACE VIEW v_edit_subcatchment AS 
 SELECT subcatchment.subc_id,
    subcatchment.outlet_id,
    subcatchment.rg_id,
    subcatchment.area,
    subcatchment.imperv,
    subcatchment.width,
    subcatchment.slope,
    subcatchment.clength,
    subcatchment.snow_id,
    subcatchment.nimp,
    subcatchment.nperv,
    subcatchment.simp,
    subcatchment.sperv,
    subcatchment.zero,
    subcatchment.routeto,
    subcatchment.rted,
    subcatchment.maxrate,
    subcatchment.minrate,
    subcatchment.decay,
    subcatchment.drytime,
    subcatchment.maxinfil,
    subcatchment.suction,
    subcatchment.conduct,
    subcatchment.initdef,
    subcatchment.curveno,
    subcatchment.conduct_2,
    subcatchment.drytime_2,
    subcatchment.sector_id,
    subcatchment.hydrology_id,
    subcatchment.the_geom,
    subcatchment.descript
   FROM inp_selector_sector,  inp_selector_hydrology, subcatchment
  WHERE subcatchment.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text 
  AND subcatchment.hydrology_id = inp_selector_hydrology.hydrology_id AND inp_selector_hydrology.cur_user = "current_user"()::text;

 
  
CREATE OR REPLACE VIEW vi_coverages AS 
 SELECT v_edit_subcatchment.subc_id,
    inp_coverage_land_x_subc.landus_id,
    inp_coverage_land_x_subc.percent
   FROM inp_coverage_land_x_subc
     JOIN v_edit_subcatchment ON inp_coverage_land_x_subc.subc_id::text = v_edit_subcatchment.subc_id::text
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, v_node.node_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS node_array, * 
			FROM subcatchment where left (outlet_id,1)='{' ) a JOIN v_node ON v_node.node_id::text = a.node_array::text) b 
			ON v_edit_subcatchment.subc_id=b.subc_id;
		

CREATE OR REPLACE VIEW vi_groundwater AS 
 SELECT inp_groundwater.subc_id,
    inp_groundwater.aquif_id,
    inp_groundwater.node_id,
    inp_groundwater.surfel,
    inp_groundwater.a1,
    inp_groundwater.b1,
    inp_groundwater.a2,
    inp_groundwater.b2,
    inp_groundwater.a3,
    inp_groundwater.tw,
    inp_groundwater.h
   FROM v_edit_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_subcatchment.subc_id::text
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, v_node.node_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS node_array, * 
			FROM subcatchment where left (outlet_id,1)='{' ) a JOIN v_node ON v_node.node_id::text = a.node_array::text) b 
			ON v_edit_subcatchment.subc_id=b.subc_id;

  

CREATE OR REPLACE VIEW vi_infiltration AS 
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.curveno AS other1,
    v_edit_subcatchment.conduct_2 AS other2,
    v_edit_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, v_node.node_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS node_array, * 
			FROM subcatchment where left (outlet_id,1)='{' ) a JOIN v_node ON v_node.node_id::text = a.node_array::text) b 
			ON v_edit_subcatchment.subc_id=b.subc_id
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.suction AS other1,
    v_edit_subcatchment.conduct AS other2,
    v_edit_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, v_node.node_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS node_array, * 
			FROM subcatchment where left (outlet_id,1)='{' ) a JOIN v_node ON v_node.node_id::text = a.node_array::text) b 
			ON v_edit_subcatchment.subc_id=b.subc_id
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.maxrate AS other1,
    v_edit_subcatchment.minrate AS other2,
    v_edit_subcatchment.decay AS other3,
    v_edit_subcatchment.drytime AS other4,
    v_edit_subcatchment.maxinfil AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, v_node.node_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS node_array, * 
			FROM subcatchment where left (outlet_id,1)='{' ) a JOIN v_node ON v_node.node_id::text = a.node_array::text) b 
			ON v_edit_subcatchment.subc_id=b.subc_id
  WHERE cat_hydrology.infiltration::text = 'MODIFIED_HORTON'::text OR cat_hydrology.infiltration::text = 'HORTON'::text
  ORDER BY 2;
 
 
CREATE OR REPLACE VIEW vi_lid_usage AS 
 SELECT inp_lidusage_subc_x_lidco.subc_id,
    inp_lidusage_subc_x_lidco.lidco_id,
    inp_lidusage_subc_x_lidco.number::integer AS number,
    inp_lidusage_subc_x_lidco.area,
    inp_lidusage_subc_x_lidco.width,
    inp_lidusage_subc_x_lidco.initsat,
    inp_lidusage_subc_x_lidco.fromimp,
    inp_lidusage_subc_x_lidco.toperv::integer AS toperv,
    inp_lidusage_subc_x_lidco.rptfile
   FROM v_edit_subcatchment
     JOIN inp_lidusage_subc_x_lidco ON inp_lidusage_subc_x_lidco.subc_id::text = v_edit_subcatchment.subc_id::text;
 
CREATE OR REPLACE VIEW vi_gwf AS 
 SELECT inp_groundwater.subc_id,
    ('LATERAL'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_lat,
    ('DEEP'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_deep
   FROM v_edit_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_subcatchment.subc_id::text;

 
 
CREATE OR REPLACE VIEW vi_loadings AS 
 SELECT inp_loadings_pol_x_subc.subc_id,
    inp_loadings_pol_x_subc.poll_id,
    inp_loadings_pol_x_subc.ibuildup
   FROM v_edit_subcatchment
     JOIN inp_loadings_pol_x_subc ON inp_loadings_pol_x_subc.subc_id::text = v_edit_subcatchment.subc_id::text;
     
 
 CREATE OR REPLACE VIEW vi_subareas AS 
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.nimp,
    v_edit_subcatchment.nperv,
    v_edit_subcatchment.simp,
    v_edit_subcatchment.sperv,
    v_edit_subcatchment.zero,
    v_edit_subcatchment.routeto,
    v_edit_subcatchment.rted
   FROM v_edit_subcatchment;

  
CREATE OR REPLACE VIEW vi_subcatchments AS 
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.rg_id,
        CASE
            WHEN b.outlet_id IS NOT NULL THEN b.outlet_id::varchar(16)
			WHEN c.outlet_id IS NOT NULL THEN c.outlet_id::varchar(16)
            ELSE v_edit_subcatchment.outlet_id
        END AS outlet_id,
    v_edit_subcatchment.area,
    v_edit_subcatchment.imperv,
    v_edit_subcatchment.width,
    v_edit_subcatchment.slope,
    v_edit_subcatchment.clength,
    v_edit_subcatchment.snow_id
   FROM v_edit_subcatchment
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, node_array as outlet_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS node_array, subc_id FROM subcatchment where left (outlet_id,1)='{' ) a 
		   JOIN rpt_inp_node b ON b.node_id::text = a.node_array::text WHERE result_id = (SELECT result_id FROM inp_selector_result WHERE cur_user=current_user)) b 
			ON v_edit_subcatchment.subc_id=b.subc_id
	 LEFT JOIN  (SELECT DISTINCT ON (subc_id) subc_id, parent_array as outlet_id FROM 
		   (SELECT unnest(subcatchment.outlet_id::text[]) AS parent_array, subc_id 
			FROM subcatchment where left (outlet_id,1)='{' ) e) c ON v_edit_subcatchment.subc_id=c.subc_id;


CREATE OR REPLACE VIEW v_inp_subcatch2node AS 
 SELECT s1.subc_id,
	CASE 
		WHEN s1.the_geom IS NOT NULL THEN st_makeline(st_centroid(s1.the_geom), st_centroid(s1.the_geom))
        ELSE st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))
	END AS the_geom
	FROM v_edit_subcatchment s1
    LEFT JOIN v_edit_subcatchment s2 ON s2.subc_id::text = s1.outlet_id::text
	LEFT JOIN v_node ON v_node.node_id::text = s1.outlet_id::text;

	 
CREATE OR REPLACE VIEW v_inp_subcatchcentroid AS 
 SELECT subc_id,
    st_centroid(the_geom) AS the_geom
   FROM v_edit_subcatchment;

			
--28/06/2019
CREATE OR REPLACE VIEW v_ui_event_x_gully AS
SELECT om_visit_event.id AS event_id,
   om_visit.id AS visit_id,
   om_visit.ext_code AS code,
   om_visit.visitcat_id,
   om_visit.startdate AS visit_start,
   om_visit.enddate AS visit_end,
   om_visit.user_name,
   om_visit.is_done,
   date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
   om_visit_x_gully.gully_id,
   om_visit_event.parameter_id,
   om_visit_parameter.parameter_type,
   om_visit_parameter.feature_type,
   om_visit_parameter.form_type,
   om_visit_parameter.descript,
   om_visit_event.value,
   om_visit_event.xcoord,
   om_visit_event.ycoord,
   om_visit_event.compass,
   om_visit_event.event_code,
       CASE
           WHEN a.event_id IS NULL THEN false
           ELSE true
       END AS gallery,
       CASE
           WHEN b.visit_id IS NULL THEN false
           ELSE true
       END AS document
  FROM om_visit
    JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
    JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
    JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
    LEFT JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
    LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
          FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
    LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
          FROM doc_x_visit) b ON b.visit_id = om_visit.id
 ORDER BY om_visit_x_gully.gully_id;

 
CREATE OR REPLACE VIEW v_plan_node AS 
SELECT
v_edit_node.node_id,
nodecat_id,
sys_type AS node_type,
top_elev,
elev,
epa_type,
sector_id,
state,
annotation,
the_geom,
v_price_x_catnode.cost_unit,
v_price_compost.descript,
v_price_compost.price as cost,
CASE WHEN v_price_x_catnode.cost_unit::text = 'u' THEN 1
     WHEN v_price_x_catnode.cost_unit::text = 'm3' THEN (CASE 	WHEN sys_type='STORAGE' THEN man_storage.max_volume::numeric 
																WHEN sys_type='CHAMBER' THEN man_chamber.max_volume::numeric
																ELSE NULL END)
     WHEN v_price_x_catnode.cost_unit::text = 'm' THEN
          CASE WHEN v_edit_node.ymax = 0 THEN v_price_x_catnode.estimated_y
			   WHEN v_edit_node.ymax IS NULL THEN v_price_x_catnode.estimated_y
               ELSE v_edit_node.ymax END
    END::numeric(12,2) AS measurement,
CASE WHEN v_price_x_catnode.cost_unit::text = 'u' THEN v_price_x_catnode.cost
     WHEN v_price_x_catnode.cost_unit::text = 'm3' THEN (CASE 	WHEN sys_type='STORAGE' THEN man_storage.max_volume*v_price_x_catnode.cost 
																WHEN sys_type='CHAMBER' THEN man_chamber.max_volume*v_price_x_catnode.cost 
																ELSE NULL END)
     WHEN v_price_x_catnode.cost_unit::text = 'm' THEN
          CASE WHEN v_edit_node.ymax = 0 THEN v_price_x_catnode.estimated_y*v_price_x_catnode.cost
               WHEN v_edit_node.ymax IS NULL THEN v_price_x_catnode.estimated_y*v_price_x_catnode.cost
               ELSE v_edit_node.ymax*v_price_x_catnode.cost END 
END::numeric(12,2) AS budget,
expl_id
FROM v_edit_node
LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
LEFT JOIN man_chamber ON man_chamber.node_id=v_edit_node.node_id
LEFT JOIN man_storage ON man_storage.node_id=v_edit_node.node_id
JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text;



CREATE OR REPLACE VIEW vu_node AS 
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
            ELSE (node.top_elev - node.ymax)::numeric(12,3)
        END AS sys_elev,
    node.node_type,
    node_type.type AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    node.epa_type,
    node.sector_id,
    sector.macrosector_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.dma_id,
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
    node.uncertain,
    node.xyz_date,
    node.unconnected,
    dma.macrodma_id,
    node.expl_id,
    node.num_value,
    node.lastupdate,
    node.lastupdate_user,
    node.insert_user
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN node_type ON node_type.id::text = node.node_type::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id;

CREATE OR REPLACE VIEW v_arc_x_node AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    a.sys_top_elev - v_arc.sys_elev1 AS sys_y1,
    a.sys_top_elev - v_arc.sys_elev1 - v_arc.geom1 AS r1,
        CASE
            WHEN a.sys_elev IS NOT NULL THEN v_arc.sys_elev1 - a.sys_elev
            ELSE (v_arc.sys_elev1 - (a.sys_top_elev - a.sys_ymax))::numeric(12,3)
        END AS z1,
    v_arc.node_2,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
	v_arc.sys_elev2,
    b.sys_top_elev - v_arc.sys_elev2 AS sys_y2,
    b.sys_top_elev - v_arc.sys_elev2 - v_arc.geom1 AS r2,
        CASE
            WHEN b.sys_elev IS NOT NULL THEN v_arc.sys_elev2 - b.sys_elev
            ELSE (v_arc.sys_elev2 - (b.sys_top_elev - b.sys_ymax))::numeric(12,3)
        END AS z2,
    v_arc.sys_slope AS slope,
    v_arc.arc_type,
    arc_type.type AS sys_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.shape,
    v_arc.geom1,
    v_arc.geom2,
    v_arc.width,
    v_arc.epa_type,
    v_arc.sector_id,
    sector.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.custom_length,
    v_arc.gis_length,
    v_arc.observ,
    v_arc.comment,
    v_arc.inverted_slope,
    v_arc.dma_id,
    dma.macrodma_id,
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
    concat(arc_type.link_path, v_arc.link) AS link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.expl_id,
    v_arc.num_value,
	a.node_type as nodetype_1,
	a.node_type as nodetype_2,
    cat_arc.label,
    v_arc.lastupdate,
    v_arc.lastupdate_user,
    v_arc.insert_user
   FROM v_arc
     JOIN sector ON sector.sector_id = v_arc.sector_id
     JOIN arc_type ON v_arc.arc_type::text = arc_type.id::text
     JOIN dma ON v_arc.dma_id = dma.dma_id
     LEFT JOIN vu_node a ON a.node_id::text = v_arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = v_arc.node_2::text
     JOIN cat_arc ON v_arc.arccat_id::text = cat_arc.id::text;


	 
CREATE OR REPLACE VIEW v_edit_arc AS 
 SELECT arc_id,
    code,
    node_1,
    node_2,
    y1,
    custom_y1,
    sys_y1,
    elev1,
    custom_elev1,
    sys_elev1,
    y2,
    custom_y2,
    sys_y2,
    elev2,
    custom_elev2,
    sys_elev2,
    z1,
    z2,
    r1,
    r2,
    slope,
    arc_type,
    sys_type,
    arccat_id,
    matcat_id AS cat_matcat_id,
    shape AS cat_shape,
    geom1 AS cat_geom1,
    geom2 AS cat_geom2,
    gis_length,
    epa_type,
    sector_id,
    macrosector_id,
    state,
    state_type,
    annotation,
    observ,
    comment,
    label,
    inverted_slope,
    custom_length,
    dma_id,
    soilcat_id,
    function_type,
    category_type,
    fluid_type,
    location_type,
    workcat_id,
    workcat_id_end,
    buildercat_id,
    builtdate,
    enddate,
    ownercat_id,
    muni_id,
    postcode,
    streetaxis_id,
    postnumber,
    postcomplement,
    postcomplement2,
    streetaxis2_id,
    postnumber2,
    descript,
    link,
    verified,
    the_geom,
    undelete,
    label_x,
    label_y,
    label_rotation,
    publish,
    inventory,
    uncertain,
    macrodma_id,
    expl_id,
    num_value,
	nodetype_1,
	nodetype_2,
    lastupdate,
    lastupdate_user,
    insert_user
   FROM v_arc_x_node;
   
 

CREATE OR REPLACE VIEW ve_arc AS 
 SELECT v_arc_x_node.arc_id,
    v_arc_x_node.code,
    v_arc_x_node.node_1,
    v_arc_x_node.node_2,
    v_arc_x_node.y1,
    v_arc_x_node.custom_y1,
    v_arc_x_node.sys_y1,
    v_arc_x_node.elev1,
    v_arc_x_node.custom_elev1,
    v_arc_x_node.sys_elev1,
    v_arc_x_node.y2,
    v_arc_x_node.custom_y2,
    v_arc_x_node.sys_y2,
    v_arc_x_node.elev2,
    v_arc_x_node.custom_elev2,
    v_arc_x_node.sys_elev2,
    v_arc_x_node.z1,
    v_arc_x_node.z2,
    v_arc_x_node.r1,
    v_arc_x_node.r2,
    v_arc_x_node.slope,
    v_arc_x_node.arc_type,
    v_arc_x_node.sys_type,
    v_arc_x_node.arccat_id,
    v_arc_x_node.matcat_id AS cat_matcat_id,
    v_arc_x_node.shape AS cat_shape,
    v_arc_x_node.geom1 AS cat_geom1,
    v_arc_x_node.geom2 AS cat_geom2,
    v_arc_x_node.gis_length,
    v_arc_x_node.epa_type,
    v_arc_x_node.sector_id,
    v_arc_x_node.macrosector_id,
    v_arc_x_node.state,
    v_arc_x_node.state_type,
    v_arc_x_node.annotation,
    v_arc_x_node.observ,
    v_arc_x_node.comment,
	v_arc_x_node.label,
    v_arc_x_node.inverted_slope,
    v_arc_x_node.custom_length,
    v_arc_x_node.dma_id,
    v_arc_x_node.soilcat_id,
    v_arc_x_node.function_type,
    v_arc_x_node.category_type,
    v_arc_x_node.fluid_type,
    v_arc_x_node.location_type,
    v_arc_x_node.workcat_id,
    v_arc_x_node.workcat_id_end,
    v_arc_x_node.buildercat_id,
    v_arc_x_node.builtdate,
    v_arc_x_node.enddate,
    v_arc_x_node.ownercat_id,
    v_arc_x_node.muni_id,
    v_arc_x_node.postcode,
    v_arc_x_node.streetaxis_id,
    v_arc_x_node.postnumber,
    v_arc_x_node.postcomplement,
    v_arc_x_node.postcomplement2,
    v_arc_x_node.streetaxis2_id,
    v_arc_x_node.postnumber2,
    v_arc_x_node.descript,
    v_arc_x_node.link,
    v_arc_x_node.verified,
    v_arc_x_node.the_geom,
    v_arc_x_node.undelete,
    v_arc_x_node.label_x,
    v_arc_x_node.label_y,
    v_arc_x_node.label_rotation,
    v_arc_x_node.publish,
    v_arc_x_node.inventory,
    v_arc_x_node.uncertain,
    v_arc_x_node.macrodma_id,
    v_arc_x_node.expl_id,
    v_arc_x_node.num_value,
    v_arc_x_node.lastupdate,
    v_arc_x_node.lastupdate_user,
    v_arc_x_node.insert_user
   FROM v_arc_x_node;



CREATE OR REPLACE VIEW ve_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    connec_type.type AS sys_type,
    connec.private_connecat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
    connec.connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    cat_connec.label,
    connec.dma_id,
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
    cat_connec.svg,
    connec.rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.featurecat_id,
    connec.feature_id,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    pjoint_type,
    pjoint_id,
    connec.lastupdate,
    connec.lastupdate_user,
    connec.insert_user
   FROM connec
     JOIN v_state_connec ON connec.connec_id::text = v_state_connec.connec_id::text
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN connec_type ON connec.connec_type::text = connec_type.id::text;


CREATE OR REPLACE VIEW v_edit_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.sys_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.sys_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
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
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.insert_user
   FROM v_node
     JOIN cat_node ON v_node.nodecat_id::text = cat_node.id::text;

CREATE OR REPLACE VIEW ve_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.sys_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.sys_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
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
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.insert_user
   FROM v_node;


CREATE OR REPLACE VIEW ve_gully AS 
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    gully_type.type AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    gully.units,
    gully.groove,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.connec_depth,
    gully.arc_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    cat_grate.label,
    gully.dma_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.streetaxis_id,
    gully.postnumber,
    gully.postcomplement,
    gully.streetaxis2_id,
    gully.postnumber2,
    gully.postcomplement2,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(gully_type.link_path, gully.link) AS link,
    gully.verified,
    gully.the_geom,
    gully.undelete,
    gully.featurecat_id,
    gully.feature_id,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.publish,
    gully.inventory,
    gully.expl_id,
    dma.macrodma_id,
    gully.uncertain,
    gully.num_value,
    gully.lastupdate,
    gully.lastupdate_user,
    gully.insert_user
   FROM gully
     JOIN v_state_gully ON gully.gully_id::text = v_state_gully.gully_id::text
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN gully_type ON gully.gully_type::text = gully_type.id::text;
