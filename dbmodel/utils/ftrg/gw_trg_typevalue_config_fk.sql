/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2750

-- DROP FUNCTION gw_trg_typevalue_config_fk();

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
	
	raise notice 'v_table,%',v_table;
	--on insert of a new typevalue creat a trigger for the table
	IF TG_OP = 'INSERT' AND v_table = 'typevalue_fk' THEN
	
		PERFORM SCHEMA_NAME.gw_fct_admin_schema_manage_triggers('fk', NEW.target_table);

	--in case of update on one of the defined typevalue table
	ELSIF TG_OP = 'UPDATE' and v_table IN (SELECT DISTINCT typevalue_table FROM typevalue_fk) THEN
		
		--select configuration from the typevalue_fk and related typevalue for the selected value
		
		v_query =  'SELECT *  FROM typevalue_fk JOIN '||v_table||' ON '||v_table||'.typevalue = typevalue_name 
		and '||v_table||'.id = '''||NEW.id||''';';

		raise notice 'v_query,%',v_query;	
		
			FOR rec IN EXECUTE v_query LOOP
				--if typevalue is a system typevalue - error, cant modify value, else update values of fields where it's used
				IF rec.typevalue_name IN (SELECT typevalue_name FROM sys_typevalue_cat) THEN
					
					PERFORM audit_function(3028,2750,rec.typevalue_name);
				ELSE

					EXECUTE 'UPDATE '||rec.target_table||' SET '||rec.target_field||' = '''||NEW.id||''' 
					WHERE '||rec.target_field||' = '''||OLD.id||''';';
				END IF;
			END LOOP;

	ELSIF TG_OP = 'DELETE' then --and v_table IN (SELECT typevalue_table FROM typevalue_fk) THEN

		--select configuration from the related typevalue table
		v_query = 'SELECT * FROM SCHEMA_NAME.'||v_table||' WHERE '||v_table||'.typevalue = '''|| OLD.typevalue||''' AND  '||v_table||'.id = '''||OLD.id||''';';
		RAISE NOTICE 'v_query,%',v_query;

		--if typevalue is a system typevalue - error, cant delete the value, else proceed with the delete process
		IF OLD.typevalue IN (SELECT typevalue_name FROM sys_typevalue_cat) THEN
			
			PERFORM audit_function(3028,2750,OLD.typevalue);
		ELSE 
			--select configuration from the typevalue_fk table
			v_query = 'SELECT * FROM typevalue_fk WHERE typevalue_table = '''||v_table||''' AND typevalue_name = '''||OLD.typevalue||''';';
			RAISE NOTICE 'v_query,%',v_query;
			
			EXECUTE v_query INTO v_typevalue_fk;

			RAISE NOTICE 'v_typevalue_fk,%',v_typevalue_fk;

			--loop over all the fields that may use the defined value
			FOR rec IN EXECUTE v_query LOOP
				--check if the value is still being used, if so - error cant delete the value of typevalue, else proceed with delete
				EXECUTE 'SELECT count('||rec.target_field||') FROM '||rec.target_table||' WHERE '||rec.target_field||' = '''||OLD.id||''''
				INTO v_count;

				IF v_count > 0 THEN

					PERFORM audit_function(3030,2750,rec.typevalue_name);
				END IF;
				--check if the value is the last one defined for the typevalue, if so delete the configuration from typevalue_fk
				EXECUTE 'SELECT count(typevalue) FROM '||v_typevalue_fk.typevalue_table||' WHERE typevalue = '''||v_typevalue_fk.typevalue_name||''''
				INTO v_count;
				
				IF v_count = 0 THEN
					EXECUTE 'DELETE FROM typevalue_fk WHERE typevalue_table = '''||v_typevalue_fk.typevalue_table||''' and typevalue_name = '''||v_typevalue_fk.typevalue_name||''';';
				END IF;

			END LOOP; 
			
		END IF;
		
	END IF;

	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;