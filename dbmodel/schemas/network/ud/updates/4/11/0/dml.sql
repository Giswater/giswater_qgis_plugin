/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/05/2026
DELETE FROM config_form_fields WHERE formname='ve_exploitation' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_exploitation' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';

-- 20/05/2026
UPDATE plan_psector SET status = 3 WHERE status = 4;

ALTER TABLE plan_typevalue DISABLE TRIGGER ALL;
DELETE FROM plan_typevalue WHERE typevalue='psector_status' AND id='4';
ALTER TABLE plan_typevalue ENABLE TRIGGER ALL;
