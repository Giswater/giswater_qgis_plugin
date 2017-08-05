SET search_path = "ud30", public, pg_catalog;

-- COMMON SQL (WS & UD)


-------------------------------------------------------
-- STATE VIEWS & JOINED WITH MASTERPLAN (ALTERNATIVES)
-------------------------------------------------------

DROP VIEW IF EXISTS v_state_arc;
CREATE VIEW v_state_arc AS
SELECT 
	arc_id
	FROM selector_state,arc
	WHERE arc.state=selector_state.state_id
	AND selector_state.cur_user=current_user

EXCEPT SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;
	


DROP VIEW IF EXISTS v_state_node;
CREATE VIEW v_state_node AS
SELECT 
	node_id
	FROM selector_state,node
	WHERE node.state=selector_state.state_id
	AND selector_state.cur_user=current_user

EXCEPT SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;


	


