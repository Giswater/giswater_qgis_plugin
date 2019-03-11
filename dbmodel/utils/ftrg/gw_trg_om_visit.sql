
CREATE OR REPLACE FUNCTION gw_trg_om_visit()
  RETURNS trigger AS
$BODY$
DECLARE 

v_version text;
  

BEGIN

   EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

   v_version = (SELECT giswater FROM version ORDER by 1 desc LIMIT 1);

   IF TG_OP='INSERT' THEN
	
		-- automatic creation of workcat
		IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
			INSERT INTO cat_work (id) VALUES (NEW.id);
		END IF;

		-- setting values of enddate
		IF NEW.is_done IS FALSE THEN
			NEW.enddate=null;
		END IF;	

		RETURN NEW;


    ELSIF TG_OP='UPDATE' THEN	

		-- setting values of enddate
		IF NEW.is_done IS FALSE THEN
			NEW.enddate=null;
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