/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/



-- FUNCTION NUMBER : 3372

-- DROP FUNCTION gw_trg_edit_flwreg();

CREATE OR REPLACE FUNCTION gw_trg_edit_flwreg()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
v_flwreg_type text;
v_curve_id text;
v_parent_table TEXT := '';
v_origin_table text := '';
v_sql text;
v_field_value json;
v_mec record;
v_json_data json;
v_new_record record;
v_trg_new text;
v_sql_insert text;
v_rec_sentence record;
v_class record;

BEGIN
    -- Ensure the search path includes the schema
    EXECUTE 'SET search_path TO ' || quote_ident(TG_TABLE_SCHEMA) || ', public';

    v_flwreg_type := TG_ARGV[0];
	
	 -- set NEW.values
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    
    	NEW.flwreg_type = (SELECT flwreg_type FROM cat_flwreg WHERE id = NEW.flwregcat_id);
       
        IF NEW.node_id IS NULL THEN
   			NEW.node_id = (SELECT n.node_id FROM node n WHERE ST_dwithin(n.the_geom, ST_startpoint(NEW.the_geom), 0.1));
   		
   			
        END IF;
       
        IF NEW.to_arc IS NULL then
    		NEW.to_arc = (SELECT a.arc_id FROM arc a WHERE ST_dwithin(a.the_geom, ST_endpoint(NEW.the_geom), 0.01));
        END IF;

        IF NEW.flwreg_length IS NULL THEN
    		NEW.flwreg_length = (SELECT st_length(NEW.the_geom));
        END IF;
       
        IF NEW.epa_type IS NULL THEN
    		NEW.epa_type = (SELECT epa_default FROM sys_feature_class WHERE id = NEW.flwreg_type);	
        END IF;
               
       	IF NEW.state IS NULL THEN
       		NEW.state = (SELECT state FROM node WHERE node_id = NEW.node_id);
       	END IF;
       
       	IF NEW.state_type IS NULL THEN
       		NEW.state_type = (SELECT state_type FROM node WHERE node_id = NEW.node_id);
       	END IF;
  
      	IF NEW.order_id IS NULL THEN
       
			EXECUTE '
			SELECT COUNT(*) FROM flwreg WHERE to_arc='||quote_literal(NEW.to_arc)||' 
			AND node_id='||quote_literal(NEW.node_id)||'' INTO NEW.order_id;
		
			NEW.order_id=NEW.order_id+1;
		
		END IF;

        
		-- inp_frorifice/weir/pump/outlet tables
	
	/*
		IF v_flwreg_type = 'frorifice' THEN

			IF NEW.orifice_class IS NULL THEN
				NEW.orifice_class = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'oriType' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
		
			IF NEW.shape IS NULL  THEN
				NEW.shape = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'shape' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
		
			IF NEW.cd IS NULL  THEN
				NEW.cd = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'cd' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
		
			IF NEW.flap IS NULL  THEN
				NEW.flap = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'flap' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
		
			IF NEW.geom1 IS NULL THEN
				NEW.geom1 = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'geom1' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
	
		ELSIF v_flwreg_type  = 'frweir' THEN
			IF NEW.weir_type IS NULL THEN
				NEW.weir_type = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'weirType' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.cd IS NULL THEN
				NEW.cd = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'cd' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.ec IS NULL  THEN
				NEW.ec = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'ec' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.cd2 IS NULL  THEN
				NEW.cd2 = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'cd2' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.flap IS NULL  THEN
				NEW.flap = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'flap' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.geom1 IS NULL THEN
				NEW.geom1 = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'geom1' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.geom2 IS NULL THEN
				NEW.geom2 = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'geom2' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
		
		ELSIF v_flwreg_type  = 'froutlet' THEN
			IF NEW.outlet_type IS NULL THEN
				NEW.outlet_type = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'outletType' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.cd1 IS NULL THEN
				NEW.cd1 = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'cd1' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.cd2 IS NULL  THEN
				NEW.cd2 = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'cd2' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;
			IF NEW.flap IS NULL  THEN
				NEW.flap = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'flap' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
			END IF;

		ELSIF v_flwreg_type  = 'frpump' THEN

		END IF;
		*/


 		-- control null values
        IF NEW.node_id NOT IN (select node_1 from arc where node_1 = NEW.node_id UNION select node_2 from arc where node_2 = NEW.node_id)
        THEN
            -- si el NEW.node_id no és el node_1 o node_2 del to_arc, fés un getmessage i peta
        END IF;
       
       	IF NEW.to_arc IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"2070", "function":"2420","parameters":null}}$$);';
		
		END IF;
	
		-- flwreg_length
		IF NEW.flwreg_length IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"2074", "function":"2420","parameters":null}}$$);';
		END IF;
		
		IF (NEW.flwreg_length) >= (SELECT st_length(arc.the_geom) FROM arc WHERE arc_id=NEW.to_arc) THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3048", "function":"2420","parameters":null}}$$);';
		END IF;
	
	END IF;

     	-- TO DO: default value for orifice class if null -> default curve_id
     	v_origin_table = TG_TABLE_NAME;
		v_parent_table = split_part(REGEXP_REPLACE(v_origin_table, '^(man_|v_|v_edit_|ve_)', '', 'gi'), '_', 1);
     
     	-- take and clean NEW
    	SELECT row_to_json(NEW) INTO v_json_data;
    
    	DROP TABLE IF EXISTS temp_new_vals;
    
	    CREATE TEMP TABLE temp_new_vals AS 
	   		WITH aux AS (
	   			SELECT 1 AS id, v_json_data AS js
	   		), json_vals AS (
				SELECT key AS col, replace(value::text, '"', '''') AS val
				FROM aux,
				jsonb_each(aux.js::jsonb) AS keys_values
			), mapping_cols AS (	
				select c.column_name AS col, c.table_name
				FROM information_schema.view_column_usage c
				JOIN pg_views v 
				    ON c.view_schema = v.schemaname 
				    AND c.view_name = v.viewname
				WHERE v.viewname = v_origin_table
				AND table_schema = CURRENT_SCHEMA 
				)
		SELECT v.*, c.table_name, NULL AS exec_order 
		FROM json_vals v LEFT JOIN mapping_cols c USING (col);
		
		UPDATE temp_new_vals SET val = quote_literal(ST_astext(NEW.the_geom)) WHERE col = 'the_geom';
	
		--UPDATE temp_new_vals SET table_name = split_part(REGEXP_REPLACE(v_origin_table, '^(v_|v_edit_|ve_)', '', 'gi'), '_', 1);
	
		update temp_new_vals set table_name = 'flwreg' where table_name = 'v_edit_flwreg';
	
		DELETE FROM temp_new_vals WHERE col IN ('expl_id', 'muni_id', 'flwreg_type');

		UPDATE temp_new_vals SET exec_order = 1 WHERE table_name = 'flwreg';
		
		UPDATE temp_new_vals SET exec_order = 2 WHERE table_name is null;

		
	
		IF TG_OP = 'INSERT' THEN
	
		    v_sql = 'SELECT concat(
		    ''INSERT INTO '', table_name, '' ('', string_agg(col, '', ''), '') 
			VALUES ('', string_agg(val, '', ''), '');''
			) AS insert_sentence FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';
		
		    FOR v_rec_sentence IN EXECUTE v_sql
		    LOOP
		        EXECUTE v_rec_sentence.insert_sentence;
		    END LOOP;
		   
		ELSIF TG_OP = 'UPDATE' THEN
		
			v_sql = 'SELECT CONCAT(
			''UPDATE ''||table_name||'' 
			SET '', string_agg(concat(col, '' = '', val), '', ''), '' 
			WHERE flwreg_id = '', '||quote_literal(quote_literal(new.flwreg_id))||'
			) AS update_sentence FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';
		
			FOR v_rec_sentence IN EXECUTE v_sql
			LOOP
				EXECUTE v_rec_sentence.update_sentence;
			END LOOP;
		
		END IF;

		DROP TABLE IF EXISTS temp_new_vals;
	
	
		RETURN NEW;

    -- Insert logic
    IF TG_OP = 'INSERT' THEN
        IF v_flwreg_type =  'VFLWREG' THEN
            IF  NEW.flwreg_type = 'ORIFICE' THEN
                
                -- Default values for orifice
                IF NEW.geom1 IS NULL THEN NEW.geom1 = 1; END IF;
                IF NEW.geom2 IS NULL THEN NEW.geom2 = 1; END IF;
                IF NEW.geom3 IS NULL THEN NEW.geom3 = 0; END IF;
                IF NEW.geom4 IS NULL THEN NEW.geom4 = 0; END IF;
                IF NEW.ori_type IS NULL THEN NEW.ori_type = 'SIDE'; END IF;
                IF NEW.shape IS NULL THEN NEW.shape = 'RECT-CLOSED'; END IF;

                INSERT INTO inp_frorifice (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, ori_type, offsetval, cd, orate, 
                    flap, shape, geom1, geom2, geom3, geom4
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'OR', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
                    NEW.ori_type, NEW.offsetval, NEW.cd, NEW.orate,
                    NEW.flap, NEW.shape, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4
                );

            ELSIF NEW.flwreg_type = 'OUTLET' THEN
                -- Default values for outlet
                IF NEW.outlet_type IS NULL THEN NEW.outlet_type = 'FUNCTIONAL/DEPTH'; END IF;

                INSERT INTO inp_froutlet (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, outlet_type, offsetval, curve_id, cd1, cd2
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'OT', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
                    NEW.outlet_type, NEW.offsetval, NEW.curve_id, NEW.cd1, NEW.cd2
                );
            END IF;

        ELSIF v_flwreg_type =  'pump' THEN
                
            INSERT INTO inp_frpump (
                flwreg_id,  nodarc_id, node_id, order_id, to_arc, flwreg_length, curve_id, status, startup, shutoff
            ) VALUES (
                NEW.flwreg_id, concat(NEW.node_id, 'PU', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
                NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff
            );

        ELSIF v_flwreg_type =  'weir' THEN
            -- Default values for weir
            IF NEW.weir_type IS NULL THEN NEW.weir_type = 'SIDEFLOW'; END IF;
            IF NEW.geom3 IS NULL THEN NEW.geom3 = 0; END IF;
            IF NEW.geom4 IS NULL THEN NEW.geom4 = 0; END IF;

            INSERT INTO inp_frweir (
                flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, weir_type, offsetval, cd, ec, cd2, flap, 
                geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve
            ) VALUES (
                NEW.flwreg_id, concat(NEW.node_id, 'WE', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
                NEW.weir_type, NEW.offsetval, NEW.cd, NEW.ec, NEW.cd2, NEW.flap, 
                NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.surcharge,
                NEW.road_width, NEW.road_surf, NEW.coef_curve
            );
        
        ELSIF v_flwreg_type = 'parent' THEN
            IF  NEW.flwreg_type = 'ORIFICE' THEN
                        
                INSERT INTO inp_frorifice (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'OR', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length
                );

            ELSIF NEW.flwreg_type = 'OUTLET' then 
        
                INSERT INTO inp_froutlet (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'OT', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length
                );            
				
            ELSIF NEW.flwreg_type = 'PUMP' THEN
            
                -- Default values for  pump
                v_curve_id = 'PUMP-01';
                
                    INSERT INTO inp_frpump (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, curve_id
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'PU', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, v_curve_id
                );

            ELSIF  NEW.flwreg_type = 'WEIR' THEN
                
                INSERT INTO inp_frweir (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'WE', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length              
                );

            END IF ;		
        END IF;

        RETURN NEW;

    -- Update logic
    ELSIF TG_OP = 'UPDATE' THEN
        IF v_flwreg_type = 'VFLWREG' THEN
           IF flwreg_type =  'ORIFICE' THEN
                UPDATE inp_frorifice
                SET
                    --nodarc_id = concat(NEW.node_id, 'OR', NEW.order_id),
					flwreg_id = NEW.flwreg_id,
                    node_id = NEW.node_id,
                    order_id = NEW.order_id,
                    to_arc = NEW.to_arc,
                    flwreg_length = NEW.flwreg_length,
                    ori_type = NEW.ori_type,
                    offsetval = NEW.offsetval,
                    cd = NEW.cd,
                    orate = NEW.orate,
                    flap = NEW.flap,
                    shape = NEW.shape,
                    geom1 = NEW.geom1,
                    geom2 = NEW.geom2,
                    geom3 = NEW.geom3,
                    geom4 = NEW.geom4
                WHERE flwreg_id = OLD.flwreg_id;

            ELSIF flwreg_type = 'OUTLET' THEN
                UPDATE inp_froutlet
                SET
                   	flwreg_id = NEW.flwreg_id,
					node_id = NEW.node_id,
                    order_id = NEW.order_id,
                    to_arc = NEW.to_arc,
                    flwreg_length = NEW.flwreg_length,
                    outlet_type = NEW.outlet_type,
                    offsetval = NEW.offsetval,
                    curve_id = NEW.curve_id,
                    cd1 = NEW.cd1,
                    cd2 = NEW.cd2
                WHERE flwreg_id = OLD.flwreg_id;
			END IF;

        ELSIF  v_flwreg_type ='pump' THEN
            UPDATE inp_frpump
            SET
                flwreg_id = NEW.flwreg_id,
                node_id = NEW.node_id,
                order_id = NEW.order_id,
                to_arc = NEW.to_arc,
                flwreg_length = NEW.flwreg_length,
                curve_id = NEW.curve_id,
                status = NEW.status,
                startup = NEW.startup,
                shutoff = NEW.shutoff
            WHERE flwreg_id = OLD.flwreg_id;

        ELSIF v_flwreg_type ='weir' THEN
            UPDATE inp_frweir
            SET
                flwreg_id = NEW.flwreg_id,
                node_id = NEW.node_id,
                order_id = NEW.order_id,
                to_arc = NEW.to_arc,
                flwreg_length = NEW.flwreg_length,
                weir_type = NEW.weir_type,
                offsetval = NEW.offsetval,
                cd = NEW.cd,
                ec = NEW.ec,
                cd2 = NEW.cd2,
                flap = NEW.flap,
                geom1 = NEW.geom1,
                geom2 = NEW.geom2,
                geom3 = NEW.geom3,
                geom4 = NEW.geom4,
                surcharge = NEW.surcharge,
                road_width = NEW.road_width,
                road_surf = NEW.road_surf,
                coef_curve = NEW.coef_curve
            WHERE flwreg_id = OLD.flwreg_id;
        END IF;
		
		IF NEW.flwreg_type <> OLD.flwreg_type THEN

            UPDATE flwreg SET nodarc_id = concat(NEW.node_id, left(NEW.flwreg_type, 2), NEW.order_id) WHERE flwreg_id = NEW.flwreg_id;
			
		END IF;
		
        RETURN NEW;

    -- Delete logic
    ELSIF TG_OP = 'DELETE' THEN
        IF v_flwreg_type = 'VFLWREG' THEN
            IF flwreg_type =  'ORIFICE' THEN
               DELETE FROM inp_frorifice WHERE flwreg_id = OLD.flwreg_id;

            ELSIF flwreg_type = 'OUTLET' THEN
                DELETE FROM inp_froutlet WHERE flwreg_id = OLD.flwreg_id;
			END IF;

        ELSIF v_flwreg_type = 'pump' THEN
            DELETE FROM inp_frpump WHERE flwreg_id = OLD.flwreg_id;

        ELSIF v_flwreg_type = 'weir' THEN
            DELETE FROM inp_frweir WHERE flwreg_id = OLD.flwreg_id;
        END IF;

		-- man_frtables
		EXECUTE 'DELETE FROM man_fr'||v_flwreg_type||' WHERE flwreg_id = OLD.flwreg_id';

		-- inp_flwreg_tables
		EXECUTE 'DELETE FROM inp_flwreg_'||v_flwreg_type||' WHERE flwreg_id = OLD.flwreg_id';

		RETURN NULL;

    END IF;
END;
$function$
;