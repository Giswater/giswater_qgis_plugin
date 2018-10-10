
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2506



--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_create_utils_trg();


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_utils_trg() RETURNS void AS
$BODY$
DECLARE

project_type_aux varchar;


BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- control of project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

    --UI_DOC_X_*

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
      

	--UI_ELEMENT_X_*
	DROP TRIGGER IF EXISTS gw_trg_ui_element_x_node ON "SCHEMA_NAME".v_ui_element_x_node;
	CREATE TRIGGER gw_trg_ui_element_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_node
	FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_node);

	DROP TRIGGER IF EXISTS gw_trg_ui_element_x_arc ON "SCHEMA_NAME".v_ui_element_x_arc;
	CREATE TRIGGER gw_trg_ui_element_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_arc
	FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_arc);

	DROP TRIGGER IF EXISTS gw_trg_ui_elememt_x_connec ON "SCHEMA_NAME".v_ui_element_x_connec;
	CREATE TRIGGER gw_trg_ui_elememt_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_connec
	FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_connec);

	--UI_VISITMAN_X_*
	DROP TRIGGER IF EXISTS gw_trg_ui_visitman_x_arc ON "SCHEMA_NAME".v_ui_om_visitman_x_arc;
	CREATE TRIGGER gw_trg_ui_visitman_x_arc INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_arc FOR EACH ROW EXECUTE PROCEDURE 
	"SCHEMA_NAME".gw_trg_ui_visitman();

	DROP TRIGGER IF EXISTS gw_trg_ui_visitman_x_node ON "SCHEMA_NAME".v_ui_om_visitman_x_node;
	CREATE TRIGGER gw_trg_ui_visitman_x_node INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_node FOR EACH ROW EXECUTE PROCEDURE 
	"SCHEMA_NAME".gw_trg_ui_visitman();

	DROP TRIGGER IF EXISTS gw_trg_ui_visitman_x_connec ON "SCHEMA_NAME".v_ui_om_visitman_x_connec;
	CREATE TRIGGER gw_trg_ui_visitman_x_connec INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_connec FOR EACH ROW EXECUTE PROCEDURE 
	"SCHEMA_NAME".gw_trg_ui_visitman();


	--UPDATE LINK
	DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".connec;
	CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".connec
	FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(connec);

	--MAN_ADDFIELDS_CONTROL
	DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_node_control ON node;
	CREATE TRIGGER gw_trg_man_addfields_value_node_control AFTER UPDATE OF node_id OR DELETE ON SCHEMA_NAME.node
	FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('NODE');

	DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_arc_control ON arc;
	CREATE TRIGGER gw_trg_man_addfields_value_arc_control AFTER UPDATE OF arc_id OR DELETE ON SCHEMA_NAME.arc
	FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('ARC');

	DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_connec_control ON connec;
	CREATE TRIGGER gw_trg_man_addfields_value_connec_control AFTER UPDATE OF connec_id OR DELETE ON SCHEMA_NAME.connec
	FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('CONNEC');
	  
	

	IF project_type_aux='UD' THEN
		DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_gully ON "SCHEMA_NAME".v_ui_doc_x_gully;
		CREATE TRIGGER gw_trg_ui_doc_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_doc_x_gully
		FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_gully);

		DROP TRIGGER IF EXISTS gw_trg_ui_elememt_x_gully ON "SCHEMA_NAME".v_ui_element_x_gully;
		CREATE TRIGGER gw_trg_ui_elememt_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_gully
		FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_gully);

		DROP TRIGGER IF EXISTS gw_trg_edit_visitman_x_gully ON "SCHEMA_NAME".v_ui_om_visitman_x_gully;
		CREATE TRIGGER gw_trg_edit_visitman_x_gully INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_gully FOR EACH ROW EXECUTE PROCEDURE 
		"SCHEMA_NAME".gw_trg_ui_visitman();

		DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".gully;
		CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".gully
		FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(gully);

		DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_gully_control ON gully;
		CREATE TRIGGER gw_trg_man_addfields_value_gully_control AFTER UPDATE OF gully_id OR DELETE ON SCHEMA_NAME.gully
		FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('GULLY');
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;