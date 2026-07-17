/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- include start in the message
UPDATE sys_message
SET error_message='There are no arcs without start/final nodes.'
WHERE id=3582;

UPDATE sys_message
SET error_message='There are %v_count_state1% arcs with state 1 without start/final nodes.'
WHERE id=3586;

UPDATE sys_message
SET error_message='There are %v_count_state2% arcs with state 2 without start/final nodes.'
WHERE id=3588;

DO $$ 

DECLARE
rec record;

BEGIN

    FOR rec IN SELECT lower(id) as id FROM sys_feature_type --arc/node/connec/link/etc
    LOOP


    END LOOP;

END $$;
ALTER TABLE arc ADD COLUMN IF NOT EXISTS dataquality INTEGER;
ALTER TABLE arc ADD COLUMN IF NOT EXISTS dataquality_obs _int4 DEFAULT ARRAY[0];

ALTER TABLE node ADD COLUMN IF NOT EXISTS dataquality INTEGER;
ALTER TABLE node ADD COLUMN IF NOT EXISTS dataquality_obs _int4 DEFAULT ARRAY[0];

ALTER TABLE connec ADD COLUMN IF NOT EXISTS dataquality INTEGER;
ALTER TABLE connec ADD COLUMN IF NOT EXISTS dataquality_obs _int4 DEFAULT ARRAY[0];

ALTER TABLE link ADD COLUMN IF NOT EXISTS dataquality INTEGER;
ALTER TABLE link ADD COLUMN IF NOT EXISTS dataquality_obs _int4 DEFAULT ARRAY[0];

ALTER TABLE element ADD COLUMN IF NOT EXISTS dataquality INTEGER;
ALTER TABLE element ADD COLUMN IF NOT EXISTS dataquality_obs _int4 DEFAULT ARRAY[0];

ALTER TABLE man_valve ADD COLUMN turns_count numeric(12, 4);
