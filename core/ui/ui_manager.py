"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import os
import webbrowser

from qgis.PyQt import uic, QtCore
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QMainWindow, QDialog, QDockWidget, QWhatsThis, QLineEdit


class GwDockWidget(QDockWidget):

    dlg_closed = QtCore.pyqtSignal()
    
    def __init__(self, subtag=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag


    def closeEvent(self, event):
        self.dlg_closed.emit()
        return super().closeEvent(event)


class GwDialog(QDialog):

    def __init__(self, subtag=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Enable event filter
        self.installEventFilter(self)


    def eventFilter(self, object, event):

        if event.type() == QtCore.QEvent.EnterWhatsThisMode and self.isActiveWindow():
            QWhatsThis.leaveWhatsThisMode()
            parser = configparser.ConfigParser()
            path = os.path.dirname(__file__) + os.sep + 'config' + os.sep + 'init.config'
            if not os.path.exists(path):
                print(f"File not found: {path}")
                webbrowser.open_new_tab('https://giswater.org/giswater-manual')
                return True

            parser.read(path)
            if self.subtag is not None:
                tag = f'{self.objectName()}_{self.subtag}'
            else:
                tag = str(self.objectName())

            try:
                web_tag = parser.get('web_tag', tag)
                webbrowser.open_new_tab(f'https://giswater.org/giswater-manual/#{web_tag}')
            except Exception:
                webbrowser.open_new_tab('https://giswater.org/giswater-manual')
            finally:
                return True

        return False


class GwMainWindow(QMainWindow):

    dlg_closed = QtCore.pyqtSignal()
    key_escape = QtCore.pyqtSignal()
    key_enter = QtCore.pyqtSignal()

    def __init__(self, subtag=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Enable event filter
        self.installEventFilter(self)


    def closeEvent(self, event):
        try:
            self.dlg_closed.emit()
            return super().closeEvent(event)
        except RuntimeError:
            # This exception jumps, for example, when closing the mincut dialog when it is in docker
            # RuntimeError: wrapped C/C++ object of type Mincut has been deleted
            pass


    def eventFilter(self, object, event):

        if event.type() == QtCore.QEvent.EnterWhatsThisMode and self.isActiveWindow():
            QWhatsThis.leaveWhatsThisMode()
            parser = configparser.ConfigParser()
            path = os.path.dirname(__file__) + os.sep + 'config' + os.sep + 'init.config'
            if not os.path.exists(path):
                print(f"File not found: {path}")
                webbrowser.open_new_tab('https://giswater.org/giswater-manual')
                return True

            parser.read(path)
            if self.subtag is not None:
                tag = f'{self.objectName()}_{self.subtag}'
            else:
                tag = str(self.objectName())
            try:
                web_tag = parser.get('web_tag', tag)
                webbrowser.open_new_tab(f'https://giswater.org/giswater-manual/#{web_tag}')
            except Exception:
                webbrowser.open_new_tab('https://giswater.org/giswater-manual')
            return True
        return False


    def keyPressEvent(self, event):
        if event.key() == QtCore.Qt.Key_Escape:
            self.key_escape.emit()
            return super().keyPressEvent(event)
        if event.key() == QtCore.Qt.Key_Return or event.key() == QtCore.Qt.Key_Enter:
            self.key_enter.emit()
            return super().keyPressEvent(event)


def get_ui_class(ui_file_name, subfolder='shared'):
    """ Get UI Python class from @ui_file_name """

    # Folder that contains UI files
    if subfolder in ('basic', 'edit', 'epa', 'om', 'plan', 'utilities', 'toc', 'custom'):
        ui_folder_path = os.path.dirname(__file__) + os.sep + 'toolbars' + os.sep + subfolder
    else:
        ui_folder_path = os.path.dirname(__file__) + os.sep + subfolder

    ui_file_path = os.path.abspath(os.path.join(ui_folder_path, ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


# region BASIC
FORM_CLASS = get_ui_class('info_crossect.ui', 'basic')
class InfoCrossectUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_feature.ui', 'basic')
class InfoFeatureUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('search.ui', 'basic')
class SearchUi(GwDockWidget, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('search_workcat.ui', 'basic')
class SearchWorkcat(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event_full.ui', 'basic')
class VisitEventFull(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_gallery.ui', 'basic')
class Gallery(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_gallery_zoom.ui', 'basic')
class GalleryZoom(GwDialog, FORM_CLASS):
    pass
# endregion


# region EDIT
FORM_CLASS = get_ui_class('arc_fusion.ui', 'edit')
class ArcFusionUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('auxcircle.ui', 'edit')
class AuxCircle(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('auxpoint.ui', 'edit')
class AuxPoint(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('dimensioning.ui', 'edit')
class DimensioningUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('doc.ui', 'edit')
class DocUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('doc_manager.ui', 'edit')
class DocManager(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('element.ui', 'edit')
class ElementUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('element_manager.ui', 'edit')
class ElementManager(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_delete.ui', 'edit')
class FeatureDelete(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_end.ui', 'edit')
class FeatureEndUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_end_connec.ui', 'edit')
class FeatureEndConnecUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('feature_replace.ui', 'edit')
class FeatureReplace(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('nodetype_change.ui', 'edit')
class NodeTypeChange(GwDialog, FORM_CLASS):
    pass
# end region


# region EPA
FORM_CLASS = get_ui_class('go2epa.ui', 'epa')
class Go2EpaUI(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('go2epa_selector.ui', 'epa')
class Go2EpaSelectorUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('go2epa_manager.ui', 'epa')
class EpaManager(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('go2epa_options.ui', 'epa')
class Go2EpaOptionsUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('hydrology_selector.ui', 'epa')
class HydrologySelector(GwDialog, FORM_CLASS):
    pass
# endregion


# region OM
FORM_CLASS = get_ui_class('mincut.ui', 'om')
class Mincut(GwMainWindow, FORM_CLASS):

    def __init__(self):
        self.closeMainWin = False
        self.mincutCanceled = True
        super().__init__()

FORM_CLASS = get_ui_class('mincut_connec.ui', 'om')
class MincutConnec(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_hydrometer.ui', 'om')
class MincutHydrometer(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_composer.ui', 'om')
class MincutComposer(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_manager.ui', 'om')
class MincutManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('mincut_end.ui', 'om')
class MincutEndUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('profile.ui', 'om')
class Profile(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('profile_list.ui', 'om')
class ProfilesList(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('selector_date.ui', 'om')
class SelectorDate(GwDialog, FORM_CLASS):
    pass
# endregion


# region PLAN
FORM_CLASS = get_ui_class('plan_psector.ui', 'plan')
class PlanPsector(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('price_manager.ui', 'plan')
class PriceManagerUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('psector_duplicate.ui', 'plan')
class PsectorDuplicate(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('psector_manager.ui', 'plan')
class PsectorManagerUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('psector_rapport.ui', 'plan')
class PsectorRapportUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region UTILITIES
FORM_CLASS = get_ui_class('config.ui', 'utilities')
class ConfigUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('csv2pg.ui', 'utilities')
class Csv2pgUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('fastprint.ui', 'utilities')
class FastPrintUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_addfields.ui', 'utilities')
class MainFields(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_credentials.ui', 'utilities')
class Credentials(GwDialog, FORM_CLASS):

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

FORM_CLASS = get_ui_class('main_dbproject.ui', 'utilities')
class MainDbProjectUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_gisproject.ui', 'utilities')
class MainGisProjectUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_importinp.ui', 'utilities')
class MainImportUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_projectinfo.ui', 'utilities')
class MainProjectInfoUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_renameproj.ui', 'utilities')
class MainRenameProjUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_sysfields.ui', 'utilities')
class MainSysFields(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_ui.ui', 'utilities')
class MainUi(GwMainWindow, FORM_CLASS):
    dlg_closed = QtCore.pyqtSignal()

FORM_CLASS = get_ui_class('main_visitclass.ui', 'utilities')
class MainVisitClass(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_visitparam.ui', 'utilities')
class MainVisitParam(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('toolbox_docker.ui', 'utilities')
class ToolboxDockerUi(GwDockWidget, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('toolbox.ui', 'utilities')
class ToolboxUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('project_check.ui', 'utilities')
class ProjectCheckUi(GwDialog, FORM_CLASS):
    pass
# endregion


# region TOC
# endregion


# region CUSTOM
# endregion


# region SHARED
FORM_CLASS = get_ui_class('dialog_text.ui')
class DialogTextUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('docker.ui')
class DockerUi(GwDockWidget, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_catalog.ui')
class InfoCatalogUi(GwMainWindow, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_generic.ui')
class InfoGenericUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_workcat.ui')
class InfoWorkcatUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('main_qtdialog.ui')
class MainQtDialogUi(GwDialog, FORM_CLASS):

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

FORM_CLASS = get_ui_class('multirow_selector.ui')
class MultirowSelector(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('selector.ui')
class SelectorUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit.ui')
class VisitUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_document.ui')
class VisitDocument(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event_rehab.ui')
class VisitEventRehab(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_event.ui')
class VisitEvent(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('visit_manager.ui')
class VisitManagerUi(GwDialog, FORM_CLASS):
    pass
# endregion
