/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION "ws_data_albert".gw_fct_audit_log_feature(enabled_aux text)
  RETURNS void AS
$BODY$ 
DECLARE
project_type_aux varchar;

BEGIN

	SET search_path = "ws_data_albert", public;
	
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	------------------
	-- ACTIVATE TRIGGER
	-------------------
	
		IF enabled_aux = 'ACTIVATE' THEN

			CREATE TRIGGER gw_trg_audit_log_feature_arc
			  AFTER UPDATE OR DELETE
			  ON "ws_data_albert".arc
			  FOR EACH ROW
			  EXECUTE PROCEDURE "ws_data_albert".gw_trg_audit_log_feature();
		  

			CREATE TRIGGER gw_trg_audit_log_feature_node
			  AFTER UPDATE OR DELETE
			  ON "ws_data_albert".node
			  FOR EACH ROW
			  EXECUTE PROCEDURE "ws_data_albert".gw_trg_audit_log_feature();
			  
			  
			CREATE TRIGGER gw_trg_audit_log_feature_connec
			  AFTER UPDATE OR DELETE
			  ON "ws_data_albert".connec
			  FOR EACH ROW
			  EXECUTE PROCEDURE "ws_data_albert".gw_trg_audit_log_feature();
			  
			  
			CREATE TRIGGER gw_trg_audit_log_feature_element
			  AFTER UPDATE OR DELETE
			  ON "ws_data_albert".element
			  FOR EACH ROW
			  EXECUTE PROCEDURE "ws_data_albert".gw_trg_audit_log_feature();
				  
			IF project_type_aux='UD' THEN
				  
				CREATE TRIGGER gw_trg_audit_log_feature_gully
				AFTER UPDATE OR DELETE
				ON "ws_data_albert".gully 
				FOR EACH ROW
				EXECUTE PROCEDURE "ws_data_albert".gw_trg_audit_log_feature();
			END IF;	  
		
		END IF;

	------------------
	-- ENABLE TRIGGER
	------------------

		IF enabled_aux = 'ENABLE' THEN

			ALTER TABLE "ws_data_albert".arc ENABLE TRIGGER gw_trg_audit_log_feature_arc;
			ALTER TABLE "ws_data_albert".node ENABLE TRIGGER gw_trg_audit_log_feature_node;
			ALTER TABLE "ws_data_albert".connec ENABLE TRIGGER gw_trg_audit_log_feature_connec;
			ALTER TABLE "ws_data_albert".element ENABLE TRIGGER gw_trg_audit_log_feature_element;

			IF project_type_aux='UD' THEN

				ALTER TABLE "ws_data_albert".gully ENABLE TRIGGER gw_trg_audit_log_feature_gully;
			END IF;

		END IF;

	------------------
	-- DISABLE TRIGGER
	------------------
	
		IF enabled_aux = 'DISABLE' THEN
			
			ALTER TABLE "ws_data_albert".arc DISABLE TRIGGER gw_trg_audit_log_feature_arc;
			ALTER TABLE "ws_data_albert".node DISABLE TRIGGER gw_trg_audit_log_feature_node;
			ALTER TABLE "ws_data_albert".connec DISABLE TRIGGER gw_trg_audit_log_feature_connec;
			ALTER TABLE "ws_data_albert".element DISABLE TRIGGER gw_trg_audit_log_feature_element;
			
			IF project_type_aux='UD' THEN
		
			ALTER TABLE "ws_data_albert".gully DISABLE TRIGGER gw_trg_audit_log_feature_gully;

			END IF;
			
		END IF;
		
	RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

	