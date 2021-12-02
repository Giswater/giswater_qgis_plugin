/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ud_deposona, public, pg_catalog;

--2021/11/30
UPDATE sys_table SET id = 'inp_snowpack_value' WHERE id  ='inp_snowpack';
UPDATE sys_table SET id = 'inp_snowpack' WHERE id  ='inp_snowpack_id';