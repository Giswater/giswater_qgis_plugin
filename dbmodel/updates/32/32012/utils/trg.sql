/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.ve_ui_rpt_result_cat
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_ui_rpt_cat_result();

DROP TRIGGER IF EXISTS gw_trg_edit_psector_x_other ON "SCHEMA_NAME".ve_plan_psector_x_other;
CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_plan_psector_x_other
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector_x_other('plan');

DROP TRIGGER IF EXISTS gw_trg_edit_psector_x_other ON "SCHEMA_NAME".ve_om_psector_x_other;
CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_om_psector_x_other
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector_x_other('om');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON "SCHEMA_NAME".ve_element;
CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE 
ON "SCHEMA_NAME".ve_element FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_element('element');

DROP TRIGGER IF EXISTS gw_trg_edit_dimensions ON "SCHEMA_NAME".ve_dimensions;
CREATE TRIGGER gw_trg_edit_dimensions INSTEAD OF INSERT OR DELETE OR UPDATE 
ON "SCHEMA_NAME".ve_dimensions FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_dimensions('dimensions');

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON "SCHEMA_NAME".ve_cad_auxcircle;
CREATE TRIGGER gw_trg_edit_cad_aux INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.ve_cad_auxcircle  FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_cad_aux('circle');

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON "SCHEMA_NAME".ve_cad_auxpoint;
CREATE TRIGGER gw_trg_edit_cad_aux  INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.ve_cad_auxpoint  FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_cad_aux('point');

DROP TRIGGER IF EXISTS gw_trg_ui_visit_x_node ON "SCHEMA_NAME".ve_ui_visit_x_node;
CREATE TRIGGER gw_trg_ui_visit_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_visit_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_visit(visit_x_node);

DROP TRIGGER IF EXISTS gw_trg_ui_visit_x_arc ON "SCHEMA_NAME".ve_ui_visit_x_arc;
CREATE TRIGGER gw_trg_ui_visit_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_visit_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_visit(visit_x_arc);

DROP TRIGGER IF EXISTS gw_trg_ui_visit_x_connec ON "SCHEMA_NAME".ve_ui_visit_x_connec;
CREATE TRIGGER gw_trg_ui_visit_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_visit_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_visit(visit_x_connec);

DROP TRIGGER IF EXISTS gw_trg_ui_hydroval_connec ON "SCHEMA_NAME".ve_ui_hydroval_x_connec;
CREATE TRIGGER gw_trg_ui_hydroval_connec INSTEAD OF UPDATE ON "SCHEMA_NAME".ve_ui_hydroval_x_connec FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_hydroval_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_rtc_hydro_data ON "SCHEMA_NAME".ve_rtc_hydro_data_x_connec;
CREATE TRIGGER gw_trg_edit_rtc_hydro_data  INSTEAD OF UPDATE ON SCHEMA_NAME.ve_rtc_hydro_data_x_connec FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_ui_hydroval_connec();

DROP TRIGGER IF EXISTS gw_trg_ui_event_x_node ON "SCHEMA_NAME".ve_ui_event_x_node;
CREATE TRIGGER gw_trg_ui_event_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_event_x_arc ON "SCHEMA_NAME".ve_ui_event_x_arc;
CREATE TRIGGER gw_trg_ui_event_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_event_x_connec ON "SCHEMA_NAME".ve_ui_event_x_connec;
CREATE TRIGGER gw_trg_ui_event_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_event ON "SCHEMA_NAME".ve_ui_event;
CREATE TRIGGER gw_trg_ui_event INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_element_x_node ON "SCHEMA_NAME".ve_ui_element_x_node;
CREATE TRIGGER gw_trg_ui_element_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_element_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_node);

DROP TRIGGER IF EXISTS gw_trg_ui_element_x_arc ON "SCHEMA_NAME".ve_ui_element_x_arc;
CREATE TRIGGER gw_trg_ui_element_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_element_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_arc);

DROP TRIGGER IF EXISTS gw_trg_ui_element_x_connec ON "SCHEMA_NAME".ve_ui_element_x_connec;
CREATE TRIGGER gw_trg_ui_element_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_element_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_connec);

DROP TRIGGER IF EXISTS gw_trg_ui_element ON "SCHEMA_NAME".ve_ui_element;
CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_element
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_node ON "SCHEMA_NAME".ve_ui_doc_x_node;
CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_doc_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_node);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_arc ON "SCHEMA_NAME".ve_ui_doc_x_arc;
CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_doc_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_arc);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_connec ON "SCHEMA_NAME".ve_ui_doc_x_connec;
CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_doc_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_connec);

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_visit ON "SCHEMA_NAME".ve_ui_doc_x_visit;
CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_doc_x_visit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_visit);
      
DROP TRIGGER IF EXISTS gw_trg_ui_doc ON "SCHEMA_NAME".ve_ui_doc;
CREATE TRIGGER gw_trg_ui_doc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_doc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc);