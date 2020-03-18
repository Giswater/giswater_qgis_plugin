-- Function: gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_createcombojson(
    label_arg text,
    name_arg text,
    type_arg text,
    datatype_arg text,
    placeholder_arg text,
    disabled_arg boolean,
    table_name_text text,
    id_column text,
    name_column text,
    selected_id text)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    combo_json json;
    schemas_array name[];

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

   combo_json := gw_fct_createcombojson(label_arg, name_arg, type_arg, datatype_arg, placeholder_arg, disabled_arg, table_name_text, id_column, name_column, selected_id, null);

    RETURN combo_json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text)
  OWNER TO bgeoadmin;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text) TO bgeoadmin;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text) TO role_basic;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text) TO qgisserver;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text) TO test;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_createcombojson(text, text, text, text, text, boolean, text, text, text, text) TO role_admin;
