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

from .dialog import GwDialog
from .docker import GwDocker
from .main_window import GwMainWindow

# region private functions

def _get_ui_class(ui_file_name, subfolder='shared'):
    """ Get UI Python class from @ui_file_name """

    # Folder that contains UI files
    if subfolder in ('basic', 'edit', 'epa', 'om', 'plan', 'utilities', 'toc'):
        ui_folder_path = os.path.dirname(__file__) + os.sep + 'toolbars' + os.sep + subfolder
    else:
        ui_folder_path = os.path.dirname(__file__) + os.sep + subfolder

    ui_file_path = os.path.abspath(os.path.join(ui_folder_path, ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


# endregion

# region BASIC
FORM_CLASS = _get_ui_class('info_crossect.ui', 'basic')
class GwInfoCrossectUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('info_feature.ui', 'basic')
class GwInfoFeatureUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('search.ui', 'basic')
class GwSearchUi(GwDocker, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('search_workcat.ui', 'basic')
class GwSearchWorkcatUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region OM
FORM_CLASS = _get_ui_class('visit_event_full.ui')
class GwVisitEventFullUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit_gallery.ui')
class GwGalleryUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit_gallery_zoom.ui')
class GwGalleryZoomUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('mincut.ui', 'om')
class GwMincutUi(GwMainWindow, FORM_CLASS):

    def __init__(self):
        self.closeMainWin = False
        self.mincutCanceled = True
        super().__init__()

FORM_CLASS = _get_ui_class('mincut_connec.ui', 'om')
class GwMincutConnecUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('mincut_hydrometer.ui', 'om')
class GwMincutHydrometerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('mincut_composer.ui', 'om')
class GwMincutComposerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('mincut_manager.ui', 'om')
class GwMincutManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('mincut_end.ui', 'om')
class GwMincutEndUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('profile.ui', 'om')
class GwProfileUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('profile_list.ui', 'om')
class GwProfilesListUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('selector_date.ui', 'om')
class GwSelectorDateUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region EDIT
FORM_CLASS = _get_ui_class('arc_fusion.ui', 'edit')
class GwArcFusionUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('auxcircle.ui', 'edit')
class GwAuxCircleUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('auxpoint.ui', 'edit')
class GwAuxPointUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('dimensioning.ui', 'edit')
class GwDimensioningUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('doc.ui', 'edit')
class GwDocUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('doc_manager.ui', 'edit')
class GwDocManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('element.ui', 'edit')
class GwElementUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('element_manager.ui', 'edit')
class GwElementManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('feature_delete.ui', 'edit')
class GwFeatureDeleteUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('feature_end.ui', 'edit')
class GwFeatureEndUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('feature_end_connec.ui', 'edit')
class GwFeatureEndConnecUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('feature_replace.ui', 'edit')
class GwFeatureReplaceUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('featuretype_change.ui', 'edit')
class GwFeatureTypeChangeUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region EPA
FORM_CLASS = _get_ui_class('go2epa.ui', 'epa')
class GwGo2EpaUI(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('go2epa_selector.ui', 'epa')
class GwGo2EpaSelectorUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('go2epa_manager.ui', 'epa')
class GwEpaManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('go2epa_options.ui', 'epa')
class GwGo2EpaOptionsUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('hydrology_selector.ui', 'epa')
class GwHydrologySelectorUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region PLAN
FORM_CLASS = _get_ui_class('psector.ui', 'plan')
class GwPsectorUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('price_manager.ui', 'plan')
class GwPriceManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('psector_duplicate.ui', 'plan')
class GwPsectorDuplicateUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('psector_manager.ui', 'plan')
class GwPsectorManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('psector_rapport.ui', 'plan')
class GwPsectorRapportUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('replace_arc.ui', 'plan')
class GwReplaceArc(GwDialog, FORM_CLASS):
    pass

# endregion


# region UTILITIES
FORM_CLASS = _get_ui_class('config.ui', 'utilities')
class GwConfigUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('csv.ui', 'utilities')
class GwCsvUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('print.ui', 'utilities')
class GwPrintUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('toolbox_reports.ui', 'utilities')
class GwToolboxReportsUi(GwDialog, FORM_CLASS):
    pass
# endregion

# region TOC
# endregion


# region ADMIN
FORM_CLASS = _get_ui_class('admin_addfields.ui', 'admin')
class GwAdminFieldsUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_credentials.ui', 'admin')
class GwCredentialsUi(GwDialog, FORM_CLASS):

    def __init__(self):

        super().__init__()
        self.txt_pass.setClearButtonEnabled(True)
        icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialog' + os.sep + '20x20' + os.sep + 'eye_open.png'
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
                __file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep + 'eye_open.png'
            text = "Show password"
        elif self.txt_pass.echoMode() == 2:
            self.txt_pass.setEchoMode(QLineEdit.Normal)
            icon_path = os.path.dirname(
                __file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep + 'eye_close.png'
            text = "Hide password"
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action.setIcon(icon)
            self.action.setText(text)

FORM_CLASS = _get_ui_class('admin_dbproject.ui', 'admin')
class GwAdminDbProjectUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_gisproject.ui', 'admin')
class GwAdminGisProjectUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_importinp.ui', 'admin')
class GwAdminImportUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_projectinfo.ui', 'admin')
class GwAdminProjectInfoUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_renameproj.ui', 'admin')
class GwAdminRenameProjUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_sysfields.ui', 'admin')
class GwAdminSysFieldsUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_ui.ui', 'admin')
class GwAdminUi(GwMainWindow, FORM_CLASS):
    dlg_closed = QtCore.pyqtSignal()

FORM_CLASS = _get_ui_class('admin_visitclass.ui', 'admin')
class GwAdminVisitClassUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_visitparam.ui', 'admin')
class GwAdminVisitParamUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('toolbox.ui', 'utilities')
class GwToolboxUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('toolbox_tool.ui', 'utilities')
class GwToolboxManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('project_check.ui', 'utilities')
class GwProjectCheckUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region Menu
FORM_CLASS = _get_ui_class('load_menu.ui', 'menu')
class GwLoadMenuUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region SHARED
FORM_CLASS = _get_ui_class('dialog_text.ui')
class GwDialogTextUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('info_catalog.ui')
class GwInfoCatalogUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('info_generic.ui')
class GwInfoGenericUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('info_workcat.ui')
class GwInfoWorkcatUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('admin_translation.ui', 'admin')
class GwAdminTranslationUi(GwDialog, FORM_CLASS):

    def __init__(self):

        super().__init__()
        self.txt_pass.setClearButtonEnabled(True)
        icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep + 'eye_open.png'
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
            icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep + 'eye_open.png'
            text = "Show password"
        elif self.txt_pass.echoMode() == 2:
            self.txt_pass.setEchoMode(QLineEdit.Normal)
            icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep + 'eye_close.png'
            text = "Hide password"
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action.setIcon(icon)
            self.action.setText(text)

FORM_CLASS = _get_ui_class('selector_multirow.ui')
class GwMultirowSelectorUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('selector.ui')
class GwSelectorUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit.ui')
class GwVisitUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit_document.ui')
class GwVisitDocumentUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit_event_rehab.ui')
class GwVisitEventRehabUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit_event.ui')
class GwVisitEventUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('visit_manager.ui')
class GwVisitManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = _get_ui_class('interpolate.ui')
class GwInterpolate(GwDialog, FORM_CLASS):
    pass

# endregion
