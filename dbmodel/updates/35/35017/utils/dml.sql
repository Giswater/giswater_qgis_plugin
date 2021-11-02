/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/01
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (415, 'Connec without pjoint_id or pjoint_type','utils', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/02
UPDATE sys_table SET notify_action='[{"channel":"desktop","name":"update_catfeaturevalues", "enabled":"true", "trg_fields":"id","featureType":[]}]'::json WHERE id='cat_feature';

UPDATE config_param_user SET value = $${"title":{"text":{"color":"black", "weight":"bold", "size":10}},
"terrain":{"color":"gray", "width":1.5, "style":"dashdot"}, 
"infra":{"real":{"color":"black", "width":1, "style":"solid"}, 
"interpolated":{"color":"black", "width":1.5,"style":"dashed"}},
"grid":{"boundary":{"color":"gray","style":"solid", "width":1}, "lines":{"color":"lightgray","style":"solid", "width":1},"text":{"color":"black", "weight":"normal"}},
"guitar":{"lines":{"color":"black", "style":"solid", "width":1}, "auxiliarlines":{"color":"gray","style":"solid", "width":1}, "text":{"color":"black", "weight":"normal"}}}$$
WHERE parameter = 'om_profile_stylesheet';

UPDATE sys_param_user SET vdefault = $${"title":{"text":{"color":"black", "weight":"bold", "size":10}},
"terrain":{"color":"gray", "width":1.5, "style":"dashdot"}, 
"infra":{"real":{"color":"black", "width":1, "style":"solid"}, 
"interpolated":{"color":"black", "width":1.5,"style":"dashed"}},
"grid":{"boundary":{"color":"gray","style":"solid", "width":1}, "lines":{"color":"lightgray","style":"solid", "width":1},"text":{"color":"black", "weight":"normal"}},
"guitar":{"lines":{"color":"black", "style":"solid", "width":1}, "auxiliarlines":{"color":"gray","style":"solid", "width":1}, "text":{"color":"black", "weight":"normal"}}}$$
WHERE id = 'om_profile_stylesheet';
