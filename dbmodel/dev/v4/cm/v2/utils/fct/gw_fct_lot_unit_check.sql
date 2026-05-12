/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_lot_unit_check(p_lot integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$

DECLARE

rec record;
v_unit integer;
v_arc text;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    RAISE NOTICE 'Get UMs of selected lot';
    FOR rec IN 
        SELECT DISTINCT(unit_id)
        FROM om_visit_lot_x_unit AS unit JOIN om_visit_lot_x_arc USING(lot_id, unit_id) 
        WHERE lot_id = p_lot
        ORDER BY unit_id
    LOOP
        v_unit = rec.unit_id;
        PERFORM * FROM om_visit_lot_x_arc
        WHERE lot_id = p_lot 
        AND unit_id = v_unit AND arc_id::int = v_unit;
        IF NOT FOUND THEN
            RAISE NOTICE 'UM without his arc: %', v_unit;
            SELECT arc_id INTO v_arc 
            FROM om_visit_lot_x_arc
            WHERE lot_id = p_lot 
            AND unit_id = v_unit ORDER BY arc_id LIMIT 1;
            IF FOUND THEN
                RAISE NOTICE 'Update unit_id = %', v_arc;
                UPDATE om_visit_lot_x_unit SET unit_id = v_arc::int, user_defined = True WHERE lot_id = p_lot AND unit_id = v_unit;
            END IF;
        END IF;
    END LOOP;

    RETURN True;

END;
$function$
;

