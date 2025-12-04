/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_report AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(105, 'Nodes per explotació i tipus', NULL),
    (100, 'Longitud de canonada per Explotació i Catàleg', NULL),
    (101, 'Connexió per explotació', NULL),
    (102, 'Pèrdues i NRW per explotació, Dma i període', NULL),
    (103, 'Pèrdues totals i NRW per explotació', NULL),
    (104, 'Pèrdues totals i NRW per Dma', NULL)
) AS v(id, alias, descript)
WHERE t.id = v.id;

