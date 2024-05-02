/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3304

CREATE OR REPLACE FUNCTION gw_fct_admin_manage_planmode(p_data json)
  RETURNS json AS
$BODY$

/*
INSTRUCTIONS
------------
This function disable/enable the plan mode in order to work in big projects without planmode wich can be the responsable for loss of performance
The function does:
- Toggle v_state_arc, v_state_node, v_state_connec, v_state_gully, v_state_link views without/with references of plan issues
- Add/remove state=2 on value_state combo
- Remove/add tab_psector for selector dialog


EXAMPLE
-------
SELECT gw_fct_admin_manage_planmode($${"data":{"action":"DISABLE", "valueStateDelete":false}}$$)
								    when there are objects with state=2 -->"valueStateDelete":false
								    when there are not objects with state=2 -->"valueStateDelete":true

SELECT gw_fct_admin_manage_planmode($${"data":{"action":"ENABLE", "valueStatePlanName":"PLANIFIED"}}$$)
*/


DECLARE 

v_message text;
v_action text;
v_version text;
v_error_context text;
v_project_type text;
v_valuestatedelete boolean;
v_valuestateplanname text;

BEGIN 
	-- search path
	SET search_path = "ws36010", public;

	 -- select project type
	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameters
	v_action := (p_data ->> 'data')::json->> 'action';
	v_valuestatedelete := (p_data ->> 'data')::json->> 'valueStateDelete';
	v_valuestateplanname := (p_data ->> 'data')::json->> 'valueStatePlanName';

	IF v_action = 'DISABLE' THEN

		IF v_valuestatedelete THEN
			DELETE FROM value_state WHERE id = 2;
		ELSE
			UPDATE config_param_system 
			SET value = '{"table":"value_state","selector":"selector_state","table_id":"id","selector_id":"state_id","label":"id, '' - '', name","manageAll":false,"query_filter":" AND id < 3"}'
			WHERE parameter = 'basic_selector_tab_network_state';
		END IF;

		UPDATE config_form_tabs SET formname = 'selector_basic_' where tabname = 'tab_psector' and formname = 'selector_basic';

		CREATE OR REPLACE VIEW v_state_arc AS 
		  SELECT arc.arc_id FROM selector_state, arc
		  WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;

		CREATE OR REPLACE VIEW v_state_connec AS 
		  SELECT connec.connec_id, connec.arc_id,state AS flag
		  FROM selector_state, selector_expl, connec
		  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id)
		  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;
		 
		CREATE OR REPLACE VIEW v_state_link AS 
		  SELECT link.link_id
		  FROM selector_state, selector_expl, link
		  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
		  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;

		CREATE OR REPLACE VIEW v_state_link_connec AS 
		 SELECT link.link_id
		 FROM selector_state,selector_expl, link
		 WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
		 AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text;
		  
		CREATE OR REPLACE VIEW v_state_node AS 
		  SELECT node.node_id FROM selector_state, node
		  WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;

		  v_message = 'PLAN MODE SUCESSFULLY REMOVED';


	ELSIF v_action = 'ENABLE' THEN

		INSERT INTO value_state VALUES (2, v_valuestateplanname) ON CONFLICT (id) DO NOTHING;

		UPDATE config_param_system 
		SET value = '{"table":"value_state","selector":"selector_state","table_id":"id","selector_id":"state_id","label":"id, '' - '', name","manageAll":false,"query_filter":" AND id < 2"}'
		WHERE parameter = 'basic_selector_tab_network_state';

		UPDATE config_form_tabs SET formname = 'selector_basic' where tabname = 'tab_psector' and formname = 'selector_basic_';

			-- state node				
			CREATE OR REPLACE VIEW v_state_node AS(
				 SELECT node.node_id
				   FROM selector_state,
				    node
				  WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
				EXCEPT
				 SELECT plan_psector_x_node.node_id
				   FROM selector_psector,
				    plan_psector_x_node
				  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_node.state = 0
			) UNION
			 SELECT plan_psector_x_node.node_id
			   FROM selector_psector,
			    plan_psector_x_node
			  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_node.state = 1;

			-- state arc
			CREATE OR REPLACE VIEW v_state_arc AS (
				 SELECT arc.arc_id
				   FROM selector_state,
				    arc
				  WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
				EXCEPT
				 SELECT plan_psector_x_arc.arc_id
				   FROM selector_psector,
				    plan_psector_x_arc
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
				  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_arc.state = 0
			) UNION
			 SELECT plan_psector_x_arc.arc_id
			   FROM selector_psector,
			    plan_psector_x_arc
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
			  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_arc.state = 1;

			-- state connec
			CREATE OR REPLACE VIEW v_state_connec AS 
			 SELECT DISTINCT ON (a.connec_id) a.connec_id::varchar(30), a.arc_id, flag::smallint
			   FROM (( SELECT connec.connec_id,
					    connec.arc_id,
					    1 AS flag
					   FROM selector_state,
					    selector_expl,
					    connec
					  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id) 
					  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
					EXCEPT
					 SELECT plan_psector_x_connec.connec_id,
					    plan_psector_x_connec.arc_id,
					    1 AS flag
					   FROM selector_psector,
					    selector_expl,
					    plan_psector_x_connec
					     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
					  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 
					  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
				) UNION
				 SELECT plan_psector_x_connec.connec_id,
				    plan_psector_x_connec.arc_id,
				    2 AS flag
				   FROM selector_psector,
				    selector_expl,
				    plan_psector_x_connec
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
				  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 
				  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			  ORDER BY 1, 3 DESC) a;

			-- state link
			CREATE OR REPLACE VIEW ws36010.v_state_link AS (
				 SELECT DISTINCT link.link_id
				   FROM ws36010.selector_state,
				    ws36010.selector_expl,
				    ws36010.link
				  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id)
				   AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
				EXCEPT ALL
				 SELECT plan_psector_x_connec.link_id
				   FROM ws36010.selector_psector,
				    ws36010.selector_expl,
				    ws36010.plan_psector_x_connec
				     JOIN ws36010.plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
				  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
				  AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE
			) UNION ALL
			 SELECT plan_psector_x_connec.link_id
			   FROM ws36010.selector_psector,
			    ws36010.selector_expl,
			    ws36010.plan_psector_x_connec
			     JOIN ws36010.plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
			  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE;


			-- state link connec
			CREATE OR REPLACE VIEW v_state_link_connec AS (
				 SELECT DISTINCT link.link_id
				   FROM selector_state,
				    selector_expl,
				    link
				  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
				  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text
				EXCEPT ALL
				 SELECT plan_psector_x_connec.link_id
				   FROM selector_psector,
				    selector_expl,
				    plan_psector_x_connec
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
				  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
				  AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE
			) UNION ALL
			 SELECT plan_psector_x_connec.link_id
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_connec
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
			  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE;

			  v_message = 'PLAN MODE SUCESSFULLY RECOVERED';

	END IF;

	-- specific for ud
	IF v_project_type = 'UD' THEN

		IF v_action = 'DISABLE' THEN

			-- gully
			CREATE OR REPLACE VIEW v_state_gully AS 
			SELECT DISTINCT ON (gully_id) gully_id, arc_id 
			FROM selector_state, selector_expl, gully
			WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) 
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;

			-- link gully
			CREATE OR REPLACE VIEW v_state_link_gully AS 
			SELECT DISTINCT link.link_id FROM selector_state, selector_expl,link
			WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id)
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text;

		ELSIF v_action = 'ENABLE' THEN

			-- gully
			CREATE OR REPLACE VIEW v_state_gully AS 
			SELECT DISTINCT ON (a.gully_id) a.gully_id, a.arc_id
			FROM ((SELECT gully.gully_id,
				    gully.arc_id,
				    1 AS flag
				   FROM selector_state,
				    selector_expl,
				    gully
				  WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) 
				  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
				EXCEPT
				 SELECT plan_psector_x_gully.gully_id,
				    plan_psector_x_gully.arc_id,
				    1 AS flag
				   FROM selector_psector,
				    selector_expl,
				    plan_psector_x_gully
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
				  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
				  AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			) UNION
			 SELECT plan_psector_x_gully.gully_id,
			    plan_psector_x_gully.arc_id,
			    2 AS flag
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_gully
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
			  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			ORDER BY 1, 3 DESC) a;

			-- link gully
			CREATE OR REPLACE VIEW v_state_link_gully AS (
			 SELECT DISTINCT link.link_id
			   FROM selector_state,
			    selector_expl,
			    link
			  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
			  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text
			EXCEPT ALL
			 SELECT plan_psector_x_gully.link_id
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_gully
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
			  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_gully.active IS TRUE
			) UNION ALL
			SELECT plan_psector_x_gully.link_id
			FROM selector_psector,
			selector_expl,
			plan_psector_x_gully
			JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
			WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_gully.active IS TRUE;
		END IF;
	END IF;
	
	-- control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;