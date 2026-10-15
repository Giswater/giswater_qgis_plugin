/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- gw_fct_workspacemanager (#974) lives in base/fct.
-- update / update_step run reload_fct_ftrg before this folder, so the body
-- is not duplicated here.

-- Drop sector 0 from saved selector_sector arrays. Replace only that array
-- so the rest of config::text stays as stored and CHECK still matches.
UPDATE cat_workspace AS cw
SET
	config = regexp_replace(
		cw.config::text,
		'("selector_sector"\s*:\s*)\[[0-9,[:space:]-]*\]',
		'\1' || CASE WHEN cleaned.ids IS NULL THEN 'null' ELSE '[' || cleaned.ids || ']' END
	)::json,
	lastupdate_timestamp = now(),
	lastupdate_user = CURRENT_USER
FROM (
	SELECT
		c.id,
		(
			SELECT string_agg(v::text, ', ' ORDER BY ord)
			FROM jsonb_array_elements(elem.sector_ids) WITH ORDINALITY AS t(v, ord)
			WHERE v <> '0'::jsonb
		) AS ids
	FROM cat_workspace c
	CROSS JOIN LATERAL (
		SELECT e->'selector_sector' AS sector_ids
		FROM jsonb_array_elements(c.config::jsonb->'selectors') AS e
		WHERE e ? 'selector_sector'
		LIMIT 1
	) AS elem
	WHERE elem.sector_ids @> '[0]'::jsonb
) AS cleaned
WHERE cw.id = cleaned.id;

UPDATE sys_fprocess SET query_text = '
SELECT * FROM (WITH
	rgh as (SELECT min(roughness), max(roughness) FROM cat_mat_roughness),
	hdl as (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter=''inp_options_headloss'')
	SELECT
		case when value = ''D-W'' and (min < 0.001 or max > 0.9) then 1
				when value = ''H-W'' and (min < 110 or max > 150) then 1
				when value = ''C-M'' and (min < 0.011 or max > 0.017) then 1
				else 0 END roughness
		from rgh, hdl) a WHERE roughness = 1' WHERE fid = 377;

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'dwfscenario_id', 0, true, NULL, 'dwfscenario_id', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'node_id', 1, true, NULL, 'Node id', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'value', 2, true, NULL, 'Value', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'pat1', 3, true, NULL, 'Pattern 1', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'pat2', 4, true, NULL, 'Pattern 2', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'pat3', 5, true, NULL, 'Pattern 3', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('info_epa', 'ud', 'inp_dwf', 'pat4', 6, true, NULL, 'Pattern 4', NULL, NULL);
