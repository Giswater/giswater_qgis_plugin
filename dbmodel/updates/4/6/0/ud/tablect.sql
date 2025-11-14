/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 05/11/2025
ALTER TABLE rtc_hydrometer_x_connec
    ADD CONSTRAINT rtc_hydrometer_x_connec_connec_id_fkey
    FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE rtc_hydrometer_x_connec
    ADD CONSTRAINT rtc_hydrometer_x_connec_hydrometer_id_fkey
    FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;

