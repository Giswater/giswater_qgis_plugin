/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 9/2/2024;
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = '_inp_options_networkmode' WHERE typevalue = 'inp_options_networkmode' and id = '1';
UPDATE inp_typevalue SET idval = 'BASIC NETWORK' WHERE typevalue = 'inp_options_networkmode' and id = '2';
UPDATE inp_typevalue SET idval = 'NETWORK & CONNECS' WHERE typevalue = 'inp_options_networkmode' and id = '4';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;