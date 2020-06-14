/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2444

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_audit_log_feature()
  RETURNS trigger AS
$BODY$
DECLARE
project_type_aux varchar;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT project_type INTO project_type_aux FROM sys_version LIMIT 1;

	-- ARC
	IF OLD.feature_type = 'ARC' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'DELETE',row_to_json(row) FROM arc WHERE arc_id=OLD.arc_id;
			RETURN OLD;
			
		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'UPDATE',row_to_json(row) FROM arc WHERE arc_id=OLD.arc_id;
			RETURN OLD;
		END IF;
	
	-- NODE
	ELSIF OLD.feature_type = 'NODE' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'DELETE',row_to_json(row) FROM node WHERE node_id=OLD.node_id;
			RETURN OLD;
			
		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'UPDATE',row_to_json(row) FROM node WHERE node_id=OLD.node_id;
			RETURN OLD;
		END IF;
		
	-- CONNEC
	ELSIF OLD.feature_type = 'CONNEC' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'DELETE',row_to_json(row) FROM connec WHERE connec_id=OLD.connec_id;
			RETURN OLD;
			
		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'UPDATE',row_to_json(row) FROM connec WHERE connec_id=OLD.connec_id;
			RETURN OLD;
		END IF;

	-- ELEMENT
	ELSIF OLD.feature_type = 'ELEMENT' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'DELETE',row_to_json(row) FROM element WHERE element_id=OLD.element_id;
			RETURN OLD;
			
		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
			SELECT 17,OLD.feature_type,'UPDATE',row_to_json(row) FROM element WHERE element_id=OLD.element_id;
			RETURN OLD;
		END IF;
	END IF;
	
	IF project_type_aux='UD' AND OLD.feature_type = 'GULLY' THEN
			IF TG_OP = 'DELETE' THEN
				INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
				SELECT 17,OLD.feature_type,'DELETE',row_to_json(row) FROM gully WHERE gully_id=OLD.gully_id;
				RETURN OLD;
			
			ELSIF TG_OP = 'UPDATE' THEN
				INSERT INTO audit_log_data (fid,feature_type,log_message,feature_id, addparam)
				SELECT 17,OLD.feature_type,'UPDATE',row_to_json(row) FROM gully WHERE gully_id=OLD.gully_id;
				RETURN OLD;
			END IF;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
