/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP RULE IF EXISTS sector_conflict ON sector;
DROP RULE IF EXISTS sector_del_conflict ON sector;
DROP RULE IF EXISTS sector_del_undefined ON sector;
DROP RULE IF EXISTS sector_undefined ON sector;

DROP RULE IF EXISTS dma_undefined ON dma;
DROP RULE IF EXISTS dma_conflict ON dma;

DROP RULE IF EXISTS macrosector_del_undefined ON macrosector;   
DROP RULE IF EXISTS macrosector_undefined ON macrosector;

DROP RULE IF EXISTS macroexploitation_del_undefined ON macroexploitation;
DROP RULE IF EXISTS macroexploitation_undefined ON macroexploitation;

DROP RULE IF EXISTS exploitation_del_undefined ON exploitation;
DROP RULE IF EXISTS exploitation_undefined ON exploitation;
