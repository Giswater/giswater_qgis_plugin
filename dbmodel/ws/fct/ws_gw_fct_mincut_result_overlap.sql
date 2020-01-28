/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2244

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_result_overlap(integer, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_result_overlap(result_id_arg integer, cur_user_var text)
RETURNS text AS
$BODY$
DECLARE
v_mincutrec record;
v_rec record;
id_last	integer;
v_overlap_macroexpl integer;
v_overlaps boolean;
v_overlap_comp boolean;
v_conflictmsg text;
v_count	integer;
v_count2 integer;
v_message text;
v_conflictarray integer[];
v_id integer;
v_querytext text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- init variables;
    v_overlaps:=FALSE;
    v_conflictmsg:=NULL;
    
    SELECT count(*) INTO v_count FROM anl_mincut_result_arc WHERE result_id=result_id_arg;
    
    -- starting process
    SELECT * INTO v_mincutrec FROM anl_mincut_result_cat WHERE id=result_id_arg;

    -- timedate overlap control
    FOR v_rec IN SELECT * FROM anl_mincut_result_cat 
    WHERE (forecast_start, forecast_end) OVERLAPS (v_mincutrec.forecast_start, v_mincutrec.forecast_end) AND id !=result_id_arg
    LOOP
	-- if exist timedate overlap
  	IF v_rec.id IS NOT NULL THEN
  	        
		-- macroexploitation overlap control
		SELECT macroexpl_id INTO v_overlap_macroexpl FROM exploitation WHERE expl_id=v_rec.expl_id;

		-- if exists macroexpl overlap		
		IF v_overlap_macroexpl=v_mincutrec.macroexpl_id THEN

			-- if it's first time - Inserting mincut values
			IF v_overlaps IS FALSE THEN

				-- create temp result for joined analysis
				DELETE FROM anl_mincut_result_cat WHERE id=-2;
				INSERT INTO anl_mincut_result_cat (id, work_order, mincut_state, mincut_class, expl_id, macroexpl_id) 
				VALUES (-2, 'Conflict Mincut (system)', 2, 1, v_mincutrec.expl_id, v_mincutrec.macroexpl_id) RETURNING id INTO id_last;

				-- copying proposed valves and afected arcs from original mincut result to temp result into anl_mincut_result_valve 
                                v_querytext:='INSERT INTO anl_mincut_result_valve (result_id, node_id,  closed,  broken, unaccess, proposed, the_geom)
				             SELECT '||id_last||', node_id,  closed,  broken, unaccess, proposed, the_geom 
				             FROM anl_mincut_result_valve WHERE result_id='||result_id_arg||' AND proposed=TRUE';
				EXECUTE v_querytext;

				v_querytext:='INSERT INTO anl_mincut_result_arc ( result_id, arc_id, the_geom)
				             SELECT '||id_last||', arc_id, the_geom 
				             FROM anl_mincut_result_arc WHERE result_id='||result_id_arg;
				EXECUTE v_querytext;	

				--identifing overlaping
				v_overlaps:= TRUE;
			END IF;

			-- copying proposed valves and afected arcs from overlaped mincut result 
			v_querytext:='INSERT INTO anl_mincut_result_valve ( result_id, node_id,  closed,  broken, unaccess, proposed, the_geom)
				     SELECT '||id_last||', node_id,  closed,  broken, unaccess, proposed, the_geom 
				     FROM anl_mincut_result_valve WHERE result_id='||v_rec.id||' AND proposed=TRUE';     
			EXECUTE v_querytext;

			v_querytext:='INSERT INTO anl_mincut_result_arc ( result_id, arc_id, the_geom)
			             SELECT '||id_last||', arc_id, the_geom 
			             FROM anl_mincut_result_arc WHERE result_id='||v_rec.id;    
			EXECUTE v_querytext;	

			-- count arc_id afected on the overlaped mincut result
			v_count:=v_count+(SELECT count(*) FROM anl_mincut_result_arc WHERE result_id=v_rec.id);

			-- Storing id of possible conflict
			IF v_conflictmsg IS NULL THEN
				v_conflictarray = array_append(v_conflictarray::integer[], v_rec.id::integer);
				v_conflictmsg:=concat('Id-', v_rec.id, ' at ',left(v_rec.forecast_start::time::text, 5),'H-',left(v_rec.forecast_end::time::text, 5),'H');			
			ELSE
				v_conflictarray = array_append(v_conflictarray, v_rec.id);
				v_conflictmsg:=concat(v_conflictmsg,' , Id-', v_rec.id, ' at ',left(v_rec.forecast_start::time::text, 5),'H-',left(v_rec.forecast_end::time::text, 5),'H');
			END IF;
			
		END IF;
	END IF;
    END LOOP;

    IF v_overlaps THEN

	-- call mincut_flowtrace function
	raise notice 'Execute mincut again mixing overlaped valves';
	PERFORM gw_fct_mincut_inverted_flowtrace (id_last);

	v_count2:=(SELECT count(*) FROM anl_mincut_result_arc WHERE result_id=id_last) ;

	-- write the possible message to show
	v_message = concat ('Mincut ', result_id_arg,' overlaps date-time with other mincuts (',v_conflictmsg,') on same macroexpl. and has conflicts at least with one');

	-- Insert the conflict results on the anl tables to enable the posibility to analyze it
	DELETE FROM anl_arc WHERE fprocesscat_id=31 and cur_user=current_user;
	DELETE FROM selector_audit WHERE cur_user = current_user;
	
	IF v_count != v_count2 THEN

		-- Update result valves with two dry sides to proposed=false
		UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE result_id=result_id_arg AND node_id IN
		(
			SELECT node_1 FROM anl_mincut_result_arc JOIN arc ON anl_mincut_result_arc.arc_id=arc.arc_id 
			JOIN anl_mincut_result_valve ON node_id=node_1 WHERE anl_mincut_result_arc.result_id=id_last AND proposed IS TRUE
				INTERSECT
			SELECT node_2 FROM anl_mincut_result_arc JOIN arc ON anl_mincut_result_arc.arc_id=arc.arc_id 
			JOIN anl_mincut_result_valve ON node_id=node_2 WHERE anl_mincut_result_arc.result_id=id_last AND proposed IS TRUE
		);		
		
		-- insert conflict mincuts
		EXECUTE 'INSERT INTO anl_arc (arc_id, fprocesscat_id, expl_id, cur_user, the_geom, result_id, descript) 
			SELECT DISTINCT ON (arc_id) arc_id, 31, expl_id, current_user, a.the_geom, result_id, '||quote_literal(v_message)||' 
			FROM anl_mincut_result_arc JOIN arc a USING (arc_id) WHERE result_id IN ('||v_conflictarray||')';

		-- insert current mincut
		INSERT INTO anl_arc (arc_id, fprocesscat_id, expl_id, cur_user, the_geom, result_id, descript) 
			SELECT DISTINCT ON (arc_id) arc_id, 31, expl_id, current_user, a.the_geom, result_id, v_message 
			FROM anl_mincut_result_arc JOIN arc a USING (arc_id) WHERE result_id=result_id_arg;

		-- insert additional affectations
		EXECUTE 'INSERT INTO anl_arc (arc_id, fprocesscat_id, expl_id, cur_user, the_geom, result_id, descript) 
			SELECT DISTINCT ON (arc_id) arc_id, 31, expl_id, current_user, a.the_geom, result_id, '||quote_literal(v_message)||'
			FROM anl_mincut_result_arc JOIN arc a USING (arc_id)  WHERE result_id = '||id_last||' AND a.arc_id NOT IN 
			(SELECT arc_id FROM anl_mincut_result_arc WHERE result_id IN ('||v_conflictarray||') UNION SELECT arc_id FROM anl_mincut_result_arc WHERE result_id='||result_id_arg||')';
	ELSE 
		-- check for overlaps type 2
		FOREACH v_id IN ARRAY v_conflictarray
		LOOP
			-- insert conflict arcs
			v_querytext =  'INSERT INTO anl_arc (arc_id, fprocesscat_id, expl_id, cur_user, the_geom, result_id, descript) 
				SELECT DISTINCT ON (arc_id) arc_id, 31, expl_id, current_user, a.the_geom, '||v_id||', '||quote_literal(v_message)||'
				FROM anl_mincut_result_arc JOIN arc a USING (arc_id)  WHERE result_id = '||result_id_arg||' AND a.arc_id IN 
				(SELECT arc_id FROM anl_mincut_result_arc WHERE result_id = '||v_id||')';

			EXECUTE v_querytext;
		END LOOP;

		SELECT count(*) INTO v_count FROM anl_arc WHERE fprocesscat_id=31 AND cur_user=current_user;
		IF v_count = 0 THEN
			v_conflictmsg:=null;
		END IF;
	END IF;

	DELETE FROM  anl_mincut_result_cat WHERE id=id_last;
	PERFORM setval('SCHEMA_NAME.anl_mincut_result_cat_seq', (select max(id) from anl_mincut_result_cat) , true);   
	
   END IF;
   
   RETURN v_conflictmsg;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

