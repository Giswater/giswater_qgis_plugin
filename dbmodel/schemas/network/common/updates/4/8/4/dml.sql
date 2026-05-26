/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table
SET orderby=NULL,alias=NULL,context=NULL
WHERE id='ve_plan_psector';

UPDATE sys_table
SET orderby=1,alias='Plan psector',context='25'
WHERE id='v_plan_psector';

UPDATE sys_style
SET layername='v_plan_psector'
WHERE layername='ve_plan_psector' AND styleconfig_id=101;

UPDATE sys_style
SET layername='v_plan_psector'
WHERE layername='ve_plan_psector' AND styleconfig_id=110;
