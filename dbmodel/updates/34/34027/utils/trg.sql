/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/20
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_fluid;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id
ON man_type_fluid FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('man_type_fluid');

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_category;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id
ON man_type_category FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('man_type_category');

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_function;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id
ON man_type_function FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('man_type_function');

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_location;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id
ON man_type_location FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('man_type_location');
