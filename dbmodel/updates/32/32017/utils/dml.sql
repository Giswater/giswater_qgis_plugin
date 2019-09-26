/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET isdeprecated=TRUE where id=2538; --dinlet

UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_ui_scada_x_node';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_ui_scada_x_node_values';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_edit_om_psector';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_edit_om_psector_x_other';


UPDATE audit_cat_table SET isdeprecated=true WHERE id='man_addfields_cat_combo';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='man_addfields_cat_datatype';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='man_addfields_cat_widgettype';

UPDATE cat_feature SET child_layer=concat('ve_', lower(feature_type), '_', lower(replace(replace(replace(id, '-', '_'), ' ', '_'), '.','_')));

