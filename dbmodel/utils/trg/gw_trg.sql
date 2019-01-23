/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



DROP TRIGGER IF EXISTS gw_trg_arc_orphannode_delete on "SCHEMA_NAME".arc;
CREATE TRIGGER gw_trg_arc_orphannode_delete AFTER DELETE ON "SCHEMA_NAME".arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_arc_orphannode_delete();

DROP TRIGGER IF EXISTS gw_trg_arc_vnodelink_update ON "SCHEMA_NAME".arc;
CREATE TRIGGER gw_trg_arc_vnodelink_update AFTER UPDATE OF the_geom ON "SCHEMA_NAME".arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_arc_vnodelink_update();

DROP TRIGGER IF EXISTS gw_trg_connec_proximity_insert ON "SCHEMA_NAME".connec;
CREATE TRIGGER gw_trg_connec_proximity_insert BEFORE INSERT ON "SCHEMA_NAME".connec  
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_connec_proximity();

DROP TRIGGER IF EXISTS gw_trg_connec_proximity_update ON "SCHEMA_NAME".connec;
CREATE TRIGGER gw_trg_connec_proximity_update AFTER UPDATE OF the_geom ON "SCHEMA_NAME".connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_connec_proximity();

DROP TRIGGER IF EXISTS gw_trg_connec_update ON "SCHEMA_NAME".connec;
CREATE TRIGGER gw_trg_connec_update AFTER UPDATE OF the_geom ON "SCHEMA_NAME".connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_connec_update();

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON "SCHEMA_NAME".v_edit_cad_auxcircle;
CREATE TRIGGER gw_trg_edit_cad_aux INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".v_edit_cad_auxcircle  
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_cad_aux('circle');

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON "SCHEMA_NAME".v_edit_cad_auxpoint;
CREATE TRIGGER gw_trg_edit_cad_aux  INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".v_edit_cad_auxpoint  
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_cad_aux('point');

DROP TRIGGER IF EXISTS gw_trg_edit_dimensions ON "SCHEMA_NAME".v_edit_dimensions;
CREATE TRIGGER gw_trg_edit_dimensions INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_dimensions 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_dimensions('dimensions');

DROP TRIGGER IF EXISTS gw_trg_edit_dma ON "SCHEMA_NAME".v_edit_dma;
CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_dma 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_dma('dma');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON "SCHEMA_NAME".v_edit_element;
CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_element 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_element('element');

DROP TRIGGER IF EXISTS gw_trg_edit_link ON "SCHEMA_NAME"."v_edit_link";
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_link 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_link();

DROP TRIGGER IF EXISTS gw_trg_edit_macrodma ON "SCHEMA_NAME".v_edit_macrodma;
CREATE TRIGGER gw_trg_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_macrodma 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_macrodma('macrodma');

DROP TRIGGER IF EXISTS gw_trg_edit_macrosector ON "SCHEMA_NAME".v_edit_macrosector;
CREATE TRIGGER gw_trg_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_macrosector 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_macrosector('macrosector');

DROP TRIGGER IF EXISTS gw_trg_edit_om_visit ON "SCHEMA_NAME".v_edit_om_visit;
CREATE TRIGGER gw_trg_edit_om_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_om_visit 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_om_visit('om_visit');

DROP TRIGGER IF EXISTS gw_trg_edit_psector ON "SCHEMA_NAME".v_edit_om_psector;
CREATE TRIGGER gw_trg_edit_psector INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".v_edit_om_psector  
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector('om');

DROP TRIGGER IF EXISTS gw_trg_edit_psector ON "SCHEMA_NAME".v_edit_plan_psector;
CREATE TRIGGER gw_trg_edit_psector  INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".v_edit_plan_psector  
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector('plan');

DROP TRIGGER IF EXISTS gw_trg_edit_psector_x_other ON "SCHEMA_NAME".v_edit_plan_psector_x_other;
CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_plan_psector_x_other 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector_x_other('plan');

DROP TRIGGER IF EXISTS gw_trg_edit_psector_x_other ON "SCHEMA_NAME".v_edit_om_psector_x_other;
CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_om_psector_x_other 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector_x_other('om');

DROP TRIGGER IF EXISTS gw_trg_edit_sector ON "SCHEMA_NAME".v_edit_sector;
CREATE TRIGGER gw_trg_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_sector 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_sector('sector');
  
DROP TRIGGER IF EXISTS gw_trg_edit_vnode ON "SCHEMA_NAME".v_edit_vnode;
CREATE TRIGGER gw_trg_edit_vnode INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_vnode 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_vnode('vnode');

DROP TRIGGER IF EXISTS gw_trg_link_connecrotation_update ON "SCHEMA_NAME".link;
CREATE TRIGGER gw_trg_link_connecrotation_update AFTER INSERT OR UPDATE OF the_geom ON "SCHEMA_NAME".link 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_link_connecrotation_update();

DROP TRIGGER IF EXISTS gw_trg_node_arc_divide ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_node_arc_divide AFTER INSERT ON "SCHEMA_NAME".node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_node_arc_divide();

DROP TRIGGER IF EXISTS gw_trg_visit_event_update_xy ON "SCHEMA_NAME".om_visit_event;
CREATE TRIGGER gw_trg_visit_event_update_xy AFTER INSERT OR UPDATE OF position_id, position_value  ON "SCHEMA_NAME".om_visit_event 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_visit_event_update_xy();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc ON "SCHEMA_NAME".plan_psector_x_arc;
CREATE TRIGGER gw_trg_plan_psector_x_arc BEFORE INSERT OR UPDATE OF arc_id ON "SCHEMA_NAME".plan_psector_x_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_plan_psector_x_arc();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node ON "SCHEMA_NAME".plan_psector_x_node;
CREATE TRIGGER gw_trg_plan_psector_x_node BEFORE INSERT OR UPDATE OF node_id ON "SCHEMA_NAME".plan_psector_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_plan_psector_x_node();

