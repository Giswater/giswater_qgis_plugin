/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/31
UPDATE sys_param_user SET vdefault = '{"forceReservoirsOnInlets":true,"setDemand":true,"checkResult":true,"onlyIsOperative":true,"delDisconnNetwork":false,"removeDemandOnDryNodes":false,"breakPipes":{"status":false, "maxLength":10, "removeVnodeBuffer":1},"graphicLog":"true","steps":0,"autoRepair":true}'
WHERE id = 'inp_options_debug';

DELETE FROM sys_function where function_name = 'gw_fct_pg2epa_inlet_flowtrace';