/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3304

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_planmode(p_data json)
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
	SET search_path = "SCHEMA_NAME", public;

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
		  SELECT connec.connec_id, connec.arc_id, state AS flag
		  FROM selector_state, selector_expl, connec
		  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id)
		  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;
  
		CREATE OR REPLACE VIEW v_state_node AS 
		  SELECT node.node_id FROM selector_state, node
		  WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;

		IF v_project_type = 'WS' THEN
		 
			CREATE OR REPLACE VIEW v_state_link AS 
			SELECT link.link_id
			FROM selector_state, selector_expl, link
			WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;
			
		ELSIF v_project_type = 'UD' THEN

			-- gully
			CREATE OR REPLACE VIEW v_state_gully AS 
			SELECT DISTINCT ON (gully_id) gully_id, arc_id 
			FROM selector_state, selector_expl, gully
			WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) 
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;
			
			-- link connec
			CREATE OR REPLACE VIEW v_state_link_connec AS 
			SELECT link.link_id
			FROM selector_state,selector_expl, link
			WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text;

			-- link gully
			CREATE OR REPLACE VIEW v_state_link_gully AS 
			SELECT DISTINCT link.link_id FROM selector_state, selector_expl,link
			WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id)
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text;
			
			CREATE OR REPLACE VIEW v_state_link AS
			SELECT * FROM v_state_link_connec
				UNION
			SELECT * FROM v_state_link_gully;

		END IF;

		v_message = 'PLAN MODE SUCESSFULLY REMOVED';

	ELSIF v_action = 'ENABLE' THEN

		INSERT INTO value_state VALUES (2, v_valuestateplanname) ON CONFLICT (id) DO NOTHING;

		UPDATE config_param_system 
		SET value = '{"table":"value_state","selector":"selector_state","table_id":"id","selector_id":"state_id","label":"id, '' - '', name","manageAll":false,"query_filter":" AND id < 2"}'
		WHERE parameter = 'basic_selector_tab_network_state';

		UPDATE config_form_tabs SET formname = 'selector_basic' where tabname = 'tab_psector' and formname = 'selector_basic_';

		CREATE OR REPLACE VIEW v_state_arc AS 
		WITH 
		p AS (SELECT arc_id, psector_id, state FROM plan_psector_x_arc WHERE active), 
		s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
		a as (SELECT arc_id, state FROM arc)
		SELECT arc.arc_id FROM selector_state,arc WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
			EXCEPT
		SELECT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
			UNION
		SELECT p.arc_id FROM s,p WHERE p.psector_id = s.psector_id AND p.state = 1;


		CREATE OR REPLACE VIEW v_state_node AS 
		WITH 
		p AS (SELECT node_id, psector_id, state FROM plan_psector_x_node WHERE active), 
		s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
		n AS (SELECT node_id, state FROM node)
		SELECT n.node_id FROM selector_state,n WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
			EXCEPT
		SELECT p.node_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
			UNION
		SELECT p.node_id FROM s,p WHERE p.psector_id = s.psector_id AND p.state = 1;


		IF v_project_type ='WS' THEN

			CREATE OR REPLACE VIEW v_state_connec AS 
			WITH 
			p AS (SELECT connec_id, psector_id, state, arc_id FROM plan_psector_x_connec WHERE active), 
			s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			c as (SELECT connec_id, state, arc_id FROM connec)
			SELECT c.connec_id, c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
				EXCEPT
			SELECT p.connec_id, p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 0
				UNION
			SELECT DISTINCT ON (p.connec_id) p.connec_id, p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 1;

		
			CREATE OR REPLACE VIEW v_state_link AS 
			WITH 
			p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
			sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
			l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
			SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
				EXCEPT
			SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
				UNION
			SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;

		ELSIF v_project_type ='UD' THEN
		

			CREATE OR REPLACE VIEW v_state_connec AS 
			WITH 
			p AS (SELECT connec_id, psector_id, state, arc_id FROM plan_psector_x_connec WHERE active), 
			s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			c as (SELECT connec_id, state, arc_id FROM connec)
			SELECT c.connec_id::varchar(30), c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
				EXCEPT
			SELECT p.connec_id::varchar(30), p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 0
				UNION
			SELECT DISTINCT ON (p.connec_id) p.connec_id::varchar(30), p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 1;


			CREATE OR REPLACE VIEW v_state_gully AS 
			WITH 
			p AS (SELECT gully_id, psector_id, state, arc_id FROM plan_psector_x_gully WHERE active), 
			s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			c as (SELECT gully_id, state, arc_id FROM gully)
			SELECT c.gully_id, c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
				EXCEPT
			SELECT p.gully_id, p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 0
				UNION
			SELECT DISTINCT ON (p.gully_id) p.gully_id, p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 1;


			CREATE OR REPLACE VIEW v_state_link_connec AS 
			WITH 
			p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
			sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
			l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
			SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
				EXCEPT
			SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
				UNION
			SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


			CREATE OR REPLACE VIEW v_state_link_gully AS 
			WITH 
			p AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
			sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
			l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
			SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
				EXCEPT
			SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
				UNION
			SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


			CREATE OR REPLACE VIEW v_state_link AS
			WITH 
			c AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
			g AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
			sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
			se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
			l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
			SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
				EXCEPT
			SELECT c.link_id FROM sp, se, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
				EXCEPT
			SELECT g.link_id FROM sp, se, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
				UNION
			SELECT c.link_id FROM sp, se, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
				UNION
			SELECT g.link_id FROM sp, se, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;

		END IF;

		v_message = 'PLAN MODE SUCESSFULLY RECOVERED';

	END IF;
	
	-- control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}}'||
	    '}')::json;

	-- Exception control
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) 
	||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;