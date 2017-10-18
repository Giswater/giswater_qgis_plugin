


--DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_trg_man_addfields_value_update();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_man_addfields_value_update()
  RETURNS TRIGGER AS
$BODY$
DECLARE 
rec_param record;
feature_type_aux varchar;
rec_feature record;
    
BEGIN

    --    Search path
    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    SELECT feature_type INTO feature_type_aux FROM cat_feature WHERE id=NEW.featurecat_id ;

    IF TG_OP='INSERT' THEN

	IF feature_type_aux='NODE' THEN
		FOR rec_feature IN SELECT node_id FROM node WHERE state>0
		LOOP
			INSERT INTO man_addfields_value (feature_id, parameter_id)
			VALUES (rec_feature.node_id, NEW.id);
		END LOOP;
	
	ELSIF feature_type_aux='ARC' THEN
		FOR rec_feature IN SELECT arc_id FROM arc WHERE state>0
		LOOP
			INSERT INTO man_addfields_value (feature_id, parameter_id)
			VALUES (rec_feature.arc_id, NEW.id);
		END LOOP;
	
	ELSIF feature_type_aux='CONNEC' THEN
		FOR rec_feature IN SELECT connec_id FROM connec WHERE state>0
		LOOP
			INSERT INTO man_addfields_value (feature_id, parameter_id)
			VALUES (rec_feature.connec_id, NEW.id);
		END LOOP;
	
	ELSIF feature_type_aux='GULLY' THEN
		FOR rec_feature IN SELECT gully_id FROM gully WHERE state>0
		LOOP
			INSERT INTO man_addfields_value (feature_id, parameter_id)
			VALUES (rec_feature.gully_id, NEW.id);
		END LOOP;
	
	END IF;

 
     ELSIF TG_OP = 'DELETE' THEN
        
		RETURN NULL;
    
      END IF;
    

RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_update ON "SCHEMA_NAME".man_addfields_parameter ;
CREATE TRIGGER gw_trg_man_addfields_value_update AFTER INSERT OR DELETE ON "SCHEMA_NAME".man_addfields_parameter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_man_addfields_value_update();