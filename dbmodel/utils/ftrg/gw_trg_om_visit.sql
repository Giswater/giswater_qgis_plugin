
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_om_visit()
  RETURNS trigger AS
$BODY$
DECLARE 
  

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';


    IF TG_OP='INSERT' THEN

	-- automatic creation of workcat
	IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
		INSERT INTO cat_work (id) VALUES (NEW.id);
	END IF;

	RETURN NEW;

    ELSIF TG_OP='UPDATE' THEN	
			
	IF NEW.class_id != OLD.class_id THEN
		DELETE FROM om_visit_event WHERE visit_id=NEW.id;			
	END IF;

	RETURN NEW;
				
    ELSIF TG_OP='DELETE' THEN
	DELETE FROM cat_work WHERE id=OLD.id::text;
	RETURN OLD;
		
    END IF;
		
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

