/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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
	CASE
		WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
		ELSE node.matcat_id
	END AS cat_matcat_id,
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
	CASE
		WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
		ELSE connec.matcat_id
	END AS cat_matcat_id,
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
    connec.pjoint_type,
    connec.pjoint_id,
    connec.lastupdate,
    connec.lastupdate_user
   FROM connec
     JOIN v_state_connec ON connec.connec_id::text = v_state_connec.connec_id::text
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN connec_type ON connec.connec_type::text = connec_type.id::text;
	 
	 
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
    CASE
		WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
		ELSE connec.matcat_id
	END AS cat_matcat_id,
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
	CASE
		WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
		ELSE arc.matcat_id::varchar(16)
	END AS matcat_id,
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



-- REVIEW NODE
CREATE OR REPLACE VIEW v_edit_review_node AS 
 SELECT review_node.node_id,
    review_node.top_elev,
    review_node.ymax,
    review_node.node_type,
    review_node.matcat_id,
    review_node.nodecat_id,
    review_node.annotation,
    review_node.observ,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_node.expl_id = selector_expl.expl_id;

DROP TRIGGER IF EXISTS gw_trg_edit_review_node ON v_edit_review_node;
CREATE TRIGGER gw_trg_edit_review_node
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_node();


CREATE OR REPLACE VIEW v_edit_review_audit_node AS 
 SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_top_elev,
    review_audit_node.new_top_elev,
    review_audit_node.old_ymax,
    review_audit_node.new_ymax,
    review_audit_node.old_node_type,
    review_audit_node.new_node_type,
    review_audit_node.old_matcat_id,
    review_audit_node.new_matcat_id,
    review_audit_node.old_nodecat_id,
    review_audit_node.new_nodecat_id,
    review_audit_node.old_annotation,
	review_audit_node.new_annotation,
    review_audit_node.old_observ,
	review_audit_node.new_observ,
    review_audit_node.expl_id,
    review_audit_node.the_geom,
    review_audit_node.review_status_id,
    review_audit_node.field_date,
    review_audit_node.field_user,
    review_audit_node.is_validated
   FROM review_audit_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_node.expl_id = selector_expl.expl_id AND review_audit_node.review_status_id <> 0;

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_node ON v_edit_review_audit_node;
CREATE TRIGGER gw_trg_edit_review_audit_node
  INSTEAD OF UPDATE
  ON v_edit_review_audit_node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_node();

  
  
-- REVIEW ARC
CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_arc.arc_id,
    review_arc.y1,
    review_arc.y2,
    review_arc.arc_type,
    review_arc.matcat_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_checked,
    review_arc.is_validated
   FROM review_arc,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;

DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_arc();
  

CREATE OR REPLACE VIEW v_edit_review_audit_arc AS 
 SELECT review_audit_arc.id,
    review_audit_arc.arc_id,
    review_audit_arc.old_y1,
    review_audit_arc.new_y1,
    review_audit_arc.old_y2,
    review_audit_arc.new_y2,
    review_audit_arc.old_arc_type,
    review_audit_arc.new_arc_type,
	review_audit_arc.old_matcat_id,
    review_audit_arc.new_matcat_id,
    review_audit_arc.old_arccat_id,
    review_audit_arc.new_arccat_id,
    review_audit_arc.old_annotation,
	review_audit_arc.new_annotation,
    review_audit_arc.old_observ,
	review_audit_arc.new_observ,
    review_audit_arc.expl_id,
    review_audit_arc.the_geom,
    review_audit_arc.review_status_id,
    review_audit_arc.field_date,
    review_audit_arc.field_user,
    review_audit_arc.is_validated
   FROM review_audit_arc,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_arc.expl_id = selector_expl.expl_id AND review_audit_arc.review_status_id <> 0;


DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_arc ON v_edit_review_audit_arc;
CREATE TRIGGER gw_trg_edit_review_audit_arc
  INSTEAD OF UPDATE
  ON v_edit_review_audit_arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_arc();
  

