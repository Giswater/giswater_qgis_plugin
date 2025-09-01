/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 01/09/2025
UPDATE sys_table SET descript='ve_inp_frorifice',alias='Inp flwreg orifice' WHERE id='ve_inp_frorifice';
UPDATE sys_table SET descript='ve_inp_frpump',alias='Inp flwreg pump' WHERE id='ve_inp_frpump';
UPDATE sys_table SET descript='ve_inp_froutlet',alias='Inp flwreg outlet' WHERE id='ve_inp_froutlet';
UPDATE sys_table SET descript='ve_inp_frweir',alias='Inp flwreg weir' WHERE id='ve_inp_frweir';
