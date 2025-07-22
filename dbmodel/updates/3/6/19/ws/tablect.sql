/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP RULE IF EXISTS dqa_conflict ON dqa;
DROP RULE IF EXISTS dqa_undefined ON dqa;
update dqa set macrodqa_id = 0 where macrodqa_id is null;
ALTER TABLE dqa alter column macrodqa_id set default 0;
CREATE RULE dqa_undefined AS ON UPDATE TO dqa WHERE((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;
CREATE RULE dqa_conflict AS ON UPDATE TO dqa WHERE((new.dqa_id = -1) OR (old.dqa_id = -1)) DO INSTEAD NOTHING;


ALTER TABLE om_waterbalance DROP CONSTRAINT om_waterbalance_pkey;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_pkey PRIMARY KEY (dma_id, startdate, enddate);

