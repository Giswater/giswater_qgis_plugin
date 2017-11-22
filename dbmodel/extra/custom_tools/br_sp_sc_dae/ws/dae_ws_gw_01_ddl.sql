/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


ALTER TABLE gw_saa.ext_rtc_hydrometer_x_data ADD COLUMN tstamp timestamp without time zone;
ALTER TABLE gw_saa.rtc_hydrometer ADD COLUMN tstamp timestamp without time zone;
ALTER TABLE gw_saa.rtc_hydrometer_x_connec ADD COLUMN tstamp timestamp without time zone;

ALTER TABLE gw_saa.rtc_hydrometer_x_connec ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE gw_saa.rtc_hydrometer ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE gw_saa.ext_rtc_hydrometer_x_data ALTER COLUMN tstamp SET DEFAULT now();
