/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_report AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(105, 'Nodes per explotació i tipus', NULL),
    (100, 'Canonada longitud per Explotació i Catàleg', NULL),
    (101, 'Connexions per Explotació', NULL),
    (102, 'Pèrdues & NRW per Explotació, Dma & Període', NULL),
    (103, 'Total Pèrdues & NRW per Explotació', NULL),
    (104, 'Total Pèrdues & NRW per Dma', NULL)
) AS v(id, alias, descript)
WHERE t.id = v.id;

