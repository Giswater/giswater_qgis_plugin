/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3328, 'gw_trg_edit_municipality', 'utils', 'function', 'json', 'json', 'Trigger to insert or update elements in v_ext_municipality table.', 'role_edit', NULL, 'core');

UPDATE config_toolbox SET inputparams='[{"widgetname":"updateValues", "label":"Values to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["allValues", "nullValues"], "comboNames":["ALL VALUES", "NULL ELEVATION VALUES"], "selectedId":"nullValues"}]'::json WHERE id=2760;

UPDATE config_form_fields SET widgetcontrols='{
  "reloadFields": [
    "fluid_type",
    "location_type",
    "category_type",
    "function_type",
    "featurecat_id"
  ]
}'::json WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';

-- 3/12/24
UPDATE arc SET muni_id = 0 WHERE muni_id IS NULL;
UPDATE node SET muni_id = 0 WHERE muni_id IS NULL;
UPDATE connec SET muni_id = 0 WHERE muni_id IS NULL;
UPDATE element SET muni_id = 0 WHERE muni_id IS NULL;
UPDATE dimensions SET muni_id = 0 WHERE muni_id IS NULL;

ALTER TABLE arc ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE node ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE connec ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE element ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE dimensions ALTER COLUMN muni_id SET NOT NULL;

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('label_quadrant', 'TL', 'TL', NULL, NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('label_quadrant', 'TR', 'TR', NULL, NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('label_quadrant', 'BL', 'BL', NULL, NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('label_quadrant', 'BR', 'BR', NULL, NULL);

UPDATE config_form_fields SET widgettype = 'combo', dv_querytext='select id, idval from edit_typevalue where typevalue = ''label_quadrant''', dv_isnullvalue = true WHERE columnname='label_quadrant';
