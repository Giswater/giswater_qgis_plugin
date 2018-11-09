/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_update_workcat_geom()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_enable boolean;
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
	-- Control of operative of trigger
	SELECT value::boolean INTO v_enable FROM config_param_system WHERE parameter='enable_update_workcat_geom';
	IF v_enable IS NOT TRUE THEN
		RETURN NULL;
	END IF;
		
	IF TG_OP = 'INSERT' THEN
	
		PERFORM gw_fct_update_workcat_geom('NEW.workcat_id');
		--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=NEW.workcat_id;
		IF NEW.workcat_id_end IS NOT NULL THEN
			PERFORM gw_fct_update_workcat_geom('NEW.workcat_id_end');
			--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=NEW.workcat_id_end;
		END IF;

		RETURN NEW;		
	
    ELSIF TG_OP = 'UPDATE' THEN

		IF OLD.workcat_id!= NEW.workcat_id THEN
			PEFORM gw_fct_update_workcat_geom('NEW.workcat_id');
			--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=NEW.workcat_id;	

			PERFORM gw_fct_update_workcat_geom('OLD.workcat_id');
			--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=OLD.workcat_id;   				
		END IF;
		
		IF OLD.workcat_id_end!= NEW.workcat_id_end THEN
			PERFORM gw_fct_update_workcat_geom('NEW.workcat_id_end');
			--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=NEW.workcat_id_end;	

			PERFORM gw_fct_update_workcat_geom('OLD.workcat_id_end');
			--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=OLD.workcat_id_end;   				
		END IF;		

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
    
		PERFORM gw_fct_update_workcat_geom('NEW.workcat_id_end');
		--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=OLD.workcat_id;

		PERFORM gw_fct_update_workcat_geom('OLD.workcat_id_end');
		--UPDATE cat_work SET the_geom=v_the_geom WHERE cat_work=OLD.workcat_id_end;   

	    RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  
DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON "SCHEMA_NAME".arc;
CREATE TRIGGER gw_trg_update_workcat_geom AFTER INSERT OR UPDATE OF the_geom, workcat_id, workcat_id_end OR DELETE
ON SCHEMA_NAME.arc FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_update_workcat_geom();

DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_update_workcat_geom AFTER INSERT OR UPDATE OF the_geom, workcat_id, workcat_id_end OR DELETE
ON SCHEMA_NAME.node FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_update_workcat_geom();

DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON "SCHEMA_NAME".connec;
CREATE TRIGGER gw_trg_update_workcat_geom AFTER INSERT OR UPDATE OF the_geom, workcat_id, workcat_id_end OR DELETE
ON SCHEMA_NAME.connec FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_update_workcat_geom();

DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON "SCHEMA_NAME".element;
CREATE TRIGGER gw_trg_update_workcat_geom AFTER INSERT OR UPDATE OF the_geom, workcat_id, workcat_id_end OR DELETE
ON SCHEMA_NAME.element FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_update_workcat_geom();
