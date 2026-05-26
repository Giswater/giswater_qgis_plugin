/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_fprocess AS t SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name FROM (
	VALUES
	(100, 'valor nul a la columna %check_column% de %table_name%.', 'Les %check_column% de %table_name% tenen valors correctes.', 'Comprovar la consistència nul·la'),
    (200, 'Hi ha alguns usuaris sense equip assignat.', 'Tots els usuaris tenen un equip assignat.', 'Comproveu la coherència dels usuaris'),
    (201, 'equips sense usuaris assignats.', 'Tots els equips tenen usuaris assignats.', 'Comprovar la coherència dels equips'),
    (202, 'Hi ha alguns nodes orfes.', 'No hi ha nodes orfes.', 'Comproveu els nodes orfes'),
    (203, 'nodes duplicats amb l''estat 1.', 'No hi ha nodes duplicats amb l''estat 1', 'Comproveu els nodes duplicats')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

