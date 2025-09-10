/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3458

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_edit_cat_team()
  RETURNS trigger AS
$BODY$
DECLARE

v_prev_search_path text;
BEGIN

    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', format('%I, public', TG_TABLE_SCHEMA), true);


    IF TG_OP = 'INSERT' THEN

        -- FEATURE INSERT
        	INSERT INTO cat_team (idval, descript, active)
            VALUES (NEW.idval, NEW.descript, NEW.active);

	PERFORM set_config('search_path', v_prev_search_path, true);
	RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
   	-- FEATURE UPDATE
		UPDATE cat_team
		SET id=NEW.id, idval=NEW.idval, descript=NEW.descript, active=NEW.active
		WHERE id=NEW.id;

        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;


     ELSIF TG_OP = 'DELETE' THEN
	 -- FEATURE DELETE
		DELETE FROM cat_team WHERE id = OLD.id;

	PERFORM set_config('search_path', v_prev_search_path, true);
	RETURN NULL;

     END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;