/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE VIEW v_anl_mincut_result_unexec_arc AS 
 SELECT anl_mincut_result_arc.id,
    anl_mincut_result_arc.result_id,
    anl_mincut_result_cat.work_order,
    anl_mincut_result_arc.arc_id,
    arc.the_geom
   FROM anl_mincut_result_selector,
    arc
     JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id::text = arc.arc_id::text
     JOIN anl_mincut_result_cat ON anl_mincut_result_arc.result_id = anl_mincut_result_cat.id
  WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_arc.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text
  AND mincut_state < 2
  ORDER BY anl_mincut_result_arc.arc_id;


  
CREATE OR REPLACE VIEW v_anl_mincut_result_unexec_node AS 
 SELECT anl_mincut_result_node.id,
    anl_mincut_result_node.result_id,
    anl_mincut_result_cat.work_order,
    anl_mincut_result_node.node_id,
    node.the_geom
   FROM anl_mincut_result_selector,
    node
     JOIN anl_mincut_result_node ON anl_mincut_result_node.node_id::text = node.node_id::text
     JOIN anl_mincut_result_cat ON anl_mincut_result_node.result_id = anl_mincut_result_cat.id
  WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_node.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text
    AND mincut_state < 2 ;


CREATE OR REPLACE VIEW v_anl_mincut_result_unexec_connec AS 
 SELECT anl_mincut_result_connec.id,
    anl_mincut_result_connec.result_id,
    anl_mincut_result_cat.work_order,
    anl_mincut_result_connec.connec_id,
    connec.customer_code,
    connec.the_geom
   FROM anl_mincut_result_selector,
    connec
     JOIN anl_mincut_result_connec ON anl_mincut_result_connec.connec_id::text = connec.connec_id::text
     JOIN anl_mincut_result_cat ON anl_mincut_result_connec.result_id = anl_mincut_result_cat.id
  WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_connec.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text
    AND mincut_state < 2;


CREATE OR REPLACE VIEW v_anl_mincut_result_unexec_valve AS 
SELECT anl_mincut_result_valve.id,
    anl_mincut_result_valve.result_id,
    anl_mincut_result_cat.work_order,
    anl_mincut_result_valve.node_id,
    anl_mincut_result_valve.closed,
    anl_mincut_result_valve.broken,
    anl_mincut_result_valve.unaccess,
    anl_mincut_result_valve.proposed,
    anl_mincut_result_valve.the_geom
   FROM anl_mincut_result_selector,
    anl_mincut_result_valve
     JOIN anl_mincut_result_cat ON anl_mincut_result_valve.result_id = anl_mincut_result_cat.id
  WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_valve.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text
    AND mincut_state < 2;


  CREATE OR REPLACE VIEW v_anl_mincut_result_unexec_cat AS 
 SELECT anl_mincut_result_cat.id,
    anl_mincut_result_cat.work_order,
    anl_mincut_cat_state.name AS state,
    anl_mincut_cat_class.name AS class,
    anl_mincut_result_cat.mincut_type,
    anl_mincut_result_cat.received_date,
    anl_mincut_result_cat.expl_id,
    anl_mincut_result_cat.macroexpl_id,
    anl_mincut_result_cat.muni_id,
    anl_mincut_result_cat.postcode,
    anl_mincut_result_cat.streetaxis_id,
    anl_mincut_result_cat.postnumber,
    anl_mincut_result_cat.anl_cause,
    anl_mincut_result_cat.anl_tstamp,
    anl_mincut_result_cat.anl_user,
    anl_mincut_result_cat.anl_descript,
    anl_mincut_result_cat.anl_feature_id,
    anl_mincut_result_cat.anl_feature_type,
    anl_mincut_result_cat.anl_the_geom,
    anl_mincut_result_cat.forecast_start,
    anl_mincut_result_cat.forecast_end,
    anl_mincut_result_cat.assigned_to,
    anl_mincut_result_cat.exec_start,
    anl_mincut_result_cat.exec_end,
    anl_mincut_result_cat.exec_user,
    anl_mincut_result_cat.exec_descript,
    anl_mincut_result_cat.exec_the_geom,
    anl_mincut_result_cat.exec_from_plot,
    anl_mincut_result_cat.exec_depth,
    anl_mincut_result_cat.exec_appropiate
   FROM anl_mincut_result_selector,
    anl_mincut_result_cat
     LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = anl_mincut_result_cat.mincut_class
     LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = anl_mincut_result_cat.mincut_state
  WHERE anl_mincut_result_selector.result_id = anl_mincut_result_cat.id AND anl_mincut_result_selector.cur_user = "current_user"()::text
    AND mincut_state < 2;




