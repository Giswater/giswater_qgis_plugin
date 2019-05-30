/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_csv2pg_cat SET isheader=true, orderby=1 WHERE id=1;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=1 WHERE id=1;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=2 WHERE id=3;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=3  WHERE id=4;
UPDATE sys_csv2pg_cat SET isheader=false, orderby=4  WHERE id=8;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=5  WHERE id=9;
UPDATE sys_csv2pg_cat SET isheader=false, orderby=6  WHERE id=10;
UPDATE sys_csv2pg_cat SET isheader=false, orderby=7  WHERE id=11;
UPDATE sys_csv2pg_cat SET isheader=false, orderby=8  WHERE id=12;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=9  WHERE id=13;
UPDATE sys_csv2pg_cat SET name='Import node visits', name_i18n='Import node visits', isheader=true, orderby=10  WHERE id=14;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=11  WHERE id=15;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=12  WHERE id=16;
UPDATE sys_csv2pg_cat SET isheader=true, orderby=13  WHERE id=17;
UPDATE sys_csv2pg_cat SET name='Import visit file', name_i18n='import visit file', csv_structure='Import visit file', isheader=true, orderby=14  WHERE id=18;


UPDATE om_visit_type SET idval='unexpected' WHERE idval ='unspected';
