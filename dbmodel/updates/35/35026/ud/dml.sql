/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/08
update  inp_typevalue set addparam = '{"BC": ["SURFACE", "SOIL", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'BC';

update  inp_typevalue set addparam = '{"RG": ["SURFACE", "SOIL", "STORAGE"] }' WHERE inp_typevalue.id  = 'RG';

update  inp_typevalue set addparam = '{"GR": ["SURFACE", "SOIL", "DRAINMAT"] }' WHERE inp_typevalue.id  = 'GR';

update  inp_typevalue set addparam = '{"IT": ["SURFACE", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'IT';

update  inp_typevalue set addparam = '{"PP": ["SURFACE", "PAVEMENT", "SOIL", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'PP';

update  inp_typevalue set addparam = '{"RB": ["STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'RB';

update  inp_typevalue set addparam = '{"RD": ["SURFACE", "DRAIN"] }' WHERE inp_typevalue.id  = 'RD';

update  inp_typevalue set addparam = '{"VS": ["SURFACE"] }' WHERE inp_typevalue.id  = 'VS';

update config_toolbox
set inputparams='[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""},
{"widgetname":"descript", "label":"Descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5,"value":""}]' 
WHERE id=3118;