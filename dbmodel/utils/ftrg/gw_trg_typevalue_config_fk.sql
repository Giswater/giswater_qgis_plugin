/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2750

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_typevalue_config_fk()
  RETURNS trigger AS
$BODY$
DECLARE 


DECLARE
	v_table text;
	v_typevalue_fk record;
	rec record;
	v_old_typevalue text;
	v_count integer;
	v_query text;
	v_sys_typevalue_name text[]; 

		
	
BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	
	v_table:= TG_ARGV[0];

	--on insert of a new typevalue create a trigger for the table
	IF TG_OP = 'INSERT' AND v_table = 'sys_foreignkey' THEN
		
		--check if there are values on the defined fileds that already have a value that is not present in a catalog
		IF NEW.parameter_id IS NULL THEN
			EXECUTE 'SELECT count('||NEW.target_field||') FROM '||NEW.target_table||' WHERE '||NEW.target_field||' is not null 
				AND '||NEW.target_field||'::text NOT IN (SELECT id::text FROM '||NEW.typevalue_table||' WHERE typevalue = '''||NEW.typevalue_name||''')'
			into v_count;
		ELSE
			EXECUTE 'SELECT count('||NEW.target_field||') FROM '||NEW.target_table||' WHERE parameter_id = '||NEW.parameter_id||' AND  '||NEW.target_field||' is not null 
				AND '||NEW.target_field||'::text NOT IN (SELECT id::text FROM '||NEW.typevalue_table||' WHERE typevalue = '''||NEW.typevalue_name||''')'

			into v_count;
		END IF;
		--if there is a value - error message, if not create a trigger for the defined typevalue 
		IF v_count > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       		"data":{"message":"3032", "function":"2750","debug_msg":null}}$$);';
		ELSE 
			PERFORM gw_fct_admin_manage_triggers('fk', NEW.target_table);
		END IF;

	--in case of update on one of the defined typevalue table
	ELSIF TG_OP = 'UPDATE' and v_table IN (SELECT DISTINCT typevalue_table FROM sys_foreignkey) THEN
		
		--select configuration from the sys_foreignkey and related typevalue for the selected value
		IF OLD.typevalue IN (SELECT typevalue_name FROM sys_typevalue) THEN
			IF NEW.typevalue != OLD.typevalue OR NEW.id != OLD.id THEN

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       				"data":{"message":"3028", "function":"2750","debug_msg":"'||OLD.typevalue||'"}}$$);';
			END IF;
		ELSE
			v_query =  'SELECT *  FROM sys_foreignkey JOIN '||v_table||' ON '||v_table||'.typevalue = typevalue_name
			and typevalue_name = '''||NEW.typevalue||''';';

			IF NEW.id!= OLD.id THEN
				
				FOR rec IN EXECUTE v_query LOOP

					--EXECUTE 'ALTER TABLE '||rec.target_table||' DISABLE TRIGGER gw_trg_typevalue_fk';
					
					EXECUTE 'UPDATE '||rec.target_table||' SET '||rec.target_field||' = '''||NEW.id||''' 
					WHERE '||rec.target_field||' = '''||OLD.id||''';';
					
					--EXECUTE 'ALTER TABLE '||rec.target_table||' ENABLE TRIGGER gw_trg_typevalue_fk';
				END LOOP;
			END IF;
		END IF;
		
	ELSIF TG_OP = 'UPDATE' AND v_table = 'sys_foreignkey' THEN

		EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON '||OLD.target_table||';';
		
		PERFORM gw_fct_admin_manage_triggers('fk', NEW.target_table);

	ELSIF TG_OP = 'DELETE' then --and v_table IN (SELECT typevalue_table FROM sys_foreignkey) THEN

		--select configuration from the related typevalue table
		v_query = 'SELECT * FROM SCHEMA_NAME.'||v_table||' WHERE '||v_table||'.typevalue = '''|| OLD.typevalue||''' AND  '||v_table||'.id = '''||OLD.id||''';';

		--if typevalue is a system typevalue - error, cant delete the value, else proceed with the delete process
		IF OLD.typevalue IN (SELECT typevalue_name FROM sys_typevalue) THEN
			
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       		"data":{"message":"3028", "function":"2750","debug_msg":"'||OLD.typevalue||'"}}$$);';
		ELSE 
			--select configuration from the sys_foreignkey table
			v_query = 'SELECT * FROM sys_foreignkey WHERE typevalue_table = '''||v_table||''' AND typevalue_name = '''||OLD.typevalue||''';';
	
			EXECUTE v_query INTO v_typevalue_fk;

			--loop over all the fields that may use the defined value
			FOR rec IN EXECUTE v_query LOOP
				--check if the value is still being used, if so - error cant delete the value of typevalue, else proceed with delete
				EXECUTE 'SELECT count('||rec.target_field||') FROM '||rec.target_table||' WHERE '||rec.target_field||' = '''||OLD.id||''''
				INTO v_count;

				IF v_count > 0 THEN

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       				"data":{"message":"3030", "function":"2750","debug_msg":"'||rec.typevalue_name||'"}}$$);';
				END IF;
				--check if the value is the last one defined for the typevalue, if so delete the configuration from sys_foreignkey
				EXECUTE 'SELECT count(typevalue) FROM '||v_typevalue_fk.typevalue_table||' WHERE typevalue = '''||v_typevalue_fk.typevalue_name||''''
				INTO v_count;
				
				IF v_count = 0 THEN
					EXECUTE 'DELETE FROM sys_foreignkey WHERE typevalue_table = '''||v_typevalue_fk.typevalue_table||''' and typevalue_name = '''||v_typevalue_fk.typevalue_name||''';';
				END IF;

			END LOOP; 
			
		END IF;
		
	END IF;

	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;