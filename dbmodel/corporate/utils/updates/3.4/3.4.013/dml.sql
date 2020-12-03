/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


UPDATE sys_table SET notify_action = null WHERE id IN ('ext_municipality','ext_streetaxis','ext_plot','ext_type_street','ext_address', 'ext_district');



