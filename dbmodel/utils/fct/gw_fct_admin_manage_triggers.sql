/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2818

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_schema_manage_triggers(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_triggers(p_action text, p_table text)
 RETURNS void AS
$BODY$

/*
EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_manage_triggers('notify',null);
SELECT SCHEMA_NAME.gw_fct_admin_manage_triggers('fk',null);
SELECT SCHEMA_NAME.gw_fct_admin_manage_triggers('fk','ALL');
SELECT SCHEMA_NAME.gw_fct_admin_manage_triggers('fk','CHECK');
*/

DECLARE

rec record;

v_version text;
v_notify_action json;
rec_json record; 
v_table record;
v_tableversion text = 'sys_version';
v_schemaname text = 'SCHEMA_NAME';

BEGIN
	
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- get info from version table
	IF (SELECT tablename FROM pg_tables WHERE schemaname = v_schemaname AND tablename = 'version') IS NOT NULL THEN v_tableversion = 'version'; END IF;
 	EXECUTE 'SELECT giswater FROM '||quote_ident(v_tableversion)||' LIMIT 1' INTO v_version;

	IF p_action = 'notify' THEN

		FOR rec IN (select * FROM sys_table WHERE notify_action IS NOT NULL AND id NOT IN (SELECT viewname FROM pg_views WHERE schemaname = 'SCHEMA_NAME')) LOOP
			v_notify_action = rec.notify_action;

			FOR rec_json IN  SELECT (a)->>'action' as action,(a)->>'name' as name, (a)->>'trg_fields' as trg_fields,(a)->>'featureType' as featureType 
			FROM json_array_elements(v_notify_action) a LOOP

				IF (rec.id ILIKE 'v_%' OR rec.id ILIKE 've_%' OR rec.id ILIKE 'vi_%') AND rec.id != 'vnode' 
				AND rec.id not ilike 'value%' AND rec_json.action = 'desktop' THEN

					EXECUTE 'DROP TRIGGER IF EXISTS  gw_trg_notify ON '||rec.id||';';
					EXECUTE  'CREATE TRIGGER gw_trg_notify 
							INSTEAD OF INSERT OR UPDATE OF '||rec_json.trg_fields||' OR DELETE ON '||rec.id||'
							FOR EACH ROW EXECUTE PROCEDURE gw_trg_notify('''||rec.id||''');';
					
				ELSE
					EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_notify ON '||rec.id||';';
					EXECUTE 'CREATE TRIGGER gw_trg_notify 
							AFTER INSERT OR UPDATE OF '||rec_json.trg_fields||' OR DELETE ON '||rec.id||'
							FOR EACH ROW EXECUTE PROCEDURE gw_trg_notify('''||rec.id||''');';
				END IF;
			END LOOP;
	 	END LOOP;

	ELSIF p_action = 'fk' AND p_table IS NOT NULL AND p_table NOT IN ('ALL', 'CHECK') THEN

		EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON '||p_table||';';
		EXECUTE 'CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON '||p_table||'
		FOR EACH ROW EXECUTE PROCEDURE gw_trg_typevalue_fk('''||p_table||''');';
				
	ELSIF p_action = 'fk' AND p_table IS NOT NULL AND p_table ='ALL' THEN

		FOR v_table IN SELECT * FROM sys_foreignkey WHERE active IS TRUE
		LOOP
			RAISE NOTICE ' v_table %', v_table;
			EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON '||v_table.target_table||';';
			EXECUTE 'CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON '||v_table.target_table||'
			FOR EACH ROW EXECUTE PROCEDURE gw_trg_typevalue_fk('''||v_table.target_table||''');';
		END LOOP;

	ELSIF p_action = 'fk' AND p_table IS NOT NULL AND p_table ='CHECK' THEN

		FOR v_table IN SELECT * FROM sys_foreignkey WHERE active IS TRUE
		LOOP
			RAISE NOTICE ' v_table %', v_table;
			EXECUTE 'UPDATE '||v_table.target_table||' SET '||v_table.target_field||' = '||v_table.target_field;
		END LOOP;

	END IF;
	
	RETURN;
	
END;
$BODY$
 LANGUAGE plpgsql VOLATILE
 COST 100;
