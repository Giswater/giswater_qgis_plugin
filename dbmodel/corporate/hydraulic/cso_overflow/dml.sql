/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;

v_returncoeff = (select value::numeric from config_param_system where "parameter" = 'cso_returncoeff');
v_daily_supply = (select value::numeric from config_param_system where "parameter" = 'cso_daily_supply');

