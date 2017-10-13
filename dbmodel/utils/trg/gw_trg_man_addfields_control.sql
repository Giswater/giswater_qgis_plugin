
SET search_path='SCHEMA_NAME';

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_man_addfields_value_control()
  RETURNS trigger AS
$BODY$
DECLARE 
project_type_aux varchar;
feature_type_aux varchar;
feature_new_aux varchar;
feature_old_aux varchar;
featurecat_aux varchar;
rec_param record;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    feature_type_aux:= TG_ARGV[0];

    SELECT wsoftware INTO project_type_aux FROM version;

    IF project_type_aux='WS' THEN
	IF feature_type_aux='NODE' THEN
		SELECT nodetype_id INTO featurecat_aux FROM v_edit_node WHERE node_id=NEW.node_id;		
		feature_new_aux:= NEW.node_id;
	ELSIF feature_type_aux='ARC' THEN
		SELECT cat_arctype_id INTO featurecat_aux FROM v_edit_arc WHERE arc_id=NEW.arc_id;
		feature_new_aux:= NEW.arc_id;
	ELSIF feature_type_aux='CONNEC' THEN
		SELECT connectype_id INTO featurecat_aux FROM v_edit_connec WHERE connec_id=NEW.connec_id;
		feature_new_aux:= NEW.connec_id;
	END IF;
	
    ELSIF project_type_aux='UD' THEN
	IF feature_type_aux='NODE' THEN
		SELECT node_type INTO featurecat_aux FROM v_edit_node WHERE node_id=NEW.node_id;
		feature_new_aux:= NEW.node_id;	
	ELSIF feature_type_aux='ARCR' THEN
		SELECT arc_type INTO featurecat_aux FROM v_edit_arc WHERE arc_id=NEW.arc_id;
		feature_new_aux:= NEW.arc_id;
	ELSIF feature_type_aux='CONNEC' THEN
		SELECT connec_type INTO featurecat_aux FROM v_edit_connec WHERE connec_id=NEW.connec_id;
		feature_new_aux:= NEW.connec_id;
	ELSIF feature_type_aux='GULLY' THEN
		SELECT gully_type INTO featurecat_aux FROM v_edit_connec WHERE gully_id=NEW.gully_id;
		feature_new_aux:= NEW.gully_id;
	END IF;

    END IF;
    
    IF TG_OP = 'INSERT' THEN

		FOR rec_param IN SELECT * FROM man_addfields_parameter WHERE featurecat_id=featurecat_aux
		LOOP
			INSERT INTO man_addfields_value (feature_id, parameter_id)
			VALUES (feature_new_aux, rec_param.id);

		END LOOP;

     ELSIF TG_OP ='UPDATE' OR TG_OP='DELETE' THEN

	IF project_type_aux='WS' THEN
		IF feature_type_aux='NODE' THEN
			feature_old_aux:= OLD.node_id;
		ELSIF feature_type_aux='NODE' THEN
			feature_old_aux:= OLD.arc_id;
		ELSIF feature_type_aux='CONNEC' THEN
			feature_old_aux:= OLD.connec_id;
		END IF;
	ELSIF project_type_aux='UD' THEN
		IF feature_type_aux='ARC' THEN
			feature_old_aux:= OLD.node_id;	
		ELSIF feature_type_aux='NODE' THEN
			feature_old_aux:= OLD.arc_id;
		ELSIF feature_type_aux='CONNEC' THEN
			feature_old_aux:= OLD.connec_id;
		ELSIF feature_type_aux='GULLY' THEN
			feature_old_aux:= OLD.gully_id;
		END IF;
	END IF;

	IF TG_OP ='UPDATE' THEN

		UPDATE man_addfields_value SET feature_id=feature_new_aux  WHERE feature_old_aux;

	ELSIF TG_OP ='DELETE' THEN

		DELETE FROM man_addfields_value WHERE feature_old_aux;
	
	END IF;

    END IF;
	
RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_trg_man_addfields_value_control()
  OWNER TO postgres;


CREATE TRIGGER gw_trg_man_addfields_value_node_control AFTER INSERT OR UPDATE OF node_id OR DELETE ON SCHEMA_NAME.node
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('NODE');

CREATE TRIGGER gw_trg_man_addfields_value_arc_control AFTER INSERT OR UPDATE OF arc_id OR DELETE ON SCHEMA_NAME.arc
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('ARC');

CREATE TRIGGER gw_trg_man_addfields_value_connec_control AFTER INSERT OR UPDATE OF connec_id OR DELETE ON SCHEMA_NAME.control
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('CONNEC');









  
