/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_fprocess AS t SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name FROM (
	VALUES
	(100, 'Nullwert in der Spalte %check_column% von %table_name%.', 'Die %check_column% auf %table_name% haben korrekte Werte.', 'Nullen auf Konsistenz prüfen'),
    (200, 'Es gibt einige Benutzer, denen kein Team zugewiesen ist.', 'Allen Benutzern ist ein Team zugewiesen.', 'Konsistenz der Benutzer prüfen'),
    (201, 'Teams, denen keine Benutzer zugewiesen sind.', 'Allen Teams sind Benutzer zugewiesen.', 'Konsistenz der Teams prüfen'),
    (202, 'Es gibt einige verwaiste Knotenpunkte.', 'Es gibt keine verwaisten Knotenpunkte.', 'Verwaiste Knoten prüfen'),
    (203, 'Knoten mit Zustand 1 dupliziert.', 'Es gibt keine doppelten Knoten mit Zustand 1', 'Duplizierte Knoten prüfen')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

