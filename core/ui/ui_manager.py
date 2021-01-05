"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt import uic, QtCore
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QLineEdit

from .basic_dialog import GwBasicDialog
from .docker_dialog import GwDockerDialog
from .main_window_dialog import GwMainWindowDialog


def get_ui_class(ui_file_name, subfolder='shared'):
    """ Get UI Python class from @ui_file_name """

    # Folder that contains UI files
    if subfolder in ('basic', 'edit', 'epa', 'om', 'plan', 'utilities', 'toc'):
        ui_folder_path = os.path.dirname(__file__) + os.sep + 'toolbars' + os.sep + subfolder
    else:
        ui_folder_path = os.path.dirname(__file__) + os.sep + subfolder

    ui_file_path = os.path.abspath(os.path.join(ui_folder_path, ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


# region BASIC
FORM_CLASS = get_ui_class('info_crossect.ui', 'basic')
class InfoCrossectUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_feature.ui', 'basic')
class InfoFeatureUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('search.ui', 'basic')
class SearchUi(GwDockerDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('search_workcat.ui', 'basic')
class SearchWorkcatUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion


# region OM
FORM_CLASS = get_ui_class('visit_event_full.ui')
class VisitEventFullUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_gallery.ui')
class GalleryUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_gallery_zoom.ui')
class GalleryZoomUi(GwBasicDialog, FORM_CLASS):
    pass
	
FORM_CLASS = get_ui_class('mincut.ui', 'om')
class MincutUi(GwMainWindowDialog, FORM_CLASS):

    def __init__(self):
        self.closeMainWin = False
        self.mincutCanceled = True
        super().__init__()

FORM_CLASS = get_ui_class('mincut_connec.ui', 'om')
class MincutConnecUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_hydrometer.ui', 'om')
class MincutHydrometerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_composer.ui', 'om')
class MincutComposerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_manager.ui', 'om')
class MincutManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_end.ui', 'om')
class MincutEndUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('profile.ui', 'om')
class ProfileUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('profile_list.ui', 'om')
class ProfilesListUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('selector_date.ui', 'om')
class SelectorDateUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion


# region EDIT
FORM_CLASS = get_ui_class('arc_fusion.ui', 'edit')
class ArcFusionUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('auxcircle.ui', 'edit')
class AuxCircleUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('auxpoint.ui', 'edit')
class AuxPointUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('dimensioning.ui', 'edit')
class DimensioningUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('doc.ui', 'edit')
class DocUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('doc_manager.ui', 'edit')
class DocManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('element.ui', 'edit')
class ElementUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('element_manager.ui', 'edit')
class ElementManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_delete.ui', 'edit')
class FeatureDeleteUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_end.ui', 'edit')
class FeatureEndUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_end_connec.ui', 'edit')
class FeatureEndConnecUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_replace.ui', 'edit')
class FeatureReplaceUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('nodetype_change.ui', 'edit')
class NodeTypeChangeUi(GwBasicDialog, FORM_CLASS):
    pass
# end region


# region EPA
FORM_CLASS = get_ui_class('go2epa.ui', 'epa')
class Go2EpaUI(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('go2epa_selector.ui', 'epa')
class Go2EpaSelectorUi(GwBasicDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('go2epa_manager.ui', 'epa')
class EpaManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('go2epa_options.ui', 'epa')
class Go2EpaOptionsUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('hydrology_selector.ui', 'epa')
class HydrologySelectorUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion



# region PLAN
FORM_CLASS = get_ui_class('plan_psector.ui', 'plan')
class PlanPsectorUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('price_manager.ui', 'plan')
class PriceManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('psector_duplicate.ui', 'plan')
class PsectorDuplicateUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('psector_manager.ui', 'plan')
class PsectorManagerUi(GwBasicDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('psector_rapport.ui', 'plan')
class PsectorRapportUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion


# region UTILITIES
FORM_CLASS = get_ui_class('config.ui', 'utilities')
class ConfigUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('csv2pg.ui', 'utilities')
class Csv2pgUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('fastprint.ui', 'utilities')
class FastPrintUi(GwBasicDialog, FORM_CLASS):
    pass
	

# region TOC
# endregion


# region ADMIN
FORM_CLASS = get_ui_class('admin_addfields.ui', 'admin')
class MainFieldsUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_credentials.ui', 'admin')
class CredentialsUi(GwBasicDialog, FORM_CLASS):

    def __init__(self):

        super().__init__()
        self.txt_pass.setClearButtonEnabled(True)
        icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialog' + os.sep + '20x20'+ os.sep +'eye_open.png'
        self.action = QAction("show")
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "show")
        self.action.triggered.connect(self.show_pass)
        self.txt_pass.addAction(self.action, QLineEdit.TrailingPosition)


    def show_pass(self):

        icon_path = ""
        text = ""
        if self.txt_pass.echoMode() == 0:
            self.txt_pass.setEchoMode(QLineEdit.Password)
            icon_path = os.path.dirname(
                __file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20'+ os.sep + 'eye_open.png'
            text = "Show password"
        elif self.txt_pass.echoMode() == 2:
            self.txt_pass.setEchoMode(QLineEdit.Normal)
            icon_path = os.path.dirname(
                __file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20'+ os.sep + 'eye_close.png'
            text = "Hide password"
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action.setIcon(icon)
            self.action.setText(text)

FORM_CLASS = get_ui_class('admin_dbproject.ui', 'admin')
class MainDbProjectUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_gisproject.ui', 'admin')
class MainGisProjectUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_importinp.ui', 'admin')
class MainImportUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_projectinfo.ui', 'admin')
class MainProjectInfoUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_renameproj.ui', 'admin')
class MainRenameProjUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_sysfields.ui', 'admin')
class MainSysFieldsUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_ui.ui', 'admin')
class MainUi(GwMainWindowDialog, FORM_CLASS):
    dlg_closed = QtCore.pyqtSignal()

FORM_CLASS = get_ui_class('admin_visitclass.ui', 'admin')
class MainVisitClassUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_visitparam.ui', 'admin')
class MainVisitParamUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('toolbox_docker.ui', 'utilities')
class ToolboxDockerUi(GwDockerDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('toolbox.ui', 'utilities')
class ToolboxUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('project_check.ui', 'utilities')
class ProjectCheckUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion



# region SHARED
FORM_CLASS = get_ui_class('dialog_text.ui')
class DialogTextUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('docker.ui')
class DockerUi(GwDockerDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_catalog.ui')
class InfoCatalogUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_generic.ui')
class InfoGenericUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_workcat.ui')
class InfoWorkcatUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_translation.ui', 'admin')
class MainQtDialogUi(GwBasicDialog, FORM_CLASS):

    def __init__(self):

        super().__init__()
        self.txt_pass.setClearButtonEnabled(True)
        icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20'+ os.sep + 'eye_open.png'
        self.action = QAction("show")
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "show")
        self.action.triggered.connect(self.show_pass)
        self.txt_pass.addAction(self.action, QLineEdit.TrailingPosition)


    def show_pass(self):

        icon_path = ""
        text = ""
        if self.txt_pass.echoMode() == 0:
            self.txt_pass.setEchoMode(QLineEdit.Password)
            icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20'+ os.sep + 'eye_open.png'
            text = "Show password"
        elif self.txt_pass.echoMode() == 2:
            self.txt_pass.setEchoMode(QLineEdit.Normal)
            icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep + 'eye_close.png'
            text = "Hide password"
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action.setIcon(icon)
            self.action.setText(text)

FORM_CLASS = get_ui_class('selector_multirow.ui')
class MultirowSelectorUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('selector.ui')
class SelectorUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit.ui')
class VisitUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_document.ui')
class VisitDocumentUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event_rehab.ui')
class VisitEventRehabUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event.ui')
class VisitEventUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_manager.ui')
class VisitManagerUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion
