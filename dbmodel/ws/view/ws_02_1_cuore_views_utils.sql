SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- COMMON SQL (WS & UD)


-------------------------------------------------------
-- STATE VIEWS & JOINED WITH MASTERPLAN (ALTERNATIVES)
-------------------------------------------------------
----------------------------------------------------

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
	AND selector_psector.cur_user=current_user AND state=1

UNION SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=2;
	


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
	AND selector_psector.cur_user=current_user AND state=1

UNION SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=2



--------------
-- STATE VIEWS
--------------

DROP VIEW IF EXISTS v_state_connec;
CREATE VIEW v_state_connec AS
SELECT 
	connec_id
	FROM selector_state,connec
	WHERE connec.state=selector_state.state_id
	AND selector_state.cur_user=current_user;


DROP VIEW IF EXISTS v_state_vnode;
CREATE VIEW v_state_vnode AS
SELECT 
	vnode_id
	FROM selector_state,vnode
	WHERE vnode.state=selector_state.state_id
	AND selector_state.cur_user=current_user;



DROP VIEW IF EXISTS v_state_link;
CREATE VIEW v_state_link AS
SELECT 
	link_id
	FROM selector_state,link
	WHERE link.state=selector_state.state_id
	AND selector_state.cur_user=current_user;



DROP VIEW IF EXISTS v_state_point;
CREATE VIEW v_state_point AS
SELECT 
	point_id
	FROM selector_state,point
	WHERE point.state=selector_state.state_id
	AND selector_state.cur_user=current_user;



DROP VIEW IF EXISTS v_state_samplepoint;
CREATE VIEW v_state_samplepoint AS
SELECT 
	samplepoint_id
	FROM selector_state,samplepoint
	WHERE samplepoint.state=selector_state.state_id
	AND selector_state.cur_user=current_user;


DROP VIEW IF EXISTS v_state_element;
CREATE VIEW v_state_element AS
SELECT 
	element_id
	FROM selector_state,element
	WHERE element.state=selector_state.state_id
	AND selector_state.cur_user=current_user
