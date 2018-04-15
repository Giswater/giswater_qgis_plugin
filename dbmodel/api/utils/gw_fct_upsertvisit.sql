CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_upsertvisit"(x float8, y float8, srid_arg int4, element_type varchar, id varchar, device int4, cur_user varchar) RETURNS pg_catalog.json AS $BODY$begin

SET search_path = "SCHEMA_NAME", public;
    RETURN gw_fct_upsertvisit($1, $2,  $3,  $4,  $5,  $6,  null, $7); 

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

