/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;


INSERT INTO selector_sector SELECT sector_id, current_user from sector where sector_id > 0 ON CONFLICT (sector_id, cur_user) DO NOTHING;
DELETE FROM selector_psector;

UPDATE cat_arc SET active=TRUE WHERE arctype_id='VARC' AND id='VIRTUAL';

UPDATE om_visit SET startdate = startdate -  random() * (startdate - timestamp '2022-01-01 10:00:00');
UPDATE om_visit SET enddate = startdate;

UPDATE arc SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE node SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE connec SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE link SET builtdate = c.builtdate FROM connec c WHERE feature_id = connec_id;
UPDATE element SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');

INSERT INTO om_waterbalance_dma_graph VALUES ('1080',1,-1);
INSERT INTO om_waterbalance_dma_graph VALUES ('1080',2,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('1097',4,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('1101',4,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('113766',1,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('113766',4,-1);

