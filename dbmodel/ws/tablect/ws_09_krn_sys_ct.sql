/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CHECK

ALTER TABLE "sys_feature_type" DROP CONSTRAINT IF EXISTS "sys_feature_type_check";
ALTER TABLE "sys_feature_cat" DROP CONSTRAINT IF EXISTS "sys_feature_cat_check";


-- ADD CHECK

ALTER TABLE sys_feature_type ADD CONSTRAINT sys_feature_type_check CHECK (id IN ('ARC','CONNEC','ELEMENT','LINK','NODE','VNODE'));
ALTER TABLE sys_feature_cat ADD CONSTRAINT sys_feature_cat_check CHECK (id IN ('ELEMENT', 'EXPANSIONTANK','FILTER','FLEXUNION','FOUNTAIN','GREENTAP','HYDRANT','JUNCTION','MANHOLE','METER','NETELEMENT','NETSAMPLEPOINT','NETWJOIN','PIPE','PUMP','REDUCTION','REGISTER','SOURCE','TANK','TAP','VALVE','VARC','WATERWELL','WJOIN','WTP'));
