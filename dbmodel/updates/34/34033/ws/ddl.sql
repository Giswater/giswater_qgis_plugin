/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ws_sample, public, pg_catalog;


-- 2021/03/06
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_curve", "column":"isdoublen2a"}}$$);
DELETE FROM config_form_fields WHERE formname  ='inp_curve' and columnname = 'isdoublen2a';

ALTER TABLE inp_pump ALTER COLUMN pump_type SET DEFAULT 'FLOWPUMP';