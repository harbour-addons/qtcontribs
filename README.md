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
* **Commercial-friendly license.** GPL v2 with the Harbour linking exception:
  executables you build and ship are not covered by the GPL.
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

## License

GNU General Public License v2, with the Harbour Project's special exception:
linking the libraries into your own executable does not place that executable
under the GPL. Your applications stay yours.
