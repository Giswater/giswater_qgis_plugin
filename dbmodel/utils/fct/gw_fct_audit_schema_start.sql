/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_audit_schema_start(foreign_schema varchar) RETURNS void AS $BODY$ 
DECLARE

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Execute functions
	PERFORM gw_fct_audit_schema_structure(foreign_schema);
	PERFORM gw_fct_audit_schema_data_integrity();
   
	RETURN;
       
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

