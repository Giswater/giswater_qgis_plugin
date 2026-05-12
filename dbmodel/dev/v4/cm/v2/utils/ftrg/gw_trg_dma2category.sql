/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3155

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_dma2category()
  RETURNS trigger AS
$BODY$
DECLARE
	v_feature_type text;
	v_category_id integer;
	v_querytext text;
	v_feature_id text;
	v_dma_id integer;
	v_exist text;
	v_trigger_from text;
	v_block text;
	v_macrocategory integer;

BEGIN

	-- set search_path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_feature_type:= TG_ARGV[0];
	v_trigger_from:= TG_ARGV[1];
	v_block = (SELECT VALUE from config_param_user where "parameter"= 'om_lot_block_dma2category' and cur_user=current_user);

	-- get v_feature_id
	IF v_feature_type = 'arc' THEN
		v_feature_id=NEW.arc_id;
		IF TG_OP = 'DELETE' THEN
			v_feature_id=OLD.arc_id;
		END IF;

	ELSIF v_feature_type = 'node' THEN
		v_feature_id=NEW.node_id;
		IF TG_OP = 'DELETE' THEN
			v_feature_id=OLD.node_id;
		END IF;

	ELSIF v_feature_type = 'connec' THEN
		v_feature_id=NEW.connec_id;
		IF TG_OP = 'DELETE' THEN
			v_feature_id=OLD.connec_id;
		END IF;

	ELSIF v_feature_type = 'gully' THEN
		v_feature_id=NEW.gully_id;
		IF TG_OP = 'DELETE' THEN
			v_feature_id=OLD.gully_id;
		END IF;

	END IF;

	/*
	 * 1. Values from dma to category. Triggered from arc, node, connec, gully
	 */
	IF v_trigger_from = 'parent_table' and (v_block != 'category2dma' or v_block is null) THEN

		-- block trigger to avoid conflict after update
		UPDATE config_param_user set value = 'dma2category' where "parameter" = 'om_lot_block_dma2category' and cur_user=current_user;

		IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
			--select category_id related to dma using dma name and feature_type
			EXECUTE 'SELECT category_id FROM om_category JOIN dma ON dma."name"=om_category.idval WHERE dma_id='||NEW.dma_id||' AND lower(feature_type)='||quote_literal(v_feature_type)||''
			INTO v_category_id;

		END IF;

		IF TG_OP = 'INSERT' THEN
			v_querytext = 'INSERT INTO om_category_x_'||v_feature_type||' VALUES ('||v_feature_id||', '||v_category_id||');';
		   	EXECUTE v_querytext;

		ELSIF TG_OP = 'UPDATE' THEN
			-- select if this feature already exists on om_category_x_* or not
			EXECUTE 'SELECT '||v_feature_type||'_id FROM om_category_x_'||v_feature_type||' WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||''
			INTO v_exist;

			IF v_exist IS NULL THEN
				v_querytext = 'INSERT INTO om_category_x_'||v_feature_type||' VALUES ('||v_feature_id||', '||v_category_id||');';
			   	EXECUTE v_querytext;

			ELSE
			   	v_querytext = 'UPDATE om_category_x_'||v_feature_type||' SET category_id = '||v_category_id||' WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||';';
		   		EXECUTE v_querytext;

		   	END IF;

	    ELSIF TG_OP = 'DELETE' THEN
		   	v_querytext = 'DELETE FROM om_category_x_'||v_feature_type||' WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||';';
		   	EXECUTE v_querytext;

	    END IF;

	   	-- unblock trigger
	   	UPDATE config_param_user set value = null where "parameter" = 'om_lot_block_dma2category' and cur_user=current_user;

	/*
	 * 2. Values from category to dma. Triggered from om_category_x_*
	 */
	 ELSIF v_trigger_from = 'om_category' and (v_block != 'dma2category' or v_block is null)  THEN

		 	raise notice '1-- block trigger to avoid conflict after update';
			UPDATE config_param_user set value = 'category2dma' where "parameter" = 'om_lot_block_dma2category' and cur_user=current_user;

			IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

			 	raise notice '2-- select macrocategory in order to only perform trigger if values in 1,2,3 (categories related to dma)';
			 	EXECUTE 'SELECT macrocategory_id FROM om_macrocategory JOIN om_category USING (macrocategory_id) 
							JOIN om_category_x_'||v_feature_type||' USING (category_id) 
							WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||' 
							AND category_id='||NEW.category_id||' LIMIT 1'
							INTO v_macrocategory;

				IF v_macrocategory IN (1,2,3) THEN

				raise notice '3-- select dma_id related to category using dma name and feature_type';
				EXECUTE 'SELECT dma_id FROM dma JOIN om_category oc ON dma."name"=oc.idval WHERE category_id='||NEW.category_id||' AND lower(feature_type)='||quote_literal(v_feature_type)||''
				INTO v_dma_id;

					raise notice '4-- select macrodma if dma is null (useful for gullies)';
					IF v_dma_id IS NULL THEN
						EXECUTE 'SELECT dma_id FROM dma JOIN macrodma USING (macrodma_id) JOIN om_category oc ON macrodma."name"=oc.idval 
						WHERE category_id='||NEW.category_id||' AND lower(feature_type)='||quote_literal(v_feature_type)||' LIMIT 1'
						INTO v_dma_id;
					END IF;

				END IF;

	            IF v_dma_id IS NOT NULL THEN

	            v_querytext = 'UPDATE ve_'||v_feature_type||' SET dma_id = '||v_dma_id||' WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||';';
	                EXECUTE v_querytext;
	            ELSE
	                RAISE NOTICE 'v_dma_id IS NULL';
	        	END IF;

	        	raise notice '5-- delete other values from om_category_x_*. There must be only one for categories related to dma';
				v_querytext = 'DELETE FROM om_category_x_'||v_feature_type||' WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||'
							AND category_id <> '||NEW.category_id||';';
				EXECUTE v_querytext;

			ELSIF TG_OP = 'DELETE' THEN
				raise notice '6-- when delete, always set dma_id = 0 if the feature is not related to any dma category';
				IF (SELECT count(*) FROM om_category_x_gully join om_category using (category_id) where gully_id=v_feature_id and macrocategory_id in (1,2,3)) = 0 then
			   		v_querytext = 'UPDATE ve_'||v_feature_type||' SET dma_id = 0 WHERE '||v_feature_type||'_id='||quote_literal(v_feature_id)||';';
			   		EXECUTE v_querytext;
			   	end if;

			END IF;

			raise notice '7-- unblock trigger';
		   	UPDATE config_param_user set value = null where "parameter" = 'om_lot_block_dma2category' and cur_user=current_user;

	 END IF;

   RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

