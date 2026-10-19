# qtcontribs - Harbour Qt Projects

**The Qt framework, in the Harbour language.**

qtcontribs is the home of **HbQt**, Harbour's bindings for the Qt framework, and of
the applications built with it: the **HbIDE** development environment, the **HbDBU**
data utility, the **HbXBP** compatibility layer, and **hbnetioqt**.

Written and maintained by **Pritpal Bedi**, with contributions from across the
Harbour community. In development since 2009.

* Project page: <https://sourceforge.net/projects/qtcontribs/>
* Source (SVN): <https://sourceforge.net/p/qtcontribs/code/HEAD/tree/>
* Source (git): <https://github.com/harbour-addons/qtcontribs>
* Static builds: <https://sourceforge.net/projects/qtcontribs/files/>
* License: GNU GPL v2 with the Harbour linking exception (see below)
* Platforms: Windows, Linux, macOS, BSD

## HbQt: Harbour's bindings for Qt

HbQt wraps Qt the way Qt presents itself: it follows Qt's class hierarchy as is and
encapsulates Qt objects the same way Qt does. For every Qt class there is a C++
wrapper named after the class (`QWidget.cpp`) and a matching PRG-level class
prefixed with `T` (`TQWidget.prg`). The API you call from Harbour is the API the Qt
documentation describes, so **the Qt docs are the manual**.

Signals and events connect straight to Harbour code blocks:

```prg
/* A taste of HbQt, adapted from tests/signalslots.prg */
#include "hbqtgui.ch"

PROCEDURE Main()
   LOCAL oMain, oLabel, oScrollBar, oLayout, qApp

   oMain      := QWidget()
   oLayout    := QVBoxLayout()
   oScrollBar := QScrollBar()
   oLabel     := QLabel()

   oLabel:setText( "Move the slider" )
   oLayout:addWidget( oScrollBar )
   oLayout:addWidget( oLabel )
   hbqt_Connect( oScrollBar, "valueChanged(int)", oLabel, "setNum(int)" )

   oMain:setLayout( oLayout )
   oMain:show()

   qApp := QApplication()
   qApp:exec()
RETURN
```

### Covered Qt modules

QtCore, QtGui, QtWidgets, QtNetwork, QtSql, QtMultimedia, QtMultimediaWidgets,
QtWebKit, QtWebEngine, QtWebSockets, QtQml, QtQuick, QtDeclarative, QtDesigner,
QtScript, QtSvg, QtOpenGL, QtCharts, QtXml, QtSensors, QtPositioning, QtLocation,
QtBluetooth and QtD-Bus, plus QScintilla (code editing) and QZXing (barcodes).

### Why Harbour developers pick it up

* **The Qt docs are the manual.** Same class names, same hierarchy, same methods.
* **Harbour's own build system.** Builds with hbmk2 through standard .hbp/.hbc
  project files, exactly like a Harbour contrib library.
* Harbour linking exception. The exception in the HbQt library code does not by itself impose the GPL on your application. Qt and third-party license obligations still apply; see the licensing disclaimer.
* **Proven in production.** HbIDE, a full IDE, is itself an HbQt application
  written in Harbour.

## The ecosystem

