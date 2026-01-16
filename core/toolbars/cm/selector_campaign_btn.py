"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .campaign import Campaign
from ..dialog import GwAction


class GwSelectorCampaignButton(GwAction):
    """Button 84: Add new campaign"""

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.new_campaign = Campaign(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self):
        """Open the correct campaign dialog based on user selection"""
        self.new_campaign.open_campaign_selector()
