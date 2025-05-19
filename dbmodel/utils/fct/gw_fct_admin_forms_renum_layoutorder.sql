CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_forms_renum_layoutorder(p_data json)
RETURNS json
LANGUAGE plpgsql
AS $function$

DECLARE
    rec RECORD;
    rec2 RECORD;
    v_counter INTEGER;
BEGIN
    SET search_path = 'SCHEMA_NAME', public;

    -- Buscar todos los grupos con layoutorder duplicado
    FOR rec IN
        SELECT formname, formtype, tabname, layoutname, layoutorder
        FROM config_form_fields
        GROUP BY formname, formtype, tabname, layoutname, layoutorder
        HAVING COUNT(*) > 1
        ORDER BY formname, formtype, tabname, layoutname, layoutorder
    LOOP
        v_counter := 0;

        FOR rec2 IN
            SELECT ctid, columnname
            FROM config_form_fields
            WHERE formname = rec.formname
              AND formtype = rec.formtype
              AND tabname = rec.tabname
              AND ((layoutname IS NULL AND rec.layoutname IS NULL) OR (layoutname = rec.layoutname))
              AND ((layoutorder IS NULL AND rec.layoutorder IS NULL) OR (layoutorder = rec.layoutorder))
            ORDER BY columnname -- puedes ordenar por lo que prefieras
        LOOP
            UPDATE config_form_fields
            SET layoutorder = v_counter
            WHERE ctid = rec2.ctid;

            v_counter := v_counter + 1;
        END LOOP;
    END LOOP;

    RETURN '{}';
END;
$function$;
