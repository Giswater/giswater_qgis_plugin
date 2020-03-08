/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_param_user SET vdefault =
'{"node":{"nullElevBuffer":100, "ceroElevBuffer":100}, "pipe":{"diameter":"160"}, "junction":{"defaultDemand":"0.001"}, "tank":{"distVirtualReservoir":0.01}, "pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE", "defaultCurve":"GP30"}, "pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED", "defaultCurve":"IM00"}, 
"PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}, "PSV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}, "reservoir":{"switch2Junction":["ETAP", "POU", "CAPTACIO"]}}'
WHERE id = 'inp_options_buildup_supply';

UPDATE audit_cat_param_user SET vdefault = 
'{"status":"true", "parameters":{"valve":{"length:"0.3", "diameter":"100", "minorloss":0.2, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}, "reservoir":{"addElevation":1}, "pipe":{}, "tank":{"addElevation":1}, "pump":{"length":0.3, "diameter":100, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}}}'
WHERE  id = 'inp_options_advancedsettings';