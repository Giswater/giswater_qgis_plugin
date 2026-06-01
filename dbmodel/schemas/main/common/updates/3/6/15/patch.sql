/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_dimensions AS 
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id,
    dimensions.observ,
    dimensions.comment,
    dimensions.sector_id,
    dimensions.muni_id
   FROM selector_expl,
    dimensions
     JOIN v_state_dimensions ON dimensions.id = v_state_dimensions.id
     LEFT JOIN selector_municipality m USING (muni_id)
     JOIN selector_sector s USING (sector_id)
  WHERE (m.cur_user = CURRENT_USER::text OR dimensions.muni_id IS NULL) 
  AND s.cur_user = CURRENT_USER::text AND dimensions.expl_id = selector_expl.expl_id 
  AND selector_expl.cur_user = "current_user"()::text;


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3270, 'You can''t create or update a document with an empty name. Please provide a valid name.', NULL, 2, true, 'utils', 'core');

UPDATE config_form_fields SET dv_querytext = 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL' WHERE columnname  = 'muni_id' AND widgettype = 'combo';

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	 IF v_utils IS true THEN
        INSERT INTO utils.municipality VALUES (0, 'Undefined', NULL, NULL, true) ON CONFLICT DO NOTHING;
     ELSE
        INSERT INTO ext_municipality VALUES (0, 'Undefined', NULL, NULL, true) ON CONFLICT DO NOTHING;
	 END IF;
END; $$;

INSERT INTO selector_municipality SELECT DISTINCT 0, cur_user FROM selector_expl ON CONFLICT (muni_id, cur_user) DO NOTHING;

ALTER TABLE doc ALTER COLUMN "name" SET NOT NULL;

DROP TRIGGER IF EXISTS gw_trg_doc ON doc;
CREATE TRIGGER gw_trg_doc BEFORE INSERT OR UPDATE ON doc
FOR EACH ROW EXECUTE FUNCTION gw_trg_doc();
