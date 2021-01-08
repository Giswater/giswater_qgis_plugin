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
class GwInfoCrossectUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_feature.ui', 'basic')
class GwInfoFeatureUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('search.ui', 'basic')
class GwSearchUi(GwDockerDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('search_workcat.ui', 'basic')
class GwSearchWorkcatUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion


# region OM
FORM_CLASS = get_ui_class('visit_event_full.ui')
class GwVisitEventFullUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_gallery.ui')
class GwGalleryUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_gallery_zoom.ui')
class GwGalleryZoomUi(GwBasicDialog, FORM_CLASS):
    pass
	
FORM_CLASS = get_ui_class('mincut.ui', 'om')
class GwMincutUi(GwMainWindowDialog, FORM_CLASS):

    def __init__(self):
        self.closeMainWin = False
        self.mincutCanceled = True
        super().__init__()

FORM_CLASS = get_ui_class('mincut_connec.ui', 'om')
class GwMincutConnecUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_hydrometer.ui', 'om')
class GwMincutHydrometerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_composer.ui', 'om')
class GwMincutComposerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_manager.ui', 'om')
class GwMincutManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_end.ui', 'om')
class GwMincutEndUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('profile.ui', 'om')
class GwProfileUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('profile_list.ui', 'om')
class GwProfilesListUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('selector_date.ui', 'om')
class GwSelectorDateUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion


# region EDIT
FORM_CLASS = get_ui_class('arc_fusion.ui', 'edit')
class GwArcFusionUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('auxcircle.ui', 'edit')
class GwAuxCircleUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('auxpoint.ui', 'edit')
class GwAuxPointUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('dimensioning.ui', 'edit')
class GwDimensioningUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('doc.ui', 'edit')
class GwDocUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('doc_manager.ui', 'edit')
class GwDocManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('element.ui', 'edit')
class GwElementUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('element_manager.ui', 'edit')
class GwElementManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_delete.ui', 'edit')
class GwFeatureDeleteUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_end.ui', 'edit')
class GwFeatureEndUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_end_connec.ui', 'edit')
class GwFeatureEndConnecUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_replace.ui', 'edit')
class GwFeatureReplaceUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('nodetype_change.ui', 'edit')
class GwNodeTypeChangeUi(GwBasicDialog, FORM_CLASS):
    pass
# end region


# region EPA
FORM_CLASS = get_ui_class('go2epa.ui', 'epa')
class GwGo2EpaUI(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('go2epa_selector.ui', 'epa')
class GwGo2EpaSelectorUi(GwBasicDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('go2epa_manager.ui', 'epa')
class GwEpaManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('go2epa_options.ui', 'epa')
class GwGo2EpaOptionsUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('hydrology_selector.ui', 'epa')
class GwHydrologySelectorUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion



# region PLAN
FORM_CLASS = get_ui_class('psector.ui', 'plan')
class GwPsectorUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('price_manager.ui', 'plan')
class GwPriceManagerUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('psector_duplicate.ui', 'plan')
class GwPsectorDuplicateUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('psector_manager.ui', 'plan')
class GwPsectorManagerUi(GwBasicDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('psector_rapport.ui', 'plan')
class GwPsectorRapportUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion


# region UTILITIES
FORM_CLASS = get_ui_class('config.ui', 'utilities')
class GwConfigUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('csv.ui', 'utilities')
class GwCsvUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('print.ui', 'utilities')
class GwPrintUi(GwBasicDialog, FORM_CLASS):
    pass
	

# region TOC
# endregion


# region ADMIN
FORM_CLASS = get_ui_class('admin_addfields.ui', 'admin')
class GwAdminFieldsUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_credentials.ui', 'admin')
class GwCredentialsUi(GwBasicDialog, FORM_CLASS):

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
class GwAdminDbProjectUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_gisproject.ui', 'admin')
class GwAdminGisProjectUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_importinp.ui', 'admin')
class GwAdminImportUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_projectinfo.ui', 'admin')
class GwAdminProjectInfoUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_renameproj.ui', 'admin')
class GwAdminRenameProjUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_sysfields.ui', 'admin')
class GwAdminSysFieldsUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_ui.ui', 'admin')
class GwAdminUi(GwMainWindowDialog, FORM_CLASS):
    dlg_closed = QtCore.pyqtSignal()

FORM_CLASS = get_ui_class('admin_visitclass.ui', 'admin')
class GwAdminVisitClassUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_visitparam.ui', 'admin')
class GwAdminVisitParamUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('toolbox_docker.ui', 'utilities')
class GwToolboxDockerUi(GwDockerDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('toolbox.ui', 'utilities')
class GwToolboxUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('project_check.ui', 'utilities')
class GwProjectCheckUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion



# region SHARED
FORM_CLASS = get_ui_class('dialog_text.ui')
class GwDialogTextUi(GwBasicDialog, FORM_CLASS):
    pass

# FORM_CLASS = get_ui_class('docker.ui')
# class GwDockerUi(GwDockerDialog, FORM_CLASS):
#     pass

FORM_CLASS = get_ui_class('info_catalog.ui')
class GwInfoCatalogUi(GwMainWindowDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_generic.ui')
class GwInfoGenericUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_workcat.ui')
class GwInfoWorkcatUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('admin_translation.ui', 'admin')
class GwAdminTranslationUi(GwBasicDialog, FORM_CLASS):

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
class GwMultirowSelectorUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('selector.ui')
class GwSelectorUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit.ui')
class GwVisitUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_document.ui')
class GwVisitDocumentUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event_rehab.ui')
class GwVisitEventRehabUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event.ui')
class GwVisitEventUi(GwBasicDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_manager.ui')
class GwVisitManagerUi(GwBasicDialog, FORM_CLASS):
    pass
# endregion
