/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- 2&/11/2018
ALTER TABLE ext_cat_period RENAME starttime TO start_date;
ALTER TABLE ext_cat_period RENAME endtime TO end_date;

ALTER TABLE ext_rtc_hydrometer_x_data ADD COLUMN value_date date;