| Project | What it is |
| --- | --- |
| **HbIDE** | An integrated development environment for Harbour, written in Harbour itself: code editor with syntax highlighting, visual debugger, project management around hbmk2 `.hbp` files, find-in-files, themes, plugins, code skeletons and an integrated DBU panel. [Static builds](https://sourceforge.net/projects/qtcontribs/files/HbIDE/) |
| **HbDBU** | The classic DBU idea rebuilt on Qt: open, browse and edit DBF tables, inspect structures, create tables. Selected builds add SQL access. [Static builds](https://sourceforge.net/projects/qtcontribs/files/HbDBU/) |
| **HbXBP** | An Xbase Parts compatibility layer: Xbase++-style classes (`Xbp*` with the familiar `appevent.ch` event model) implemented on top of HbQt, giving Xbase++ GUI code a home in Harbour. |
| **hbqtwidgets** | Ready-made widgets written at the PRG level: data-aware browse grids, DBU panels, a syntax-highlighting editor, dashboards, charts, an on-screen keyboard, an icons manager, an HTTP client and common dialogs. The pieces HbIDE is assembled from. |
| **hbqtqmlparts** | A bridge between Harbour and Qt Quick/QML, with ready parts for camera capture, barcode reading and embedded web views. |
| **hbnetioqt** | An HbQt management console for hbnetio servers: watch connected clients, manage addresses and terminate sessions from a desktop UI. |

## History

* **Mar 2009** - First HbQt commits land in the Harbour repository as
  `contrib/hbqt`, together with `contrib/hbide` and `contrib/hbxbp`.
* **Sep 2012** - The Qt contribs move out of Harbour into a project of their own;
  qtcontribs opens on SourceForge.
* **2013-2017** - Steady releases: QtContribs setup packages and static
  HbIDE/HbDBU builds for Qt 4.8 through 5.9 with MinGW.
* **2023-2026** - Active maintenance continues on SourceForge SVN
  (revision 489 as of June 2026).
* **2026** - The complete combined history, every commit by every contributor
  since March 2009, is preserved in git at
  [harbour-addons/qtcontribs](https://github.com/harbour-addons/qtcontribs).

## Get started

1. **Try it without a compiler.** Download a static HbIDE or HbDBU build from
   [SourceForge](https://sourceforge.net/projects/qtcontribs/files/) and run it.
   No Qt installation needed; everything is linked in.
2. **Set up a toolchain.** Harbour 3.2 or later, a Qt development kit
   (Qt 4.8 or Qt 5.x) and a C++ compiler. Published kits pair MinGW with Qt,
   including a ready static Qt 5.8 build.
3. **Get the source.** SVN at
   [SourceForge](https://sourceforge.net/p/qtcontribs/code/HEAD/tree/) or git at
   [github.com/harbour-addons/qtcontribs](https://github.com/harbour-addons/qtcontribs).
4. **Build.** From the trunk, `hbmk2 qtcontribs.hbp` builds the libraries; each
   application has its own project file (`hbide.hbp`, `hbdbu.hbp`).

## Credits

From the project's own `CREDITS.txt`:

* **Pritpal Bedi** - author and maintainer of HbQt, HbIDE, HbDBU, HbXBP, hbnetioqt
* **Marcos Antonio Gambeta** - the first prototype parsing methods HbQt grew from
* **Viktor Szakats** - direction, the build system for hbQT and hbIDE,
  signal/slot and event classes
* **Francesco Perillo** - the simplified signals/slots mechanism, PRG-level code
  ported to C++
* **Przemyslaw Czerpak** - HVM internals, tips and tricks, and a path whenever
  the project got stuck
* **Istvan Bisz** - the QPointer concept in the generator, testing across the board
* **Carlos Bacco** - HBQT_TYPE enums and optimization review
* **Teo Fonrouge** - building blocks for porting PRG-level classes to C++

## Qt credit and licensing disclaimer

HbQt brings the Qt framework to Harbour. We gratefully acknowledge the work of The Qt Company and the Qt community. Qt is a registered trademark of The Qt Company Ltd and/or its subsidiaries. qtcontribs is a separate community project; no affiliation with or endorsement by The Qt Company is implied.

The Harbour linking exception applies to the code carrying that exception. It does not waive the licenses of Qt, its modules, or other third-party libraries. Your choice of Qt version, modules and distribution method matters:

* Qt 5.5 and 5.6: LGPLv2.1 remained an option for much of Qt, alongside LGPLv3 and commercial licensing. Not every module offered LGPLv2.1, even in these releases. Check the licenses shipped with the exact modules you use. [1][2]
* Qt 5.7, including Qt 5.8: Qt removed LGPLv2.1 as an option for its own framework code. Most libraries were offered under LGPLv3, with GPL alternatives and commercial licensing. Some modules, including Qt Charts, Qt Data Visualization and Qt Virtual Keyboard, were offered under GPLv3 or commercial terms, not LGPL. Third-party code may carry other licenses. [3][4]
* Later Qt 5 and Qt 6: Commercial and open-source options continue, but the available licenses vary by module and release. Do not assume that every Qt component is LGPL, or that a license available in an older release applies to a newer one. [5][6]

Static builds are not a licensing exemption. This also applies when redistributing static HbIDE/HbDBU builds or applications built with a static Qt kit. LGPL distribution requires the applicable notices, license texts and library source obligations to be met, and a way for recipients to use a modified library. With static linking, this can require application object files or source and the materials needed to relink; LGPLv3 also requires installation information where applicable. Static linking does not, by itself, mean that you must buy a commercial Qt license. GPL-licensed modules have different obligations. [7][8]

Before distributing an application or binary package, check the exact Qt release, every included module and dependency, and the license terms supplied with them. This page is a general guide, not legal advice or a statement that a particular build complies. Consult Qt's official licensing documentation and obtain legal advice for your own distribution.

Sources:
[1] https://doc.qt.io/archives/qt-5.5/licensing.html
[2] https://doc.qt.io/archives/qt-5.6/licensing.html
[3] https://www.qt.io/blog/2016/06/16/qt-5-7-released
[4] https://doc.qt.io/archives/qt-5.8/licensing.html
[5] https://doc.qt.io/qt-5/licensing.html
[6] https://doc.qt.io/qt-6/licensing.html
[7] https://www.qt.io/faq/tag/qt-open-source-licensing
[8] https://doc.qt.io/qt-6/lgpl.html

## License

Code carrying the Harbour Project's linking exception may be linked into an executable without that linking alone placing the executable under the GPL. This exception does not override Qt or third-party licenses. See the Qt credit and licensing disclaimer above.
