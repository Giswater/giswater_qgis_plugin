DROP VIEW sanejament.v_edit_man_manhole;

CREATE OR REPLACE VIEW sanejament.v_edit_man_manhole AS 
 SELECT node.node_id,
    node.top_elev AS manhole_top_elev,
    node.ymax AS manhole_ymax,
    node.sander AS manhole_sander,
    node.top_elev - node.ymax AS manhole_elev,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state AS manhole_state,
    node.annotation AS manhole_annotation,
    node.observ AS manhole_observ,
    node.comment AS manhole_comment,
    node.dma_id,
    node.soilcat_id AS manhole_soilcat_id,
    node.category_type AS manhole_category_type,
    node.fluid_type AS manhole_fluid_type,
    node.location_type AS manhole_location_type,
    node.workcat_id AS manhole_workcat_id,
    node.buildercat_id AS manhole_buildercat_id,
    node.builtdate AS manhole_builtdate,
    node.ownercat_id AS manhole_ownercat_id,
    node.adress_01 AS manhole_adress_01,
    node.adress_02 AS manhole_adress_02,
    node.adress_03 AS manhole_adress_03,
    node.descript AS manhole_descript,
    node.est_top_elev AS manhole_est_top_elev,
    node.est_ymax AS manhole_est_ymax,
    node.rotation AS manhole_rotation,
    node.link AS manhole_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS manhole_workcat_id_end,
    node.undelete,
    node.label_x AS manhole_label_x,
    node.label_y AS manhole_label_y,
    node.label_rotation AS manhole_label_rotation,
    man_manhole.add_info AS manhole_add_info,
    man_manhole.sander_depth AS manhole_sander_depth,
    man_manhole.prot_surface AS manhole_prot_surface,
    index_gen,
    startdate::date as index_date
   FROM sanejament.node
     JOIN sanejament.man_manhole ON man_manhole.node_id::text = node.node_id::text
     LEFT JOIN sanejament.om_visit_x_node ON om_visit_x_node.node_id=node.node_id
     LEFT JOIN sanejament.om_visit ON visit_id=om_visit.id
     WHERE is_last=true
     ;

ALTER TABLE sanejament.v_edit_man_manhole
  OWNER TO postgres;

-- Trigger: gw_trg_edit_man_manhole on sanejament.v_edit_man_manhole

-- DROP TRIGGER gw_trg_edit_man_manhole ON sanejament.v_edit_man_manhole;

CREATE TRIGGER gw_trg_edit_man_manhole
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON sanejament.v_edit_man_manhole
  FOR EACH ROW
  EXECUTE PROCEDURE sanejament.gw_trg_edit_man_node('man_manhole');