-- REVIEW GULLY
CREATE OR REPLACE VIEW v_edit_review_gully AS 
 SELECT review_gully.gully_id,
    review_gully.top_elev,
    review_gully.ymax,
    review_gully.sandbox,
    review_gully.matcat_id,
    review_gully.gully_type,
    review_gully.gratecat_id,
    review_gully.units,
    review_gully.groove,
    review_gully.siphon,
    review_gully.connec_matcat_id,
    review_gully.connec_arccat_id,
    review_gully.featurecat_id,
    review_gully.feature_id,
    review_gully.annotation,
    review_gully.observ,
    review_gully.expl_id,
    review_gully.the_geom,
    review_gully.field_checked,
    review_gully.is_validated
   FROM review_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_gully.expl_id = selector_expl.expl_id;

DROP TRIGGER IF EXISTS gw_trg_edit_review_gully ON v_edit_review_gully;
CREATE TRIGGER gw_trg_edit_review_gully
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_gully
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_gully();


CREATE OR REPLACE VIEW v_edit_review_audit_gully AS 
 SELECT review_audit_gully.id,
    review_audit_gully.gully_id,
    review_audit_gully.old_top_elev,
    review_audit_gully.new_top_elev,
    review_audit_gully.old_ymax,
    review_audit_gully.new_ymax,
    review_audit_gully.old_sandbox,
    review_audit_gully.new_sandbox,
    review_audit_gully.old_matcat_id,
    review_audit_gully.new_matcat_id,
    review_audit_gully.old_gully_type,
    review_audit_gully.new_gully_type,
    review_audit_gully.old_gratecat_id,
    review_audit_gully.new_gratecat_id,
    review_audit_gully.old_units,
    review_audit_gully.new_units,
    review_audit_gully.old_groove,
    review_audit_gully.new_groove,
    review_audit_gully.old_siphon,
    review_audit_gully.new_siphon,
    review_audit_gully.old_connec_matcat_id,
    review_audit_gully.new_connec_matcat_id,
    review_audit_gully.old_connec_arccat_id,
    review_audit_gully.new_connec_arccat_id,
    review_audit_gully.old_featurecat_id,
    review_audit_gully.new_featurecat_id,
    review_audit_gully.old_feature_id,
    review_audit_gully.new_feature_id,
    review_audit_gully.old_annotation,
	review_audit_gully.new_annotation,
    review_audit_gully.old_observ,
	review_audit_gully.new_observ,
    review_audit_gully.expl_id,
    review_audit_gully.the_geom,
    review_audit_gully.review_status_id,
    review_audit_gully.field_date,
    review_audit_gully.field_user,
    review_audit_gully.is_validated
   FROM review_audit_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_gully.expl_id = selector_expl.expl_id AND review_audit_gully.review_status_id <> 0;

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_gully ON v_edit_review_audit_gully;
CREATE TRIGGER gw_trg_edit_review_audit_gully
  INSTEAD OF UPDATE
  ON v_edit_review_audit_gully
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_gully();

  
-- REVIEW CONNEC
CREATE OR REPLACE VIEW v_edit_review_connec AS 
 SELECT review_connec.connec_id,
    review_connec.y1,
    review_connec.y2,
    review_connec.connec_type,
    review_connec.matcat_id,
	review_connec.connecat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_connec.expl_id = selector_expl.expl_id;

CREATE TRIGGER gw_trg_edit_review_connec
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_connec
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_connec();


CREATE OR REPLACE VIEW v_edit_review_audit_connec AS 
 SELECT review_audit_connec.id,
    review_audit_connec.connec_id,
    review_audit_connec.old_y1,
    review_audit_connec.new_y1,
    review_audit_connec.old_y2,
    review_audit_connec.new_y2,
    review_audit_connec.old_connec_type,
    review_audit_connec.new_connec_type,
    review_audit_connec.old_matcat_id,
    review_audit_connec.new_matcat_id,
    review_audit_connec.old_connecat_id,
    review_audit_connec.new_connecat_id,
    review_audit_connec.old_annotation,
	review_audit_connec.new_annotation,
    review_audit_connec.old_observ,
	review_audit_connec.new_observ,
    review_audit_connec.expl_id,
    review_audit_connec.the_geom,
    review_audit_connec.review_status_id,
    review_audit_connec.field_date,
    review_audit_connec.field_user,
    review_audit_connec.is_validated
   FROM review_audit_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_connec.expl_id = selector_expl.expl_id AND review_audit_connec.review_status_id <> 0;

CREATE TRIGGER gw_trg_edit_review_audit_connec
  INSTEAD OF UPDATE
  ON v_edit_review_audit_connec
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_connec();

