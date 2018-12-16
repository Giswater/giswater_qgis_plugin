CREATE OR REPLACE VIEW ws_sample.ve_lot_x_arc AS 
 SELECT arc.arc_id,
    om_visit_lot_x_arc.lot_id,
    status,
    the_geom
    FROM ws_sample.selector_lot, ws_sample.om_visit_lot
     JOIN ws_sample.om_visit_lot_x_arc ON lot_id=id
     JOIN ws_sample.arc ON arc.arc_id=om_visit_lot_x_arc.arc_id
     WHERE selector_lot.lot_id = om_visit_lot.id AND cur_user=current_user;