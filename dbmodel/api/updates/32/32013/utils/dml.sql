/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE api_ws_sample.cat_feature SET shortcut_key = concat('Alt+',sys_feature_cat.shortcut_key) FROM api_ws_sample.sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'NODE'
UPDATE api_ws_sample.cat_feature SET shortcut_key = concat('Ctrl+',sys_feature_cat.shortcut_key) FROM api_ws_sample.sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'CONNEC'
UPDATE api_ws_sample.cat_feature SET shortcut_key = sys_feature_cat.shortcut_key FROM api_ws_sample.sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'ARC'