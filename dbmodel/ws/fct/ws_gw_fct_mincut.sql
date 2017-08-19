/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut(character varying, character varying);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut(
    element_id_arg character varying,
    type_element_arg character varying,
    result_id_arg character varying)
  RETURNS integer AS
$BODY$
DECLARE
    node_1_aux		text;
    node_2_aux		text;
    controlValue	integer;
    exists_id		text;
    polygon_aux		public.geometry;
    polygon_aux2	public.geometry;
    arc_aux         public.geometry;
    node_aux        public.geometry;    
    srid_schema		text;
	
	
	
--------------------------------------------------------
--BASICS: 
---------------------------------------------------------
--LES VALVULES DISPONIBLES: V_ANL_MINCUT_VALVE
--LA XARXA: V_EDIT_NODE & V_EDIT_ARC
--L'ESTAT: ANL_MINCUT_RESULT_VALVE
--L'ACCESIBILITAT: ANL_MINCUT_RESULT_VALVE_UNACCESS
--------------------------------------------------------
--------------------------------------------------------



-----------------------------------
-- TO DO
--CAL REVISAR EL MINCUT PER A QUE ANALITZI ELS CONFLICTES DE CONCURRENCIA TEMPORAL
--CAL REVISAR EL MINCUT INCORPORANT EL TEMA DELS CULS DE SAC AMB VALVULES PERMANENTMENT TANCADES
------------------------------------

	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	/*

    DELETE FROM "anl_mincut_result_node" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_arc" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_valve" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_polygon" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_connec" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_hydrometer" where result_id=result_id_arg; 

	-- 
	INSERT INTO anl_mincut_result_valve (result_id, node_id, closed, broken)
	SELECT * FROM v_anl_mincut_valve;
	
	UPDATE anl_mincut_result_valve SET unaccess=false WHERE result_id=result_id_var;
	UPDATE anl_mincut_result_valve SET unaccess=true WHERE result_id=result_id_var AND valve_id IN 
	(SELECT valve_id FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_var)
		
	
     -- The element to isolate could be an arc or a node
    IF type_element_arg = 'arc' THEN

        -- Check an existing arc
        SELECT COUNT(*) INTO controlValue FROM v_edit_arc WHERE arc_id = element_id_arg;
        IF controlValue = 1 THEN

            -- Select public.geometry
            SELECT the_geom INTO arc_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

            -- Insert arc id
            INSERT INTO "anl_mincut_result_arc" VALUES(element_id_arg, arc_aux);
        
            -- Run for extremes node
            SELECT node_1, node_2 INTO node_1_aux, node_2_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

			-- Check extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve WHERE node_id = node_1_aux AND (broken  = FALSE)  AND (opened = TRUE) 
			AND (unaccess = FALSE) AND result_cat_id=result_id_arg) ;

            IF controlValue = 1 THEN

                 -- update valve id
                UPDATE anl_mincut_result_valve SET proposed=true where node_id=node_1_aux;
                
            ELSE

                -- Call recursive
                PERFORM gw_fct_mincut_recursive(node_1_aux,result_id_arg);

            END IF;

            -- Check other extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve WHERE node_id = node_2_aux AND (broken  = FALSE)  AND (opened = TRUE) 
			AND (unaccess = FALSE) AND result_cat_id=result_id_arg) ;
           
            IF controlValue = 1 THEN

                -- Compute proceed
                IF NOT FOUND THEN

                    -- update valve id
                    UPDATE anl_mincut_result_valve SET proposed=true where node_id=node_2_aux;

                END IF;
                
            ELSE

                -- Call recursive
                PERFORM gw_fct_mincut_recursive(node_2_aux,result_id_arg);

            END IF;

        -- The arc_id was not found
        ELSE 
            RAISE EXCEPTION 'Nonexistent Arc ID --> %', element_id_arg
            USING HINT = 'Please check your arc table';
        END IF;

    ELSE

        -- Check an existing node
        SELECT COUNT(*) INTO controlValue FROM v_edit_node WHERE node_id = element_id_arg;
        IF controlValue = 1 THEN

            -- Compute the tributary area using DFS
            PERFORM gw_fct_mincut_recursive(element_id_arg,result_id_arg);

        -- The arc_id was not found
        ELSE 
            RAISE EXCEPTION 'Nonexistent Node ID --> %', node_id_arg
            USING HINT = 'Please check your node table';
        END IF;

    END IF;

	
    PERFORM gw_fct_valveanalytics(result_id_arg);

*/


    RETURN 1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
