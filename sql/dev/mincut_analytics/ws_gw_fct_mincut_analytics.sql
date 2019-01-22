CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_analytics(    p_work_order  text,    p_expl_id integer,    p_sector_id integer)
RETURNS void AS

$BODY$

DECLARE
v_result_id integer;
v_arc_id text;
v_the_geom public.geometry;
v_the_geom_p public.geometry;
v_num_connec integer;
v_num_hydro integer;
v_sum float;
v_count_all integer;
v_count integer = 0;
v_query_text text;



BEGIN
	-- Search path
    SET search_path = SCHEMA_NAME, public;

    DELETE FROM anl_arc WHERE fprocesscat_id=30;
    DELETE FROM temp_anl_mincut_analytics;
    DELETE FROM anl_mincut_analytics;


    -- create new catalog of mincut register
    INSERT INTO anl_mincut_result_cat (work_order) VALUES(p_work_order) RETURNING id INTO v_result_id ;

	IF p_sector_id=0 THEN
			v_query_text:= 'SELECT arc_id, the_geom FROM v_edit_arc WHERE state=1 AND expl_id='|| p_expl_id;
				
	        ELSE 
       			v_query_text:= 'SELECT arc_id, the_geom FROM v_edit_arc 
				JOIN value_state_type ON state_type=id 
				WHERE state=1 AND is_operative=TRUE AND expl_id='|| p_expl_id||'AND sector_id='||p_sector_id;
		END IF;	
		
		EXECUTE 'SELECT COUNT(*) FROM ('||v_query_text||')a'
			USING v_query_text 
			INTO v_count_all;

                RAISE NOTICE 'Total number of arcs to calculate: %', v_count_all;

				--Define the mincut areas
				DELETE FROM config_param_user WHERE cur_user=current_user AND parameter='om_mincut_areas';
				INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_mincut_areas', 'TRUE', current_user);
				
                FOR v_arc_id, v_the_geom  IN EXECUTE v_query_text
                LOOP
				
					IF v_arc_id NOT IN (SELECT arc_id FROM anl_arc WHERE arc_id=v_arc_id AND fprocesscat_id=30) THEN
					
						--mincut areas
						PERFORM gw_fct_mincut (v_arc_id, 'ARC', v_result_id, current_user);
					END IF;
				
				END LOOP;
	
				--Proceed to whole computational
				UPDATE config_param_user SET value='FALSE' WHERE cur_user=current_user AND parameter='om_mincut_areas';
				
				DELETE FROM config_param_user WHERE cur_user=current_user AND parameter='om_mincut_disable_check_temporary_overlap';
				INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_mincut_disable_check_temporary_overlap', 'TRUE', current_user) ;
				
				FOR v_arc_id IN EXECUTE v_query_text
                LOOP
				
					IF v_arc_id NOT IN (SELECT arc_id FROM anl_arc WHERE arc_id=v_arc_id AND fprocesscat_id=30) THEN
						PERFORM gw_fct_mincut (v_arc_id, 'ARC', v_result_id, current_user);
						SELECT count (*) INTO v_num_connec FROM anl_mincut_result_connec  WHERE result_id=v_result_id;
						SELECT count (*) INTO v_num_hydro FROM anl_mincut_result_hydrometer WHERE result_id=v_result_id;
						SELECT sum (st_length(the_geom)) INTO v_sum FROM anl_mincut_result_arc WHERE result_id=v_result_id;								

                        INSERT INTO temp_anl_mincut_analytics (arc_id, network_length, num_connec, num_hydro, sector_id)
						VALUES (v_arc_id, v_sum, v_num_connec, v_num_hydro, p_sector_id);
						v_count = v_count+1;
                        RAISE NOTICE 'In process % / %', v_count, v_count_all;
                    END IF;
					
				END LOOP;
				
				--Restore values
				UPDATE config_param_user SET value='FALSE' WHERE cur_user=current_user AND parameter='om_mincut_disable_check_temporary_overlap';

				--Insert values on the result table				
                INSERT INTO anl_mincut_analytics (arc_id, network_length, num_connec, num_hydro, sector_id) 
				SELECT arc_id, network_length, num_connec, num_hydro, sector_id FROM temp_anl_mincut_analytics;
                INSERT INTO anl_mincut_analytics (arc_id, arc_id_aux) SELECT arc_id,arc_id_aux FROM anl_arc;

				--Update values on the result table		
				UPDATE anl_mincut_analytics SET arc_id_aux=arc_id WHERE arc_id_aux IS NULL;
                UPDATE anl_mincut_analytics SET network_length=a.network_length, num_connec=a.num_connec, num_hydro=a.num_hydro,sector_id=a.sector_id   
					FROM anl_mincut_analytics a WHERE anl_mincut_analytics.arc_id_aux=a.arc_id;
                UPDATE anl_mincut_analytics SET the_geom=a.the_geom from arc a 	where a.arc_id=anl_mincut_analytics.arc_id;
                UPDATE anl_mincut_analytics SET the_geom_p=st_lineinterpolatepoint(the_geom, 0.5);
				
	RETURN;


END;

$BODY$

  LANGUAGE plpgsql VOLATILE

  COST 100;