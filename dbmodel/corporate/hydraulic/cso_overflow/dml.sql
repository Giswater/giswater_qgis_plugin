/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;

INSERT INTO config_param_system ("parameter", value, descript) VALUES('cso_daily_supply', '150', 'Daily supply of water (L x hab x day)') ON CONFLICT ("parameter") DO NOTHING;
INSERT INTO config_param_system ("parameter", value, descript) VALUES('cso_returncoeff', '0.8', 'Return coefficient (%)');
