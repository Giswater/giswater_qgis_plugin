/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW ve_inp_dwf
AS SELECT i.dwfscenario_id,
    i.node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4
   FROM config_param_user c,
    inp_dwf i
     JOIN ve_inp_junction USING (node_id)
  WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario_current'::text AND c.value::integer = i.dwfscenario_id;
