/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_typevalue AS t SET idval = v.idval, descript = v.descript FROM (
	VALUES
	('1', 'campaign_feature_status', 'PLANOWANE', NULL),
    ('2', 'campaign_feature_status', 'NIE ODWIEDZONO', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('4', 'campaign_feature_status', 'ODWIEDŹ PONOWNIE', NULL),
    ('5', 'campaign_feature_status', 'PRZYJĘTY', NULL),
    ('6', 'campaign_feature_status', 'ODWOŁANE', NULL),
    ('1', 'campaign_status', 'PLANOWANIE', NULL),
    ('10', 'campaign_status', 'ODWOŁANE', NULL),
    ('2', 'campaign_status', 'PLANOWANE', NULL),
    ('3', 'campaign_status', 'PRZYPISANY', NULL),
    ('4', 'campaign_status', 'NA BIEŻĄCO', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('7', 'campaign_status', 'ODRZUCONY', NULL),
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('9', 'campaign_status', 'PRZYJĘTY', NULL),
    ('1', 'campaign_type', 'PRZEGLĄD', NULL),
    ('2', 'campaign_type', 'WIZYTA', NULL),
    ('3', 'campaign_type', 'INWENTARYZACJA', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'PLANOWANE', NULL),
    ('2', 'lot_feature_status', 'NIE ODWIEDZONO', NULL),
    ('3', 'lot_feature_status', 'ODWIEDZONY', NULL),
    ('4', 'lot_feature_status', 'ODWIEDŹ PONOWNIE', NULL),
    ('5', 'lot_feature_status', 'PRZYJĘTY', NULL),
    ('6', 'lot_feature_status', 'ODWOŁANE', NULL),
    ('1', 'lot_status', 'PLANOWANIE', NULL),
    ('10', 'lot_status', 'ODWOŁANE', NULL),
    ('2', 'lot_status', 'PLANOWANE', NULL),
    ('3', 'lot_status', 'PRZYPISANY', NULL),
    ('4', 'lot_status', 'NA BIEŻĄCO', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'WYKONANE', NULL),
    ('7', 'lot_status', 'ODRZUCONY', NULL),
    ('8', 'lot_status', 'GOTOWY DO PRZYJĘCIA', NULL),
    ('9', 'lot_status', 'PRZYJĘTY', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

