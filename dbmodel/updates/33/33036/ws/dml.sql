/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/04/22
UPDATE audit_cat_param_user SET widgetcontrols = null, placeholder='24' WHERE id = 'inp_times_duration';
