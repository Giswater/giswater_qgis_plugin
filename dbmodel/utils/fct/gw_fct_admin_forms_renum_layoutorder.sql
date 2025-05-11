/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION gw_fct_admin_forms_renum_layoutorder(p_data json)
RETURNS json AS $$

/*
SELECT gw_fct_formfields_renumber_layoutorder ({data:{parameters{}}})
*/

DECLARE
    rec RECORD;
    current_layout TEXT;
    new_order INTEGER;
	v_step integer;
	v_tablename text;

BEGIN

	-- set search path
	
	
	-- get input parameters
	v_tablename = 'config_form_fields'; -- config_param_system, sys_param_user
	v_step = 2; -- the number of steps for each.
		
	
    -- loop for each layoutname
    FOR rec IN
        SELECT id, layoutname
        FROM config_form_fields
        ORDER BY layoutname, layoutorder, id
    LOOP
        -- reinit counter for new layout
        IF rec.layoutname IS DISTINCT FROM current_layout THEN
            current_layout := rec.layoutname;
            new_order := v_step;
        END IF;

        -- update layoutorder
        UPDATE config_form_fields
        SET layoutorder = new_order
        WHERE id = rec.id;

        -- Increment the counter
        new_order := new_order + v_step;
    END LOOP;
	
	RETURN '{}';
	
END;
$$ LANGUAGE plpgsql;;