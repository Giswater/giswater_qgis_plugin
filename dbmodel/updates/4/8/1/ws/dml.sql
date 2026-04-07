/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 04/04/2026
INSERT INTO inp_family (family_id,descript,age) VALUES
	('PRV','Pressure Reducing Valve',10),
	('PBV','Pressure Breaker Valve',10),
	('GPV','General Purpose Valve',10),
	('FCV','Flow Control Valve',10),
	('TCV','Throttle Control Valve',10),
	('PSV','Pressure Sustaining Valve',10),
	('PUMP','Head pump (buster)',10),
	('RESERVOIR','Reservoir',10),
	('TANK','Tank',10),
	('JUNCTION','Junction',10);

-- 07/04/2026
UPDATE config_toolbox
SET active = FALSE
WHERE id = 3560;

UPDATE inp_typevalue
SET typevalue = '_inp_typevalue_dscenario'
WHERE typevalue = 'inp_typevalue_dscenario' AND id = 'LOSSES';
