#-------------------------------------------------
#
# Project created by QtCreator 2014-08-08T10:38:29
#
#-------------------------------------------------

VERSION = 1.5.0

QT += core gui widgets network sql xml svg
QT += gui-private
QT += concurrent

TARGET    = Notes
TEMPLATE  = app
CONFIG   += c++11

UI_DIR = uic
MOC_DIR = moc
RCC_DIR = qrc
OBJECTS_DIR = obj

TRANSLATIONS += \
    $$PWD/translations/zh_CN.ts \
    $$PWD/translations/qt_zh_CN.ts \

#include ($$PWD/../3rdParty/qxt/qxt.pri)
include ($$PWD/../3rdParty/QSimpleUpdater/QSimpleUpdater.pri)
include ($$PWD/../3rdParty/qmarkdowntextedit/qmarkdowntextedit.pri)
include ($$PWD/../3rdParty/qautostart/src/qautostart.pri)

SOURCES += \
    $$PWD/main.cpp\
    $$PWD/mainwindow.cpp \
    $$PWD/notedata.cpp \
    $$PWD/notewidgetdelegate.cpp \
    $$PWD/notemodel.cpp \
    $$PWD/noteview.cpp \
    $$PWD/singleinstance.cpp \
    $$PWD/updaterwindow.cpp \
    $$PWD/dbmanager.cpp \
    $$PWD/aboutwindow.cpp \
    $$PWD/customdocument.cpp \
    $$PWD/editorsettingsbutton.cpp \
    $$PWD/styleeditorwindow.cpp \
    $$PWD/textedit.cpp \
    $$PWD/vscrollbar.cpp \
    $$PWD/lineedit.cpp \
    $$PWD/svgicons.cpp \
    $$PWD/aboutdialog.cpp \

HEADERS  += \
    $$PWD/mainwindow.h \
    $$PWD/notedata.h \
    $$PWD/notewidgetdelegate.h \
    $$PWD/notemodel.h \
    $$PWD/noteview.h \
    $$PWD/singleinstance.h \
    $$PWD/updaterwindow.h \
    $$PWD/dbmanager.h \
    $$PWD/aboutwindow.h \
    $$PWD/customDocument.h \
    $$PWD/editorsettingsbutton.h \
    $$PWD/framelesswindow.h \
    $$PWD/styleeditorwindow.h \
    $$PWD/textedit.h \
    $$PWD/vscrollbar.h \
    $$PWD/lineedit.h \
    $$PWD/svgicons.h \
    $$PWD/spinbox.h \
    $$PWD/filedialog.h \
    $$PWD/aboutdialog.h \

FORMS += \
    $$PWD/mainwindow.ui \
    $$PWD/updaterwindow.ui \
    $$PWD/aboutwindow.ui \
    $$PWD/styleeditorwindow.ui \
    $$PWD/aboutdialog.ui \

RESOURCES += \
    $$PWD/images.qrc \
    $$PWD/fonts.qrc \
    $$PWD/styles.qrc \
    $$PWD/translations.qrc

linux:!android {
    isEmpty (PREFIX) {
        PREFIX = /usr
    }

    BINDIR  = $$PREFIX/bin

    target.path    = $$BINDIR
    icon.path      = $$PREFIX/share/pixmaps
    desktop.path   = $$PREFIX/share/applications
    icon.files    += $$PWD/packaging/linux/common/notes.png
    desktop.files += $$PWD/packaging/linux/common/notes.desktop

    TARGET    = notes
    INSTALLS += target desktop icon

    # SNAP  --------------------------------------------------------------------------------
    snap_pack.commands = snapcraft clean && snapcraft

    # Debian -------------------------------------------------------------------------------

    License = gpl2
    Project = "$$TARGET-$$VERSION"

    AuthorEmail = \"awesomeness.notes@gmail.com\"
    AuthorName = \"Ruby Mamistvalove\"

    deb.target   = deb
    deb.depends  = fix_deb_dependencies
    deb.depends += $$TARGET
    deb.commands = rm -rf deb &&\
                   mkdir -p deb/$$Project &&\
                   cp $$TARGET deb/$$Project &&\
                   cp $$_PRO_FILE_PWD_/../packaging/linux/common/LICENSE deb/$$Project/license.txt &&\
                   cp -a $$_PRO_FILE_PWD_/../packaging/linux/common/icons deb/$$Project/ &&\
                   cp $$_PRO_FILE_PWD_/../packaging/linux/common/notes.desktop deb/$$Project/notes.desktop &&\
                   cp $$_PRO_FILE_PWD_/../packaging/linux/debian/copyright deb/$$Project/copyright &&\
                   cp -avr $$_PRO_FILE_PWD_/../packaging/linux/debian deb/$$Project/debian &&\
                   cd deb/$$Project/ &&\
                   DEBFULLNAME=$$AuthorName EMAIL=$$AuthorEmail dh_make -y -s -c $$License --createorig; \
                   dpkg-buildpackage -uc -us

    fix_deb_dependencies.commands = \
        sed -i -- 's/5.2/$$QT_MAJOR_VERSION\.$$QT_MINOR_VERSION/g'  $$_PRO_FILE_PWD_/../packaging/linux/debian/control

    # AppImage -------------------------------------------------------------------------------

    appimage.target    = appimage
    appimage.depends   = $$TARGET
    appimage.commands  = mkdir -p Notes/usr/bin;
    appimage.commands += cp $$TARGET Notes/usr/bin;
    appimage.commands += mkdir -p Notes/usr/share/applications/;
    appimage.commands += cp $$_PRO_FILE_PWD_/../packaging/linux/common/notes.desktop Notes/usr/share/applications/;
    appimage.commands += cp $$_PRO_FILE_PWD_/../packaging/linux/common/icons/256x256/notes.png Notes;
    appimage.commands += mkdir -p Notes/usr/share/icons/default/256x256/apps/;
    appimage.commands += cp $$_PRO_FILE_PWD_/../packaging/linux/common/icons/256x256/notes.png Notes/usr/share/icons/default/256x256/apps/;
    appimage.commands += wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage";
    appimage.commands += chmod a+x linuxdeployqt*.AppImage;
    appimage.commands += unset QTDIR; unset QT_PLUGIN_PATH; unset LD_LIBRARY_PATH;
    appimage.commands += ./linuxdeployqt*.AppImage Notes/usr/share/applications/*.desktop -bundle-non-qt-libs;
    appimage.commands += cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 Notes/usr/lib;
    appimage.commands += ./linuxdeployqt*.AppImage Notes/usr/share/applications/*.desktop -appimage;
    appimage.commands += find Notes -executable -type f -exec ldd {} \; | grep \" => /usr\" | cut -d \" \" -f 2-3 | sort | uniq;

    # EXTRA --------------------------------------------------------------------------------
    QMAKE_EXTRA_TARGETS += \
                           snap_pack            \
                           deb                  \
                           fix_deb_dependencies \
                           appimage
}


Release:DESTDIR = $$PWD/../bin
Debug:DESTDIR = $$PWD/../bin_debug

macx {
    ICON = $$PWD/images\notes_icon.icns
    OBJECTIVE_SOURCES += \
                framelesswindow.mm
    LIBS += -framework Cocoa
}

win32 {
    RC_FILE = $$PWD/images\notes.rc
    SOURCES += \
        framelesswindow.cpp
    QMAKE_POST_LINK += $$quote($$[QT_INSTALL_BINS]/windeployqt --no-translations --no-system-d3d-compiler --no-compiler-runtime --no-opengl-sw  \"$${DESTDIR}/$${TARGET}.exe\"$$escape_expand(\\n\\t))
}
