/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2946

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_notify()
  RETURNS trigger AS
$BODY$
DECLARE
	v_project_type text;
	v_notification text;
	v_table text;
	i integer;	
	rec_layers text; 
	v_parameters text;
	v_notification_data text;
	v_child_layer text;
	v_parent_layer text;
	v_schemaname text;
	v_channel text;
	rec_json json;
	rec record;
	v_query text;
	v_featuretype text;
	v_featuretype_replaced text;
	v_enabled text;
	v_name text;
	v_notification_all text;
	v_notification_data_desktop text;
	v_notification_data_user text;
	v_notification_all_desktop TEXT;
	v_notification_all_user text;
	v_notification_desktop text;
	v_notification_user text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;

	v_table = TG_ARGV[0];

	v_query = 'SELECT json_array_elements_text(notify_action) as data FROM sys_table WHERE id ='''||v_table||'''';
	
	FOR rec IN EXECUTE v_query LOOP

		rec_json= row_to_json(rec);

		v_channel = ((rec_json ->>'data')::json->>'channel')::text;
		v_featuretype = ((rec_json ->>'data')::json->>'featureType')::text;
		v_enabled = ((rec_json ->>'data')::json->>'enabled')::text;
		v_name = ((rec_json ->>'data')::json->>'name')::text;


		IF v_enabled = 'true'  THEN

			--transform notifications with layer name as input parameters
			IF v_featuretype != '[]' THEN
				

				--loop over input featureType in order to capture the layers related to feature type
				FOR rec_layers IN SELECT * FROM json_array_elements_text(v_featuretype::json) LOOP
					--select only child and parent layers of active features
					EXECUTE 'SELECT json_agg(child_layer) FROM cat_feature where active IS TRUE
					AND lower(feature_type) = '''||(rec_layers)||''''
					INTO v_child_layer;
					
					EXECUTE ' SELECT  json_agg(DISTINCT parent_layer) FROM cat_feature WHERE lower(feature_type) = '''||(rec_layers)||''' and parent_layer is not null'
					INTO v_parent_layer;
	
					--concatenate the notification out of parameters
					--concatenation for arc,node,connec,gully which have child layers
					IF v_parent_layer IS NOT NULL THEN
						v_parent_layer = replace(replace(v_parent_layer,'[',''),']','');
						v_child_layer = replace(replace(v_child_layer,'[',''),']','');
						
						v_parameters = v_parent_layer ||','|| v_child_layer;
						
						IF v_channel = 'desktop' THEN
							IF v_notification_data_desktop IS NULL OR 
							(v_notification_data_desktop IS NOT NULL AND v_notification_data_desktop ILIKE '%name%') THEN
								v_notification_data_desktop = null;
								v_notification_data_desktop = v_parameters;
							
							ELSIF v_notification_data_desktop IS NOT NULL AND v_notification_data_desktop not ILIKE '%name%' THEN
								v_notification_data_desktop = concat(v_notification_data_desktop,',',v_parameters);

							END IF;
						ELSIF v_channel = 'user' THEN
							IF v_notification_data_user IS NULL OR 
							(v_notification_data_user IS NOT NULL AND v_notification_data_user ILIKE '%name%') THEN
								v_notification_data_user = null;
								v_notification_data_user = v_parameters;
							
							ELSIF v_notification_data_user IS NOT NULL AND v_notification_data_user not ILIKE '%name%' THEN
								v_notification_data_user = concat(v_notification_data_user,',',v_parameters);

							END IF;
						END IF;
					ELSE 
					
						--remove parenthesis from the feature_types
						v_featuretype_replaced = concat('"',rec_layers,'"');
						
						--concatenation for other layers
						IF v_channel = 'desktop' THEN
							IF v_notification_data_desktop IS NOT NULL AND v_notification_data_desktop!=v_featuretype_replaced THEN
								v_notification_data_desktop = concat(v_notification_data_desktop,',',v_featuretype_replaced);
							ELSE 
								v_notification_data_desktop = v_featuretype_replaced;
							END IF;

						ELSIF v_channel = 'user' THEN
							IF v_notification_data_user IS NOT NULL AND v_notification_data_user!=v_featuretype_replaced THEN
						
								v_notification_data_user = concat(v_notification_data_user,',',v_featuretype_replaced);
						
							ELSE
								v_notification_data_user = v_featuretype_replaced;
							END IF;
						END IF;
					
					END IF;
										
				END LOOP;

				IF v_channel = 'desktop' THEN
					v_notification_data_desktop = '"parameters":{"tableName":['|| v_notification_data_desktop||']}';
					v_notification_data_desktop = '{"name":"'||v_name||'",'||v_notification_data_desktop||'}';

				ELSIF v_channel = 'user' THEN
					v_notification_data_user = '"parameters":{"tableName":['|| v_notification_data_user||']}';
					v_notification_data_user = '{"name":"'||v_name||'",'||v_notification_data_user||'}';

				END IF;
			ELSE
			--transform notifications without input parameters
				v_parameters = '"parameters":{}';
				
				v_notification_data = '{"name":"'||v_name||'",'||v_parameters||'}';
				
			END IF;
			
		END IF;

		--else
		IF v_channel = 'desktop' THEN
			IF v_notification_all_desktop is not null then
				v_notification_all_desktop = concat(v_notification_all_desktop,',',v_notification_data_desktop);
			ELSE 
				v_notification_all_desktop=v_notification_data_desktop;
			END IF;

		ELSIF v_channel = 'user' THEN
			IF v_notification_all_user is not null then
			
				v_notification_all_user = concat(v_notification_all_user,',',v_notification_data_user);
			ELSE 
				v_notification_all_user=v_notification_data_user;
			END IF;

		ELSE
			IF v_notification_all is not null then
			
				v_notification_all = concat(v_notification_all,',',v_notification_data);
				
			ELSE 
				v_notification_all=v_notification_data;
			END IF;
		END IF;		
	
	END LOOP;
	
	v_notification_desktop = '{"functions":['||v_notification_all_desktop||']}';
	v_notification_user = '{"functions":['||v_notification_all_user||']}';
	v_notification = '{"functions":['||v_notification_all||']}';
	


	
	IF v_channel IS NULL THEN
		v_channel='desktop';
	END IF;

	IF v_notification_desktop IS NOT NULL THEN
		PERFORM pg_notify(v_channel, '{"functionAction":'||v_notification_desktop||',"user":"'||current_user||'","schema":"'||v_schemaname||'"}');
		
	END IF;

	IF v_notification_user IS NOT NULL THEN
	
		v_channel = replace(current_user,'.','_');

		PERFORM pg_notify(v_channel, '{"functionAction":'||v_notification_user||',"user":"'||current_user||'","schema":"'||v_schemaname||'"}');
		
	END IF;	

	IF v_notification IS NOT NULL THEN
		v_channel='desktop';
		PERFORM pg_notify(v_channel, '{"functionAction":'||v_notification||',"user":"'||current_user||'","schema":"'||v_schemaname||'"}');
	END IF;	

	RETURN NEW;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
