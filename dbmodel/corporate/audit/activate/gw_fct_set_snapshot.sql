/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- DROP FUNCTION SCHEMA_NAME.gw_fct_set_snapshot();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_set_snapshot(p_description TEXT DEFAULT NULL)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

DECLARE

v_schemaname text;
v_child text;
v_pk_name text;
v_table_name text;
v_date DATE := CURRENT_DATE;

BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Insert the first snapshot
	INSERT INTO snapshot (date, descripcion) VALUES (v_date, p_description);

	-- Get childs from cat_feature
	FOR v_child IN (SELECT child_layer FROM PARENT_SCHEMA.cat_feature) LOOP

		-- Create table name
		v_table_name := format('PARENT_SCHEMA_%I', v_child);

		-- Check if table exists
		IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_table_name) THEN

			 -- Create empty table with the same columns structure
            EXECUTE FORMAT('CREATE TABLE %I (LIKE PARENT_SCHEMA.%I INCLUDING ALL)', v_table_name, v_child);

			-- Get primary key column name
			SELECT column_name INTO v_pk_name FROM information_schema.COLUMNS
			WHERE table_schema = 'PARENT_SCHEMA' AND table_name = v_child LIMIT 1;

			-- Add date column at the end of the table
            EXECUTE format('ALTER TABLE %I ADD COLUMN date DATE ', v_table_name);

			-- Add foreign key constraint to reference the primary key of snapshot
			EXECUTE format('ALTER TABLE %I ADD CONSTRAINT fk_snapshot_date FOREIGN KEY (date) REFERENCES snapshot(date)', v_table_name);

			-- Add primary keys
            EXECUTE format('ALTER TABLE %I ADD PRIMARY KEY (date, %I)', v_table_name, v_pk_name);

		END IF;

		-- Insert current data and current date from v_child into v_table_name
		EXECUTE format('INSERT INTO %I SELECT *, %L FROM PARENT_SCHEMA.%I', v_table_name, v_date, v_child);

    END LOOP;

return 0;
END;

$function$
;
