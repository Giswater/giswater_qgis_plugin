-- Function: SCHEMA_NAME.gw_trg_notify()

-- DROP FUNCTION SCHEMA_NAME.gw_trg_notify();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_notify()
  RETURNS trigger AS
$BODY$
DECLARE
	v_project_type text;
	v_notification text;
	v_table text;
	i integer;
	v_notify_action_json json;
	v_notify record;
	
	rec_notify_action record; 
	rec_layers text; 
	rec_layers_child text;
	rec_layers_parent text;
	
	v_parameters text;
	
	v_notification_layer text;
	v_notification_data text;
	v_child_layer text;
	v_parent_layer text;
	v_notify_for_all text;
	v_schemaname text;
	v_action text;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_schemaname = 'SCHEMA_NAME';

	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	v_table = TG_ARGV[0];

	EXECUTE 'SELECT notify_action FROM audit_cat_table WHERE id = '''||v_table||''''
	INTO v_notify_action_json;
	
	SELECT (a)->>'action' INTO v_action  FROM json_array_elements(v_notify_action_json) a;
	
	--capture data from the input json
	FOR rec_notify_action IN SELECT (a)->>'action' as action,(a)->>'name' as name, (a)->>'enabled' as enabled, 
	(a)->>'featureType' as featureType FROM json_array_elements(v_notify_action_json) a LOOP

		--transform enabled notifications for desktop
		IF rec_notify_action.enabled = 'true'  THEN
		
			--transform notifications with layer name as input parameters
			IF rec_notify_action.featureType != '[]' THEN
				
				--loop over input featureType in order to capture the layers related to feature type
				FOR rec_layers IN SELECT * FROM json_array_elements_text(rec_notify_action.featureType::json) LOOP
				raise notice'rec_layers,%',rec_layers;
					--select only child and parent layers of active features
					IF v_project_type ='WS' THEN
						EXECUTE 'SELECT json_agg(child_layer) FROM cat_feature where id IN (SELECT id FROM node_type WHERE active IS TRUE
										UNION SELECT id FROM arc_type  WHERE active IS TRUE
										UNION SELECT id FROM connec_type  WHERE active IS TRUE
										)
										AND lower(feature_type) = '''||(rec_layers)||''''
						INTO v_child_layer;
						
					ELSIF v_project_type ='UD' THEN
						EXECUTE 'SELECT json_agg(child_layer) FROM cat_feature where id IN (SELECT id FROM node_type WHERE active IS TRUE
										UNION SELECT id FROM arc_type  WHERE active IS TRUE
										UNION SELECT id FROM connec_type  WHERE active IS TRUE
										UNION SELECT id FROM gully_type  WHERE active IS TRUE
										)
										AND lower(feature_type) = '''||(rec_layers)||''''
						INTO v_child_layer;
					END IF;

					EXECUTE ' SELECT  json_agg(DISTINCT parent_layer) FROM cat_feature WHERE lower(feature_type) = '''||(rec_layers)||''''
					INTO v_parent_layer;
					--concatenate the notification out of parameters
					--concatenation for arc,node,connec,gully which have child layers
					IF v_parent_layer IS NOT NULL THEN
						v_parent_layer = replace(replace(v_parent_layer,'[',''),']','');
						v_child_layer = replace(replace(v_child_layer,'[',''),']','');
						
						raise notice 'v_parent_layer ,%',v_parent_layer ;
						raise notice 'v_child_layer ,%',v_child_layer ;
						
						v_parameters = v_parent_layer ||','|| v_child_layer;
						
						
							IF v_notification_data IS NULL THEN
								v_notification_data = v_parameters;
							ELSE
								v_notification_data = concat(v_notification_data,',',v_parameters);
							END IF;
					ELSE 
					--concatenation for other layers
						IF v_notification_data IS NOT NULL THEN
							v_notification_data = concat(v_notification_data,',',replace(replace(rec_notify_action.featureType,'[',''),']',''));
						ELSE
							v_notification_data = replace(replace(rec_notify_action.featureType,'[',''),']','');
						END IF;
					END IF;
										
				END LOOP;
				
				v_notification_data = '"parameters":{"tableName":['|| v_notification_data||']}';
				v_notification_data = '{"name":"'||rec_notify_action.name||'",'||v_notification_data||'}';
						raise notice 'v_notification_data ,%',v_notification_data ;
			ELSE
			--transform notifications without input parameters
				v_parameters = '"parameters":{}';
				
				v_notification_data = '{"name":"'||rec_notify_action.name||'",'||v_parameters||'}';
				
			END IF;
			
		END IF;
		
	END LOOP;
	
	
	v_notification = '{"functions":['||v_notification_data||']}';
	raise notice 'v_notification,%',v_notification;
	
	v_notification := COALESCE(v_notification, '{}');

	IF v_action = 'user' THEN
		v_action = current_user;
	END IF;
	
	PERFORM pg_notify(v_action, '{"functionAction":'||v_notification||',"user":"'||current_user||'","schema":"'||v_schemaname||'"}');
	

	RETURN new;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
