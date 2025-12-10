/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_report AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(105, 'Nodos por explotación y tipo', NULL),
    (100, 'Longitud del tubo por explotación y catálogo', NULL),
    (101, 'Conexiones por explotación', NULL),
    (102, 'Pérdidas y NRW por explotación, Dma y periodo', NULL),
    (103, 'Pérdidas totales y RNW por explotación', NULL),
    (104, 'Pérdidas totales y NRW por Dma', NULL)
) AS v(id, alias, descript)
WHERE t.id = v.id;

