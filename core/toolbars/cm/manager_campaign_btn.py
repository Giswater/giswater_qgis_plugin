"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .campaign import Campaign
from ..dialog import GwAction


class GwManageCampaignButton(GwAction):
    """ Button 87: Campaign Management """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.campaign_manager = Campaign(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self):
        """ Open the campaign manager """
        self.campaign_manager.campaign_manager()
