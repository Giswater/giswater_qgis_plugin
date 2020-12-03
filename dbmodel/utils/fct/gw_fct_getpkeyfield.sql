/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 2984

-- Function: SCHEMA_NAME.gw_fct_getpkeyfield(character varying)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getpkeyfield(character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getpkeyfield(
    p_layer_name character varying)
  RETURNS character varying AS
$BODY$

DECLARE

v_geom_field text;
v_schemaname text;

BEGIN
	-- Search path
	SET search_path = 'SCHEMA_NAME', public;
	v_schemaname := 'SCHEMA_NAME';
	
	-- Get id column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
	INTO v_geom_field
	USING p_layer_name;
	
	-- For views it suposse pk is the first column
	IF v_geom_field ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_geom_field
		USING p_layer_name, v_schemaname;
	END IF;

	RETURN v_geom_field;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
