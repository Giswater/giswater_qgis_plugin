/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE raingage DROP CONSTRAINT raingage_rgage_type_fkey;
ALTER TABLE _inp_windspeed_ DROP CONSTRAINT inp_windspeed_wind_type_fkey;
ALTER TABLE inp_flwreg_weir DROP CONSTRAINT inp_flwreg_weir_flap_fkey;
ALTER TABLE _inp_inflows_ DROP CONSTRAINT inp_inflows_pattern_id_fkey;