/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/30
UPDATE sys_param_user 
SET vdefault = '{"onlyExport":false,"setDemand":true,"checkData":true,"checkNetwork":true,"checkResult":true,"onlyIsOperative":true,"delDisconnNetwork":false,"removeDemandOnDryNodes":false, "breakPipes":{"status":false, "maxLength":10, "removeVnodeBuffer":1}}'
WHERE id = 'inp_options_debug';

UPDATE config_param_user 
SET value = '{"onlyExport":false,"setDemand":true,"checkData":true,"checkNetwork":true,"checkResult":true,"onlyIsOperative":true,"delDisconnNetwork":false,"removeDemandOnDryNodes":false, "breakPipes":{"status":false, "maxLength":10, "removeVnodeBuffer":1}}'
WHERE parameter = 'inp_options_debug';

UPDATE sys_function SET descript = 'Function TO import network data from EPANET inp file into database. This function is experimental. Import may crash due many reasons. Be patient amb notify us if something went wrong. 
The parameter ''Create node2arc'' transforms EPANET valves and pumps to node2arc Giswater elements, enabling to use this doublegeometry capability (node on Giswater tables, arc on EPANET tables).
This option only is valid if EPANET file comes from Giswater project.' 
WHERE id=2522;