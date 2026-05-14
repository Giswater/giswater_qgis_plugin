/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_fprocess AS t SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name FROM (
	VALUES
	(100, 'wartość null w kolumnie %check_column% w %table_name%.', 'Kolumna %check_column% w %table_name% ma prawidłowe wartości.', 'Sprawdź spójność zer'),
    (200, 'Niektórzy użytkownicy nie mają przypisanego zespołu.', 'Wszyscy użytkownicy mają przypisany zespół.', 'Sprawdź spójność użytkowników'),
    (201, 'zespołów bez przypisanych użytkowników.', 'Wszystkie zespoły mają przypisanych użytkowników.', 'Sprawdź spójność zespołów'),
    (202, 'Istnieje kilka osieroconych węzłów.', 'Nie ma osieroconych węzłów.', 'Sprawdź osierocone węzły'),
    (203, 'węzłów zduplikowanych ze stanem 1.', 'Nie ma zduplikowanych węzłów ze stanem 1', 'Sprawdź zduplikowane węzły')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

