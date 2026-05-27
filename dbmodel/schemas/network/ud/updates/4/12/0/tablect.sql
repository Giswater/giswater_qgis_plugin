/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 27/05/26
ALTER TABLE ext_hydrometer_data DROP CONSTRAINT IF EXISTS ext_rtc_hydrometer_x_data_hydrometer_id_fkey;
ALTER TABLE ext_hydrometer_data ADD CONSTRAINT ext_hydrometer_data_hydrometer_id_fkey
FOREIGN KEY (hydrometer_id) REFERENCES ext_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;
