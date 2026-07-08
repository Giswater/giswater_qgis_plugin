/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3550

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_get_utils_language_ui();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_utils_language_ui()
RETURNS text AS
$BODY$
/*
Returns normalized multilang language id from config_param_user.utils_language_ui,
or NULL when multilang is unavailable or the parameter is unset.
*/
DECLARE
    v_lang text;
BEGIN
    SET search_path = "SCHEMA_NAME", public;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.schemata WHERE schema_name = 'multilang'
    ) THEN
        RETURN NULL;
    END IF;

    BEGIN
        SELECT
            value::json->>'lang'
        INTO v_lang
        FROM config_param_user
        WHERE parameter = 'utils_language_ui'
          AND cur_user = current_user;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END;

    IF v_lang IS NULL OR v_lang = '' OR length(v_lang) != 5 THEN
        RETURN NULL;
    END IF;

    RETURN lower(v_lang);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
