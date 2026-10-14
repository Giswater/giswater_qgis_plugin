/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.
*/

SET search_path = am, public;

DO $$
DECLARE
	v_parent text;
BEGIN
	SELECT NULLIF(btrim(addparam->>'parentSchema'), '')
	INTO v_parent
	FROM am.sys_version
	ORDER BY id DESC
	LIMIT 1;

	IF v_parent IS NULL OR to_regnamespace(v_parent) IS NULL THEN
		RETURN;
	END IF;

	EXECUTE format($sql$
		UPDATE %1$I.sys_table AS t
		SET alias = v.alias
		FROM (VALUES
			('leaks', 'Leak History Points'),
			('v_asset_ws_arc_output_compare', 'Comparison Arc Result'),
			('v_asset_ws_arc_output', 'Selected Arc Result'),
			('v_asset_ws_arc_corporate', 'Corporate Arc Plan'),
			('ws_arc_output', 'All Arc Calculation Results'),
			('v_asset_ws_arc_input', 'Arc Failure Rates and Inputs'),
			('ext_ws_arc_asset', 'Existing Arc Inventory'),
			('v_asset_ws_node_output_compare', 'Comparison Node Result'),
			('v_asset_ws_node_output', 'Selected Node Result'),
			('v_asset_ws_node_corporate', 'Corporate Node Plan'),
			('v_asset_ws_node_input', 'Node Planning Inputs'),
			('ext_ws_node_asset', 'Existing Node Inventory'),
			('v_asset_ws_link_output_compare', 'Comparison Link Result'),
			('v_asset_ws_link_output', 'Selected Link Result'),
			('v_asset_ws_link_corporate', 'Corporate Link Plan'),
			('v_asset_ws_link_input', 'Link Planning Inputs'),
			('ext_ws_link_asset', 'Existing Link Inventory'),
			('v_asset_ud_arc_output_compare', 'Comparison Arc Result'),
			('v_asset_ud_arc_output', 'Selected Arc Result'),
			('v_asset_ud_arc_corporate', 'Corporate Arc Plan'),
			('ud_arc_output', 'All Arc Calculation Results'),
			('v_asset_ud_arc_input', 'Arc Planning Inputs'),
			('ext_ud_arc_asset', 'Existing Arc Inventory'),
			('v_asset_ud_node_output_compare', 'Comparison Node Result'),
			('v_asset_ud_node_output', 'Selected Node Result'),
			('v_asset_ud_node_corporate', 'Corporate Node Plan'),
			('v_asset_ud_node_input', 'Node Planning Inputs'),
			('ext_ud_node_asset', 'Existing Node Inventory')
		) AS v(id, alias)
		WHERE t.id = v.id
	$sql$, v_parent);
END $$;
