
DROP VIEW sanejament.v_edit_man_conduit;

CREATE OR REPLACE VIEW sanejament.v_edit_man_conduit AS 
 SELECT arc.arc_id,
    arc.node_1 AS conduit_node_1,
    arc.node_2 AS conduit_node_2,
    arc.y1 AS conduit_y1,
    arc.y2 AS conduit_y2,
    v_arc_x_node.z1 AS conduit_z1,
    v_arc_x_node.z2 AS conduit_z2,
    v_arc_x_node.r1 AS conduit_r1,
    v_arc_x_node.r2 AS conduit_r2,
    v_arc_x_node.slope AS conduit_slope,
    arc.arc_type,
    arc.arccat_id,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.shape AS conduit_cat_shape,
    cat_arc.geom1 AS conduit_cat_geom1,
    cat_arc.width AS conduit_cat_width,
    st_length2d(arc.the_geom)::numeric(12,2) AS conduit_gis_length,
    arc.epa_type,
    arc.sector_id,
    arc.state AS conduit_state,
    arc.annotation AS conduit_annotation,
    arc.observ AS conduit_observ,
    arc.comment AS conduit_comment,
    arc.inverted_slope AS conduit_inverted_slope,
    arc.custom_length AS conduit_custom_length,
    arc.dma_id,
    arc.soilcat_id AS conduit_soilcat_id,
    arc.category_type AS conduit_category_type,
    arc.fluid_type AS conduit_fluid_type,
    arc.location_type AS conduit_location_type,
    arc.workcat_id AS conduit_workcat_id,
    arc.buildercat_id AS conduit_buildercat_id,
    arc.builtdate AS conduit_builtdate,
    arc.ownercat_id AS conduit_ownercat_id,
    arc.adress_01 AS conduit_adress_01,
    arc.adress_02 AS conduit_adress_02,
    arc.adress_03 AS conduit_adress_03,
    arc.descript AS conduit_descript,
    cat_arc.svg AS conduit_svg,
    arc.est_y1 AS conduit_est_y1,
    arc.est_y2 AS conduit_est_y2,
    arc.rotation AS conduit_rotation,
    arc.link AS conduit_link,
    arc.verified,
    arc.the_geom,
    v_arc_x_node.elev1 AS conduit_elev1,
    v_arc_x_node.elev2 AS conduit_elev2,
    arc.workcat_id_end AS conduit_workcat_id_end,
    arc.undelete,
    arc.label_x AS conduit_label_x,
    arc.label_y AS conduit_label_y,
    arc.label_rotation AS conduit_label_rotation,
    man_conduit.add_info AS conduit_add_info,
    index_gen,
    startdate::date as index_date
   FROM sanejament.arc
     LEFT JOIN sanejament.cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN sanejament.v_arc_x_node ON v_arc_x_node.arc_id::text = arc.arc_id::text
     JOIN sanejament.man_conduit ON man_conduit.arc_id::text = arc.arc_id::text
     LEFT JOIN sanejament.om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id 
     LEFT JOIN sanejament.om_visit ON visit_id=om_visit.id
     WHERE is_last=true;

   


ALTER TABLE sanejament.v_edit_man_conduit
  OWNER TO postgres;

-- Trigger: gw_trg_edit_man_conduit on sanejament.v_edit_man_conduit

-- DROP TRIGGER gw_trg_edit_man_conduit ON sanejament.v_edit_man_conduit;

CREATE TRIGGER gw_trg_edit_man_conduit
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON sanejament.v_edit_man_conduit
  FOR EACH ROW
  EXECUTE PROCEDURE sanejament.gw_trg_edit_man_arc('man_conduit');


