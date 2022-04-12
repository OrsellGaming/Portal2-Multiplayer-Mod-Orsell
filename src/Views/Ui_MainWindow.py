# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'src\Views\MainWindow.ui'
#
# Created by: PyQt5 UI code generator 5.15.6
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(795, 524)
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("src\\Views\\Resources/Images/MainWindowIcon.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        MainWindow.setWindowIcon(icon)
        MainWindow.setStyleSheet("font: 63 20pt \"Quicksand SemiBold\";\n"
"color: rgb(104, 150, 137);\n"
"background-color: rgb(11, 60, 73);")
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.Button_Play = QtWidgets.QPushButton(self.centralwidget)
        self.Button_Play.setGeometry(QtCore.QRect(10, 390, 141, 51))
        self.Button_Play.setStyleSheet("color: rgb(19, 231, 69);\n"
"font: 600 30pt \"Quicksand\";")
        self.Button_Play.setFlat(True)
        self.Button_Play.setObjectName("Button_Play")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setEnabled(True)
        self.label.setGeometry(QtCore.QRect(0, 20, 100, 100))
        self.label.setText("")
        self.label.setPixmap(QtGui.QPixmap("src\\Views\\Resources/Images/logo.svg"))
        self.label.setScaledContents(True)
        self.label.setObjectName("label")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(10, 140, 121, 21))
        self.label_2.setObjectName("label_2")
        self.Button_CopyIP = QtWidgets.QPushButton(self.centralwidget)
        self.Button_CopyIP.setGeometry(QtCore.QRect(120, 130, 211, 41))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.Button_CopyIP.sizePolicy().hasHeightForWidth())
        self.Button_CopyIP.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(20)
        font.setBold(False)
        font.setItalic(False)
        font.setUnderline(True)
        font.setKerning(True)
        self.Button_CopyIP.setFont(font)
        self.Button_CopyIP.setToolTip("")
        self.Button_CopyIP.setLayoutDirection(QtCore.Qt.RightToLeft)
        self.Button_CopyIP.setAutoFillBackground(False)
        self.Button_CopyIP.setStyleSheet("\n"
"text-decoration: underline;")
        icon1 = QtGui.QIcon()
        icon1.addPixmap(QtGui.QPixmap("src\\Views\\Resources/Images/copy-icon.svg"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.Button_CopyIP.setIcon(icon1)
        self.Button_CopyIP.setCheckable(False)
        self.Button_CopyIP.setFlat(True)
        self.Button_CopyIP.setObjectName("Button_CopyIP")
        self.label_3 = QtWidgets.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(10, 180, 231, 31))
        self.label_3.setObjectName("label_3")
        self.Button_DeveloperMode = QtWidgets.QCheckBox(self.centralwidget)
        self.Button_DeveloperMode.setGeometry(QtCore.QRect(230, 180, 21, 31))
        self.Button_DeveloperMode.setLayoutDirection(QtCore.Qt.RightToLeft)
        self.Button_DeveloperMode.setText("")
        self.Button_DeveloperMode.setTristate(False)
        self.Button_DeveloperMode.setObjectName("Button_DeveloperMode")
        self.Button_Guide = QtWidgets.QPushButton(self.centralwidget)
        self.Button_Guide.setGeometry(QtCore.QRect(720, 390, 71, 51))
        font = QtGui.QFont()
        font.setPointSize(30)
        font.setBold(True)
        font.setItalic(False)
        self.Button_Guide.setFont(font)
        self.Button_Guide.setStyleSheet("color: rgb(19, 231, 69);\n"
"border-color: rgb(19, 231, 69);\n"
"font: 600 30pt \"Quicksand\";")
        self.Button_Guide.setIconSize(QtCore.QSize(30, 30))
        self.Button_Guide.setDefault(False)
        self.Button_Guide.setFlat(True)
        self.Button_Guide.setObjectName("Button_Guide")
        self.Button_Discord = QtWidgets.QPushButton(self.centralwidget)
        self.Button_Discord.setGeometry(QtCore.QRect(630, 390, 71, 51))
        self.Button_Discord.setStyleSheet("color: rgb(19, 231, 69);\n"
"border-color: rgb(19, 231, 69);")
        self.Button_Discord.setText("")
        icon2 = QtGui.QIcon()
        icon2.addPixmap(QtGui.QPixmap("src\\Views\\Resources/Images/discord-icon.svg"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.Button_Discord.setIcon(icon2)
        self.Button_Discord.setIconSize(QtCore.QSize(50, 50))
        self.Button_Discord.setDefault(False)
        self.Button_Discord.setFlat(True)
        self.Button_Discord.setObjectName("Button_Discord")
        self.Button_Unmount = QtWidgets.QPushButton(self.centralwidget)
        self.Button_Unmount.setGeometry(QtCore.QRect(150, 390, 181, 51))
        self.Button_Unmount.setStyleSheet("color: rgb(218, 44, 56);\n"
"font: 600 30pt \"Quicksand\";")
        self.Button_Unmount.setFlat(True)
        self.Button_Unmount.setObjectName("Button_Unmount")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 795, 40))
        self.menubar.setObjectName("menubar")
        self.menuSettings_2 = QtWidgets.QMenu(self.menubar)
        self.menuSettings_2.setObjectName("menuSettings_2")
        self.menuHelp = QtWidgets.QMenu(self.menubar)
        self.menuHelp.setObjectName("menuHelp")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.actionGuide = QtWidgets.QAction(MainWindow)
        self.actionGuide.setObjectName("actionGuide")
        self.actionCheck_for_update = QtWidgets.QAction(MainWindow)
        self.actionCheck_for_update.setObjectName("actionCheck_for_update")
        self.actionSettings = QtWidgets.QAction(MainWindow)
        self.actionSettings.setObjectName("actionSettings")
        self.actionAbout = QtWidgets.QAction(MainWindow)
        self.actionAbout.setObjectName("actionAbout")
        self.menuSettings_2.addAction(self.actionSettings)
        self.menuHelp.addAction(self.actionGuide)
        self.menuHelp.addAction(self.actionCheck_for_update)
        self.menuHelp.addSeparator()
        self.menuHelp.addAction(self.actionAbout)
        self.menubar.addAction(self.menuSettings_2.menuAction())
        self.menubar.addAction(self.menuHelp.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Portal 2: Multiplayer Mod"))
        self.Button_Play.setText(_translate("MainWindow", "Play"))
        self.label_2.setText(_translate("MainWindow", "Public IP:"))
        self.Button_CopyIP.setText(_translate("MainWindow", "123.456.789.123"))
        self.label_3.setText(_translate("MainWindow", "<html><head/><body><p><span style=\" font-weight:600; color:#da2c38;\">Developer Mode:</span></p></body></html>"))
        self.Button_Guide.setText(_translate("MainWindow", "?"))
        self.Button_Unmount.setText(_translate("MainWindow", "Unmount"))
        self.menuSettings_2.setTitle(_translate("MainWindow", "Options"))
        self.menuHelp.setTitle(_translate("MainWindow", "Help"))
        self.actionGuide.setText(_translate("MainWindow", "Guide"))
        self.actionCheck_for_update.setText(_translate("MainWindow", "Check for update"))
        self.actionSettings.setText(_translate("MainWindow", "Settings"))
        self.actionAbout.setText(_translate("MainWindow", "About"))