/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_report AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(105, 'Вузли за експлуатацією та типом', NULL),
    (100, 'Довжина труби за Експлуатацією та Каталогом', NULL),
    (101, 'Підключення за Експлуатацією', NULL),
    (102, 'Втрати & NRW за Експлуатацією, Dma & Період', NULL),
    (103, 'Загальні Втрати & NRW за Експлуатацією', NULL),
    (104, 'Загальні Втрати & NRW за Dma', NULL)
) AS v(id, alias, descript)
WHERE t.id = v.id;

