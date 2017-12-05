/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2244

DROP FUNCTION IF EXISTS gw_fct_mincut_result_overlap(integer, text);
CREATE OR REPLACE FUNCTION gw_fct_mincut_result_overlap(result_id_arg integer, cur_user_var text)
  RETURNS integer AS
$BODY$
DECLARE
    mincut_rec			record;
    mincut_macexpl_aux  integer;
    overlap_rec	 		record;
    id_last				integer;
    overlap_macexpl_aux integer;
    overlap_exists_bool	boolean;
    comp_overlap_bool	boolean;
    conflict_id_text   	text;
    query_text 			text;
    count_int			integer;

BEGIN

    -- Search path
    SET search_path = "ws", public;

    -- init variables;
    overlap_exists_bool:=FALSE;
    comp_overlap_bool:=FALSE;
    count_int:=0;
    
    -- starting process
    SELECT * INTO mincut_rec FROM anl_mincut_result_cat WHERE id=result_id_arg;

    -- timedate overlap control
    FOR overlap_rec IN SELECT * FROM anl_mincut_result_cat 
    WHERE (forecast_start, forecast_end) OVERLAPS (mincut_rec.forecast_start, mincut_rec.forecast_end) AND id !=result_id_arg
    LOOP
    
  	IF overlap_rec.id IS NOT NULL THEN
  	        
		-- macroexploitation overlap control
		SELECT macroexpl_id INTO overlap_macexpl_aux FROM exploitation WHERE expl_id=overlap_rec.expl_id;		
		IF overlap_macexpl_aux=mincut_rec.macroexpl_id THEN

			IF overlap_exists_bool IS FALSE THEN

				-- create temp result for joined analysis
				INSERT INTO anl_mincut_result_cat (work_order, mincut_state, mincut_class, expl_id, macroexpl_id) 
				VALUES ('Temporary Analisys', 2,1, mincut_rec.expl_id, mincut_rec.macroexpl_id) RETURNING id INTO id_last;

				-- moving proposed valves from original mincut result to temp result cat into anl_mincut_result_valve 
                                query_text:='INSERT INTO anl_mincut_result_valve ( result_id, node_id,  closed,  broken, unaccess, proposed,the_geom)
				SELECT '||id_last||', node_id,  closed,  broken, unaccess, proposed,the_geom FROM anl_mincut_result_valve WHERE result_id='||result_id_arg;
				EXECUTE query_text;

				--identifing overlaping
				overlap_exists_bool:= TRUE;
			END IF;

			-- inserting proposed valves from overlaped mincut result (only those valves that are not present on the new resultcat
                        query_text:='UPDATE anl_mincut_result_valve SET proposed=TRUE WHERE result_id='||id_last||' 
				    AND node_id IN (SELECT node_id FROM anl_mincut_result_valve WHERE result_id='||overlap_rec.id||' AND proposed=TRUE)';
			EXECUTE query_text;

			-- count arc_id afected on the overlaped mincut result
			count_int:=count_int+(SELECT count(*) FROM anl_mincut_result_arc WHERE result_id=overlap_rec.id);
			conflict_id_text:=concat(conflict_id_text,',',overlap_rec.id);
			
		END IF;
	END IF;
    END LOOP;


    IF overlap_exists_bool THEN
	
		-- call mincut_flowtrace function
		raise notice 'execute mincut';
		PERFORM gw_fct_mincut_flowtrace (id_last);

		/* used for print image to test
		-- Update result valves with two dry sides to proposed=false
		UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE result_id=result_id_arg AND node_id IN
		(
			SELECT node_1 FROM anl_mincut_result_arc JOIN arc ON anl_mincut_result_arc.arc_id=arc.arc_id 
			JOIN anl_mincut_result_valve ON node_id=node_1 WHERE anl_mincut_result_arc.result_id=id_last AND proposed IS TRUE
				INTERSECT
			SELECT node_2 FROM anl_mincut_result_arc JOIN arc ON anl_mincut_result_arc.arc_id=arc.arc_id 
			JOIN anl_mincut_result_valve ON node_id=node_2 WHERE anl_mincut_result_arc.result_id=id_last AND proposed IS TRUE
		);
	
		-- Update result selector
		DELETE FROM "anl_mincut_result_selector" where cur_user=cur_user_var;
		INSERT INTO "anl_mincut_result_selector" (result_id, cur_user) VALUES (id_last, cur_user_var);
		*/
		
		-- compare results from original againts overlaped result
		IF count_int != (SELECT count(*) FROM anl_mincut_result_arc WHERE result_id=id_last) THEN
			PERFORM audit_function(2026 ,2244,conflict_id_text);
		END IF;
	
    END IF;

    DELETE FROM  anl_mincut_result_cat WHERE id=id_last;

RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;