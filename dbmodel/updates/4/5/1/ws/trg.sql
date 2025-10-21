/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_fluid;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_fluid FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_fluid');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF fluid_type ON man_type_fluid FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('man_type_fluid', 'fluid_type');
