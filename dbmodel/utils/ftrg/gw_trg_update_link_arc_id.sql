/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2688



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_update_link_arc_id() RETURNS trigger AS $BODY$
DECLARE 

	v_exittype text;
	v_link record;
	v_minsector integer;
	v_dqa integer;
	v_minsector_val text;
	v_dqa_val text;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_exittype:= TG_ARGV[0];

	
	IF v_exittype='connec' THEN
	FOR v_link IN SELECT * FROM link WHERE (exit_type='CONNEC' AND exit_id=OLD.connec_id)
		LOOP

			-- get man_addfields_parameters for minsector & dqa
			SELECT id INTO v_minsector FROM man_addfields_parameter WHERE param_name='minsector_id';
			SELECT id INTO v_dqa FROM man_addfields_parameter WHERE param_name='dqa_id';

			IF v_link.feature_type='CONNEC' THEN

				-- update connec
				UPDATE connec SET arc_id=NEW.arc_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id, expl_id=NEW.expl_id WHERE connec_id=v_link.feature_id;
				
				IF v_projecttype = 'WS' THEN

					-- update presszone
					UPDATE connec SET presszonecat_id=NEW.presszonecat_id WHERE connec_id=v_link.feature_id;
		
					-- update dqa, minsector
					SELECT value INTO v_minsector_val FROM man_addfields_value WHERE parameter_id=v_minsector AND feature_id=NEW.connec_id;
					SELECT value INTO v_dqa_val FROM man_addfields_value WHERE parameter_id=v_dqa AND feature_id=NEW.connec_id;
				
					UPDATE man_addfields_value SET value=v_minsector_val WHERE parameter_id=v_minsector AND feature_id=v_link.feature_id;
					UPDATE man_addfields_value SET value=v_dqa_val WHERE parameter_id=v_dqa AND feature_id=v_link.feature_id;
				END IF;

			
			ELSIF v_link.feature_type='GULLY' THEN
 		
				UPDATE gully SET arc_id=NEW.arc_id WHERE gully_id=v_link.feature_id;
				UPDATE man_addfields_value SET dqa, minsector
				
			END IF;
		END LOOP;
	
	ELSIF v_exittype='gully' THEN
	FOR v_link IN SELECT * FROM link WHERE (exit_type='GULLY' AND exit_id=OLD.gully_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id WHERE connec_id=v_link.feature_id;
			
			ELSIF v_link.feature_type='GULLY' THEN
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id WHERE gully_id=v_link.feature_id;
			END IF;
		END LOOP;
		
	END IF;
	
	RETURN NEW;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


