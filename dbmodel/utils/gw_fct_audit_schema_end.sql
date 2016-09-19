/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_audit_schema_end() RETURNS void AS $BODY$ 
DECLARE

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	DROP VIEW IF EXISTS "v_audit_schema_column" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_table" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_catalog_column" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_catalog_compare_table" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_catalog_compare_column" CASCADE;
   	DROP VIEW IF EXISTS "v_audit_schema_foreign_table" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_column" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_compare_table" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_compare_column" CASCADE;

	DROP TABLE IF EXISTS "audit_schema_data_integrity" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_data_node_integrity" CASCADE;

	
   RETURN;
       
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

