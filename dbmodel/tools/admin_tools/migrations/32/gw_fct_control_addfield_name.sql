/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 

--drop function SCHEMA_NAME.gw_fct_control_addfield_name();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_control_addfield_name()
  RETURNS void AS
$BODY$


DECLARE 

	v_unaccent_id text;
	rec record;

BEGIN	

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	FOR rec IN SELECT * FROM sys_addfields LOOP

		v_unaccent_id = array_to_string(ts_lexize('unaccent',rec.param_name),',','*');

		IF v_unaccent_id IS NOT NULL THEN
			UPDATE sys_addfields SET param_name = v_unaccent_id WHERE id=rec.id;
		END IF;
	END LOOP;

	FOR rec IN SELECT * FROM sys_addfields WHERE param_name ILIKE '%-%' OR param_name ilike '% %' OR param_name ilike '%.%' LOOP
		
		UPDATE sys_addfields SET param_name = replace(replace(replace(rec.param_name,'-','_'),' ','_'),'.','_') WHERE id=rec.id;

	END LOOP;	
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

