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