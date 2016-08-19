/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- DROP FUNCTION SCHEMA_NAME.set_functions_schema(text, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.set_functions_schema(
    old_name text,
    new_name text)
  RETURNS void AS
$BODY$
 
DECLARE
	rec_view record;
	rec_fk record;
	rec_table text;
	rec_function record;
	rec_parameters record;
	tablename text;
	default_ text;
	column_ text;
	msg text;
	parameters_text text;

	on_delete_text text;
	on_update_text text;
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- Functions
	SET check_function_bodies = false;
	
	FOR rec_function IN
		SELECT routine_name, REPLACE(routine_definition, old_name, new_name) as definition, type_udt_name, external_language, specific_name FROM information_schema.ROUTINES WHERE routine_schema = new_name
	LOOP

		-- Get function parameters
		parameters_text := '';

		FOR rec_parameters IN
			SELECT parameter_mode, parameter_name, udt_name FROM information_schema.PARAMETERS WHERE specific_name = rec_function.specific_name ORDER BY ordinal_position
		LOOP
			parameters_text := parameters_text || rec_parameters.parameter_mode || ' ' || rec_parameters.parameter_name || ' ' || rec_parameters.udt_name || ', ';
		END LOOP;

		IF (char_length(parameters_text) > 0) THEN
			parameters_text := substring(parameters_text from 1 for (char_length(parameters_text) - 2));
		END IF;

		IF (rec_function.type_udt_name != 'trigger') THEN
			msg := 'CREATE OR REPLACE FUNCTION ' || new_name || '.' || quote_ident(rec_function.routine_name) || '(' ||parameters_text|| ') RETURNS ' || rec_function.type_udt_name || ' AS $BODY' || '$' || rec_function.definition || '$BODY' || '$'
			|| ' LANGUAGE '|| rec_function.external_language ||' VOLATILE COST 100;';
			EXECUTE msg;
		END IF;

	END LOOP;
	
	PERFORM SCHEMA_NAME.audit_function(0,100);
	RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.set_functions_schema(text, text)
  OWNER TO postgres
