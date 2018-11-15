/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2422

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_audit_log_feature(enabled_aux text)
  RETURNS void AS
$BODY$ 
DECLARE
project_type_aux varchar;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	------------------
	-- ACTIVATE TRIGGER
	-------------------
	
		IF enabled_aux = 'ACTIVATE' THEN

			CREATE TRIGGER gw_trg_audit_log_feature_arc
			  AFTER UPDATE OR DELETE
			  ON "SCHEMA_NAME".arc
			  FOR EACH ROW
			  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_audit_log_feature();
		  

			CREATE TRIGGER gw_trg_audit_log_feature_node
			  AFTER UPDATE OR DELETE
			  ON "SCHEMA_NAME".node
			  FOR EACH ROW
			  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_audit_log_feature();
			  
			  
			CREATE TRIGGER gw_trg_audit_log_feature_connec
			  AFTER UPDATE OR DELETE
			  ON "SCHEMA_NAME".connec
			  FOR EACH ROW
			  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_audit_log_feature();
			  
			  
			CREATE TRIGGER gw_trg_audit_log_feature_element
			  AFTER UPDATE OR DELETE
			  ON "SCHEMA_NAME".element
			  FOR EACH ROW
			  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_audit_log_feature();
				  
			IF project_type_aux='UD' THEN
				  
				CREATE TRIGGER gw_trg_audit_log_feature_gully
				AFTER UPDATE OR DELETE
				ON "SCHEMA_NAME".gully 
				FOR EACH ROW
				EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_audit_log_feature();
			END IF;	  
		
		END IF;

	------------------
	-- ENABLE TRIGGER
	------------------

		IF enabled_aux = 'ENABLE' THEN

			ALTER TABLE "SCHEMA_NAME".arc ENABLE TRIGGER gw_trg_audit_log_feature_arc;
			ALTER TABLE "SCHEMA_NAME".node ENABLE TRIGGER gw_trg_audit_log_feature_node;
			ALTER TABLE "SCHEMA_NAME".connec ENABLE TRIGGER gw_trg_audit_log_feature_connec;
			ALTER TABLE "SCHEMA_NAME".element ENABLE TRIGGER gw_trg_audit_log_feature_element;

			IF project_type_aux='UD' THEN

				ALTER TABLE "SCHEMA_NAME".gully ENABLE TRIGGER gw_trg_audit_log_feature_gully;
			END IF;

		END IF;

	------------------
	-- DISABLE TRIGGER
	------------------
	
		IF enabled_aux = 'DISABLE' THEN
			
			ALTER TABLE "SCHEMA_NAME".arc DISABLE TRIGGER gw_trg_audit_log_feature_arc;
			ALTER TABLE "SCHEMA_NAME".node DISABLE TRIGGER gw_trg_audit_log_feature_node;
			ALTER TABLE "SCHEMA_NAME".connec DISABLE TRIGGER gw_trg_audit_log_feature_connec;
			ALTER TABLE "SCHEMA_NAME".element DISABLE TRIGGER gw_trg_audit_log_feature_element;
			
			IF project_type_aux='UD' THEN
		
			ALTER TABLE "SCHEMA_NAME".gully DISABLE TRIGGER gw_trg_audit_log_feature_gully;

			END IF;
			
		END IF;
		
	RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

	