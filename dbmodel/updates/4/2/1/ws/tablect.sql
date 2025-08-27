/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE rpt_cat_result DROP CONSTRAINT IF EXISTS rpt_cat_result_network_dma_corporate;
ALTER TABLE rpt_cat_result ADD CONSTRAINT rpt_cat_result_network_dma_corporate CHECK (NOT (iscorporate = TRUE AND network_type = '5'));


CREATE RULE omzone_conflict AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = '-1'::integer) OR (old.omzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE omzone_undefined AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = 0) OR (old.omzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;

CREATE RULE presszone_conflict AS
    ON UPDATE TO presszone
   WHERE ((new.presszone_id = '-1'::integer) OR (old.presszone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE presszone_undefined AS
    ON UPDATE TO presszone
   WHERE ((new.presszone_id = 0) OR (old.presszone_id = 0)) DO INSTEAD NOTHING;
   
CREATE RULE dqa_conflict AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = '-1'::integer) OR (old.dqa_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dqa_undefined AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;

-- expl_id is not void
CREATE RULE dqa_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE RULE presszone_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE RULE dma_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE RULE omzone_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;