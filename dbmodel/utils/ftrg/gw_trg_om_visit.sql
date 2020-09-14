/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit()
  RETURNS trigger AS
$BODY$
DECLARE 

v_version text;
v_featuretype text;
v_triggerfromtable text;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_featuretype:= TG_ARGV[0];
    v_version = (SELECT giswater FROM sys_version ORDER by 1 desc LIMIT 1);


    IF v_featuretype IS NULL THEN
        v_triggerfromtable = 'om_visit';
    ELSE 
        v_triggerfromtable = 'om_visit_x_feature';
    END IF;

    IF TG_OP='INSERT' THEN
		 	
		-- automatic creation of workcat
		IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
			INSERT INTO cat_work (id) VALUES (NEW.id);
		END IF;

		IF v_triggerfromtable = 'om_visit' THEN -- we need workflow when function is triggered by om_visit (for this reason when parameter is null)

			-- when visit is not finished
			IF NEW.status < 4 THEN 
				NEW.enddate=null;
				
			-- when visit is finished and it has not lot_id assigned visit is automatic published
			ELSIF NEW.status=4 AND NEW.lot_id IS NULL THEN
				UPDATE om_visit SET publish=TRUE WHERE id=NEW.id;
			END IF;
            
            --set visit_type captured from class_id
			UPDATE om_visit SET visit_type=(SELECT visit_type FROM config_visit_class WHERE id=NEW.class_id) WHERE id=NEW.id;

			--TODO: when visit is inserted via QGIS, we need to set class_id (adding this widget in the form of the new visit)

		END IF;

		RETURN NEW;

    ELSIF TG_OP='UPDATE' AND v_triggerfromtable ='om_visit' THEN -- we need workflow when function is triggered by om_visit (for this reason when parameter is null)

		-- move status of lot element to status=0 (visited)

		IF NEW.status <> 4 THEN
			NEW.enddate=null;

			-- when visit is finished and it has lot_id assigned visit is automatic published
			IF NEW.status=5 AND NEW.lot_id IS NOT NULL THEN
				UPDATE om_visit SET publish=TRUE WHERE id=NEW.id;
			END IF;
			
		END IF;

		IF v_version > '3.2.019' THEN
			IF NEW.class_id != OLD.class_id THEN
				DELETE FROM om_visit_event WHERE visit_id=NEW.id;
			END IF;
		END IF;

		RETURN NEW;
				
    ELSIF TG_OP='DELETE' THEN
	
    	-- automatic creation of workcat
		IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
			DELETE FROM cat_work WHERE id=OLD.id::text;
		END IF;
		
		RETURN OLD;
		
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


