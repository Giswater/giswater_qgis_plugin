/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_csv set descript = 'The csv file must have the folloWing fields:
dscenario_name, feature_id, feature_type, value, demand_type, source', active = TRUE WHERE fid=501;

UPDATE config_toolbox SET inputparams = b.inp FROM
(SELECT json_agg(a.inputs::json) AS inp FROM
(SELECT json_array_elements_text(inputparams) as inputs
FROM   config_toolbox
WHERE id=2768
union select concat('{"widgetname":"dscenario_valve", "label":"Use valve status from dscenario:","widgettype":"combo","datatype":"text","tooltip": "Use closed and opened valves defined on inp_dscenario_shortpipe for selected dscenario", "layoutname":"grl_option_parameters","layoutorder":"',maxord+1,'","dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''SHORTPIPE'' order by name","isNullValue":"true", "selectedId":""}')
from (select max(d.layoutord::integer) as maxord from
(SELECT json_extract_path_text(json_array_elements(inputparams),'layoutorder') as layoutord
FROM config_toolbox
WHERE id=2768)d where layoutord is not null)e)a)b WHERE  id=2768;