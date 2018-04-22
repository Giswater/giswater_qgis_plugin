CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinsertform"(table_id varchar, lang varchar) RETURNS pg_catalog.int2 AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN gw_fct_getinsertform($1, $2, null, null); 
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

