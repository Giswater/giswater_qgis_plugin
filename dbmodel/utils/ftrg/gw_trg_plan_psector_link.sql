/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2938

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_link()
  RETURNS trigger AS
$BODY$


DECLARE 

v_table_name text;
v_point_aux public.geometry;
v_channel text;
v_schemaname text;
v_arc_id text;
v_projecttype text;
v_exit_type text;
v_connect text;
v_featuretype text;
v_arc record;
v_feature text;
v_id integer;
v_link record;
	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_table_name:= TG_ARGV[0];
	v_schemaname='SCHEMA_NAME';
	v_projecttype = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
	
	IF NEW.arc_id='' THEN NEW.arc_id=NULL; END IF;

	-- setting variables
	v_id = NEW.id;
	SELECT * INTO v_link FROM link LIMIT 1;

	-- getting variables in function of table
	IF v_table_name = 'connec' THEN
		v_featuretype = 'CONNEC';
		v_feature = NEW.connec_id;

	ELSIF v_table_name = 'gully' THEN
		v_featuretype = 'GULLY';
		v_feature = NEW.gully_id;
	END IF;

	SELECT * INTO v_arc FROM arc WHERE arc_id = NEW.arc_id;

	-- executing options
	IF TG_OP = 'INSERT' THEN
	
		IF NEW.state = 0 THEN
			
		ELSIF NEW.state = 1 THEN
	
			IF NEW.arc_id IS NOT NULL AND NEW.link_id IS NULL THEN

				EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{"id":["'|| v_feature ||'"]},"data":{"feature_type":"'|| v_featuretype ||'", "isPsector":"true", "forceArcs":['||NEW.arc_id||']}}$$)';
			END IF;
		END IF;

	ELSIF TG_OP = 'UPDATE' THEN 

		IF NEW.state = 1 AND COALESCE(NEW.arc_id,'') != COALESCE(OLD.arc_id,'') AND COALESCE(NEW.link_id,0) = COALESCE(OLD.link_id,0) THEN

			IF NEW.arc_id IS NULL THEN

				IF (SELECT exit_type FROM link WHERE link_id = NEW.link_id) = 'ARC' THEN
					EXECUTE 'UPDATE plan_psector_x_'||v_table_name||' SET link_id = NULL WHERE id = '||v_id;
					DELETE FROM link WHERE link_id = NEW.link_id;			
				END IF;
			ELSE
				EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{"id":["'|| v_feature ||'"]},"data":{"feature_type":"'|| v_featuretype ||'", "isPsector":"true", "forceArcs":['||NEW.arc_id||']}}$$)';
			END IF;
		END IF;
	END IF;

	-- reconnect connects
	IF v_table_name = 'connec' THEN
	
		-- looking for related connecs
		FOR v_connect IN SELECT connec_id FROM connec JOIN link l ON l.feature_id = connec_id WHERE l.feature_type = 'CONNEC' AND exit_type = 'CONNEC' and exit_id = NEW.connec_id
		LOOP
			UPDATE plan_psector_x_connec SET arc_id = NEW.arc_id WHERE connec_id = v_connect AND psector_id = NEW.psector_id;
		END LOOP;
		
		-- looking for related gullies
		IF v_projecttype = 'UD' THEN
			FOR v_connect IN SELECT gully_id FROM gully JOIN link l ON l.feature_id = gully_id WHERE l.feature_type = 'GULLY' AND exit_type = 'CONNEC' and exit_id = NEW.connec_id
			LOOP
				UPDATE plan_psector_x_gully SET arc_id = NEW.arc_id WHERE gully_id = v_connect AND psector_id = NEW.psector_id;
			END LOOP;
		END IF;	
	
	ELSIF v_table_name = 'gully' THEN
	
		-- looking for related connecs
		FOR v_connect IN SELECT connec_id FROM connec JOIN link l ON l.feature_id = connec_id WHERE l.feature_type = 'CONNEC' AND exit_type = 'GULLY' and exit_id = NEW.gully_id
		LOOP
			UPDATE plan_psector_x_connec SET arc_id = NEW.arc_id WHERE connec_id = v_connect AND psector_id = NEW.psector_id;
		END LOOP;
		
		-- looking for related gullies
		FOR v_connect IN SELECT gully_id FROM gully JOIN link l ON l.feature_id = gully_id WHERE l.feature_type = 'GULLY' AND exit_type = 'GULLY' and exit_id = NEW.gully_id
		LOOP
			UPDATE plan_psector_x_gully SET arc_id = NEW.arc_id WHERE gully_id = v_connect AND psector_id = NEW.psector_id;
		END LOOP;
	END IF;		

	RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;