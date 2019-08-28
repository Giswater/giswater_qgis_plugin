/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

--drop function SCHEMA_NAME.gw_fct_admin_schema_manage_triggers();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_manage_triggers(p_action text)
 RETURNS void AS
$BODY$
/*
EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_triggers('notify');
SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_triggers('fk');
*/
DECLARE
	v_action text;
	rec record;
	rec_view record;
	v_query text;
	v_version text;
	v_trg_fields text;
	v_notify_action json;
	aux_json record;  

BEGIN
	
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	IF p_action = 'notify' THEN

		FOR rec IN (select * FROM audit_cat_table WHERE notify_action IS NOT NULL) LOOP
			v_notify_action = rec.notify_action;

			FOR aux_json IN  SELECT (a)->>'action' as action,(a)->>'name' as name, (a)->>'trg_fields' as trg_fields,(a)->>'featureType' as featureType FROM json_array_elements(v_notify_action) a LOOP

				raise notice 'aux_json,%',aux_json;

				IF rec.id ILIKE 'v_%' OR rec.id ILIKE 've_%' OR rec.id ILIKE 'vi_%' THEN

					EXECUTE 'DROP TRIGGER IF EXISTS  gw_trg_notify_'||aux_json.action||' ON '||rec.id||';';
					EXECUTE  'CREATE TRIGGER gw_trg_notify_'||aux_json.action||' 
							INSTEAD OF INSERT OR UPDATE OF '||aux_json.trg_fields||' OR DELETE ON '||rec.id||'
							FOR EACH ROW EXECUTE PROCEDURE gw_trg_notify('''||rec.id||''');';
					
				ELSE
					EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_notify_'||aux_json.action||' ON '||rec.id||';';
					EXECUTE 'CREATE TRIGGER gw_trg_notify_'||aux_json.action||' 
							AFTER INSERT OR UPDATE OF '||aux_json.trg_fields||' OR DELETE ON '||rec.id||'
							FOR EACH ROW EXECUTE PROCEDURE gw_trg_notify('''||rec.id||''');';
					
				END IF;
			
			END LOOP;
			
	 	END LOOP;

	ELSIF p_action = 'fk' THEN
			

			FOR rec IN (SELECT * FROM typevalue_fk ) LOOP
			
				EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON '||rec.target_table||';';
				EXECUTE 'CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON '||rec.target_table||'
				FOR EACH ROW EXECUTE PROCEDURE gw_trg_typevalue_fk('''||rec.target_table||''');';
	 			
			END LOOP;	


	END IF;
END;
$BODY$
 
 LANGUAGE plpgsql VOLATILE
 COST 100;