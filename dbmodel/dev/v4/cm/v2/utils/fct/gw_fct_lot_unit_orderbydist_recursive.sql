/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3151

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_lot_unit_orderbydist_recursive(p_unit integer) 
RETURNS json AS 
$BODY$

-- fid: 134
/*
SELECT SCHEMA_NAME.gw_fct_lot_unit('{"data":{"parameters":{"isNew":true, "lotId":207, "geomParamUpdate":2}}}');

SELECT * from om_visit_lot_x_unit where lot_id = 207
SELECT * from temp_table
SELECT * from temp_data

*/


DECLARE

v_unit int4 = 0;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

    SELECT a.feature_id
    INTO v_unit
    FROM temp_data a
    JOIN temp_data b ON a.feature_id = b.feature_type
    WHERE a.feature_type::integer = p_unit AND b.flag IS NOT true
    ORDER BY a.float_value ASC
    LIMIT 1;

	raise notice 'ORDER p_unit % - v_unit %', p_unit, v_unit;

	-- update flag
	UPDATE temp_data SET flag = TRUE WHERE feature_type::integer = p_unit;

	-- log for unit
	INSERT INTO temp_table (fid, text_column) VALUES (134, p_unit);

	IF v_unit IS NOT NULL AND v_unit > 0 THEN
		-- Call recursive function
		PERFORM gw_fct_lot_unit_orderbydist_recursive(v_unit);
	END IF;

	RETURN ('{"status":"ok"}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
