/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP RULE IF EXISTS presszone_conflict ON presszone;
DROP RULE IF EXISTS presszone_del_uconflict ON presszone;
DROP RULE IF EXISTS presszone_del_undefined ON presszone;
DROP RULE IF EXISTS presszone_undefined ON presszone;

DROP RULE IF EXISTS dma_del_conflict ON dma;
DROP RULE IF EXISTS dma_del_undefined ON dma;

DROP RULE IF EXISTS macrodma_del_undefined ON macrodma;
DROP RULE IF EXISTS macrodma_undefined ON macrodma;

DROP RULE IF EXISTS dqa_conflict ON dqa;
DROP RULE IF EXISTS dqa_del_conflict ON dqa;
DROP RULE IF EXISTS dqa_del_undefined ON dqa;
DROP RULE IF EXISTS dqa_undefined ON dqa;

DROP RULE IF EXISTS macrodqa_del_undefined ON macrodqa;
DROP RULE IF EXISTS macrodqa_undefined ON macrodqa;     

DROP RULE IF EXISTS supplyzone_conflict ON supplyzone;
DROP RULE IF EXISTS supplyzone_del_conflict ON supplyzone;
DROP RULE IF EXISTS supplyzone_del_undefined ON supplyzone;
DROP RULE IF EXISTS supplyzone_undefined ON supplyzone;     

ALTER TABLE inp_dscenario_frvalve DROP CONSTRAINT IF EXISTS inp_dscenario_frvalve_check_status;
