/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2504



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_importdxfblock(
    csv2pgcat_id_aux integer)
  RETURNS integer AS
$BODY$
DECLARE

v_record record;
v_target text;
v_total integer;
v_id int8;
v_value text;
v_i integer=0;
v_filter float=0;
v_percent integer;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	
	SELECT count(*)  INTO v_total FROM temp_csv2pg WHERE user_name=current_user;
	
	FOR v_record IN SELECT id, csv1 FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=8 order by id
	LOOP 
		v_i=v_i+1;
		-- massive refactor of source field (getting target)
		IF v_record.csv1 LIKE 'ATTRIB' THEN
			v_target=v_record.id;
		END IF;
		UPDATE temp_csv2pg SET source=v_target WHERE v_record.id=temp_csv2pg.id;

		v_percent:=((v_i::float/v_total::float)*100)::integer;

		IF v_percent > v_filter THEN
				v_filter = v_percent;
				raise notice '(1/2), % %% executed', v_percent;
		END IF;

	END LOOP;

	v_i=0;
	v_filter = 0;

	FOR v_record IN SELECT id, csv1, source FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=8 order by id
	LOOP 	
		v_i=v_i+1;
		-- xcoord
		IF v_record.csv1 = ' 10' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv2=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;
		
		-- ycoord
		IF v_record.csv1 = ' 20' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv3=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		-- value
		IF v_record.csv1 = '  1' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv4=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		-- rotation
		IF v_record.csv1 = ' 50' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv5=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		-- layer
		IF v_record.csv1 = '  7' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv6=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		IF v_percent > v_filter THEN
				v_filter = v_percent;
				raise notice '(2/2), %%% executed', v_percent;
		END IF;		

	END LOOP;

	DELETE FROM temp_csv2pg WHERE csv2 IS NULL AND csv2pgcat_id=8 AND user_name=current_user;
	
RETURN 0;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
