
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_state_searchnodes (varchar, integer, varchar, public.geometry, varchar);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_state_searchnodes(arc_id_aux varchar, arc_state_aux integer, point_aux varchar, arc_geom_aux public.geometry, tg_op_aux varchar)
  RETURNS varchar AS
  
$BODY$
DECLARE 
    node_id_var text;
    psector_vdefault_var integer;
    tolerance float;

BEGIN 

 -- Set search_path
    SET search_path = 'SCHEMA_NAME', public;
    
 -- Get data from config tables
    SELECT arc_searchnodes INTO tolerance FROM config; 


--  Looking for nodes
    IF tg_op_aux='INSERT' THEN
    
	IF point_aux = 'StartPoint' THEN 
		SELECT node_id INTO node_id_var	FROM v_edit_node 
					WHERE ST_DWithin(ST_startpoint(arc_geom_aux), v_edit_node.the_geom, tolerance)

					-- looking for existing nodes
					AND ((arc_state_aux=1 AND v_edit_node.state=1) 
					
					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN 
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='psector_vdefault' AND cur_user="current_user"())))

					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='psector_vdefault' AND cur_user="current_user"()))))

					-- Orderign by de closest one
					ORDER BY ST_Distance(v_edit_node.the_geom, ST_startpoint(arc_geom_aux)) LIMIT 1;
					
	ELSIF point_aux='EndPoint' THEN
		SELECT node_id INTO node_id_var	FROM v_edit_node 
					WHERE ST_DWithin(ST_endpoint(arc_geom_aux), v_edit_node.the_geom, tolerance)

					-- looking for existing nodes
					AND ((arc_state_aux=1 AND v_edit_node.state=1) 
					
					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN 
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='psector_vdefault' AND cur_user="current_user"())))

					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN
							(SELECT value::integer FROM config_param_user 
							WHERE parameter='psector_vdefault' AND cur_user="current_user"()))))
						
					-- Orderign by de closest one	
					ORDER BY ST_Distance(v_edit_node.the_geom, ST_endpoint(arc_geom_aux)) LIMIT 1;
	END IF;
	
	RETURN (node_id_var);  


    ELSIF tg_op_aux='UPDATE' THEN

	IF point_aux = 'StartPoint' THEN 
		SELECT node_id INTO node_id_var	FROM v_edit_node 
					WHERE ST_DWithin(ST_startpoint(arc_geom_aux), v_edit_node.the_geom, tolerance)

					-- looking for existing nodes
					AND ((arc_state_aux=1 AND v_edit_node.state=1) 
					
					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN 
							(SELECT psector_id FROM plan_arc_x_psector WHERE arc_id=arc_id_aux)))
							

					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN
							(SELECT psector_id FROM plan_arc_x_psector WHERE arc_id=arc_id_aux))))
							
					-- Orderign by de closest one
					ORDER BY ST_Distance(v_edit_node.the_geom, ST_startpoint(arc_geom_aux)) LIMIT 1;
					
	ELSIF point_aux='EndPoint' THEN
		SELECT node_id INTO node_id_var	FROM v_edit_node 
					WHERE ST_DWithin(ST_endpoint(arc_geom_aux), v_edit_node.the_geom, tolerance)

					-- looking for existing nodes
					AND ((arc_state_aux=1 AND v_edit_node.state=1) 
					
					-- looking for existing nodes that not belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=1 AND node_id NOT IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN 
							(SELECT psector_id FROM plan_arc_x_psector WHERE arc_id=arc_id_aux)))

					-- looking for planified nodes that belongs on the same alternatives that arc
					OR (arc_state_aux=2 AND v_edit_node.state=2 AND node_id IN 
						(SELECT node_id FROM plan_node_x_psector 
						 WHERE plan_node_x_psector.node_id=v_edit_node.node_id AND psector_id IN
						(SELECT psector_id FROM plan_arc_x_psector WHERE arc_id=arc_id_aux))))
													
					-- Orderign by de closest one	
					ORDER BY ST_Distance(v_edit_node.the_geom, ST_endpoint(arc_geom_aux)) LIMIT 1;
	END IF;
	
	RETURN (node_id_var);  





   END IF;
     
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;