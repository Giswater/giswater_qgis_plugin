/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DELETE FROM config_form_tableview WHERE tablename='v_ui_arc_x_relations' AND columnname='arc_state';
UPDATE config_form_tableview SET columnindex=7 WHERE tablename='v_ui_arc_x_relations' AND columnname='feature_state';
UPDATE config_form_tableview SET columnindex=8 WHERE tablename='v_ui_arc_x_relations' AND columnname='x';
UPDATE config_form_tableview SET columnindex=9 WHERE tablename='v_ui_arc_x_relations' AND columnname='y';

ALTER TABLE gully DISABLE TRIGGER gw_trg_connect_update;

UPDATE gully set pjoint_type=a.exit_type, pjoint_id=a.exit_id
from (select feature_id, exit_type, exit_id from link)a
where a.feature_id=gully_id and pjoint_id is null and state=1;

ALTER TABLE gully ENABLE TRIGGER gw_trg_connect_update;