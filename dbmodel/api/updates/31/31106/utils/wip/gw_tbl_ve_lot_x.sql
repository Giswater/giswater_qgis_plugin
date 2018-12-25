CREATE OR REPLACE VIEW SCHEMA_NAME.ve_lot_x_arc AS 
 SELECT arc.arc_id,
    om_visit_lot_x_arc.lot_id,
    status,
    the_geom
    FROM SCHEMA_NAME.selector_lot, SCHEMA_NAME.om_visit_lot
     JOIN SCHEMA_NAME.om_visit_lot_x_arc ON lot_id=id
     JOIN SCHEMA_NAME.arc ON arc.arc_id=om_visit_lot_x_arc.arc_id
     WHERE selector_lot.lot_id = om_visit_lot.id AND cur_user=current_user;