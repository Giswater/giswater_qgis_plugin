/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3202

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_autoupdate_arc_topology() RETURNS trigger AS $BODY$
DECLARE 

v_node_topelev_autoupdate integer := 0;

	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	SELECT value::integer INTO v_node_topelev_autoupdate FROM config_param_user WHERE parameter='edit_node_topelev_options' AND cur_user = current_user;
	v_node_topelev_autoupdate := COALESCE(v_node_topelev_autoupdate, 0);


	-- node_1
	IF NEW.node_top_elev_1 IS NOT NULL AND (OLD.node_top_elev_1 IS DISTINCT FROM NEW.node_top_elev_1) THEN
		-- user variable is elev
		IF v_node_topelev_autoupdate = 0 THEN

			IF NEW.y1 IS NOT NULL THEN
				-- recalculate elev
				NEW.elev1 := NEW.node_top_elev_1 - NEW.y1;
			ELSIF NEW.elev1 IS NOT NULL THEN
				-- recalculate ymax
				NEW.y1 := NEW.node_top_elev_1 - NEW.elev1;
			END IF;
		-- user variable is ymax
		ELSIF v_node_topelev_autoupdate = 1 THEN
			IF NEW.elev1 IS NOT NULL THEN
				-- recalculate ymax
				NEW.y1 := NEW.node_top_elev_1 - NEW.elev1;
			ELSIF NEW.y1 IS NOT NULL THEN
				-- recalculate elev
				NEW.elev1 := NEW.node_top_elev_1 - NEW.y1;
			END IF;
		END IF;
	END IF;
	
	-- node_2
	IF NEW.node_top_elev_2 IS NOT NULL AND (OLD.node_top_elev_2 IS DISTINCT FROM NEW.node_top_elev_2) THEN
		-- user variable is elev
		IF v_node_topelev_autoupdate = 0 THEN

			IF NEW.y2 IS NOT NULL THEN
				-- recalculate elev
				NEW.elev2 := NEW.node_top_elev_2 - NEW.y2;
			ELSIF NEW.elev2 IS NOT NULL THEN
				-- recalculate ymax
				NEW.y2 := NEW.node_top_elev_2 - NEW.elev2;
			END IF;
		-- user variable is ymax
		ELSIF v_node_topelev_autoupdate = 1 THEN
			IF NEW.elev2 IS NOT NULL THEN
				-- recalculate ymax
				NEW.y2 := NEW.node_top_elev_2 - NEW.elev2;
			ELSIF NEW.y2 IS NOT NULL THEN
				-- recalculate elev
				NEW.elev2 := NEW.node_top_elev_2 - NEW.y2;
			END IF;
		END IF;
	END IF;

RETURN NEW;
		
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
