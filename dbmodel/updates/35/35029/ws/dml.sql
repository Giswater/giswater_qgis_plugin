/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21
INSERT INTO config_form_fields(formname, formtype, tabname, columnname,  datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate,  dv_querytext,  dv_isnullvalue, hidden)
VALUES ('v_edit_dma', 'form_feature', 'data', 'avg_press', 'numeric', 'text', 'average pressure', null,
null, false, false, true, false, null,null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

ALTER TABLE dqa DISABLE RULE dqa_conflict;
ALTER TABLE dma DISABLE RULE dma_conflict;
ALTER TABLE presszone DISABLE RULE presszone_conflict;
ALTER TABLE sector DISABLE RULE sector_conflict;

UPDATE dma SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';
UPDATE dqa SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';
UPDATE presszone SET link=replace(link,'graf','graph') WHERE link ilike '%graf%' and presszone_id='-1';
UPDATE sector SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';

ALTER TABLE dqa ENABLE RULE dqa_conflict;
ALTER TABLE dma ENABLE RULE dma_conflict;
ALTER TABLE presszone ENABLE RULE presszone_conflict;
ALTER TABLE sector ENABLE RULE sector_conflict;

