/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION gw_fct_formfields_renumber_layoutorders(p_data json)
RETURNS json AS $$

/*
SELECT gw_fct_formfields_renumber_layoutorders (formType)
*/

DECLARE
    rec RECORD;
    current_layout TEXT;
    new_order INTEGER;

BEGIN

	-- set search path
	
	
	-- get input parameters
	v_formtype = '';
	
	
    -- Bucle per cada layoutname ordenat
    FOR rec IN
        SELECT id, layoutname
        FROM config_form_fields
        ORDER BY layoutname, layoutorder, id
    LOOP
        -- Si és un layout nou, reinicia el comptador
        IF rec.layoutname IS DISTINCT FROM current_layout THEN
            current_layout := rec.layoutname;
            new_order := 2;
        END IF;

        -- Actualitza el layoutorder
        UPDATE config_form_fields
        SET layoutorder = new_order
        WHERE id = rec.id;

        -- Incrementa el comptador
        new_order := new_order + 2;
    END LOOP;
	
	RETURN '{}';
	
END;
$$ LANGUAGE plpgsql;;