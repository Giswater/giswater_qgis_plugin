/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2446

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_psector()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_sql varchar;
	plan_psector_seq int8;
	om_aux text;
	rec_type record;
	v_plan_table text;
	v_plan_table_id text;
	rec record;
	

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    om_aux:= TG_ARGV[0];
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
		
		-- Scale_vdefault
			IF (NEW.scale IS NULL) THEN
				NEW.scale := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_scale_vdefault' AND "cur_user"="current_user"())::numeric (8,2);
			END IF;
			
		-- Rotation_vdefault
			IF (NEW.rotation IS NULL) THEN
				NEW.rotation := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_rotation_vdefault' AND "cur_user"="current_user"())::numeric (8,4);
			END IF;
			
		-- Gexpenses_vdefault
			IF (NEW.gexpenses IS NULL) THEN
				NEW.gexpenses := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_gexpenses_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
			END IF;
			
		-- Vat_vdefault
			IF (NEW.vat IS NULL) THEN
				NEW.vat := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_vat_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
			END IF;
			
		-- Other_vdefault
			IF (NEW.other IS NULL) THEN
				NEW.other := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_other_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
			END IF;
		
		-- Type_vdefault
			IF (NEW.psector_type IS NULL) THEN
				NEW.psector_type := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_type_vdefault' AND "cur_user"="current_user"())::integer;
			END IF;
			
		-- Control insertions ID
			IF (NEW.psector_id IS NULL and om_aux='om') THEN
				NEW.psector_id:= (SELECT nextval('om_psector_id_seq'));
			ELSIF (NEW.psector_id IS NULL and om_aux='plan') THEN
				NEW.psector_id:= (SELECT nextval('plan_psector_id_seq'));
			END IF;
			
			
          
	
	IF om_aux='om' THEN
	               
		INSERT INTO om_psector (psector_id, name, psector_type, result_id, descript, priority, text1, text2, observ, rotation, scale, 
		sector_id, atlas_id, gexpenses, vat, other, the_geom, expl_id, active)
		VALUES  (NEW.psector_id, NEW.name, NEW.psector_type, NEW.result_id, NEW.descript, NEW.priority, NEW.text1, NEW.text2, NEW.observ, 
		NEW.rotation, NEW.scale, NEW.sector_id, NEW.atlas_id, NEW.gexpenses, NEW.vat, NEW.other, NEW.the_geom, NEW.expl_id, NEW.active);

	ELSIF om_aux='plan' THEN

		INSERT INTO plan_psector (psector_id, name, psector_type, descript, priority, text1, text2, observ, rotation, scale, sector_id,
		 atlas_id, gexpenses, vat, other, the_geom, expl_id, active, ext_code, status)
		VALUES  (NEW.psector_id, NEW.name, NEW.psector_type, NEW.descript, NEW.priority, NEW.text1, NEW.text2, NEW.observ, NEW.rotation, 
		NEW.scale, NEW.sector_id, NEW.atlas_id, NEW.gexpenses, NEW.vat, NEW.other, NEW.the_geom, NEW.expl_id, NEW.active,
		NEW.ext_code, NEW.status);
	END IF;

		
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

	IF om_aux='om' THEN
	               
		UPDATE om_psector 
		SET psector_id=NEW.psector_id, name=NEW.name, psector_type=NEW.psector_type, result_id=NEW.result_id, descript=NEW.descript, priority=NEW.priority, 
		text1=NEW.text1, text2=NEW.text2, observ=NEW.observ, rotation=NEW.rotation, scale=NEW.scale, sector_id=NEW.sector_id, atlas_id=NEW.atlas_id, 
		gexpenses=NEW.gexpenses, vat=NEW.vat, other=NEW.other, expl_id=NEW.expl_id, active=NEW.active
		WHERE psector_id=OLD.psector_id;

	ELSIF om_aux='plan' THEN

		UPDATE plan_psector 
		SET psector_id=NEW.psector_id, name=NEW.name, psector_type=NEW.psector_type, descript=NEW.descript, priority=NEW.priority, text1=NEW.text1, 
		text2=NEW.text2, observ=NEW.observ, rotation=NEW.rotation, scale=NEW.scale, sector_id=NEW.sector_id, atlas_id=NEW.atlas_id, 
		gexpenses=NEW.gexpenses, vat=NEW.vat, other=NEW.other, expl_id=NEW.expl_id, active=NEW.active, ext_code=NEW.ext_code, status=NEW.status
		WHERE psector_id=OLD.psector_id;
	END IF;

               
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
    
	IF om_aux='om' THEN
		DELETE FROM om_psector WHERE psector_id = OLD.psector_id;      

	ELSIF om_aux='plan' THEN
	
		FOR rec_type IN (SELECT * FROM sys_feature_type WHERE net_category=1) LOOP
		
			v_plan_table=concat('plan_psector_x_',lower(rec_type.id));
			v_plan_table_id=concat(lower(rec_type.id),'_id');

			FOR rec IN EXECUTE 'SELECT * FROM '||v_plan_table||' WHERE psector_id = '||OLD.psector_id||'
			and '||v_plan_table_id||' not IN (SELECT '||v_plan_table_id||' FROM '||v_plan_table||' WHERE psector_id != '||OLD.psector_id||')' LOOP
	
				IF rec_type.id='NODE' THEN
					EXECUTE 'DELETE FROM '||lower(rec_type.id)||' WHERE state=2 and '||v_plan_table_id||' =  '''||rec.node_id||'''';
				ELSIF rec_type.id='ARC' THEN
					EXECUTE 'DELETE FROM '||lower(rec_type.id)||' WHERE state=2 and '||v_plan_table_id||' =  '''||rec.arc_id||'''';
				ELSIF rec_type.id='GULLY' THEN
					EXECUTE 'DELETE FROM '||lower(rec_type.id)||' WHERE state=2 and '||v_plan_table_id||' =  '''||rec.gully_id||'''';
				ELSIF rec_type.id='CONNEC' THEN
					EXECUTE 'DELETE FROM '||lower(rec_type.id)||' WHERE state=2 and '||v_plan_table_id||' =  '''||rec.connec_id||'''';
				END IF;
			END LOOP;
			

		END LOOP;

		DELETE FROM plan_psector WHERE psector_id = OLD.psector_id;

	END IF;

        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;