DROP TRIGGER IF EXISTS gw_trg_psector_selector ON "SCHEMA_NAME".plan_psector;
CREATE TRIGGER gw_trg_psector_selector AFTER INSERT ON "SCHEMA_NAME".plan_psector 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_psector_selector();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc_geom ON "SCHEMA_NAME".plan_psector_x_arc;
CREATE TRIGGER gw_trg_plan_psector_x_arc_geom  AFTER INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".plan_psector_x_arc 
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_plan_psector_geom('plan');
 
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node_geom ON "SCHEMA_NAME".plan_psector_x_node;
CREATE TRIGGER gw_trg_plan_psector_x_node_geom  AFTER INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".plan_psector_x_node 
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_plan_psector_geom('plan');

DROP TRIGGER IF EXISTS gw_trg_om_psector_x_arc ON "SCHEMA_NAME".om_psector_x_arc;
CREATE TRIGGER gw_trg_om_psector_x_arc  AFTER INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".om_psector_x_arc 
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_plan_psector_geom('om');
 
DROP TRIGGER IF EXISTS gw_trg_om_psector_x_node ON "SCHEMA_NAME".om_psector_x_node;
CREATE TRIGGER gw_trg_om_psector_x_node AFTER INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".om_psector_x_node 
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_plan_psector_geom('om');

DROP TRIGGER IF EXISTS gw_trg_selector_expl ON "SCHEMA_NAME".selector_expl;
CREATE TRIGGER gw_trg_selector_expl AFTER INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".selector_expl 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_selector_expl();
ALTER TABLE selector_expl DISABLE TRIGGER gw_trg_selector_expl;

DROP TRIGGER IF EXISTS gw_trg_topocontrol_node ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_topocontrol_node BEFORE INSERT OR UPDATE OF the_geom, "state" ON "SCHEMA_NAME".node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_topocontrol_node();

DROP TRIGGER IF EXISTS gw_trg_ui_rpt_cat_result ON "SCHEMA_NAME".v_ui_rpt_cat_result;
CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_rpt_cat_result 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_rpt_cat_result();

DROP TRIGGER IF EXISTS gw_trg_ui_om_result_cat ON "SCHEMA_NAME".v_ui_om_result_cat;
CREATE TRIGGER gw_trg_ui_om_result_cat INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_om_result_cat 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_om_result_cat();

DROP TRIGGER IF EXISTS gw_trg_visit_expl ON "SCHEMA_NAME".om_visit;
CREATE TRIGGER gw_trg_visit_expl BEFORE INSERT OR UPDATE OF the_geom ON "SCHEMA_NAME".om_visit 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_visit_expl();

DROP TRIGGER IF EXISTS gw_trg_vnode_update ON "SCHEMA_NAME".vnode;
CREATE TRIGGER gw_trg_vnode_update BEFORE UPDATE OF the_geom ON "SCHEMA_NAME".vnode
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_vnode_update();

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_node ON "SCHEMA_NAME".v_ui_doc_x_node;
CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_doc_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_node);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_arc ON "SCHEMA_NAME".v_ui_doc_x_arc;
CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_doc_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_arc);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_connec ON "SCHEMA_NAME".v_ui_doc_x_connec;
CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_doc_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_connec);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_visit ON "SCHEMA_NAME".v_ui_doc_x_visit;
CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_doc_x_visit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_visit);
    
DROP TRIGGER IF EXISTS gw_trg_ui_element_x_node ON "SCHEMA_NAME".v_ui_element_x_node;
CREATE TRIGGER gw_trg_ui_element_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_node);

DROP TRIGGER IF EXISTS gw_trg_ui_element_x_arc ON "SCHEMA_NAME".v_ui_element_x_arc;
CREATE TRIGGER gw_trg_ui_element_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_arc);

DROP TRIGGER IF EXISTS gw_trg_ui_elememt_x_connec ON "SCHEMA_NAME".v_ui_element_x_connec;
CREATE TRIGGER gw_trg_ui_elememt_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_connec);

DROP TRIGGER IF EXISTS gw_trg_ui_visitman_x_arc ON "SCHEMA_NAME".v_ui_om_visitman_x_arc;
CREATE TRIGGER gw_trg_ui_visitman_x_arc INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_arc FOR EACH ROW EXECUTE PROCEDURE 
"SCHEMA_NAME".gw_trg_ui_visitman();

DROP TRIGGER IF EXISTS gw_trg_ui_visitman_x_node ON "SCHEMA_NAME".v_ui_om_visitman_x_node;
CREATE TRIGGER gw_trg_ui_visitman_x_node INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_node FOR EACH ROW EXECUTE PROCEDURE 
"SCHEMA_NAME".gw_trg_ui_visitman();

DROP TRIGGER IF EXISTS gw_trg_ui_visitman_x_connec ON "SCHEMA_NAME".v_ui_om_visitman_x_connec;
CREATE TRIGGER gw_trg_ui_visitman_x_connec INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_connec FOR EACH ROW EXECUTE PROCEDURE 
"SCHEMA_NAME".gw_trg_ui_visitman();

DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".connec;
CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(connec);



