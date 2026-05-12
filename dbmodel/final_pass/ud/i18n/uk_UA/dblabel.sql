/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE sys_label AS t SET idval = v.idval FROM (
	VALUES
	(1001, 'ІНФО'),
    (1002, 'ПОПЕРЕДЖЕННЯ'),
    (1003, 'ПОМИЛКА'),
    (1004, 'КРИТИЧНІ ПОМИЛКИ'),
    (1005, 'ПІДКАЗКА'),
    (1006, 'ПОПЕРЕДЖЕННЯ-403'),
    (1007, 'ПОМИЛКА-403'),
    (1008, 'ПОМИЛКА-357'),
    (2000, ' '),
    (2007, '-------'),
    (2008, '--------'),
    (2009, '---------'),
    (2010, '----------'),
    (2011, '-----------'),
    (2014, '--------------'),
    (2022, '----------------------'),
    (2025, '-------------------------'),
    (2030, '------------------------------'),
    (2049, '-------------------------------------------------'),
    (3001, 'ІНФОРМАЦІЯ'),
    (3002, 'ПОПЕРЕДЖЕННЯ'),
    (3003, 'ПОМИЛКИ'),
    (3006, 'ДУГА РОЗДІЛ = TRUE'),
    (3008, 'ДУГА РОЗДІЛ = FALSE'),
    (3009, 'ПІДСУМОК'),
    (3010, 'ПЕРЕВІРИТИ СИСТЕМУ'),
    (3011, 'ПЕРЕВІРИТИ ДАНІ БД'),
    (3012, 'ДЕТАЛІ'),
    (3013, 'Щоб перевірити КРИТИЧНІ ПОМИЛКИ або ПОПЕРЕДЖЕННЯ, виконайте запит FROM anl_table WHERE fid=номер помилки AND current_user. Наприклад:  SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;  Тільки помилки з anl_table поруч із номером можна перевірити таким чином. Використовуючи Giswater Toolbox також можливо перевірити ці помилки.')
) AS v(id, idval)
WHERE t.id = v.id;

