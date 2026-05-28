/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_typevalue AS t SET idval = v.idval, descript = v.descript FROM (
	VALUES
	('1', 'campaign_feature_status', 'GEPLANT', NULL),
    ('2', 'campaign_feature_status', 'NICHT BESUCHT', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('4', 'campaign_feature_status', 'WIEDERBESUCHEN', NULL),
    ('5', 'campaign_feature_status', 'AKZEPTIERT', NULL),
    ('6', 'campaign_feature_status', 'ANGESAGT', NULL),
    ('1', 'campaign_status', 'PLANUNG', NULL),
    ('10', 'campaign_status', 'ANGESAGT', NULL),
    ('2', 'campaign_status', 'GEPLANT', NULL),
    ('3', 'campaign_status', 'ZUGEORDNET', NULL),
    ('4', 'campaign_status', 'IM GANG', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('7', 'campaign_status', 'ABGELEHNT', NULL),
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('9', 'campaign_status', 'AKZEPTIERT', NULL),
    ('1', 'campaign_type', 'REVIEW', NULL),
    ('2', 'campaign_type', 'BESUCHE', NULL),
    ('3', 'campaign_type', 'INVENTUR', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'GEPLANT', NULL),
    ('2', 'lot_feature_status', 'NICHT BESUCHT', NULL),
    ('3', 'lot_feature_status', 'BESUCHT', NULL),
    ('4', 'lot_feature_status', 'WIEDERBESUCHEN', NULL),
    ('5', 'lot_feature_status', 'AKZEPTIERT', NULL),
    ('6', 'lot_feature_status', 'ANGESAGT', NULL),
    ('1', 'lot_status', 'PLANUNG', NULL),
    ('10', 'lot_status', 'ANGESAGT', NULL),
    ('2', 'lot_status', 'GEPLANT', NULL),
    ('3', 'lot_status', 'ZUGEORDNET', NULL),
    ('4', 'lot_status', 'IM GANG', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'EXECUTED (OPERATIV setzen und Trace speichern)', NULL),
    ('7', 'lot_status', 'ABGELEHNT', NULL),
    ('8', 'lot_status', 'ABNAHMEBEREIT', NULL),
    ('9', 'lot_status', 'AKZEPTIERT', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

