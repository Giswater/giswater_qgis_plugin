/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES
('scada_graph', 'scada_graph', 'tab_none', 'object_1', 'lyt_scada_node_1', 0, 'integer', 'text', 'Node 1:', 'object_1', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_pick_object_1', 'lyt_scada_node_1', 1, NULL, 'button', NULL, 'Pick node 1', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon": "137"}'::json, NULL, '{"functionName": "pick_node", "module": "scada_graph", "parameters": {"target": "object_1"}}'::json, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'object_2', 'lyt_scada_node_2', 0, 'integer', 'text', 'Node 2:', 'object_2', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_pick_object_2', 'lyt_scada_node_2', 1, NULL, 'button', NULL, 'Pick node 2', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon": "137"}'::json, NULL, '{"functionName": "pick_node", "module": "scada_graph", "parameters": {"target": "object_2"}}'::json, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Accept"}'::json, '{"functionName": "accept", "module": "scada_graph"}'::json, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{"functionName": "close", "module": "scada_graph"}'::json, NULL, false, 0);


CREATE OR REPLACE VIEW vf_link AS
SELECT l.link_id, COALESCE(pp.state, l.state) AS p_state
FROM link l
LEFT JOIN LATERAL (
	SELECT x.connec_id, x.psector_id
	FROM (SELECT 1 WHERE EXISTS (
			SELECT 1 FROM selector_psector sp WHERE sp.cur_user = CURRENT_USER
		)) gate
	CROSS JOIN LATERAL (
		SELECT pp1.connec_id, pp1.psector_id
		FROM plan_psector_x_connec pp1
		WHERE pp1.connec_id = l.feature_id
			AND pp1.psector_id IN (
				SELECT sp.psector_id FROM selector_psector sp WHERE sp.cur_user = CURRENT_USER
			)
		ORDER BY pp1.psector_id DESC
		LIMIT 1
	) x
) last_ps ON true
LEFT JOIN LATERAL (
	SELECT x.state
	FROM (SELECT 1 WHERE last_ps.psector_id IS NOT NULL) gate
	CROSS JOIN LATERAL (
		SELECT pp2.state
		FROM plan_psector_x_connec pp2
		WHERE pp2.link_id = l.link_id AND pp2.psector_id = last_ps.psector_id
		LIMIT 1
	) x
) pp ON true
WHERE EXISTS (
		SELECT 1 FROM selector_state ss
		WHERE ss.cur_user = CURRENT_USER AND ss.state_id = COALESCE(pp.state, l.state)
	)
	AND l.sector_id IN (SELECT ssec.sector_id FROM selector_sector ssec WHERE ssec.cur_user = CURRENT_USER)
	AND l.muni_id IN (SELECT sm.muni_id FROM selector_municipality sm WHERE sm.cur_user = CURRENT_USER)
	AND EXISTS (
		SELECT 1 FROM selector_expl se
		WHERE se.cur_user = CURRENT_USER
			AND (se.expl_id = l.expl_id OR se.expl_id = ANY (l.expl_visibility))
	);
