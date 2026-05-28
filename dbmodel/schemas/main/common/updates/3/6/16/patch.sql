/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

drop VIEW v_ui_workspace;

CREATE OR REPLACE VIEW v_ui_workspace
AS SELECT cat_workspace.id,
    cat_workspace.name,
    cat_workspace.private,
    cat_workspace.descript,
    cat_workspace.cur_user as insert_user,
    cat_workspace.config
   FROM cat_workspace
  WHERE cat_workspace.private IS FALSE OR cat_workspace.private IS TRUE AND cat_workspace.cur_user = CURRENT_USER::text;
  
  
CREATE OR REPLACE VIEW v_ext_municipality
AS SELECT DISTINCT m.muni_id,
    m.name,
    m.active,
    m.the_geom
   FROM ext_municipality m,
    selector_municipality
  WHERE m.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text
  and m.muni_id > 0;


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


ALTER TABLE link DROP constraint if exists  link_sector_id;

ALTER TABLE link DROP constraint if exists link_muni_id;

ALTER TABLE link ADD CONSTRAINT link_sector_id_fkey FOREIGN KEY (sector_id) 
REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

DROP TRIGGER IF EXISTS gw_trg_edit_municipality ON v_ext_municipality;
CREATE TRIGGER gw_trg_edit_municipality INSTEAD OF INSERT OR DELETE OR UPDATE 
ON v_ext_municipality FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_municipality();
