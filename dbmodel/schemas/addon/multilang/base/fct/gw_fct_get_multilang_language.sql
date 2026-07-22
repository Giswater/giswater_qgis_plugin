/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3566

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_get_multilang_language();
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_get_multilang_language(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_multilang_language(p_schema_name text)
RETURNS jsonb AS
$BODY$
/*
Returns jsonb {"lang": "...", "project_type": "..."} from cat_user_lang for the
given network schema and current_user, or NULL when unset / invalid.

Translations are keyed by project_type; language preference remains per schema.
*/
DECLARE
    v_lang text;
    v_project_type text;
    v_schema text;
    v_prev_search_path text;
BEGIN
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'multilang,public', true);

    v_schema := NULLIF(btrim(p_schema_name), '');
    IF v_schema IS NULL THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NULL;
    END IF;

    BEGIN
        SELECT
            lang,
            project_type
        INTO v_lang, v_project_type
        FROM cat_user_lang
        WHERE schema_name = v_schema
          AND username = current_user;
    EXCEPTION WHEN OTHERS THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NULL;
    END;

    IF v_lang IS NULL OR v_lang = '' OR length(v_lang) != 5 THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NULL;
    END IF;

    IF v_project_type IS NULL OR btrim(v_project_type) = '' THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NULL;
    END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN jsonb_build_object(
        'lang', lower(v_lang),
        'project_type', lower(btrim(v_project_type))
    );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
