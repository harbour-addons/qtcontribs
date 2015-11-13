/*
 * $Id$
 */

/*
 * hbmk2 plugin script, implementing support for QT specific features
 *
 * Copyright 2010 Viktor Szakats (harbour syenar.net)
 * Copyright 2010 Pritpal Bedi <bedipritpal@hotmail.com> (qth->prg/cpp generator and hbqtui_gen_prg())
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA (or visit
 * their web site at http://www.gnu.org/).
 *
 */

#pragma warninglevel=3
#pragma -km+
#pragma -ko+

#include "directry.ch"
#include "hbclass.ch"
#include "error.ch"

#define I_( x )                 hb_i18n_gettext( x )

#if defined( __HBSCRIPT__HBMK_PLUGIN )

FUNCTION hbmk_plugin_qt( hbmk )
   LOCAL cRetVal := ""

   LOCAL cSrc
   LOCAL cDst
   LOCAL tSrc
   LOCAL tDst

   LOCAL cDstCPP, cDstDOC
   LOCAL tDstCPP

   LOCAL cTmp, cTmp1
   LOCAL cPRG
   LOCAL cVer

   LOCAL cCommand
   LOCAL nError
   LOCAL lBuildIt

   SWITCH hbmk[ "cSTATE" ]
   CASE "init"

      hbmk_Register_Input_File_Extension( hbmk, ".qrc" )
      hbmk_Register_Input_File_Extension( hbmk, ".ui" )
      hbmk_Register_Input_File_Extension( hbmk, ".hpp" )
      hbmk_Register_Input_File_Extension( hbmk, ".h" )
      hbmk_Register_Input_File_Extension( hbmk, ".qth" )

      cVer := qt_version_detect( hbmk, "uic", "UIC_BIN" )
      cVer := StrTran( cVer, hb_eol() )
      hb_SetEnv( "HB_QT_MAJOR_VER", "5" )

      IF ! Empty( GetEnv( "QTCONTRIBS_REBUILD" ) )
         cTmp1 := MemoRead( "ChangeLog" )
         IF ( cTmp := At( " * $Id: ChangeLog ", cTmp1 ) ) > 0
            cTmp1 := SubStr( cTmp1, cTmp + Len( " * $Id: ChangeLog " ) )
            cTmp := At( " ", cTmp1 )
            cTmp1 := Left( cTmp1, cTmp - 1 )
         ENDIF

         cTmp := "/* ------------------ Auto Generated Header, Do Not Edit --------------------- */" + hb_eol()
         cTmp += " " + hb_eol()
         cTmp += "#ifndef __HBQT_VERSION_CH" + hb_eol()
         cTmp += "   #define __HBQT_VERSION_CH" + hb_eol()
         cTmp += " " + hb_eol()
         cTmp += "#define __HB_QT_MAJOR_VERSION_5__        " + '"' + cVer + '"' + hb_eol()
         cTmp += "#define __HBQT_REVISION__                " + '"' + cTmp1 + '"' + hb_eol()
         cTmp += " " + hb_eol()
         cTmp += "#endif" + hb_eol()

         hb_MemoWrit( "hbqt" + hb_ps() + "qtgui" + hb_ps() + "hbqt_version.ch", cTmp )
      ENDIF

      EXIT

   CASE "pre_all"

      /* Gather input parameters */

      hbmk[ "vars" ][ "aQRC_Src" ] := {}
      hbmk[ "vars" ][ "aUIC_Src" ] := {}
      hbmk[ "vars" ][ "aMOC_Src" ] := {}
      hbmk[ "vars" ][ "aQTH_Src" ] := {}

      hbmk[ "vars" ][ "qtmodule" ] := ""
      hbmk[ "vars" ][ "qtver" ] := ""
      hbmk[ "vars" ][ "qthdocdir" ] := ""

      FOR EACH cSrc IN hbmk[ "params" ]
         IF Left( cSrc, 1 ) == "-"
            DO CASE
            CASE Left( cSrc, Len( "-qtver=" ) ) == "-qtver="
               hbmk[ "vars" ][ "qtver" ] := SubStr( cSrc, Len( "-qtver=" ) + 1 )
            CASE Left( cSrc, Len( "-qtmodule=" ) ) == "-qtmodule="
               hbmk[ "vars" ][ "qtmodule" ] := SubStr( cSrc, Len( "-qtmodule=" ) + 1 )
            CASE Left( cSrc, Len( "-qthdocdir=" ) ) == "-qthdocdir="
               hbmk[ "vars" ][ "qthdocdir" ] := SubStr( cSrc, Len( "-qthdocdir=" ) + 1 )
            ENDCASE
         ELSE
            SWITCH Lower( hb_FNameExt( cSrc ) )
            CASE ".qrc"
               AAdd( hbmk[ "vars" ][ "aQRC_Src" ], cSrc )
               EXIT
            CASE ".ui"
               AAdd( hbmk[ "vars" ][ "aUIC_Src" ], cSrc )
               EXIT
            CASE ".hpp"
            CASE ".h"
               AAdd( hbmk[ "vars" ][ "aMOC_Src" ], cSrc )
               EXIT
            CASE ".qth"
               AAdd( hbmk[ "vars" ][ "aQTH_Src" ], cSrc )
               EXIT
            ENDSWITCH
         ENDIF
      NEXT

      /* Create output file lists */

      hbmk[ "vars" ][ "aQRC_Dst" ] := {}
      hbmk[ "vars" ][ "aQRC_PRG" ] := {}
      FOR EACH cSrc IN hbmk[ "vars" ][ "aQRC_Src" ]
         cDst := hbmk_FNameDirExtSet( "rcc_" + hb_FNameName( cSrc ), hbmk[ "cWorkDir" ], ".qrb" )
         AAdd( hbmk[ "vars" ][ "aQRC_Dst" ], cDst )
         cDst := hbmk_FNameDirExtSet( "rcc_" + hb_FNameName( cSrc ), hbmk[ "cWorkDir" ], ".prg" )
         AAdd( hbmk[ "vars" ][ "aQRC_PRG" ], cDst )
         hbmk_AddInput_PRG( hbmk, cDst )
      NEXT

      hbmk[ "vars" ][ "aUIC_Dst" ] := {}
      FOR EACH cSrc IN hbmk[ "vars" ][ "aUIC_Src" ]
         cDst := hbmk_FNameDirExtSet( "uic_" + hb_FNameName( cSrc ), hbmk[ "cWorkDir" ], ".prg" )
         AAdd( hbmk[ "vars" ][ "aUIC_Dst" ], cDst )
         hbmk_AddInput_PRG( hbmk, cDst )
      NEXT

      hbmk[ "vars" ][ "aMOC_Dst" ] := {}
      FOR EACH cSrc IN hbmk[ "vars" ][ "aMOC_Src" ]
         cDst := hbmk_FNameDirExtSet( "moc_" + hb_FNameName( cSrc ), hbmk[ "cWorkDir" ], ".cpp" )
         AAdd( hbmk[ "vars" ][ "aMOC_Dst" ], cDst )
         hbmk_AddInput_CPP( hbmk, cDst )
      NEXT

      hbmk[ "vars" ][ "aQTH_CPP" ] := {}
      hbmk[ "vars" ][ "aQTH_DOC" ] := {}
      FOR EACH cSrc IN hbmk[ "vars" ][ "aQTH_Src" ]
         cDst := hbmk_FNameDirExtSet( hb_FNameName( cSrc ), hbmk[ "cWorkDir" ], ".cpp" )
         AAdd( hbmk[ "vars" ][ "aQTH_CPP" ], cDst )
         hbmk_AddInput_CPP( hbmk, cDst )
         cDst := hb_PathNormalize( hbmk_FNameDirExtSet( "class_" + Lower( hb_FNameName( cSrc ) ), hb_FNameDir( cSrc ) + hbmk[ "vars" ][ "qthdocdir" ] + "en" + hb_ps(), ".txt" ) )
         AAdd( hbmk[ "vars" ][ "aQTH_DOC" ], cDst )

         IF qth_is_extended( cSrc )
            AAdd( hbmk[ "vars" ][ "aMOC_Src" ], hbmk_FNameDirExtSet( "q" + lower( hb_FNameName( cSrc ) ), hbmk[ "cWorkDir" ], ".h" ) )
            cDst := hbmk_FNameDirExtSet( "moc_q" + lower( hb_FNameName( cSrc ) ), hbmk[ "cWorkDir" ], ".cpp" )
            AAdd( hbmk[ "vars" ][ "aMOC_Dst" ], cDst )
            hbmk_AddInput_CPP( hbmk, cDst )
         ENDIF
      NEXT

      /* Detect tool locations */

      IF ! hbmk[ "lCLEAN" ]
         IF ! Empty( hbmk[ "vars" ][ "aQRC_Src" ] )
            //hbmk[ "vars" ][ "cRCC_BIN" ] := qt_tool_detect( hbmk, "rcc", "RCC_BIN", .F. )
            hbmk[ "vars" ][ "cRCC_BIN" ] := qt_tool_detect( hbmk, "rcc", "RCC_BIN", .T. )
            IF Empty( hbmk[ "vars" ][ "cRCC_BIN" ] )
               cRetVal := I_( "Required QT tool not found" )
            ENDIF
         ENDIF
         IF ! Empty( hbmk[ "vars" ][ "aUIC_Src" ] )
            hbmk[ "vars" ][ "cUIC_BIN" ] := qt_tool_detect( hbmk, "uic", "UIC_BIN" )
            IF Empty( hbmk[ "vars" ][ "cUIC_BIN" ] )
               cRetVal := I_( "Required QT tool not found" )
            ENDIF
         ENDIF
         IF ! Empty( hbmk[ "vars" ][ "aMOC_Src" ] )
            hbmk[ "vars" ][ "cMOC_BIN" ] := qt_tool_detect( hbmk, "moc", "MOC_BIN" )
            IF Empty( hbmk[ "vars" ][ "cMOC_BIN" ] )
               cRetVal := I_( "Required QT tool not found" )
            ENDIF
         ENDIF
      ENDIF

      EXIT

   CASE "pre_prg"

      IF ! hbmk[ "lCLEAN" ] .AND. ;
         ! Empty( hbmk[ "vars" ][ "aQRC_Src" ] )

         IF ! Empty( hbmk[ "vars" ][ "cRCC_BIN" ] )

            /* Execute 'rcc' commands on input files */

            FOR EACH cSrc, cDst, cPRG IN hbmk[ "vars" ][ "aQRC_Src" ], hbmk[ "vars" ][ "aQRC_Dst" ], hbmk[ "vars" ][ "aQRC_PRG" ]

               IF hbmk[ "lINC" ] .AND. ! hbmk[ "lREBUILD" ]
                  lBuildIt := ! hb_FGetDateTime( cDst, @tDst ) .OR. ;
                              ! hb_FGetDateTime( cSrc, @tSrc ) .OR. ;
                              tSrc > tDst
               ELSE
                  lBuildIt := .T.
               ENDIF

               IF lBuildIt

                  cCommand := hbmk[ "vars" ][ "cRCC_BIN" ] +;
                              " -binary" +;
                              " " + hbmk_FNameEscape( hbmk, hbmk_PathSepToTarget( hbmk, cSrc ) ) +;
                              " -o " + hbmk_FNameEscape( hbmk, hbmk_PathSepToTarget( hbmk, cDst ) )

                  IF hbmk[ "lTRACE" ]
                     IF ! hbmk[ "lQUIET" ]
                        hbmk_OutStd( hbmk, I_( "'rcc' command:" ) )
                     ENDIF
                     hbmk_OutStdRaw( hbmk, cCommand )
                  ENDIF

                  IF ! hbmk[ "lDONTEXEC" ]
                     IF ( nError := hb_processRun( cCommand ) ) != 0
                        hbmk_OutErr( hbmk, hb_StrFormat( I_( "Error: Running 'rcc' executable. %1$d" ), nError ) )
                        IF ! hbmk[ "lQUIET" ]
                           hbmk_OutErrRaw( hbmk, cCommand )
                        ENDIF
                        IF ! hbmk[ "lIGNOREERROR" ]
                           cRetVal := "error"
                           EXIT
                        ENDIF
                     ELSE
                        /* Create little .prg stub which includes the binary */
                        cTmp := "/* WARNING: Automatically generated source file. DO NOT EDIT! */" + hb_eol() +;
                                hb_eol() +;
                                "#pragma -km+" + hb_eol() +;
                                hb_eol() +;
                                "FUNCTION hbqtres_" + hbmk_FuncNameEncode( hb_FNameName( cSrc ) ) + "()" + hb_eol() +;
                                "   #pragma __binarystreaminclude " + Chr( 34 ) + hb_FNameNameExt( cDst ) + Chr( 34 ) + " | RETURN %s" + hb_eol()

                        IF ! hb_MemoWrit( cPRG, cTmp )
                           hbmk_OutErr( hbmk, hb_StrFormat( "Error: Cannot create file: %1$s", cPRG ) )
                           IF ! hbmk[ "lIGNOREERROR" ]
                              cRetVal := "error"
                              EXIT
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT
         ENDIF
      ENDIF

      IF ! hbmk[ "lCLEAN" ] .AND. ;
         ! Empty( hbmk[ "vars" ][ "aUIC_Src" ] )

         IF ! Empty( hbmk[ "vars" ][ "cUIC_BIN" ] )

            /* Execute 'uic' commands on input files */

            FOR EACH cSrc, cDst IN hbmk[ "vars" ][ "aUIC_Src" ], hbmk[ "vars" ][ "aUIC_Dst" ]

               IF hbmk[ "lINC" ] .AND. ! hbmk[ "lREBUILD" ]
                  lBuildIt := ! hb_FGetDateTime( cDst, @tDst ) .OR. ;
                              ! hb_FGetDateTime( cSrc, @tSrc ) .OR. ;
                              tSrc > tDst
               ELSE
                  lBuildIt := .T.
               ENDIF

               IF lBuildIt

                  FClose( hb_FTempCreateEx( @cTmp ) )

                  cCommand := hbmk[ "vars" ][ "cUIC_BIN" ] +;
                              " " + hbmk_FNameEscape( hbmk, hbmk_PathSepToTarget( hbmk, cSrc ) ) +;
                              " -o " + hbmk_FNameEscape( hbmk, cTmp )

                  IF hbmk[ "lTRACE" ]
                     IF ! hbmk[ "lQUIET" ]
                        hbmk_OutStd( hbmk, I_( "'uic' command:" ) )
                     ENDIF
                     hbmk_OutStdRaw( hbmk, cCommand )
                  ENDIF

                  IF ! hbmk[ "lDONTEXEC" ]
                     IF ( nError := hb_processRun( cCommand ) ) != 0
                        hbmk_OutErr( hbmk, hb_StrFormat( I_( "Error: Running 'uic' executable. %1$d" ), nError ) )
                        IF ! hbmk[ "lQUIET" ]
                           hbmk_OutErrRaw( hbmk, cCommand )
                        ENDIF
                        IF ! hbmk[ "lIGNOREERROR" ]
                           FErase( cTmp )
                           cRetVal := "error"
                           EXIT
                        ENDIF
                     ELSE
                        IF ! uic_to_prg( hbmk, cTmp, cDst, hbmk_FuncNameEncode( hb_FNameName( cSrc ) ) )
                           IF ! hbmk[ "lIGNOREERROR" ]
                              FErase( cTmp )
                              cRetVal := "error"
                              EXIT
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
                  FErase( cTmp )
               ENDIF
            NEXT
         ENDIF
      ENDIF

      EXIT

   CASE "pre_c"

      IF ! hbmk[ "lCLEAN" ] .AND. ;
         ! Empty( hbmk[ "vars" ][ "aQTH_Src" ] )

         IF ! Empty( hbmk[ "vars" ][ "qtmodule" ] ) .AND. ;
            ! Empty( hbmk[ "vars" ][ "qtver" ] )

            FOR EACH cSrc, cDstCPP, cDstDOC IN hbmk[ "vars" ][ "aQTH_Src" ], hbmk[ "vars" ][ "aQTH_CPP" ], hbmk[ "vars" ][ "aQTH_DOC" ]

               IF hbmk[ "lINC" ] .AND. ! hbmk[ "lREBUILD" ]
                  lBuildIt := ! hb_FGetDateTime( cDstCPP, @tDstCPP ) .OR. ;
                              ! hb_FGetDateTime( cSrc, @tSrc ) .OR. ;
                              tSrc > tDstCPP
               ELSE
                  lBuildIt := .T.
               ENDIF

               IF lBuildIt
                  IF ! hbmk[ "lDONTEXEC" ]
                     IF ! qth_to_src( cSrc, cDstCPP, cDstDOC, hbmk[ "vars" ][ "qtmodule" ], hbmk[ "vars" ][ "qtver" ] )
                        IF ! hbmk[ "lIGNOREERROR" ]
                           cRetVal := "error"
                           EXIT
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT
         ELSE
            hbmk_OutErr( hbmk, I_( "Error: Qt module or version not specified." ) )
            cRetVal := "error"
         ENDIF
      ENDIF

      IF ! hbmk[ "lCLEAN" ] .AND. ;
         ! Empty( hbmk[ "vars" ][ "aMOC_Src" ] )

         IF ! Empty( hbmk[ "vars" ][ "cMOC_BIN" ] )

            /* Execute 'moc' commands on input files */

            FOR EACH cSrc, cDst IN hbmk[ "vars" ][ "aMOC_Src" ], hbmk[ "vars" ][ "aMOC_Dst" ]

               IF hbmk[ "lINC" ] .AND. ! hbmk[ "lREBUILD" ]
                  lBuildIt := ! hb_FGetDateTime( cDst, @tDst ) .OR. ;
                              ! hb_FGetDateTime( cSrc, @tSrc ) .OR. ;
                              tSrc > tDst
               ELSE
                  lBuildIt := .T.
               ENDIF

               IF lBuildIt

                  cCommand := hbmk[ "vars" ][ "cMOC_BIN" ] +;
                              " " + hbmk_FNameEscape( hbmk, hbmk_PathSepToTarget( hbmk, cSrc ) ) +;
                              " -o " + hbmk_FNameEscape( hbmk, hbmk_PathSepToTarget( hbmk, cDst ) )

                  IF hbmk[ "lTRACE" ]
                     IF ! hbmk[ "lQUIET" ]
                        hbmk_OutStd( hbmk, I_( "'moc' command:" ) )
                     ENDIF
                     hbmk_OutStdRaw( hbmk, cCommand )
                  ENDIF

                  IF ! hbmk[ "lDONTEXEC" ] .AND. ( nError := hb_processRun( cCommand ) ) != 0
                     hbmk_OutErr( hbmk, hb_StrFormat( I_( "Error: Running 'moc' executable. %1$d" ), nError ) )
                     IF ! hbmk[ "lQUIET" ]
                        hbmk_OutErrRaw( hbmk, cCommand )
                     ENDIF
                     IF ! hbmk[ "lIGNOREERROR" ]
                        cRetVal := "error"
                        EXIT
                     ENDIF
                  ENDIF
               ENDIF
            NEXT
         ENDIF
      ENDIF

      EXIT

   CASE "post_all"

      IF ! hbmk[ "lINC" ] .OR. hbmk[ "lCLEAN" ]
         AEval( hbmk[ "vars" ][ "aQRC_Dst" ], {| tmp | FErase( tmp ) } )
         AEval( hbmk[ "vars" ][ "aQRC_PRG" ], {| tmp | FErase( tmp ) } )
         AEval( hbmk[ "vars" ][ "aUIC_Dst" ], {| tmp | FErase( tmp ) } )
         AEval( hbmk[ "vars" ][ "aMOC_Dst" ], {| tmp | FErase( tmp ) } )
         AEval( hbmk[ "vars" ][ "aQTH_CPP" ], {| tmp | FErase( tmp ) } )
         AEval( hbmk[ "vars" ][ "aQTH_DOC" ], {| tmp | FErase( tmp ) } )
      ENDIF

      EXIT

   ENDSWITCH

   RETURN cRetVal

STATIC FUNCTION qt_version_detect( hbmk, cName, cEnvQT, lPostfix )
   LOCAL cStdOut := ""
	LOCAL cStdErr := ""
   LOCAL cBIN := qt_tool_detect( hbmk, cName, cEnvQT, lPostfix )

   IF ! Empty( cBIN )
      hb_processRun( cBIN + " -v",, @cStdOut, @cStdErr )
   ENDIF

   RETURN IIF( !EMPTY(cStdOut), cStdOut, cStdErr )

STATIC FUNCTION qt_tool_detect( hbmk, cName, cEnvQT, lPostfix )
   LOCAL cBIN
   LOCAL aEnvList
   LOCAL cStdErr

   IF ! HB_ISLOGICAL( lPostfix )
      lPostfix := .T.
   ENDIF

   IF lPostfix
      aEnvList := { "HB_QTPATH", "HB_QTPOSTFIX" }
   ELSE
      aEnvList := { "HB_QTPATH" }
   ENDIF

   cBIN := GetEnv( cEnvQT )
   IF Empty( cBIN )

      IF lPostfix
         cName += GetEnv( "HB_QTPOSTFIX" )
      ENDIF
      cName += hbmk[ "cCCEXT" ]

      IF Empty( GetEnv( "HB_QTPATH" ) ) .OR. ;
         ! hb_FileExists( cBIN := hb_DirSepAdd( GetEnv( "HB_QTPATH" ) ) + cName )

         #if defined( __PLATFORM__WINDOWS ) .OR. defined( __PLATFORM__OS2 )

            hb_AIns( aEnvList, 1, "HB_WITH_QT", .T. )

            IF ! Empty( GetEnv( "HB_WITH_QT" ) )

               IF GetEnv( "HB_WITH_QT" ) == "no"
                  /* Return silently. It shall fail at dependency detection inside hbmk2 */
                  RETURN NIL
               ELSE
                  IF ! hb_FileExists( cBIN := hb_PathNormalize( hb_DirSepAdd( GetEnv( "HB_WITH_QT" ) ) + "..\bin\" + cName ) )
                     hbmk_OutErr( hbmk, hb_StrFormat( "Warning: HB_WITH_QT points to incomplete QT installation. '%1$s' executable not found.", cName ) )
                     cBIN := ""
                  ENDIF
               ENDIF
            ELSE
               cBIN := hb_DirSepAdd( hb_DirBase() ) + cName
               IF ! hb_FileExists( cBIN )
                  cBIN := ""
               ENDIF
            ENDIF
         #else
            cBIN := ""
         #endif

         IF Empty( cBIN )
            cBIN := hbmk_FindInPath( cName, GetEnv( "PATH" ) + hb_osPathListSeparator() + "/opt/qtsdk/qt/bin" )
            IF Empty( cBIN )
               hbmk_OutErr( hbmk, hb_StrFormat( "%1$s not set, could not autodetect '%2$s' executable", hbmk_ArrayToList( aEnvList, ", " ), cName ) )
               RETURN NIL
            ENDIF
         ENDIF
      ENDIF
      IF hbmk[ "lINFO" ]
         cStdErr := ""
         IF ! hbmk[ "lDONTEXEC" ]
            hb_processRun( cBIN + " -v",,, @cStdErr )
            IF ! Empty( cStdErr )
               cStdErr := " [" + StrTran( StrTran( cStdErr, Chr( 13 ) ), Chr( 10 ) ) + "]"
            ENDIF
         ENDIF
         hbmk_OutStd( hbmk, hb_StrFormat( "Using QT '%1$s' executable: %2$s%3$s (autodetected)", cName, cBIN, cStdErr ) )
      ENDIF
   ENDIF

   RETURN cBIN

#else

/* Standalone test code conversions */
PROCEDURE Main( cSrc )
   LOCAL cTmp
   LOCAL nError
   LOCAL cExt
   LOCAL aFile
   LOCAL cFN

   IF cSrc != NIL

      hb_FNameSplit( cSrc,,, @cExt )

      SWITCH Lower( cExt )
      CASE ".ui"

         FClose( hb_FTempCreateEx( @cTmp ) )

         IF ( nError := hb_processRun( "uic " + cSrc + " -o " + cTmp ) ) == 0
            IF ! uic_to_prg( NIL, cTmp, cSrc + ".prg", "TEST" )
               nError := 9
            ENDIF
         ELSE
            OutErr( "Error: Calling 'uic' tool: " + hb_ntos( nError ) + hb_eol() )
         ENDIF

         FErase( cTmp )
         EXIT

      CASE ".qth"

         FOR EACH aFile IN Directory( cSrc )
            cFN := hb_FNameMerge( FNameDirGet( cSrc ), aFile[ F_NAME ] )
            qth_to_src( cFN, cFN + ".cpp", cFN + ".txt", "QtModule", "0x040500" )
         NEXT

         EXIT

      ENDSWITCH
   ELSE
      OutErr( "Missing parameter. Call with: <input>" + hb_eol() )
      nError := 8
   ENDIF

   ErrorLevel( nError )

   RETURN

STATIC FUNCTION FNameDirGet( cFileName )
   LOCAL cDir

   hb_FNameSplit( cFileName, @cDir )

   RETURN cDir

STATIC FUNCTION hbmk_OutStd( hbmk, ... )
   HB_SYMBOL_UNUSED( hbmk )
   RETURN OutStd( ... )

STATIC FUNCTION hbmk_OutErr( hbmk, ... )
   HB_SYMBOL_UNUSED( hbmk )
   RETURN OutErr( ... )

#endif

/* ----------------------------------------------------------------------- */

STATIC FUNCTION uic_to_prg( hbmk, cFileNameSrc, cFileNameDst, cName )
   LOCAL aLinesPRG
   LOCAL cFile

   IF hb_FileExists( cFileNameSrc )
      IF ! Empty( cFile := hb_MemoRead( cFileNameSrc ) )
         IF ! Empty( aLinesPRG := hbqtui_gen_prg( cFile, "hbqtui_" + cName, hbmk ) )
            cFile := ""
            AEval( aLinesPRG, {| cLine | cFile += cLine + hb_eol() } )
            IF hb_MemoWrit( cFileNameDst, cFile )
               RETURN .T.
            ELSE
               hbmk_OutErr( hbmk, hb_StrFormat( "Error: Cannot create file: %1$s", cFileNameDst ) )
            ENDIF
         ELSE
            hbmk_OutErr( hbmk, hb_StrFormat( "Error: Intermediate file (%1$s) is not an .uic file.", cFileNameSrc ) )
         ENDIF
      ELSE
         hbmk_OutErr( hbmk, hb_StrFormat( "Error: Intermediate file (%1$s) empty or cannot be read.", cFileNameSrc ) )
      ENDIF
   ELSE
      hbmk_OutErr( hbmk, hb_StrFormat( "Error: Cannot find intermediate file: %1$s", cFileNameSrc ) )
   ENDIF

   RETURN .F.

/*======================================================================*/

#define WR_PRG( cStr )                            AAdd( ::aLinesPrg, cStr )

#ifndef HBUIC_STANDALONE

STATIC FUNCTION hbqtui_gen_prg( cFile, cFuncName, hbmk )
   LOCAL oHbUic

   oHbUic := THbUIC():New( cFile, cFuncName, hbmk )
   oHbUic:scanInputFile()
   oHbUic:postProcess()

   RETURN oHbUic:aLinesPrg

#endif


CLASS THbUIC

#ifndef HBUIC_STANDALONE
   METHOD New( cTmpFileSrc, cFuncName, hbmk )
#else
   METHOD New( cTmpFileSrc, cUiFile, cOutDir, cFrmFile, cSlotStyle, cTestFile,  cHbmFile, cQrcFile )
#endif

   METHOD regexInit()
   METHOD scanInputFile()
   METHOD getMethodsBounds()
   METHOD pullMainWidget()
   METHOD cleanupLines()
   METHOD concatLines( nFrom, nTo )
   METHOD removeNonImplMethods()
   METHOD replaceConstants()
   METHOD pullWidgets()
   METHOD pullLocalObjects( nStartLine, nEndLine )
   METHOD scanLines( nStart, nEnd )
   METHOD processActions()
   METHOD parseParams( aParams )
   METHOD checkBrackets( cFunc )
   METHOD isWidget( cName )
   METHOD isLocal( cName )
   METHOD isSlot( cName )
   METHOD pullTranslate( cLine )
   METHOD getFuncName( s )
   METHOD concatArgs( aArgs )
   METHOD lineHasTemplate( cLine )
   METHOD exprHasTemplate( cExpr )
   METHOD replcmFuncName( cName )            // replacementFunctions - (fix of errors  or enhancements)

   // --------- POSTPROCESSING OF aLinesPrg ---------

   METHOD postProcess()
   METHOD postRemoveQStringList()            // << insertion operator not processed yet
   METHOD postFormatCode()

   // --------- EXPRESSION PARSERS ---------

   METHOD parseNumeric( s )
   METHOD ParseString( s )
   METHOD parseBool( s )
   METHOD parseVar( s )
   METHOD parseVarDot( s )
   METHOD parseVarPtr( s )
   METHOD parseFunc( s )
   METHOD parseFuncDot( s )
   METHOD parseFuncPtr( s )
   METHOD parseRightPart( s )

   // --------- SPECIAL PARSERS ---------

   METHOD parseSignalSlot( cLine )
   METHOD parseRetranslateUi( cLine )
   METHOD parseTabOrder( cLine )

   // --------- ASSIGNEMENT / NEW PARSERS ---------

   METHOD parseNewFunc( cLine )
   METHOD parseTypVar( s )
   METHOD parseTypFunc( s )
   METHOD parseAssign( s )
   METHOD parseAssignNew( s )
	
   METHOD IsQMainWindowSlot( cSlot )
   METHOD IsQDialogSlot( cSlot )
   METHOD IsQWidgetSlot( cSlot )

   // --------- BUILD METHODS ---------

   METHOD buildHeader()
   METHOD buildClass()
   METHOD buildMethod( cName, nStartLine, nEndLine, cParent )
   METHOD buildCloseMethod()
   METHOD buildMethodUiDestroy()
   METHOD buildMethod_on_error()
   METHOD buildReplacedMethods()

   DATA   hbmk

   // --------- REGULAR EXPRESSIONS ---------

   VAR rxRetransl
   VAR rxSigSlot
   VAR rxTabOrder
   VAR rxIfndef
   VAR rxEndif

   VAR rxNumeric
   VAR rxString
   VAR rxBool
   VAR rxVar
   VAR rxVarDot
   VAR rxVarPtr
   VAR rxFunc
   VAR rxFuncDot
   VAR rxFuncPtr

   VAR rxNewFunc
   VAR rxTypVar
   VAR rxTypFunc
   VAR rxAssign
   VAR rxAssignNew
   VAR arxRemoveFunc                              INIT {}
   VAR arxWrapParams                              INIT {}

   VAR aLineTemplates                             INIT {}
   VAR aSpecialTemplates                          INIT {}
   VAR aExprTemplates                             INIT {}
   VAR aOtherTemplates                            INIT {}

   VAR cTmpFileSrc
   VAR aLinesSrc                                  INIT {}
   VAR aLinesPrg                                  INIT {}

   VAR aWidgets                                   INIT {}
   VAR aLocalObjs                                 INIT {}
   VAR aSlots                                     INIT {}
   VAR aReplcmFunc                                INIT {}   // list or replacement functions {{cOldName,cNewname,lUsed},...}
	
   VAR aNotImplementedMethods                     INIT {}
   VAR nSetupUiStartLine                          INIT 0    // Start line of  void setupUi( ) method
   VAR nSetupUiEndLine                            INIT 0    // End line of  void setupUi( ) method
   VAR nRetranslateUiStartLine                    INIT 0    // Start line of  void retranslateUi( ) method
   VAR nRetranslateUiEndLine                      INIT 0    // End line of  void retranslateUi( ) method

   VAR oWriter
   VAR cFuncName
   VAR cClass
   VAR cSlotStyle
   VAR cFormClass
   VAR cFormName
	
   ENDCLASS


#ifndef HBUIC_STANDALONE

METHOD THbUIC:New( cTmpFileSrc, cFuncName, hbmk )

   LOCAL cSlotStyle

   ::hbmk := hbmk

   ::cTmpFileSrc  := cTmpFileSrc
   ::aLinesSrc := hb_ATokens( StrTran( cTmpFileSrc, Chr( 13 ) ), Chr( 10 ) )
   ::regexInit()

   cSlotStyle := GetEnv( "HBQT_UIC_SLOTSTYLE" )
   ::cSlotStyle := IIF( Empty( cSlotStyle ), 'public', cSlotStyle )
   ::cFuncName := cFuncName
   ::cClass := StrTran( ::cFuncName, "hbqtui_", "ui_" )

   RETURN Self

#else

METHOD THbUIC:New( cTmpFileSrc, cUiFile, cOutDir, cFrmFile, cSlotStyle, cTestFile,  cHbmFile, cQrcFile )

   ::cTmpFileSrc  := cTmpFileSrc
   ::aLinesSrc := hb_ATokens( StrTran( cTmpFileSrc, Chr( 13 ) ), Chr( 10 ) )
   ::regexInit()
   ::cSlotStyle := cSlotStyle
   ::cFuncName := "hbqtui_" + hb_FNameName( cUiFile )
   ::cClass := StrTran( ::cFuncName, "hbqtui_", "ui_" )

   ::oWriter := TWriter():new( self, cUiFile, cOutDir, cFrmFile, cSlotStyle, cTestFile,  cHbmFile, cQrcFile )
	
   // ::aNotImplementedMethods := { "setAccessibleName" }
   // ::aReplcmFunc := { };

   RETURN Self
#endif


#if 0
#define RX_Q_TYPE                                 '(Q\w+)'     // possible promotion to other non Q... clases
#endif
#define RX_Q_TYPE                                 '(\w+)'
#define RX_C_TYPE                                 '(bool|int|char)'
#define RX_ANY_TYPE                               '(bool|int|char|Q\w+)'
#define RX_VAR                                    '([A-Z,a-z,_]\w*)'
#define RX_FUNC                                   '([A-Z,a-z,_]\w*\(.*?\))'
#define RX_ANY                                    '(.*)'
#define RX_NUMERIC                                '(\d+\.?\d*u?)'
#define RX_STRING                                 '(".*")'
#define RX_BOOL                                   '(true|false)'


METHOD THbUIC:regexInit

   // SPECIAL
   ::rxRetransl   := hb_regexComp( '^retranslateUi\(.+' )
   ::rxSigSlot    := hb_regexComp( '^QObject_connect\(.+' )
   ::rxTabOrder   := hb_regexComp( '^QWidget_setTabOrder\(.+' )
   ::rxIfndef     := hb_regexComp( '^#ifndef .+' )
   ::rxEndif      := hb_regexComp( '^#endif .+' )

   // EXPRESSIONS
   ::rxNumeric    := hb_regexComp( hb_StrFormat( '^%s$',                  RX_NUMERIC ) )
   ::rxString     := hb_regexComp( hb_StrFormat( '^%s$',                  RX_STRING ) )
   ::rxBool       := hb_regexComp( hb_StrFormat( '^%s$',                  RX_BOOL ) )
   ::rxVar        := hb_regexComp( hb_StrFormat( '^%s$',                  RX_VAR ) )
   ::rxVarDot     := hb_regexComp( hb_StrFormat( '^%s\.%s$',              RX_VAR, RX_ANY ) )
   ::rxVarPtr     := hb_regexComp( hb_StrFormat( '^%s->%s$',              RX_VAR, RX_ANY ) )
   ::rxFunc       := hb_regexComp( hb_StrFormat( '^%s$',                  RX_FUNC ) )
   ::rxFuncDot    := hb_regexComp( hb_StrFormat( '^%s\.%s$',              RX_FUNC, RX_ANY ) )
   ::rxFuncPtr    := hb_regexComp( hb_StrFormat( '^%s->%s$',              RX_FUNC, RX_ANY ) )

   // CONSTRUCTOR / ASSIGNEMENT
   ::rxNewFunc    := hb_regexComp( hb_StrFormat( '^new %s$',              RX_FUNC ) )
   ::rxTypVar     := hb_regexComp( hb_StrFormat( '^%s \*?%s$',            RX_Q_TYPE, RX_VAR ) )
   ::rxTypFunc    := hb_regexComp( hb_StrFormat( '^%s \*?%s$',            RX_Q_TYPE, RX_FUNC ) )

   ::rxAssign     := hb_regexComp( hb_StrFormat( '^%s \*?%s = %s$',       RX_ANY_TYPE, RX_VAR, RX_ANY ) )
   ::rxAssignNew  := hb_regexComp( hb_StrFormat( '^(%s \*?)?%s = new %s', RX_Q_TYPE, RX_VAR, RX_ANY ) )

   // TEMPLATE              , CODEBLOCK                           , IDENT
   // do not change the order of elements in arrays   !!!
   ::aSpecialTemplates := { ;
      { ::rxRetransl , {| s | ::parseRetranslateUi( s ) }, 3, }, ;
      { ::rxSigSlot  , {| s | ::parseSignalSlot( s ) }, 3, }, ;
      { ::rxTabOrder , {| s | ::parseTabOrder( s ) }, 3, }, ;
      { ::rxIfndef   , {| s | s }, 1, }, ;
      { ::rxEndif    , {| s | s }, 1, } ;
     }

   ::aExprTemplates  := { ;
      { ::rxVarPtr   , {| s | ::parseVarPtr( s ) }, 3, }, ;
      { ::rxVarDot   , {| s | ::parseVarDot( s ) }, 3, }, ;
      { ::rxFunc     , {| s | ::parseFunc( s ) }, 3,{| s| ::checkBrackets( s ) } }, ;
      { ::rxFuncPtr  , {| s | ::parseFuncPtr( s ) }, 3, }, ;
      { ::rxFuncDot  , {| s | ::parseFuncDot( s ) }, 3, }, ;
      { ::rxBool     , {| s | ::parseBool( s ) }, 3, }, ;
      { ::rxVar      , {| s | ::parseVar( s ) }, 3, }, ;
      { ::rxNumeric  , {| s | ::parseNumeric( s ) }, 3, }, ;
      { ::rxString   , {| s | ::ParseString( s ) }, 3, } ;
     }

   ::aOtherTemplates  := { ;
      { ::rxNewFunc  , {| s | ::parseNewFunc( s ) }, 3, }, ;
      { ::rxTypVar   , {| s | ::parseTypVar( s ) }, 3, }, ;
      { ::rxTypFunc  , {| s | ::parseTypFunc( s ) }, 3, }, ;
      { ::rxAssignNew, {| s | ::parseAssignNew( s ) }, 3, }, ;
      { ::rxAssign   , {| s | ::parseAssign( s ) }, 3, } ;
     }

   ::arxRemoveFunc :=  { ;
        hb_regexComp( 'QStringLiteral\((".*")\)' ) ,;
        hb_regexComp( 'QString::fromUtf8\((".*")\)' ) ,;
        hb_regexComp( 'static_cast<Qt::DockWidgetArea>\((\d+)\)' ) ,;
        hb_regexComp( 'QLatin1String\(("[^\]]+")\)' ) ,;
        hb_regexComp( 'Q_UINT64_C\((.*)\)' ),;
        hb_regexComp( 'Q_INT64_C\((.*)\)' );
     }

   ::arxWrapParams := {;
       /* { hb_regexComp( 'setShortcut\((.*)\)') , "QKeySequence"}  */;
     }

   AEval( ::aSpecialTemplates, {| el| AAdd( ::aLineTemplates, el ) } )
   AEval( ::aOtherTemplates  , {| el| AAdd( ::aLineTemplates, el ) } )
   AEval( ::aExprTemplates   , {| el| AAdd( ::aLineTemplates, el ) } )
   AEval( ::aLineTemplates   , {| el| el[ 4 ] := iif( Empty( el[ 4 ] ), {|| .T. }, el[ 4 ] ) } )

   RETURN NIL


METHOD THbUIC:scanInputFile()
	
   IF ! ::getMethodsBounds()
      RETURN NIL
   ENDIF
	
   ::pullMainWidget()
   ::cleanupLines()
   ::removeNonImplMethods()
   ::replaceConstants()
   ::pullWidgets()

   ::buildHeader()
   ::buildClass()
	
   ::buildMethod( "init", ::nSetupUiStartLine, ::nSetupUiEndLine, "oParent" )
   ::scanLines( ::nSetupUiStartLine, ::nSetupUiEndLine )
   IF ! Empty( GetEnv( "HBQT_UIC_GEN_ACTIONS" ) )
      ::processActions()
   ENDIF
   ::buildCloseMethod()
	
   ::buildMethod( "retranslate",  ::nRetranslateUiStartLine, ::nRetranslateUiEndLine, ""  )
   ::scanLines( ::nRetranslateUiStartLine, ::nRetranslateUiEndLine )
   ::buildCloseMethod()

   ::buildMethodUiDestroy()
   ::buildMethod_on_error()
   ::buildReplacedMethods()

   RETURN NIL


METHOD THbUIC:postProcess()

   ::postRemoveQStringList()
   ::postFormatCode()

   RETURN NIL

/*
  Dynamic property of type String list was added to some widget.
  Not processed yet !
*/
METHOD THbUIC:postRemoveQStringList()
   LOCAL i

   FOR i := 1 TO Len( ::aLinesPrg )
      IF Left( ::aLinesPrg[ i ], 5 ) == '** <<'
         ::aLinesPrg[ i - 1 ] := '**' + SubStr( ::aLinesPrg[ i - 1 ], 3 )
      ENDIF
   NEXT

   RETURN NIL


METHOD THbUIC:postFormatCode()
   LOCAL i, cLine, nPos
   LOCAL nMaxColonPoz := 0

   FOR i := 1 TO Len( ::aLinesPrg )
      nMaxColonPoz := Max( nMaxColonPoz, firstColonPos( ::aLinesPrg[ i ] ) )
   NEXT
   nMaxColonPoz := Min( nMaxColonPoz, 40 )

   FOR i := 1 TO Len( ::aLinesPrg )
      cLine := ::aLinesPrg[ i ]
      IF Left( cLine, 1 ) == ' '
         nPos := firstColonPos( cLine )
         IF nPos > 0
            ::aLinesPrg[ i ] := hb_StrFormat( "%s%s:%s", Left( cLine, nPos - 1 ), Space( nMaxColonPoz - nPos ), SubStr( cLine, nPos + 1 ) )
         ENDIF
      ENDIF
   NEXT

   RETURN NIL


STATIC FUNCTION firstColonPos( s )
   RETURN firstPos( s, ':', 6 )


METHOD THbUIC:scanLines( nStart, nEnd )
   LOCAL cLine, nLine, n
	
   FOR nLine := nStart + 1 TO nEnd - 1
      cLine := ::aLinesSrc[ nLine ]

      IF ! Empty( cLine )
         IF ( n := ::lineHasTemplate( cLine ) ) > 0
            WR_PRG( Space( ::aLineTemplates[ n ][ 3 ] ) + Eval( ::aLineTemplates[ n ][ 2 ], cLine ) )
         ELSE
            WR_PRG( '** ' + cLine )
         ENDIF
      ENDIF
   NEXT

   RETURN NIL


METHOD THbUIC:parseParams( aParams )
   LOCAL n, par
   LOCAL aPar := AClone( aParams )

   FOR EACH par IN aPar
      IF ( n := ::exprHasTemplate( par ) ) > 0
         par := Eval( ::aExprTemplates[ n ][ 2 ], par )
      ENDIF
   NEXT

   RETURN aPar


METHOD THbUIC:getMethodsBounds()
   LOCAL nLine

   ::nSetupUiStartLine := AScan( ::aLinesSrc, {| e | "void setupUi" $ e } )
   IF ::nSetupUiStartLine == 0
      RETURN .F.
   ENDIF
   ::nSetupUiEndLine := AScan( ::aLinesSrc, {| e | "// setupUi" $ e }, ::nSetupUiStartLine )
   IF ::nSetupUiEndLine == 0
      RETURN .F.
   ENDIF
   // ::aLinesSrc[ ::nSetupUiStartLine ] := "" // needed for pullMainWidget

   ::nRetranslateUiStartLine := AScan( ::aLinesSrc, {| e | "void retranslateUi" $ e } )
   IF ::nRetranslateUiStartLine == 0
      RETURN .F.
   ENDIF
   ::nRetranslateUiEndLine  := AScan( ::aLinesSrc, {| e | "// retranslateUi" $ e }, ::nRetranslateUiStartLine )
   IF ::nRetranslateUiEndLine == 0
      RETURN .F.
   ENDIF
   ::aLinesSrc[ ::nRetranslateUiStartLine ] := ""
	
   FOR nLine := ::nRetranslateUiEndLine + 1 TO Len( ::aLinesSrc )
      ::aLinesSrc[ nLine ] := ""
   NEXT

   RETURN .T.

/*
 * Extract class and widget name from line: * void setupUi(Qclass  *widget)
 */
METHOD THbUIC:pullMainWidget()
   LOCAL cLine, aReg
   LOCAL regEx := hb_StrFormat( "void setupUi\(%s \*%s\)$", RX_Q_TYPE, RX_VAR  )

   cLine := AllTrim( ::aLinesSrc[ ::nSetupUiStartLine ] )
   IF Empty( aReg := hb_regex( regEx, cLine ) )
      RETURN .F.
   ENDIF

   ::cFormClass := aReg[ 2 ]
   ::cFormName := aReg[ 3 ]
   AAdd( ::aWidgets, { ::cFormClass, ::cFormName } )
   ::aLinesSrc[ ::nSetupUiStartLine ] := ""

   RETURN .T.

/*
 *  Normalize lines (alltrim, remove ";" ,remove comments)
 *  Blank not (yet) used lines
 *  Concat lines ending with '\n"'
 */
METHOD THbUIC:cleanupLines()
   LOCAL cLine, cStr
   LOCAL blankThem := { "QT_BEGIN_NAMESPACE", "QT_END_NAMESPACE",  "namespace ", "class ", ;
                           "public:", "/", "*", "{", "}", "if ", "#include", "QMetaObject" }

   FOR EACH cLine IN ::aLinesSrc
      cLine := AllTrim( cline )
      IF Right( cLine, 1 ) == ";"
         cLine := trimRight( cLine, 1 )
      ENDIF

      //IF Right( cLine, 3 ) == '\n"'
      IF Right( cLine, 1 ) == '"'
         cLine := ::concatLines( cLine:__enumIndex(), Len( ::aLinesSrc ) )
      ENDIF
      FOR EACH cStr IN blankThem
         IF Left( cLine, Len( cStr ) ) == cStr
            cLine := ""
            EXIT
         ENDIF
      NEXT
   NEXT

   RETURN NIL


METHOD THbUIC:concatLines( nFrom, nTo )
   LOCAL cLine, cString                           //FR  -- PREVERI

   cString := stripRight( ::aLinesSrc[ nFrom ], '"' )
   cString := stripRight( cString, '\n' )
   nFrom++
   DO WHILE nFrom <= nTo
      cLine := AllTrim( ::aLinesSrc[ nFrom ] )
      IF ! ( Left( cLine, 1 ) == '"' )
         EXIT
      ENDIF
      cLine := stripRight( cLine, '"' )
      cLine := stripRight( cLine, '\n' )
      cString += SubStr( cLine, 2 )
      ::aLinesSrc[ nFrom ] := ""
      nFrom++
   ENDDO

   RETURN stripRight( cString, ';' )


METHOD THbUIC:removeNonImplMethods()
   LOCAL cLine, cMethod

   IF Len( ::aNotImplementedMethods ) == 0
      RETURN NIL
   ENDIF
   FOR EACH cLine IN ::aLinesSrc
      IF ! Empty( cLine )
         FOR EACH cMethod IN ::aNotImplementedMethods
            IF cMethod $ cLine
               cLine := ""
               EXIT
            ENDIF
         NEXT
      ENDIF
   NEXT

   RETURN NIL

/*
 *  Only params - remove function :
 *      1. QStringLiteral("xxx")                 -> "xxx"
 *      2. QString::fromUtf8("xxxx")             -> "xxx"
 *      3. static_cast<Qt::DockWidgetArea>(n)    -> n
 *      4. QLatin1String("xxx")                  -> "xxx"
 *      5. Q_UINT64_C(ddd)                       -> ddd
 *      6. Q_INT64_C(ddd)                        -> ddd
 *
 *      7. QString()                             -> ""
 *      8. Qxx::a1|Qyy::a2 | ...                 -> hb_bitOr(Qxx::a1,Qyy::a2, ...)
 *  Wrap params to function:
 *      1. setShortcut( xxxx )                   -> setShortcut(QKeySequence( xxx ))
 *
 *  Remove at start of the line:
 *      1. const
 *
 *  Transform:
 *      1. "::"                                  -> "_"
 */
// __qtreewidgetitem->setTextAlignment(1, Qt::AlignLeft|Qt::AlignBottom);

METHOD THbUIC:replaceConstants()
   LOCAL cLine, cRepl, rx, aResult, i, cStr
   LOCAL aregw1 := { hb_regexComp( 'setShortcut\((.*)\)') , "QKeySequence" }
   LOCAL regd1  := hb_regexComp( hb_StrFormat( "((%s::%s)(\|%s::%s)+)", RX_Q_TYPE, RX_VAR, RX_Q_TYPE, RX_VAR ) )
   LOCAL regd2  := hb_regexComp( "\b[A-Za-z_]+::[A-Za-z0-9_]+\b" )

   FOR EACH cLine IN ::aLinesSrc
      IF ! Empty( cLine )
         cLine := ::pullTranslate( cLine )
			
         FOR EACH rx in ::arxRemoveFunc
            cLine := keepOnlyParams( rx, cLine )
         NEXT

         FOR EACH rx in ::arxWrapParams
            cLine := wrapParams( rx[ 1 ], cLine, rx[ 2 ] )
         NEXT

         /* SPECIAL TREATMENT - POSSSIBLE UIC ERROR */
         IF ! Empty( hb_regex( aregw1[ 1 ], cLine ) ) .AND. ! ( aregw1[ 2 ] $ cLine )
            cLine := wrapParams( aregw1[ 1 ], cLine, aregw1[ 2 ] )
         ENDIF

         cLine := StrTran( cLine, 'QString()', '""' )

         IF hb_regexHas( regd1, cLine )
            aResult := hb_regex( regd1, cLine )
            cRepl   := StrTran( aResult[ 1 ], '|', ',' )
            cLine   := StrTran( cLine, aResult[ 1 ], hb_StrFormat( "hb_bitOr(%s)", cRepl ) )
         ENDIF

         IF hb_regexHas( "^const .*", cLine )
            cLine   := StrTran( cLine, "const " )
         ENDIF

         aResult := hb_regexAll( regd2, cLine )
         FOR i:=1 TO Len( aResult )
             cStr:=aResult[ i, 1 ]
             IF ! BetwenDblQuotes( cStr, cLine )
                cLine := StrTran( cLine, cStr, StrTran( cStr, "::", "_" ) )
             ENDIF
         NEXT
      ENDIF
   NEXT

   RETURN NIL


STATIC FUNCTION BetwenDblQuotes( cStr1, cStr2 )     // test for cStr1 cointained in cStr2 between  ""
   LOCAL cReg := hb_StrFormat( '".*%s.*"', cStr1 )

   RETURN ! Empty( hb_regex( cReg, cStr2 ) )


STATIC FUNCTION keepOnlyParams( regx, cStr )
   LOCAL aResult, nAt, nLen

   IF ! Empty( aResult := hb_regex( regx, cStr ) )
      nAt := At( aResult[ 1 ], cStr )
      nLen:= Len( aResult[ 1 ] )
      RETURN hb_StrFormat( "%s%s%s", Left( cStr, nAt - 1 ), aResult[ 2 ], SubStr( cStr, nAt + nLen ) )
   ENDIF

   RETURN cStr


STATIC FUNCTION wrapParams( regx, cStr, cWrap )
   LOCAL aResult, nAt, nLen

   IF ! Empty( aResult := hb_regex( regx, cStr ) )
      nAt := At( aResult[ 2 ], cStr )
      nLen:= Len( aResult[ 2 ] )
      RETURN hb_StrFormat( "%s%s(%s)%s", Left( cStr, nAt - 1 ), cWrap, aResult[ 2 ], SubStr( cStr, nAt + nLen ) )
   ENDIF

   RETURN cStr


METHOD THbUIC:pullTranslate( cLine )
   LOCAL aResult, aArgs
   LOCAL reg := hb_regexComp( "(.+)QApplication::translate(\(.+, 0\))" )
	
   IF hb_regexHas( reg, cLine )
      aResult    := hb_regex( reg, cLine )
      aArgs      := args2array( aResult[ 3 ] )
      aArgs[ 2 ] := ::ParseString( aArgs[ 2 ] )
      aArgs[ 3 ] := '""'
      cLine      := hb_StrFormat( "%s QApplication().translate(%s))", aResult[ 2 ], ::concatArgs( aArgs ) )
   ENDIF
   RETURN cLine

/*
 *    All widgets are declared  Qxxxxx  *name
 *    Source is scanned from the beginning to  ::nSetupUiStartLine (Start line of setupUi method)
 *    A line containing declaration is cleared
 */
METHOD THbUIC:pullWidgets()
   LOCAL i, cLine
   LOCAL cCls, cNam
   LOCAL regEx := hb_StrFormat( "^%s \*%s$", RX_Q_TYPE, RX_VAR  )
   LOCAL aReg

   FOR i := 1 TO ::nSetupUiStartLine - 1
      cLine := ::aLinesSrc[ i ]
      IF !Empty( cLine )
         IF !Empty( aReg := hb_regex( regEx, cLine ) )
            cCls := aReg[ 2 ]
            cNam := aReg[ 3 ]
            ::aLinesSrc[ i ] := ""
         ELSE
            cCls := ""
         ENDIF
         IF ! Empty( cCls )
            IF ! ::isWidget( cNam )
               AAdd( ::aWidgets, { cCls, cNam } )
            ENDIF
         ENDIF
      ENDIF
   NEXT
   RETURN .T.

/*
 *    Local objects are declared/defined inside setupUI and retranslateUi methods like
 *    1. Qxxx [*] name [...]
 *    2  [const] bool __sortingEnabled = treeWidget->isSortingEnabled();   // "const " before bool allready removed
 */
METHOD THbUIC:pullLocalObjects( nStartLine, nEndLine )
   LOCAL i, cLine, cCls, cNam, aReg
   LOCAL regEx1 := hb_StrFormat( "^%s \*?%s.*", RX_Q_TYPE, RX_VAR  )
   LOCAL regEx2 := hb_StrFormat( "^%s %s .*",   RX_C_TYPE, RX_VAR )
	
   ::aLocalObjs := {}

   FOR i := nStartLine TO nEndLine
      cLine := ::aLinesSrc[ i ]
      IF ! Empty( cLine )
         IF hb_regexHas( regEx1, cLine )
            aReg := hb_regex( regEx1, cLine )
            cCls := aReg[ 2 ]
            cNam := aReg[ 3 ]
         ELSEIF hb_regexHas( regEx2, cLine )
            aReg := hb_regex( regEx2, cLine )
            cCls := aReg[ 2 ]
            cNam := aReg[ 3 ]
         ELSE
            cCls := ""
         ENDIF
         IF ! Empty( cCls )
            IF ! ::isLocal( cNam )
               AAdd( ::aLocalObjs, { cCls, cNam } )
            ENDIF
         ENDIF
      ENDIF
   NEXT
   RETURN .T.


METHOD THbUIC:lineHasTemplate( cLine )
   RETURN stringHasTemplate( cLine, ::aLineTemplates )


METHOD THbUIC:exprHasTemplate( cExpr )
   RETURN stringHasTemplate( cExpr, ::aExprTemplates )


STATIC FUNCTION stringHasTemplate( s, aTmpl )
   LOCAL el

   FOR EACH el IN aTmpl
      IF hb_regexHas( el[ 1 ], s ) .AND. Eval( el[ 4 ], s )
         RETURN el:__enumIndex()
      ENDIF
   NEXT
   RETURN 0


METHOD THbUIC:isWidget( cName )
   RETURN  AScan( ::aWidgets, {| el| el[ 2 ] == cName } ) != 0


METHOD THbUIC:isLocal( cName )
   RETURN  AScan( ::aLocalObjs, {| el| el[ 2 ] == cName } ) != 0


METHOD THbUIC:isSlot( cName )
   RETURN  AScan( ::aSlots, {| el| el[ 2 ] == cName } ) != 0


METHOD THbUIC:replcmFuncName( cName )
   LOCAL i := AScan( ::aReplcmFunc, {| el| el[ 1 ] == cName } )

   IF i > 0
      ::aReplcmFunc[ i, 3 ] := .T.
      cName := ::aReplcmFunc[ i, 2 ]
   ENDIF
   RETURN  cName


METHOD THbUIC:getFuncName( s )
   RETURN AllTrim( Left( s, At( "(", s ) -1 ) )


METHOD THbUIC:parseSignalSlot( cLine )
   LOCAL aPar, cSnd, cSig, cRcv, cSlot, cCall1, cSlot2, cCall2, cCall, cSl2Ps, cxSlot

   aPar  := args2array( cLine )
   cSnd  := aPar[ 1 ]
   cSig  := getFunParsStr( aPar[ 2 ] )
   cRcv  := aPar[ 3 ]
   cSlot := getFunParsStr( aPar[ 4 ] )

   cCall1 := hb_StrFormat( 'hbqt_connect(::%s,"%s",::%s,"%s")', cSnd, cSig, cRcv, cSlot )
   cSl2Ps := getFunParsStr( cSlot )
   IF !Empty( cSl2Ps )
      cSlot2 := StrTran( cSlot, cSl2Ps, hb_StrFormat( "::%s,Self,...", cSnd ) )
   ELSE
      cSlot2 := hb_StrFormat( "%s(%s)", ::getFuncName( cSlot ), hb_StrFormat( "::%s,Self,...", cSnd ) )
   ENDIF

   cCall2 := hb_StrFormat( 'hbqt_connect(::%s,"%s",{|...| %s})', cSnd, cSig, IIF( ::cSlotStyle == 'method', '::', '' ) + cSlot2 )

   cxSlot := ::getFuncName( cSlot )
   IF ::IsQMainWindowSlot( cxSlot, 0 ) .OR. ::IsQDialogSlot( cxSlot, 0 ) .OR. ::IsQWidgetSlot( cxSlot, 0 ) .OR. cRcv != ::cFormName
      cCall := cCall1
   ELSE
      cCall := cCall2
      IF !::isSlot( ::getFuncName( cSlot ) )
         AAdd( ::aSlots, { cSlot2, ::getFuncName( cSlot ) } )
      ENDIF
   ENDIF

   RETURN cCall


METHOD THbUIC:IsQMainWindowSlot( cSlot )

   STATIC s_b_ := { ;
      "setAnimated"                        =>  1, ;
      "setDockNestingEnabled"              =>  1, ;
      "setUnifiedTitleAntToolbarOnMac"     =>  1   }

   RETURN cSlot $ s_b_ // .AND.  s_b_


METHOD THbUIC:IsQDialogSlot( cSlot )

   STATIC s_b_ := { ;
      "accept"                              => 0, ;
      "done"                                => 1, ;
      "exec"                                => 0, ;
      "open"                                => 0, ;
      "reject"                              => 0, ;
      "showExtension"                       => 1   }

   RETURN cSlot $ s_b_ // .AND.  s_b_


METHOD THbUIC:IsQWidgetSlot( cSlot )

   STATIC s_b_ := { ;
      "close"                                => 0, ;
      "deleteLater"                          => 0, ;
      "hide"                                 => 0, ;
      "lower"                                => 0, ;
      "raise"                                => 0, ;
      "repaint"                              => 0, ;
      "setFocus"                             => 0, ;
      "show"                                 => 0, ;
      "showFullScreen"                       => 0, ;
      "showMaximized"                        => 0, ;
      "showMinimized"                        => 0, ;
      "showNormal"                           => 0, ;
      "update"                               => 0   }

   RETURN cSlot $ s_b_ // .AND.  s_b_


METHOD THbUIC:parseTabOrder( cLine )
   LOCAL aPar

   /* QWidget_set_tab_order(radioButton_2, radioButton_3); */
   aPar := args2array( cLine )

   RETURN hb_StrFormat( "::setTabOrder( ::%s, ::%s )", aPar[ 1 ], aPar[ 2 ] )


METHOD THbUIC:parseRetranslateUi( cLine )
   LOCAL aPar

   /* retranslateUi(MainWindow) */
   aPar := args2array( cLine )

   RETURN hb_StrFormat( "::retranslate( ::%s )", aPar[ 1 ] )


METHOD THbUIC:parseNumeric( s )
   RETURN StrTran( s, 'u' )


METHOD THbUIC:ParseString( s )
   RETURN 'e' + s


METHOD THbUIC:parseBool( s )
   RETURN IIF( s == 'true', ".T.", ".F." )


METHOD THbUIC:parseVar( s )
   LOCAL aResult, cName

   aResult := hb_regex( ::rxVar, s )
   cName   := aResult[ 2 ]

   RETURN hb_StrFormat( "%s%s", iif( ::isWidget( cName ), '::', '' ), cName )


METHOD THbUIC:parseVarDot( s )
   LOCAL aResult, cName, cRest

   aResult  := hb_regex( ::rxVarDot, s )
   cName    := aResult[ 2 ]
   cRest    := aResult[ 3 ]

   RETURN hb_StrFormat( "%s :  %s", ::parseVar( cName ), ::parseRightPart( cRest ) )


METHOD THbUIC:parseVarPtr( s )
   LOCAL aResult, cName, cRest

   aResult := hb_regex( ::rxVarPtr, s )
   cName   := aResult[ 2 ]
   cRest   := aResult[ 3 ]

   RETURN hb_StrFormat( "%s :  %s", ::parseVar( cName ), ::parseRightPart( cRest ) )


METHOD THbUIC:parseFunc( s )
   LOCAL aResult, cName, aArgs

   aResult := hb_regex( ::rxFunc, s )
   cName   := ::replcmFuncName( ::getFuncName( aResult[ 2 ] ) )
   aArgs   := args2array( aResult[ 2 ] )
   aArgs   := ::parseParams( aArgs )

   RETURN hb_StrFormat( "%s%s( %s )", iif( ::isWidget( cName ), '::', '' ), cName, ::concatArgs( aArgs ) )


METHOD THbUIC:parseFuncDot( s )
   LOCAL aResult, cFunc, cRest

   aResult := hb_regex( ::rxFuncDot, s )
   cFunc   := aResult[ 2 ]
   cRest   := aResult[ 3 ]

   RETURN hb_StrFormat( "%s :  %s", ::parseFunc( cFunc ), ::parseRightPart( cRest ) )


METHOD THbUIC:parseFuncPtr( s )
   LOCAL aResult, cFunc, cRest

   aResult := hb_regex( ::rxFuncPtr, s )
   cFunc   := aResult[ 2 ]
   cRest   := aResult[ 3 ]

   RETURN hb_StrFormat( "%s :  %s", ::parseFunc( cFunc ), ::parseRightPart( cRest ) )


METHOD THbUIC:parseRightPart( s )
   LOCAL n
   LOCAL cRetV := ''

   IF ( n := ::exprHasTemplate( s ) ) > 0
      cRetV := Eval( ::aExprTemplates[ n ][ 2 ], s )
   ENDIF

   RETURN cRetV


METHOD THbUIC:parseAssign( s )
   LOCAL aResult, cName, cRest

   aResult := hb_regex( ::rxAssign, s )
   cName   := aResult[ 3 ]
   cRest   := aResult[ 4 ]

   RETURN hb_StrFormat( "%s := %s", ::parseVar( cName ), ::parseRightPart( cRest ) )


METHOD THbUIC:parseAssignNew( s )
   LOCAL aResult, cName, cRest, nLen

   aResult := hb_regex( ::rxAssignNew, s )
   nLen    := Len( aResult )
   cName   := aResult[ nLen - 1 ]
   cRest   := aResult[ nLen ]

   RETURN hb_StrFormat( "%s := %s", ::parseVar( cName ), ::parseRightPart( cRest ) )


METHOD THbUIC:checkBrackets( cFunc )
   LOCAL lRetV := .T.
   LOCAL aPars := args2Array( cFunc )

   AEval( aPars,{| par | lRetV := lRetV .AND. par != NIL } )

   RETURN  lRetV


METHOD THbUIC:parseNewFunc( cLine )
   LOCAL aArgs, cConstr
   LOCAL aResult := hb_regex( ::rxNewFunc, cLine )

   cConstr := ::replcmFuncName( ::getFuncName( StrTran( aResult[ 1 ], "new" ) ) )
   aArgs   := ::parseParams( args2array( aResult[ 2 ] ) )

   RETURN  hb_StrFormat( "%s( %s )", cConstr, ::concatArgs( aArgs ) )


METHOD THbUIC:parseTypVar( s )
   LOCAL cName, cClass
   LOCAL aResult := hb_regex( ::rxTypVar, s )

   cClass := aResult[ 2 ]
   cName  := aResult[ 3 ]
	
   RETURN hb_StrFormat( "%s := %s()", cName, cClass )


METHOD THbUIC:parseTypFunc( s )
   LOCAL cName, aArgs, cConstr
   LOCAL aResult := hb_regex( ::rxTypFunc, s )

   cConstr   := ::replcmFuncName( aResult[ 2 ] )
   cName     := ::getFuncName( aResult[ 3 ] )
   aArgs     := ::parseParams( args2array( aResult[ 3 ] ) )

   RETURN  hb_StrFormat( "%s%s := %s( %s )", iif( ::isWidget( cName ), '::', '' ), cName, cConstr, ::concatArgs( aArgs ) )


METHOD THbUIC:concatArgs( aArgs )
   LOCAL i
   LOCAL cPars := ""

   FOR i := 1 TO Len( aArgs )
      cPars += aArgs[ i ] + ', '
   NEXT

   RETURN stripComma( cPars )


// *******************************
// building
// *******************************

METHOD THbUIC:buildHeader()

   WR_PRG( "/* WARNING: Automatically generated source file. DO NOT EDIT! */" )
   WR_PRG( "" )
   WR_PRG( '#include "hbqtgui.ch"' )
   WR_PRG( '#include "hbclass.ch"' )
   WR_PRG( '#include "error.ch"' )
   WR_PRG( "" )
   WR_PRG( "" )
   WR_PRG( "FUNCTION " + ::cFuncName + "( oParent )" )
   WR_PRG( "   RETURN " + StrTran( ::cFuncName, "hbqtui_", "ui_" ) + "():new( oParent )" )
   WR_PRG( "" )
   WR_PRG( "" )

   RETURN NIL


METHOD THbUIC:buildClass()
   LOCAL item

   WR_PRG( hb_StrFormat( "CLASS %s", ::cClass ) )
   WR_PRG( "" )
   WR_PRG( "   VAR    oWidget" )
   FOR EACH item IN ::aWidgets
      WR_PRG( "   VAR    " + item[ 2 ] )
   NEXT
   WR_PRG( "" )
   WR_PRG( "   METHOD init( oParent )" )
   WR_PRG( "   ACCESS widget()                                INLINE ::oWidget" )
   WR_PRG( "   METHOD destroy()" )
   WR_PRG( "   METHOD retranslate()" )
   WR_PRG( "" )
   WR_PRG( "   ERROR HANDLER __OnError( ... )" )
   WR_PRG( "" )
   WR_PRG( "" )
   WR_PRG( "   ENDCLASS" )
   WR_PRG( "" )
   WR_PRG( "" )

   RETURN NIL

/*
  oActNew:connect( "triggered(bool)", {|w,l| FileDialog( "New" , w, l ) } )
  hbqt_connect(%s,"triggered(bool)",{|...| ::toolButtonClicked(::toolButton_2,Self,...)})
  hbqt_connect(::%s,"triggered(bool)",{|...| ::%s_triggered(::toolButton_2,Self,...)})
*/
METHOD THbUIC:processActions()
   LOCAL item, cAct

   FOR EACH item IN ::aWidgets
      IF At( "QAction", item[ 1 ] ) > 0
         cAct := item[ 2 ]
         AAdd( ::aSlots, { cAct + '_triggered', cAct + '_triggered(x,oWnd)' } )
         IF ::cSlotStyle == 'method'
            WR_PRG( hb_StrFormat( '   hbqt_connect(::%s,"triggered(bool)",{|...| ::%s_triggered(::%s,Self,...)})', cAct, cAct, cAct ) )
         ELSE
            WR_PRG( hb_StrFormat( '   hbqt_connect(::%s,"triggered(bool)",{|...|   %s_triggered(::%s,Self,...)})', cAct, cAct, cAct ) )
         ENDIF
      ENDIF
   NEXT

   RETURN NIL


METHOD THbUIC:buildMethod( cName, nStartLine, nEndLine, cParent )
   LOCAL item

   ::pullLocalObjects( nStartLine, nEndLine )

   WR_PRG( hb_StrFormat( "METHOD %s:%s(%s)", ::cClass, cName, cParent ) )

   FOR EACH item IN ::aLocalObjs
      WR_PRG( "   LOCAL " + item[ 2 ] )
   NEXT
   WR_PRG( "" )
	
   IF nStartLine == ::nSetupUiStartLine
      SWITCH ::cFormClass
      CASE "QDialog"
         WR_PRG( "   ::oWidget := QDialog( oParent )" )
         EXIT
      CASE "QWidget"
         WR_PRG( "   ::oWidget := QWidget( oParent )" )
         EXIT
      CASE "QMainWindow"
         WR_PRG( "   ::oWidget := QMainWindow( oParent )" )
         EXIT
      ENDSWITCH
      WR_PRG( hb_StrFormat( "   ::%s:= ::oWidget", ::cFormName ) )
      WR_PRG( "" )
   ENDIF

   RETURN NIL


METHOD THbUIC:buildCloseMethod()

   WR_PRG( "" )
   WR_PRG( "   RETURN NIL" )
   WR_PRG( "" )
   WR_PRG( "" )

   RETURN NIL


METHOD THbUIC:buildMethod_on_error()

   WR_PRG( "METHOD " + ::cClass + ":__OnError( ... )" )
   WR_PRG( "   LOCAL cMsg := __GetMessage()" )
   WR_PRG( "   LOCAL oError" )
   WR_PRG( "" )
   WR_PRG( '   IF SubStr( cMsg, 1, 1 ) == "_"' )
   WR_PRG( "      cMsg := SubStr( cMsg, 2 )" )
   WR_PRG( "   ENDIF" )
   WR_PRG( "" )
   WR_PRG( '   IF Left( cMsg, 2 ) == "Q_"' )
   WR_PRG( "      IF __objHasMsg( Self, SubStr( cMsg, 3 ) )" )
   WR_PRG( "         cMsg := SubStr( cMsg, 3 )" )
   WR_PRG( "         RETURN ::&cMsg" )
   WR_PRG( "      ELSE" )
   WR_PRG( "         WITH OBJECT oError := ErrorNew()" )
   WR_PRG( "            :severity    := ES_ERROR" )
   WR_PRG( "            :genCode     := EG_ARG" )
   WR_PRG( '            :subSystem   := "HBQT" ' )
   WR_PRG( "            :subCode     := 1001" )
   WR_PRG( "            :canRetry    := .F." )
   WR_PRG( "            :canDefault  := .F." )
   WR_PRG( "            :args        := hb_AParams()" )
   WR_PRG( "            :operation   := ProcName()" )
   WR_PRG( '            :description := hb_StrFormat("Control <%s> does not exist",SubStr( cMsg, 3 ))' )
   WR_PRG( "         ENDWITH" )
   WR_PRG( "" )
   WR_PRG( "         Eval( ErrorBlock(), oError )" )
   WR_PRG( "      ENDIF" )
   WR_PRG( "   ELSEIF ! Empty( ::oWidget )" )
   WR_PRG( "      RETURN ::oWidget:&cMsg( ... )" )
   WR_PRG( "   ENDIF" )
   WR_PRG( "" )
   WR_PRG( "   RETURN NIL" )
   WR_PRG( "" )
   WR_PRG( "" )

   RETURN NIL


METHOD THbUIC:buildMethodUiDestroy()
   LOCAL item

   WR_PRG( "METHOD " + ::cClass + ":destroy()" )
   FOR EACH item IN ::aWidgets
      IF item:__enumIndex() > 1
         WR_PRG( "   ::" + item[ 2 ] + ":= NIL" )
      ENDIF
   NEXT
   WR_PRG( "" )
   WR_PRG( "   ::oWidget:setParent( QWidget() )" )
   WR_PRG( "   ::oWidget := NIL" )
   WR_PRG( "" )
   WR_PRG( "   RETURN NIL" )
   WR_PRG( "" )
   WR_PRG( "" )

   RETURN NIL


METHOD THbUIC:buildReplacedMethods()
   LOCAL el
   LOCAL nLnCnt := 0

   FOR EACH el IN ::aReplcmFunc
      IF el[ 3 ]
      ENDIF
   NEXT

   IF nLnCnt > 0
      WR_PRG( "" )
      WR_PRG( "" )
   ENDIF

   RETURN NIL


STATIC FUNCTION getFunParsStr( cStr )
   LOCAL n1 := At( '(', cStr )
   LOCAL n2 := RAt( ')', cStr )

   IF n2 == 0
      n2 := Len( cStr ) + 1
   ENDIF

   RETURN SubStr( cStr, n1 + 1, n2 - 1 - n1 )


STATIC FUNCTION args2array( cStr )
   LOCAL i
   LOCAL cArgs := getFunParsStr( cStr )
   LOCAL aArgs := {}

   i := 1
   DO WHILE i <= Len( cArgs  )
      AAdd( aArgs, nextArgToken( cArgs, @i ) )
      i++
   ENDDO

   RETURN aArgs


STATIC FUNCTION nextArgToken( cArgs, i )
   LOCAL ch, chOld := '', cToken := '', braCnt := 0, inString := .F.

   DO WHILE i <= Len( cArgs )
      ch := SubStr( cArgs, i, 1 )
      IF ch == "(" .AND. ! inString
         braCnt++
      ENDIF
      IF ch == ")" .AND. ! inString
         braCnt--
      ENDIF
      IF braCnt < 0
         RETURN NIL
      ENDIF
      IF ch == '"' .AND. chOld != '\'
         inString := ! inString
      ENDIF

      IF ch == "," .AND. braCnt == 0 .AND. ! inString
         EXIT
      ENDIF
      cToken += ch
      i++
      chOld := ch
   ENDDO

   RETURN AllTrim( cToken )


STATIC FUNCTION firstPos( s, c, i )
   LOCAL ch, chOld := '',  braCnt := 0, inString := .F.

   DO WHILE i <= Len( s )
      ch := SubStr( s, i, 1 )
      IF ch == "(" .AND. ! inString
         braCnt++
      ENDIF
      IF ch == ")" .AND. ! inString
         braCnt--
      ENDIF
      IF ch == '"' .AND. chOld != '\'
         inString := ! inString
      ENDIF

      IF ch == c .AND. braCnt == 0 .AND. ! inString
         EXIT
      ENDIF
      i++
      chOld := ch
   ENDDO

   RETURN iif( i < Len( s ), i, 0 )


STATIC FUNCTION stripRight( s, cStrip )
   LOCAL nLen := Len( cStrip )

   RETURN iif( Right( s, nLen ) == cStrip, trimRight( s, nLen ), s )


STATIC FUNCTION stripComma( s )
   RETURN stripRight( s, ', ' )


STATIC FUNCTION trimRight( s,n )
   RETURN Left( s, Len( s ) -n )

/*======================================================================*/

STATIC FUNCTION qth_to_src( cQTHFileName, cCPPFileName, cDOCFileName, cQtModule, cQtVer )
   LOCAL oSrc

   oSrc := HbQtSource():new( cQtModule, cQtVer, cQTHFileName, cCPPFileName, cDOCFileName )
   oSrc:build()

   RETURN .T.

/*----------------------------------------------------------------------*/

CREATE CLASS HbQtSource

   VAR    cCPPFileName, cDOCFileName
   VAR    hRef

   VAR    cQtModule
   VAR    cQtVer
   VAR    cQtObject

   VAR    aMethods                                INIT {}

   VAR    isList                                  INIT .F.
   VAR    isDestructor                            INIT .T.
   VAR    isConstructor                           INIT .F.
   VAR    isQtObjectAvailable                     INIT .F.
   VAR    isObject                                INIT .T.
   VAR    isDetached                              INIT .F.
   VAR    areMethodsClubbed                       INIT .T.

   VAR    class_                                  INIT {}
   VAR    subCls_                                 INIT {}
   VAR    docum_                                  INIT {}
   VAR    code_                                   INIT {}
   VAR    cls_                                    INIT {}
   VAR    new_                                    INIT {}
   VAR    newW_                                   INIT {}
   VAR    old_                                    INIT {}
   VAR    enums_                                  INIT {}
   VAR    enum_                                   INIT {}
   VAR    protos_                                 INIT {}
   VAR    varbls_                                 INIT {}
   VAR    slots_                                  INIT {}

   VAR    dummy_                                  INIT {}
   VAR    func_                                   INIT { { "", 0 } }
   VAR    txt_                                    INIT {}
   VAR    cmntd_                                  INIT {}
   VAR    doc_                                    INIT {}
   VAR    constructors_                           INIT {}

   VAR    nFuncs                                  INIT 0
   VAR    nCnvrtd                                 INIT 0

   VAR    cFunc
   VAR    cTrMode

   VAR    cInt                                    INIT "int,qint8,quint8,qint16,quint16,short,ushort,unsigned,GLuint,GLenum,GLint,GLsizei,GLclampf"
   VAR    cIntLong                                INIT "qint32,quint32,QRgb,qgl_GLsizeiptr,qgl_GLintptr"
   VAR    cIntLongLong                            INIT "qint64,quint64,qlonglong,qulonglong,ulong,qintptr,quintptr"

   VAR    lPaintEvent                             INIT .F.
   VAR    lBuildExtended                          INIT .F.
   VAR    lQtVerLessThan                          INIT .F.
   VAR    cQtVerLessThan                          INIT ""

   METHOD new( cQtModule, cQtVer, cQTHFileName, cCPPFileName, cDOCFileName )
   METHOD parseProto( cProto, fBody_ )
   METHOD parseVariables( cProto )
   METHOD build()
   METHOD exploreExtensions()
   METHOD getConstructor()
   METHOD getConstructorW()
   METHOD buildCppCode( oMtd )
   METHOD buildMethodBody( oMtd )
   METHOD buildDOC()
   METHOD getMethodBody( oMtd, cMtdName, aMethods )
   METHOD normalizeCmd( oMtd, v )
   METHOD getReturnAsList( oMtd, FP, cPrefix )
   METHOD getReturnMethod( oMtd, lAddRet )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtSource:new( cQtModule, cQtVer, cQTHFileName, cCPPFileName, cDOCFileName )
   LOCAL cQth, s, n, i, n1, b_, tmp, cOrg, fBody_
   LOCAL f

   ::hRef := { => }
   hb_HKeepOrder( ::hRef, .T. )

   IF Empty( GetEnv( "HBQT_BUILD_TR_LEVEL" ) )
      ::cTrMode := "HB_TR_DEBUG"
   ELSE
      ::cTrMode := Upper( GetEnv( "HBQT_BUILD_TR_LEVEL" ) )
      IF ! ( ::cTrMode $ "HB_TR_ALWAYS,HB_TR_WARNING,HB_TR_ERROR" )
         ::cTrMode := "HB_TR_DEBUG"
      ENDIF
   ENDIF

   hb_fNameSplit( cQTHFileName,, @tmp )

   ::cCPPFileName := cCPPFileName
   ::cDOCFileName := cDOCFileName

   ::cQtModule    := cQtModule
   ::cQtVer       := cQtVer
   IF Empty( ::cQtVer )
      ::cQtVer := "0x040500"
   ENDIF

   ::cQtObject    := tmp

   cQth := hb_MemoRead( cQTHFileName )

   /* Prepare to be parsed properly */
   IF !( hb_eol() == Chr( 10 ) )
      cQth := StrTran( cQth, hb_eol(), Chr( 10 ) )
   ENDIF
   IF !( hb_eol() == Chr( 13 ) + Chr( 10 ) )
      cQth := StrTran( cQth, Chr( 13 ) + Chr( 10 ), Chr( 10 ) )
   ENDIF

   IF ! Empty( ::class_:= hbqtgen_PullOutSection( @cQth, "CLASS" ) )
      FOR EACH s IN ::class_
         IF ( n := at( "=", s ) ) > 0
            AAdd( ::cls_, { AllTrim( SubStr( s, 1, n - 1 ) ), AllTrim( SubStr( s, n + 1 ) ) } )
         ENDIF
      NEXT
   ENDIF

   /* Explore if protected methods are to be implemented */
   ::exploreExtensions()

   /* Reassign class level version information */
   IF ( n := AScan( ::cls_, {| e_ | upper( e_[ 1 ] ) == "VERSION" } ) ) > 0
      IF ! Empty( ::cls_[ n, 2 ] )
         ::cQtVer := ::cls_[ n, 2 ]
      ENDIF
   ENDIF
   IF ( n := AScan( ::cls_, {| e_ | upper( e_[ 1 ] ) == "VERSIONUPTO" } ) ) > 0
      IF ! Empty( ::cls_[ n, 2 ] )
         ::cQtVerLessThan := ::cls_[ n, 2 ]
         ::lQtVerLessThan := .T.
      ENDIF
   ENDIF

   /* Pull out SUBCLASS section */
   ::subCls_ := hbqtgen_PullOutSection( @cQth, "SUBCLASS" )

   /* Pull out Doc Section */
   ::docum_  := hbqtgen_PullOutSection( @cQth, "DOC"   )

   /* Pull out Code Section */
   ::code_   := hbqtgen_PullOutSection( @cQth, "CODE"   )

   /* Separate constructor function */
   ::new_:= {}
   f := "HB_FUNC( QT_" + Upper( ::cQtObject ) + " )"
// ::cFunc := "HB_FUNC_STATIC( NEW )"
   ::cFunc := "HB_FUNC_STATIC( INIT )"

   n := AScan( ::code_, {| e | f $ e } )

   AAdd( ::new_, ::cFunc )
   FOR i := n + 1 TO Len( ::code_ )
      AAdd( ::new_, ::code_[ i ] )
      IF RTrim( ::code_[ i ] ) == "}"
         n1 := i
         EXIT
      ENDIF
   NEXT
   ::old_ :={}
   FOR i := 1 TO Len( ::code_ )
      IF i < n .or. i > n1
         AAdd( ::old_, ::code_[ i ] )
      ENDIF
   NEXT
   ::code_ := ::old_

   ::newW_:= aClone( ::new_ )
   ::newW_[ 1 ] := "HB_FUNC( " + Upper( ::cQtObject ) + " )"

   /* Pullout constructor methods */
   #if 0
   tmp := ::cQtObject + " ("
   FOR EACH s IN ::code_
      IF ( n := at( tmp, s ) ) > 0 .AND. ! ( "~" $ s )
         AAdd( ::constructors_, SubStr( s, n ) )
      ENDIF
   NEXT
   #endif

   /* Pull out Enumerators  */
   ::enums_:= hbqtgen_PullOutSection( @cQth, "ENUMS"  )
   ::enum_:= {}

   FOR EACH s IN ::enums_
      s := StrTran( s, "      ", " " )
      s := StrTran( s, "     ", " " )
      s := StrTran( s, "    ", " " )
      s := StrTran( s, "   ", " " )
      s := StrTran( s, "  ", " " )
      IF "enum " $ s .OR. "flags " $ s
         b_:= hb_ATokens( AllTrim( s ), " " )
         AAdd( ::enum_, b_[ 2 ] )
      ENDIF
   NEXT

   /* Pull out Prototypes   */
// ::protos_ := hbqtgen_PullOutSection( @cQth, "PROTOS" )
   tmp := hbqtgen_PullOutSection( @cQth, "PROTOS" )
   AEval( ::constructors_, {| e | AAdd( ::protos_, e ) } )
   AEval( tmp, {| e | AAdd( ::protos_, e ) } )

   IF ::lBuildExtended
      AAdd( ::protos_, "void hbSetEventBlock( int event, PHB_ITEM block );" )
   ENDIF

   /* Pull out Variables */
   ::varbls_ := hbqtgen_PullOutSection( @cQth, "VARIABLES" )

   /* Pull Out Signals      */
   ::slots_  := hbqtgen_PullOutSection( @cQth, "SLOTS"  )

   /* Combine signals and protos : same nature */
   AEval( ::slots_, {| e | AAdd( ::protos_, e ) } )

   ::isList            := AScan( ::cls_, {| e_ | Lower( e_[ 1 ] ) == "list"        .AND. Lower( e_[ 2 ] ) == "yes" } ) > 0
   ::isDetached        := AScan( ::cls_, {| e_ | Lower( e_[ 1 ] ) == "detached"    .AND. Lower( e_[ 2 ] ) == "yes" } ) > 0
   ::isConstructor     := AScan( ::cls_, {| e_ | Lower( e_[ 1 ] ) == "constructor" .AND. Lower( e_[ 2 ] ) == "no"  } ) == 0
   ::isDestructor      := AScan( ::cls_, {| e_ | Lower( e_[ 1 ] ) == "destructor"  .AND. Lower( e_[ 2 ] ) == "no"  } ) == 0
   ::isObject          := qth_is_QObject( ::cQtObject )
   ::areMethodsClubbed := AScan( ::cls_, {| e_ | Lower( e_[ 1 ] ) == "clubmethods" .AND. Lower( e_[ 2 ] ) == "no"  } ) == 0
   /* Determine Constructor - but this is hacky a bit. What could be easiest ? */
   IF ! ::isConstructor
      FOR i := 3 TO Len( ::new_ ) - 1
         IF !( Left( LTrim( ::new_[ i ] ), 2 ) == "//" )
            IF "__HB_RETPTRGC__(" $ ::new_[ i ]
               ::isConstructor := .T.
               EXIT
            ENDIF
         ENDIF
      NEXT
   ENDIF

   FOR EACH s IN ::protos_
      cOrg := s
      IF Empty( s := AllTrim( s ) )
         LOOP
      ENDIF

      /* Check if proto is commented out */
      IF Left( s, 2 ) == "//"
         AAdd( ::cmntd_, cOrg )
         LOOP
      ENDIF
      /* Check if it is not ANSI C Comment */
      IF Left( AllTrim( cOrg ), 1 ) $ "/*"
         LOOP
      ENDIF
      /* Another comment tokens */
      IF Empty( s ) .or. Left( s, 1 ) $ "#;}"
         LOOP
      ENDIF

      ::nFuncs++

      fBody_:= {}
      IF right( s, 1 ) == "{"
         fBody_:= hbqtgen_PullOutFuncBody( ::protos_, s:__enumIndex() )
         s := SubStr( s, 1, Len( s ) - 1 )
      ENDIF
      IF ::parseProto( s, fBody_ )
         ::nCnvrtd++
      ELSE
         AAdd( ::dummy_, cOrg )
      ENDIF
   NEXT

   FOR EACH s IN ::varbls_
      cOrg := s

      IF Empty( s := AllTrim( s ) )
         LOOP
      ENDIF
      /* Check if proto is commented out */
      IF Left( s, 2 ) == "//"
         AAdd( ::cmntd_, cOrg )
         LOOP
      ENDIF
      /* Check if it is not ANSI C Comment */
      IF Left( AllTrim( cOrg ), 1 ) $ "/*"
         LOOP
      ENDIF
      /* Another comment tokens */
      IF Empty( s ) .or. Left( s, 1 ) $ "#;"
         LOOP
      ENDIF

      ::nFuncs++

      IF ::parseVariables( s )
         ::nCnvrtd++
      ELSE
         AAdd( ::dummy_, cOrg )
      ENDIF
   NEXT

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtSource:build()
   LOCAL i, s, oMtd, tmp, tmp1, n, k, aLine, uQtObject, aParents, cParent

   uQtObject := Upper( ::cQtObject )

   ::hRef[ ::cQtObject ] := NIL

   /* Methods Body */
   FOR EACH oMtd IN ::aMethods
      ::buildMethodBody( oMtd, ::aMethods )
   NEXT

   /* Pull .cpp copyright text */
   aLine := hbqtgen_BuildCopyrightText()
   IF ::lQtVerLessThan                                            /* Only Once at top of the source */
      AAdd( aLine, "#if QT_VERSION <= " + ::cQtVerLessThan )
   ELSE
      AAdd( aLine, "#if QT_VERSION >= " + ::cQtVer )
   ENDIF
   AAdd( aLine, "" )

   /* Place ENUM definitions into the source */
   IF ! Empty( ::enums_ )
      AAdd( aLine, "/*" )
      AEval( ::enums_, {| e | iif( ! Empty( e ), AAdd( aLine, " *  " + e ), NIL ) } )
      AAdd( aLine, " */ " )
      AAdd( aLine, "" )
   ENDIF

   FOR i := 3 TO Len( ::new_ ) - 1
      IF ! Left( LTrim( ::new_[ i ] ), 2 ) == "//"
         IF "__HB_RETPTRGC__(" $ ::new_[ i ]
            ::isQtObjectAvailable := .T.
         ENDIF
      ENDIF
   NEXT

   IF ::isConstructor .AND. ::isQtObjectAvailable
      FOR i := 3 TO Len( ::new_ ) - 1
         IF ! Left( LTrim( ::new_[ i ] ), 2 ) == "//"
            IF "__HB_RETPTRGC__(" $ ::new_[ i ]
               tmp1 := ::new_[ i ]
               DO WHILE ( tmp := At( "hbqt_par_", tmp1 ) ) > 0
                  tmp1 := SubStr( tmp1, tmp + Len( "hbqt_par_" ) )
                  hbqtgen_AddRef( ::hRef, Left( tmp1, At( "(", tmp1 ) - 1 ) )
                  tmp1 := SubStr( tmp1, At( "(", tmp1 ) + 1 )
               ENDDO
            ENDIF
         ENDIF
      NEXT
   ENDIF

   AAdd( aLine, "HB_EXTERN_BEGIN" )
#if 0
   AAdd( aLine, "" )
   AAdd( aLine, "HB_FUNC_EXTERN( __HB" + Upper( ::cQtModule ) + " );" )
   FOR EACH s IN ::hRef
      IF ! ( s:__enumKey() == "QModelIndexList" )
         AAdd( aLine, "HB_FUNC_EXTERN( HB_" + Upper( s:__enumKey() ) + " );" )
      ENDIF
   NEXT
   AAdd( aLine, "" )
   AAdd( aLine, "void _hb_force_link_" + ::cQtObject +"( void )" )
   AAdd( aLine, "{" )
   AAdd( aLine, "   HB_FUNC_EXEC( __HB" + Upper( ::cQtModule ) + " );" )
   FOR EACH s IN ::hRef
      IF ! ( s:__enumKey() == "QModelIndexList" )
         AAdd( aLine, "   HB_FUNC_EXEC( HB_" + Upper( s:__enumKey() ) + " );" )
      ENDIF
   NEXT
   AAdd( aLine, "}" )
   AAdd( aLine, "" )
#endif
   IF ::cQtVer > "0x040500"
      AAdd( aLine, "#if QT_VERSION >= " + ::cQtVer )
   ENDIF
   AAdd( aLine, "" )

   FOR EACH s IN ::hRef
      AAdd( aLine, "extern HB_EXPORT void hbqt_del_" + s:__enumKey() + "( void * pObj, int iFlags );" )
   NEXT
   AAdd( aLine, "" )

   n := AScan( ::cls_, {| e_ | Left( Lower( e_[ 1 ] ), 7 ) == "inherit" .and. ! Empty( e_[ 2 ] ) } )
   IF n > 0
      aParents := hb_ATokens( AllTrim( ::cls_[ n, 2 ] ), "," )
      s := ""
      FOR EACH cParent IN aParents
         IF ! Empty( cParent )
            s += Upper( "HB_" + AllTrim( cParent ) + iif( cParent:__enumIndex() == Len( aParents ), "", ", " ) )
         ENDIF
      NEXT
   ELSE
      s := "HBQTOBJECTHANDLER"
   ENDIF

   AAdd( aLine, "" )
   AAdd( aLine, "extern HB_EXPORT void hbqt_register_" + lower( uQtObject ) + "();" )
   AAdd( aLine, "" )

   FOR EACH k IN hb_aTokens( s, "," )
      k := lower( AllTrim( k ) )
      IF k == "hbqtobjecthandler"
         AAdd( aLine, "HB_FUNC_EXTERN( " + Upper( k ) + " );" )
      ELSE
         AAdd( aLine, "extern HB_EXPORT void hbqt_register_" + SubStr( k,4 ) + "();" )
      ENDIF
   NEXT
   AAdd( aLine, "" )

   IF ::cQtVer > "0x040500"
      AAdd( aLine, "#endif" )
   ENDIF
   AAdd( aLine, "" )

   FOR EACH k IN hb_aTokens( s, "," )
      AAdd( aLine, "HB_FUNC_EXTERN( " + Upper( AllTrim( k ) ) + " );" )
   NEXT
   AAdd( aLine, "" )
   AAdd( aLine, "HB_EXTERN_END" )
   AAdd( aLine, "" )
   AAdd( aLine, "static void s_registerMethods( HB_USHORT uiClass );" )
   AAdd( aLine, "" )
   AAdd( aLine, "static HB_CRITICAL_NEW( s_hbqtMtx );" )
   AAdd( aLine, "#define HB_HBQT_LOCK     hb_threadEnterCriticalSection( &s_hbqtMtx );" )
   AAdd( aLine, "#define HB_HBQT_UNLOCK   hb_threadLeaveCriticalSection( &s_hbqtMtx );" )
   AAdd( aLine, "" )
   IF ::cQtVer > "0x040500"
      AAdd( aLine, "#if QT_VERSION >= " + ::cQtVer )
   ENDIF
   FOR EACH s IN ::hRef
      IF s:__enumKey() == "QList" /* TOFIX: Ugly hack */
         tmp := s:__enumKey() + "< void * >"
      ELSEIF s:__enumKey() == "QModelIndexList" /* TOFIX: Ugly hack */
         tmp := "QList< QModelIndex >"
      ELSE
         tmp := s:__enumKey()
      ENDIF
      AAdd( aLine, PadR( "#define hbqt_par_" + s:__enumKey() + "( n )", 64 ) + PadR( "( ( " + tmp, 48 ) + "* ) hbqt_par_ptr( n ) )" )
   NEXT
   IF ::cQtVer > "0x040500"
      AAdd( aLine, "#endif" )
   ENDIF
   AAdd( aLine, "" )

   IF ! Empty( ::code_ )
      IF ::cQtVer > "0x040500"
         AAdd( aLine, "#if QT_VERSION >= " + ::cQtVer )
      ENDIF
      n := AScan( ::code_, {| e | "gcMark" $ e } )
      IF n == 0
//       AEval( ::code_, {| e | AAdd( aLine, StrTran( e, chr( 13 ) ) ) } )
         FOR EACH s IN ::code_
            s := StrTran( s, chr( 13 ) )
            IF Left( s, 8 ) == "#include"
               tmp := At( "/", s )
               IF tmp > 0
                  tmp1 := StrTran( SubStr( s, tmp + 1 ), ">" )
                  IF IsQt5Widget( tmp1 ) .OR. IsQt5PrintSupport( tmp1 )
                     AAdd( aLine, "#if QT_VERSION <= 0x040900" )
                     AAdd( aLine, s )
                     AAdd( aLine, "#else" )
                     IF IsQt5Widget( tmp1 )
                        AAdd( aLine, "#include <QtWidgets/" + tmp1 + ">" )
                     ELSE
                        AAdd( aLine, "#include <QtPrintSupport/" + tmp1 + ">" )
                     ENDIF
                     AAdd( aLine, "#endif" )
                  ELSE
                     AAdd( aLine, s )
                  ENDIF
               ELSE
                  AAdd( aLine, s )
               ENDIF
            ELSE
               AAdd( aLine, s )
            ENDIF
         NEXT
      ELSE
         AEval( ::code_, {| e | AAdd( aLine, StrTran( e, chr( 13 ) ) ) }, 1, n - 1 )
      ENDIF
      IF ::cQtVer > "0x040500"
         AAdd( aLine, "#endif" )
      ENDIF
      AAdd( aLine, "" )
   ENDIF
   AAdd( aLine, "" )

   AAdd( aLine, "static PHB_ITEM s_oClass = NULL;" )
   AAdd( aLine, "" )

   AAdd( aLine, "" )
   AAdd( aLine, "void hbqt_del_" + ::cQtObject + "( void * pObj, int iFlags )" )
   AAdd( aLine, "{" )
   AAdd( aLine, "   Q_UNUSED( iFlags );" )
   AAdd( aLine, "   if( pObj )" )
   AAdd( aLine, "   {" )
   IF ::isList
      AAdd( aLine, "      QList< void * > * p = ( QList< void * > * ) pObj;" )
      AAdd( aLine, "      int i;" )
      AAdd( aLine, "      for( i = 0; i < p->size(); i++ )" )
      AAdd( aLine, "      {" )
      AAdd( aLine, "         if( p->at( i ) != NULL )" )
      AAdd( aLine, "         {" )
      AAdd( aLine, "            hb_itemRelease( p->at( i ) );" )
      AAdd( aLine, "         }" )
      AAdd( aLine, "      }" )
      AAdd( aLine, "      delete ( ( " + ::cQtObject + "< void * >" + " * ) pObj );" )
   ELSE
      IF ::isConstructor .and. ::isDestructor
         AAdd( aLine, "      delete ( " + ::cQtObject + " * ) pObj;" )
      ENDIF
   ENDIF
   AAdd( aLine, "      pObj = NULL;" )
   AAdd( aLine, "   }" )
   AAdd( aLine, "}" )
   AAdd( aLine, "" )

   AAdd( aLine, "void hbqt_register_" + lower( uQtObject ) + "()" )
   AAdd( aLine, "{" )
   AAdd( aLine, '   HB_TRACE( HB_TR_DEBUG, ( "hbqt_register_' + lower( uQtObject ) + '()" ) );' )
   AAdd( aLine, "   HB_HBQT_LOCK" )
   AAdd( aLine, "   if( s_oClass == NULL )" )
   AAdd( aLine, "   {" )
   AAdd( aLine, "      s_oClass = hb_itemNew( NULL );" )
   FOR EACH k IN hb_aTokens( s, "," )
      k := lower( AllTrim( k ) )
      IF k == "hbqtobjecthandler"
         AAdd( aLine, "      HB_FUNC_EXEC( " + Upper( k ) + " );" )
      ELSE
         AAdd( aLine, "      hbqt_register_" + SubStr( k, 4 ) + "();" )
      ENDIF
   NEXT
   AAdd( aLine, '      PHB_ITEM oClass = hbqt_defineClassBegin( "' + uQtObject + '", s_oClass, "' + s + '" );' )
   AAdd( aLine, "      if( oClass )" )
   AAdd( aLine, "      {" )
   AAdd( aLine, "         s_registerMethods( hb_objGetClass( hb_stackReturnItem() ) );" )
   AAdd( aLine, "         hbqt_defineClassEnd( s_oClass, oClass );" )
   AAdd( aLine, "      }" )
   AAdd( aLine, "   }" )
   AAdd( aLine, "   HB_HBQT_UNLOCK" )
   AAdd( aLine, "}" )
   AAdd( aLine, "" )

   AAdd( aLine, "HB_FUNC( HB_" + uQtObject + " )" )
   AAdd( aLine, "{" )
   AAdd( aLine, '   HB_TRACE( HB_TR_DEBUG, ( "HB_' +  uQtObject + '" ) );' )
   AAdd( aLine, "   if( s_oClass == NULL )" )
   AAdd( aLine, "   {" )
   AAdd( aLine, "       hbqt_register_" + lower( uQtObject ) + "();" )
   AAdd( aLine, "   }" )
   AAdd( aLine, '   hb_objSendMsg( s_oClass, "INSTANCE", 0 );' )
   AAdd( aLine, "}" )
   AAdd( aLine, "" )

   /* Build PRG level constructor */
   AAdd( aLine, ::newW_[ 1 ] )          // Func definition
   AAdd( aLine, ::newW_[ 2 ] )          // {
   AEval( ::getConstructorW(), {| e | AAdd( aLine, e ) } )

   /* Build the constructor */
   AAdd( aLine, ::new_[ 1 ] )           // Func definition
   AAdd( aLine, ::new_[ 2 ] )           // {
   AEval( ::getConstructor( 0 ), {| e | AAdd( aLine, e ) } )

   /* Insert Functions */
   AEval( ::txt_, {| e | AAdd( aLine, StrTran( e, chr( 13 ) ) ) } )

   AAdd( aLine, "" )
   AAdd( aLine, "static void s_registerMethods( HB_USHORT uiClass )" )
   AAdd( aLine, "{" )
// AAdd( aLine, "   hb_clsAdd( uiClass, " + PadR( '"new"', 40 ) + ", HB_FUNCNAME( " + PadR( Upper( "NEW" ), 40 ) + " ) );" )
   AAdd( aLine, "   hb_clsAdd( uiClass, " + PadR( '"init"', 40 ) + ", HB_FUNCNAME( " + PadR( Upper( "INIT" ), 40 ) + " ) );" )
   FOR EACH oMtd IN ::aMethods
      IF ! Empty( oMtd:cHBFunc )
         AAdd( aLine, "   hb_clsAdd( uiClass, " + PadR( '"' + oMtd:cHBFunc + '"', 40 ) + ", HB_FUNCNAME( " + PadR( Upper( oMtd:cHBFunc ), 40 ) + " ) );" )
      ENDIF
   NEXT
   AAdd( aLine, "}" )
   AAdd( aLine, "" )
   AAdd( aLine, "HB_INIT_SYMBOLS_BEGIN( __HBQT_CLS_" + uQtObject  + "__ )" )
   AAdd( aLine, '   { "' + uQtObject + '", { HB_FS_PUBLIC | HB_FS_LOCAL }, { HB_FUNCNAME( ' + uQtObject + " ) }, NULL }," )
   AAdd( aLine, '   { "HB_' + uQtObject + '", { HB_FS_PUBLIC | HB_FS_LOCAL }, { HB_FUNCNAME( HB_' + uQtObject + " ) }, NULL }" )
   AAdd( aLine, "HB_INIT_SYMBOLS_END( __HBQT_CLS_" + uQtObject + "__ )" )
   AAdd( aLine, "" )

   /* Footer */
   hbqtgen_BuildFooter( @aLine )

   /* Build Document File */
   ::buildDOC()

   /* Distribute in specific lib subfolder */
   hbqtgen_CreateTarget( ::cCPPFileName, aLine )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtSource:exploreExtensions()
   LOCAL n

   IF ( n := AScan( ::cls_, {| e_ | Upper( e_[ 1 ] ) $ "PAINTEVENT" } ) ) > 0
      IF ! Empty( ::cls_[ n,2 ] )
         ::lPaintEvent := .T.
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtSource:getConstructor()
   LOCAL i, s, aLine := {}
   LOCAL cObjPfx := iif( ::lBuildExtended, "Q", "" )

   IF ::cQtVer > "0x040500"
      AAdd( aLine, "#if QT_VERSION >= " + ::cQtVer )
   ENDIF
   IF ::isConstructor
      IF ::isQtObjectAvailable
         IF ::isList
            AAdd( aLine, "   " + cObjPfx + ::cQtObject + "< void * > * pObj = NULL;" )
         ELSE
            AAdd( aLine, "   " + cObjPfx + ::cQtObject + " * pObj = NULL;" )
         ENDIF
         AAdd( aLine, " " )
      ENDIF
      FOR i := 3 TO Len( ::new_ ) - 1
         IF !( Left( LTrim( ::new_[ i ] ), 2 ) == "//" )
            IF "__HB_RETPTRGC__(" $ ::new_[ i ]
               s := ::new_[ i ]
               s := RTrim( StrTran( s, "__HB_RETPTRGC__(", "pObj =" ) )
               IF ");" $ s
                  s := RTrim( StrTran( s, ");" ) ) + ";"
               ENDIF
               s := StrTran( s, "( " + ::cQtObject + "* )" )
               s := StrTran( s, "new ", "new " + cObjPfx )
               AAdd( aLine, s )
            ELSE
               AAdd( aLine, ::new_[ i ] )
            ENDIF
         ENDIF
      NEXT
      IF ::isQtObjectAvailable
         AAdd( aLine, " " )
         AAdd( aLine, '   hb_itemReturnRelease( hbqt_bindSetHbObject( NULL, pObj, "' + "HB_" + upper( ::cQtObject ) + '", hbqt_del_' + ::cQtObject + ", " + qth_get_bits( ::cQtObject, ! ::isDetached ) + " ) );" )
      ENDIF
   ELSE
      FOR i := 3 TO Len( ::new_ ) - 1
         AAdd( aLine, ::new_[ i ] )
      NEXT
   ENDIF
   IF ::cQtVer > "0x040500"
      AAdd( aLine, "#endif" )
   ENDIF
   AAdd( aLine, ::new_[ Len( ::new_ ) ] ) // }
   AAdd( aLine, "" )

   RETURN aLine

/*----------------------------------------------------------------------*/

METHOD HbQtSource:getConstructorW()
   LOCAL aLine := ::getConstructor()

   AEval( aLine, {| e, i | aLine[ i ] := StrTran( e, "hbqt_bindSetHbObject", "hbqt_bindGetHbObject" ) } )

   RETURN aLine

/*----------------------------------------------------------------------*/

METHOD HbQtSource:normalizeCmd( oMtd, v )
   LOCAL FP

   oMtd:cCmd := StrTran( oMtd:cCmd, "(  )", "()" )

   IF ! oMtd:isConstructor
      FP := StrTran( oMtd:cCmd, "hbqt_par_" + ::cQtObject + "( 1 )", v, 1, 1 )
   ELSE
      FP := oMtd:cCmd
   ENDIF

   /* Manage Re-Attached */
   IF oMtd:nAttach > 0
      FP := StrTran( FP, ", false", ", true" )
   ENDIF

   RETURN FP

/*----------------------------------------------------------------------*/

METHOD HbQtSource:getReturnAsList( oMtd, FP, cPrefix )
   LOCAL cRetCast, n, n1, cCast, cParas, nStrCnt, lFar
   LOCAL aLines := {}

   IF oMtd:isRetList
      cRetCast := oMtd:oRet:cCast
      lFar := "*" $ cRetCast
      IF ( n := at( "<", cRetCast ) ) > 0
         IF ( n1 := at( ">", cRetCast ) ) > 0
            cCast := AllTrim( SubStr( cRetCast, n + 1, n1 - n - 1 ) )
            cCast := StrTran( cCast, "*" )
            cCast := StrTran( cCast, " " )
         ENDIF
      ENDIF
      IF ! Empty( cCast )
         cParas := oMtd:cParas
         nStrCnt := 0
         DO WHILE "%%%" $ cParas
            ++nStrCnt
            cParas := StrTran( cParas, "%%%", StrZero( nStrCnt, 2, 0 ), 1, 1 )
         ENDDO

         AAdd( aLines, cPrefix + "QList<PHB_ITEM> * qList = new QList< PHB_ITEM >;" )
         AAdd( aLines, cPrefix + cRetCast + " qL = p->" + oMtd:cFun + cParas + ";" )
         AAdd( aLines, cPrefix + "int i;" )
         AAdd( aLines, cPrefix + "for( i = 0; i < qL.size(); i++ )" )
         AAdd( aLines, cPrefix + "{" )
         IF cCast == "QString"
            AAdd( aLines, cPrefix + "   const char * str = qL.at( i ).data();" )
            AAdd( aLines, cPrefix + "   PHB_ITEM pItem = hb_itemNew( NULL );" )
            AAdd( aLines, cPrefix + "   hb_itemPutCL( pItem, str, strlen( str ) );" )
            AAdd( aLines, cPrefix + "   qList->append( pItem );" )
         ELSEIF cCast == "int"
            AAdd( aLines, cPrefix + "   /* TOFIX: how TO release pItem ? */" )
            AAdd( aLines, cPrefix + "   PHB_ITEM pItem = hb_itemNew( NULL );" )
            AAdd( aLines, cPrefix + "   hb_itemPutNI( pItem, qL.at( i ) );" )
            AAdd( aLines, cPrefix + "   qList->append( pItem );" )
         ELSEIF cCast == "qreal"
            AAdd( aLines, cPrefix + "   /* TOFIX: how TO release pItem ? */" )
            AAdd( aLines, cPrefix + "   PHB_ITEM pItem = hb_itemNew( NULL );" )
            AAdd( aLines, cPrefix + "   hb_itemPutND( pItem, qL.at( i ) );" )
            AAdd( aLines, cPrefix + "   qList->append( pItem );" )
         ELSE
            IF lFar
               AAdd( aLines, cPrefix + '   qList->append( hbqt_bindGetHbObject( NULL, ( void * ) qL.at( i ), "HB_' + Upper( cCast ) + '", NULL, ' + qth_get_bits( cCast, .F. ) + " ) );" )
            ELSE
               AAdd( aLines, cPrefix + '   qList->append( hbqt_bindGetHbObject( NULL, new ' + cCast + '( qL.at( i ) ), "HB_' + Upper( cCast ) + '", hbqt_del_' + cCast + ", " + qth_get_bits( cCast, .T. ) + " ) );" )
            ENDIF
         ENDIF
         AAdd( aLines, cPrefix + "}" )
         AAdd( aLines, cPrefix + 'hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, qList, "HB_QLIST", hbqt_del_QList, HBQT_BIT_OWNER ) );' )
      ENDIF
   ELSE
      AAdd( aLines, cPrefix + FP + ";" )
   ENDIF

   RETURN aLines

/*----------------------------------------------------------------------*/

METHOD HbQtSource:getReturnMethod( oMtd, lAddRet )
   LOCAL txt_, nStrCnt, n, FP, v

   txt_:= {}

   v := "p"  /* NEVER change this */
   FP := ::normalizeCmd( oMtd, v )

   IF ! Empty( oMtd:aPre )
      FOR n := 1 TO Len( oMtd:aPre )
         AAdd( txt_, oMtd:aPre[ n, 1 ] )
      NEXT
      AAdd( txt_, "" )
   ENDIF

   /* Manage detached Argument */
   IF oMtd:nDetach > 0
      AAdd( txt_, "hbqt_par_detach_ptrGC( " + hb_ntos( oMtd:nDetach ) + " );" )
   ENDIF

   nStrCnt := 0
   DO WHILE "%%%" $ FP
      ++nStrCnt
      FP := StrTran( FP, "%%%", StrZero( nStrCnt, 2, 0 ), 1, 1 )
      AAdd( txt_, "void * pText" + StrZero( nStrCnt, 2, 0 ) + " = NULL;" )
   ENDDO

   AEval( ::getReturnAsList( oMtd, FP, "" ), {| e | AAdd( txt_, e ) } )

   FOR n := nStrCnt TO 1 STEP -1
      AAdd( txt_, "hb_strfree( pText" + StrZero( n, 2, 0 ) + " );" )
   NEXT

   /* Return values back to PRG */
   IF ! Empty( oMtd:aPre )
      AAdd( txt_, "" )
      FOR n := 1 TO Len( oMtd:aPre )
         AAdd( txt_, oMtd:aPre[ n, 4 ] + "( " + oMtd:aPre[ n, 3 ] + ", " + hb_ntos( oMtd:aPre[ n, 2 ] ) + " );" )
      NEXT
   ENDIF

   IF lAddRet
      AAdd( txt_, "return;" )
   ENDIF

   RETURN txt_

/*----------------------------------------------------------------------*/

METHOD HbQtSource:getMethodBody( oMtd, cMtdName, aMethods )
   LOCAL cTmp, n, v, ooMtd, i, nArgs, nArgGrps
   LOCAL txt_:= {}, a_:= {}, b_:= {}, c_:= {}, d_:= {}
   LOCAL cCrc, nMtds, lInIf, lFirst, nTySame

   HB_SYMBOL_UNUSED( cMtdName )

   /* check for methods already been worked on */
   IF AScan( ::func_, {| e_ | e_[ 1 ] == oMtd:cFun } ) > 0
      RETURN {}
   ENDIF
   AAdd( ::func_, { oMtd:cFun, 0, "" } )

   oMtd:cHBFunc := oMtd:cFun
   oMtd:cCmd    := StrTran( oMtd:cCmd, "(  )", "()" )

   FOR EACH ooMtd IN aMethods
      IF ooMtd:cFun == oMtd:cFun
         AAdd( a_, ooMtd )
      ENDIF
   NEXT

   /* Display method prototypes on top of the method body */
   FOR EACH ooMtd IN a_
      AAdd( txt_, "/* " + StrTran( ooMtd:cProto, chr( 13 ) ) + " */" )
   NEXT

   v := "p"  /* NEVER change this */

   AAdd( txt_, "HB_FUNC_STATIC( " + Upper( oMtd:cHBFunc ) + " )" )
   AAdd( txt_, "{" )
   IF ! empty( oMtd:cDefine )
      AAdd( txt_, oMtd:cDefine )
   ENDIF
   IF ! empty( oMtd:cVersion )
      IF Left( oMtd:cVersion, 1 ) == "-"
         AAdd( txt_, "#if QT_VERSION <= " + SubStr( oMtd:cVersion, 2 ) )
      ELSE
         AAdd( txt_, "#if QT_VERSION >= " + oMtd:cVersion )
      ENDIF
   ELSEIF ::lQtVerLessThan
      AAdd( txt_, "#if QT_VERSION <= " + ::cQtVerLessThan )
   ELSEIF ::cQtVer > "0x040500"
      AAdd( txt_, "#if QT_VERSION >= " + ::cQtVer )
   ENDIF

   /* If method is manually written in .qth - no more processing */
   IF ! Empty( oMtd:fBody_ )
      AEval( oMtd:fBody_, {| e | AAdd( txt_, e ) } )
      IF ! empty( oMtd:cVersion ) .OR. ::cQtVer > "0x040500" .OR. ::lQtVerLessThan
         AAdd( txt_, "#endif" )
      ENDIF
      AAdd( txt_, "}" )
      AAdd( txt_, "" )
      RETURN txt_
   ENDIF

   /* Sort per number of arguments */
   asort( a_, , , {| e, f | StrZero( e:nArgs, 2 ) + iif( e:nArgs == 0, "", e:hArgs[ 1 ]:cTypeHB ) > StrZero( f:nArgs, 2 ) + iif( f:nArgs == 0, "", f:hArgs[ 1 ]:cTypeHB )  } )

   /* know the maximum groups by number of parameters - first CASE */
   AEval( a_, {| o | iif( AScan( b_, o:nArgs ) == 0, AAdd( b_, o:nArgs ), NIL ) } )

   /* also take into account optional arguments if any */
   FOR EACH ooMtd IN a_
      IF ooMtd:nArgsReal < ooMtd:nArgs
         FOR i := ooMtd:nArgs - 1 TO ooMtd:nArgsReal STEP -1
            IF AScan( b_, i ) == 0
               AAdd( b_, i )
            ENDIF
         NEXT
      ENDIF
   NEXT

   /* Build the structure number of parameters wise */
   FOR EACH nArgs IN b_
      AAdd( c_, { nArgs, {}, {}, {} } )
      n := Len( c_ )
      FOR EACH ooMtd IN a_
         IF ooMtd:nArgs == nArgs
            AAdd( c_[ n, 2 ], ooMtd )
         ENDIF
      NEXT
      /* Again append methods with optional arguments */
      FOR EACH ooMtd IN a_
         IF ooMtd:nArgsReal < ooMtd:nArgs
            FOR i := ooMtd:nArgs - 1 TO ooMtd:nArgsReal STEP -1
               IF i == nArgs
                  AAdd( c_[ n, 2 ], ooMtd )
               ENDIF
            NEXT
         ENDIF
      NEXT
   NEXT

   /* stack groups based on parameters descending */
   asort( c_, , , {| e, f | e[ 1 ] > f[ 1 ] } )

   /* again sort no of arguments based methods by type of arguments */
   FOR i := 10 TO 0 STEP -1  /* consider maximum 10 arguments */
      IF ( n := AScan( c_, {| e_ | e_[ 1 ] == i } ) ) > 0
         d_:= c_[ n, 2 ]                      // d_ == a_
         asort( d_, , , {| e, f | __TY( e, c_[ n, 1 ] ) < __TY( f, c_[ n, 1 ] ) } )
      ENDIF
   NEXT


   cTmp := iif( ::lBuildExtended, "Q", "" ) + ::cQtObject + iif( ::isList, "< void * >", "" )
   AAdd( txt_, "   " + cTmp + " * " + v + " = ( " + cTmp + " * ) hbqt_par_ptr( 0 );" )

   AAdd( txt_, "   if( " + v + " )" )
   AAdd( txt_, "   {" )

   IF Len( a_ ) == 1 .and. oMtd:nArgs == oMtd:nArgsReal    /* Only one method - no overloads */
      FOR EACH b_ IN c_
         nArgs    := b_[ 1 ]
         a_       := b_[ 2 ]
         FOR EACH oMtd IN a_
            IF oMtd:nArgs > 0
               AAdd( txt_, "      " + iif( oMtd:__enumIndex() == 1, "if", "else if" ) + "( " + __TY_TYPEScpp( oMtd, nArgs, .F. ) + " )" )
               AAdd( txt_, "      {" )
            ENDIF

            AEval( ::getReturnMethod( oMtd, ( oMtd:nArgs > 0 ) ), {| e | AAdd( txt_, Space( iif( oMtd:nArgs > 0, 9, 6 ) ) + e ) } )

            IF oMtd:nArgs > 0
               AAdd( txt_, "      }" )
               AAdd( txt_, "      hb_errRT_BASE( EG_ARG, 9999, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );" )
            ENDIF
         NEXT
      NEXT

   ELSE

      nArgs := 0
      AAdd( txt_, "      switch( hb_pcount() )" )
      AAdd( txt_, "      {" )

      FOR EACH b_ IN c_
         nArgs    := b_[ 1 ]
         a_       := b_[ 2 ]
         nArgGrps := Len( c_ )
         cCrc     := "xxx"
         nMtds    := 0
         lInIf    := .F.
         nTySame  := 0
         lFirst   := nArgs > 0

         AAdd( txt_, "         case " + hb_ntos( nArgs ) + ":" )      /* number of parameters */
         AAdd( txt_, "         {" )

         FOR EACH oMtd IN a_
            IF nArgs > 0
               IF !( cCrc == __TY( oMtd, nArgs ) )
                  cCrc    := __TY( oMtd, nArgs )
                  nMtds   := 0
                  nTySame := 0
                  AEval( a_, {| o | iif( __TY( o,nArgs ) == cCrc, nTySame++, NIL ) } )
                  lInIf   := oMtd:nArgQCast > 0 .AND. oMtd:nArgQCast <= nArgs .AND. nTySame > 1
                  AAdd( txt_, "            " + iif( lFirst, "if( ", "else if( " ) + __TY_TYPEScpp( oMtd, nArgs, nTySame > 1 ) + " )" )
                  AAdd( txt_, "            {" )
               ENDIF
            ENDIF
            IF lFirst
               lFirst := .F.
            ENDIF

            nMtds++

            IF lInIf
               AAdd( txt_, "               " + iif( nMtds == 1, "if( ", "else if( " ) + __TY_Method( oMtd, nArgs ) + " )" )
               AAdd( txt_, "               {" )
            ENDIF

            AEval( ::getReturnMethod( oMtd, .T. ), {| e | AAdd( txt_, Space( iif( nArgs == 0, 12, 15 ) + iif( lInIf, 3, 0 ) ) + e ) } )

            IF lInIf
               AAdd( txt_, "               }" )
            ENDIF

            IF nArgs > 0 .AND. ! lInIf
               AAdd( txt_, "            }" )
            ELSEIF nArgs > 0 .AND. lInIf .AND. nMtds == nTySame
               AAdd( txt_, "            }" )
            ENDIF
         NEXT
         IF nArgs > 0
            AAdd( txt_, "            break;" )
            AAdd( txt_, "         }" )
         ENDIF
      NEXT
      IF nArgs == 0
         AAdd( txt_, "         }" )  // CASE
      ENDIF
      AAdd( txt_, "      }" )        // SWITCH
      AAdd( txt_, "      hb_errRT_BASE( EG_ARG, 9999, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );" )

   ENDIF

   AAdd( txt_, "   }" )
   IF ! empty( oMtd:cVersion ) .OR. ::cQtVer > "0x040500" .OR. ::lQtVerLessThan
      AAdd( txt_, "#endif" )
   ENDIF
   IF ! empty( oMtd:cDefine )
      AAdd( txt_, "#endif" )
   ENDIF
   AAdd( txt_, "}" )              // HB_FUNC()
   AAdd( txt_, "" )

   HB_SYMBOL_UNUSED( d_ )
   HB_SYMBOL_UNUSED( nArgGrps )

   RETURN txt_

/*----------------------------------------------------------------------*/

METHOD HbQtSource:buildMethodBody( oMtd )
   LOCAL aBdy, cFunc

   oMtd:cCmd := StrTran( oMtd:cCmd, "(  )", "()" )

   aBdy := ::getMethodBody( oMtd, "QT_" + Upper( ::cQtObject ) + "_" + Upper( oMtd:cHBFunc ), ::aMethods )

   AEval( aBdy, {| e | AAdd( ::txt_, e ) } )

   cFunc := iif( ::areMethodsClubbed, hbqtgen_stripLastFrom( oMtd:cHBFunc, "_" ), oMtd:cHBFunc )

   oMtd:cDoc := "Qt_" + ::cQtObject + "_" + cFunc + "( p" + ::cQtObject + ;
                     iif( Empty( oMtd:cDocs ), "", ", " + oMtd:cDocs ) + " ) -> " + oMtd:cPrgRet

   AAdd( ::doc_, oMtd:cDoc )
   AAdd( ::doc_, "" )

   RETURN Self

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_prgRetNormalize( cPrgRet )

   cPrgRet := StrTran( cPrgRet, "::", "_" )
   cPrgRet := StrTran( cPrgRet, "<", "_" )
   cPrgRet := StrTran( cPrgRet, " *>" )
   cPrgRet := StrTran( cPrgRet, "*>" )

   RETURN cPrgRet

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_paramCheckStrCpp( cType, nArg, cCast, lObj )

   HB_SYMBOL_UNUSED( cCast )

   SWITCH cType
   CASE "PB"
      RETURN "! HB_ISNIL( " + hb_ntos( nArg ) + " )"
   CASE "P"  /* TODO */
      RETURN "HB_ISPOINTER( " + hb_ntos( nArg ) + " )"
   CASE "O"
      IF lObj
         RETURN "HB_ISOBJECT( " + hb_ntos( nArg ) + " )"
      ELSE
         RETURN "hbqt_par_isDerivedFrom( " + hb_ntos( nArg ) + ', "' + upper( cCast ) + '" )'
      ENDIF
   CASE "N*"
      RETURN  "HB_ISBYREF( " + hb_ntos( nArg ) + " )"
   CASE "N"
      RETURN  "HB_ISNUM( " + hb_ntos( nArg ) + " )"
   CASE "L*"
      RETURN  "HB_ISBYREF( " + hb_ntos( nArg ) + " )"
   CASE "L"
      RETURN  "HB_ISLOG( " + hb_ntos( nArg ) + " )"
   CASE "C"
      RETURN  "HB_ISCHAR( " + hb_ntos( nArg ) + " )"
   ENDSWITCH

   RETURN ""
/*----------------------------------------------------------------------*/

STATIC FUNCTION __TY_TYPEScpp( oM, nArgs, lObj )
   LOCAL i, s := ""
   FOR i := 1 TO nArgs
      s += hbqtgen_paramCheckStrCpp( oM:hArgs[ i ]:cTypeHB, i, oM:hArgs[ i ]:cCast, lObj ) + " && "
   NEXT
   IF " && " $ s
      s := Left( s, Len( s ) - 4 )
   ENDIF
   RETURN s

/*----------------------------------------------------------------------*/

METHOD HbQtSource:buildDOC()
   LOCAL cText, n, n1, n2, nLen, pWidget, cRet, cLib, i, cInherits

   LOCAL hEntry := { => }

   LOCAL cQT_VER := hb_ntos( hb_HexToNum( SubStr( ::cQtVer, 3, 2 ) ) ) + "." + hb_ntos( hb_HexToNum( SubStr( ::cQtVer, 5, 2 ) ) )

   hb_HKeepOrder( hEntry, .T. )

   n := AScan( ::cls_, {| e_ | Left( Lower( e_[ 1 ] ), 7 ) $ "inherits" .and. ! Empty( e_[ 2 ] ) } )
   cInherits := iif( n > 0, ::cls_[ n, 2 ], "" )

   cLib := ::cQtModule

   hEntry[ "TEMPLATE"     ] := "Class"
   hEntry[ "NAME"         ] := ::cQtObject + "()"
   hEntry[ "CATEGORY"     ] := "Harbour Bindings for Qt"
   hEntry[ "SUBCATEGORY"  ] := "GUI"
   hEntry[ "EXTERNALLINK" ] := "http://doc.trolltech.com/" + cQT_VER + "/" + Lower( ::cQtObject ) + ".html"
   hEntry[ "ONELINER"     ] := "Creates a new " + ::cQtObject + " object."
   hEntry[ "INHERITS"     ] := cInherits
   hEntry[ "SYNTAX"       ] := ::cQtObject + "( ... )" + hb_eol()
   hEntry[ "ARGUMENTS"    ] := ""
   hEntry[ "RETURNS"      ] := "An instance of the object of type " + ::cQtObject
   IF ! Empty( ::doc_ )
      hEntry[ "METHODS"      ] := ""
      nLen    := Len( ::cQtObject )
      n       := at( ::cQtObject, ::doc_[ 1 ] )
      pWidget := "p" + ::cQtObject
      FOR i := 1 TO Len( ::doc_ )
         IF ! Empty( cText := ::doc_[ i ] )
            cText := SubStr( cText, n + nLen + 1 )
            cText := StrTran( cText, pWidget + ", " )
            cText := StrTran( cText, pWidget )
            cText := StrTran( cText, "(  )", "()" )
            n1    := at( "->", cText )
            cRet  := hbqtgen_prgRetNormalize( AllTrim( SubStr( cText, n1 + 2 ) ) )
            cText := SubStr( cText, 1, n1 - 1 )
            n2    := Max( 50, Len( cText ) )
            cText := padR( cText, n2 )
            IF ! Empty( cRet )
               hEntry[ "METHODS" ] += ":" + cText + " -> " + cRet + hb_eol()
            ENDIF
         ENDIF
      NEXT
   ENDIF
   hEntry[ "DESCRIPTION"  ] := ""
   hEntry[ "EXAMPLES"     ] := ""
   FOR EACH cText IN ::docum_
      IF ! Empty( cText )
         hEntry[ "EXAMPLES" ] += cText + hb_eol()
      ENDIF
   NEXT
   hEntry[ "TESTS"        ] := ""
   hEntry[ "STATUS"       ] := "R"
   hEntry[ "COMPLIANCE"   ] := "Not Clipper compatible"
   hEntry[ "PLATFORMS"    ] := "Windows, Linux, Mac OS X, OS/2"
   hEntry[ "VERSION"      ] := cQT_VER + " or upper"
   hEntry[ "FILES"        ] := "Library: " + "hb" + cLib
#if 0
   hEntry[ "SEEALSO"      ] := ""
   hEntry[ "SEEALSO"      ] += iif( Empty( cInherits ), "", cInherits + "()" )
#endif

   RETURN hb_MemoWrit( ::cDOCFileName, __hbdoc_ToSource( { hEntry } ) )

/*----------------------------------------------------------------------*/

METHOD HbQtSource:parseVariables( cProto )
   LOCAL n, oMtd, oRet

   IF ( n := at( " ", cProto ) ) == 0
      RETURN .F.
   ENDIF

   oMtd := HbqtMethod():new()
   oMtd:cProto     := cProto
   oMtd:isVariable := .T.

   oMtd:cPre := cProto

   oMtd:cRet := AllTrim( SubStr( cProto, 1, n - 1 ) )
   oMtd:cFun := AllTrim( SubStr( cProto, n + 1    ) )

   oRet := HbqtArgument():new( oMtd:cRet, ::cQtObject, ::enum_, "const" $ oMtd:cPas, .T. )
   oMtd:oRet := oRet

   ::buildCppCode( oMtd )

   RETURN oMtd:lValid

/*----------------------------------------------------------------------*/

#define HBQTGEN_THIS_PROPER( s )   ( Upper( Left( s, 1 ) ) + SubStr( s, 2 ) )

METHOD HbQtSource:parseProto( cProto, fBody_ )
   LOCAL aArg, n, nn, cHBIdx, nIndex, s, ss, cFirstParamCast, cArg
   LOCAL oMtd, oRet, oArg, k, cKey, cVal
   LOCAL cRef

   IF ( n := at( "(", cProto ) ) == 0
      RETURN .F.
   ENDIF
   IF ( nn := rat( ")", cProto ) ) == 0
      RETURN .F.
   ENDIF

   /*                    Method Parsing                    */
   oMtd := HbqtMethod():new()
   oMtd:cProto := cProto
   oMtd:fBody_ := fBody_

   oMtd:cPre := AllTrim( SubStr( cProto,     1, n - 1      ) )
   oMtd:cPar := AllTrim( SubStr( cProto, n + 1, nn - 1 - n ) )
   oMtd:cPas := AllTrim( SubStr( cProto, nn + 1            ) )

   IF ( n := at( "[*", oMtd:cPas ) ) > 0
      IF ( nn := at( "*]", oMtd:cPas ) ) > 0
         oMtd:cMrk := AllTrim( SubStr( oMtd:cPas, n + 2, nn - n - 2 ) )
         oMtd:cPas := AllTrim( SubStr( oMtd:cPas, 1, n - 1 ) )
         FOR EACH k IN hb_aTokens( oMtd:cMrk, ";" )
            IF ( n := at( "=", k ) ) > 0
               cKey := AllTrim( SubStr( k, 1, n - 1 ) )
               cVal := AllTrim( SubStr( k, n + 1 ) )
               SWITCH Upper( cKey )
               CASE "D"
                  oMtd:nDetach := val( cVal )
                  EXIT
               CASE "A"
                  oMtd:nAttach := val( cVal )
                  EXIT
               CASE "V"
                  oMtd:cVersion := cVal
                  EXIT
               CASE "R"
                  oMtd:nDetachRet := val( cVal )
                  EXIT
               CASE "F"
                  oMtd:cDefine := cVal
                  EXIT
               ENDSWITCH
            ENDIF
         NEXT
      ENDIF
   ENDIF
   IF ( n := rat( " ", oMtd:cPre ) ) > 0
      oMtd:cFun := AllTrim( SubStr( oMtd:cPre, n + 1    ) )
      oMtd:cRet := AllTrim( SubStr( oMtd:cPre, 1, n - 1 ) )
   ELSE
      oMtd:cFun := oMtd:cPre
      oMtd:cRet := ""
   ENDIF
   IF Empty( oMtd:cRet ) .AND. oMtd:cFun == ::cQtObject
      oMtd:isConstructor := .T.
      oMtd:cRet := oMtd:cFun
   ENDIF

   /* Return Value Parsing */
   oRet := HbqtArgument():new( oMtd:cRet, ::cQtObject, ::enum_, "const" $ oMtd:cPas, .T. )
   oMtd:oRet := oRet

   IF ! Empty( oMtd:cPar )
      /* Arguments Parsing */
      aArg := hb_ATokens( oMtd:cPar, "," )
      AEval( aArg, {| e, i | aArg[ i ] := AllTrim( e ) } )

      FOR EACH cArg IN aArg
         nIndex := cArg:__enumIndex()

         oArg := HbqtArgument():new( cArg, ::cQtObject, ::enum_, .F., .F. )
         oMtd:hArgs[ nIndex ] := oArg

         oMtd:nHBIdx := nIndex // iif( oMtd:isConstructor, 0, 1 )
         cHBIdx := hb_ntos( oMtd:nHBIdx )
         oMtd:cDocNM := HBQTGEN_THIS_PROPER( oArg:cName )

         oMtd:nArgs++
         oMtd:nArgsOpt += iif( oArg:lOptional, 1, 0 )

         IF Empty( cFirstParamCast )
            cFirstParamCast := oArg:cCast
            IF "::" $ cFirstParamCast
               cFirstParamCast := SubStr( cFirstParamCast, at( "::", cFirstParamCast ) + 2 )
            ENDIF
         ENDIF

         cRef := NIL

         DO CASE
         CASE oArg:cCast == "..."
            oArg:cBody   := "..."
            oArg:cDoc    := "..."
            oArg:cTypeHB := "..."

         CASE oArg:cCast == "PHB_ITEM"
            oArg:cBody   := "hb_param( " + cHBIdx + ", HB_IT_ANY )"
            oArg:cDoc    := "x" + oMtd:cDocNM
            oArg:cTypeHB := "PB"

         CASE oArg:cCast == "T"
            oArg:cBody   := "hb_param( " + cHBIdx + ", HB_IT_ANY )"
            oArg:cDoc    := "x" + oMtd:cDocNM
            oArg:cTypeHB := "P"

         CASE oArg:cCast $ ::cInt .AND. oArg:lFar
            AAdd( oMtd:aPre, { oArg:cCast + " i" + oMtd:cDocNM + " = 0;", oMtd:nHBIdx, "i" + oMtd:cDocNM, "hb_storni" } )
            oArg:cBody   := "&i" + oMtd:cDocNM
            oArg:cDoc    := "@n" + oMtd:cDocNM
            oArg:cTypeHB := "N*"

         CASE oArg:cCast $ ::cIntLong .AND. oArg:lFar
            AAdd( oMtd:aPre, { oArg:cCast + " i" + oMtd:cDocNM + " = 0;", oMtd:nHBIdx, "i" + oMtd:cDocNM, "hb_stornl" } )
            oArg:cBody   := "&i" + oMtd:cDocNM
            oArg:cDoc    := "@n" + oMtd:cDocNM
            oArg:cTypeHB := "N*"

         CASE oArg:cCast $ ::cIntLongLong .AND. oArg:lFar
            AAdd( oMtd:aPre, { oArg:cCast + " i" + oMtd:cDocNM + " = 0;", oMtd:nHBIdx, "i" + oMtd:cDocNM, "hb_stornint" } )
            oArg:cBody   := "&i" + oMtd:cDocNM
            oArg:cDoc    := "@n" + oMtd:cDocNM
            oArg:cTypeHB := "N*"

         CASE oArg:cCast $ ::cInt
            IF ! Empty( oArg:cDefault ) .AND. !( oArg:cDefault == "0" )
               oArg:cBody := "hb_parnidef( " + cHBIdx + ", " + oArg:cDefault + " )"
            ELSE
               oArg:cBody := "hb_parni( " + cHBIdx + " )"
            ENDIF
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast $ ::cIntLong
            IF ! Empty( oArg:cDefault ) .AND. !( oArg:cDefault == "0" )
               oArg:cBody := "hb_parnldef( " + cHBIdx + ", " + oArg:cDefault + " )"
            ELSE
               oArg:cBody := "hb_parnl( " + cHBIdx + " )"
            ENDIF
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast == "WId"
            oArg:cBody := "( " + oArg:cCast + " ) hb_parnint( " + cHBIdx + " )"
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast $ "qlonglong,qulonglong"
            IF ! Empty( oArg:cDefault ) .AND. !( oArg:cDefault == "0" )
               oArg:cBody := "( " + oArg:cCast + " ) hb_parnintdef( " + cHBIdx + ", " + oArg:cDefault + " )"
            ELSE
               oArg:cBody := "( " + oArg:cCast + " ) hb_parnint( " + cHBIdx + " )"
            ENDIF
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast $ ::cIntLongLong
            IF ! Empty( oArg:cDefault ) .AND. !( oArg:cDefault == "0" )
               oArg:cBody := "hb_parnintdef( " + cHBIdx + ", " + oArg:cDefault + " )"
            ELSE
               oArg:cBody := "hb_parnint( " + cHBIdx + " )"
            ENDIF
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast $ "double,qreal,float,GLfloat,qsreal" .AND. oArg:lFar
            AAdd( oMtd:aPre, { oArg:cCast + " qr" + oMtd:cDocNM + " = 0;", oMtd:nHBIdx, "qr" + oMtd:cDocNM, "hb_stornd"  } )
            oArg:cBody   := "&qr" + oMtd:cDocNM
            oArg:cDoc    := "@n" + oMtd:cDocNM
            oArg:cTypeHB := "N*"

         CASE oArg:cCast $ "double,qreal,float,GLfloat,qsreal"
            s := "hb_parnd( " + cHBIdx + " )"
            IF ! Empty( oArg:cDefault )
               oArg:cBody := "( HB_ISNUM( " + cHBIdx + " ) ? " + s + " : " + oArg:cDefault + " )"
            ELSE
               oArg:cBody := s
            ENDIF
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast == "uchar" .AND. oArg:lFar .AND. ! oArg:lConst
            /* TOFIX: Such code is not valid and should never be generated (const->non-const) [vszakats] */
            oArg:cBody   := "( uchar * ) hb_parc( " + cHBIdx + " )"
            oArg:cDoc    := "c" + oMtd:cDocNM
            oArg:cTypeHB := "C"

         CASE oArg:cCast == "uchar" .AND. oArg:lFar .AND. oArg:lConst
            oArg:cBody   := "( const uchar * ) hb_parc( " + cHBIdx + " )"
            oArg:cDoc    := "c" + oMtd:cDocNM
            oArg:cTypeHB := "C"

         CASE oArg:cCast == "uchar" .AND. ! oArg:lFar .AND. ! oArg:lConst
            oArg:cBody   := "( uchar ) hb_parni( " + cHBIdx + " )"
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast == "char" .AND. oArg:lFar .AND. ! oArg:lConst
            /* TOFIX: Such code is not valid and should never be generated (const->non-const) [vszakats] */
            oArg:cBody   := "( char * ) hb_parc( " + cHBIdx + " )"
            oArg:cDoc    := "c" + oMtd:cDocNM
            oArg:cTypeHB := "C"

         CASE oArg:cCast == "char" .AND. oArg:lFar .AND. oArg:lConst
            oArg:cBody   := "( const char * ) hb_parc( " + cHBIdx + " )"
            oArg:cDoc    := "c" + oMtd:cDocNM
            oArg:cTypeHB := "C"

         CASE oArg:cCast == "char" .AND. ! oArg:lFar .AND. ! oArg:lConst
            oArg:cBody   := "( char ) hb_parni( " + cHBIdx + " )"
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE "::" $ oArg:cCast .AND. oArg:lFar
            AAdd( oMtd:aPre, { oArg:cCast + " i" + oMtd:cDocNM + " = ( " + oArg:cCast + " ) 0;", oMtd:nHBIdx, "i" + oMtd:cDocNM, "hb_storni" } )
            oArg:cBody   := "&i" + oMtd:cDocNM
            oArg:cDoc    := "@n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE "::" $ oArg:cCast
            s := "( " + oArg:cCast + " ) hb_parni( " + cHBIdx + " )"
            IF ! Empty( oArg:cDefault ) .AND. !( oArg:cDefault == "0" )
               IF AScan( ::enum_, oArg:cDefault ) > 0
                  ss := ::cQtObject + "::" + oArg:cDefault
               ELSE
                  ss := iif( "::" $ oArg:cDefault, oArg:cDefault, ;
                     iif( isDigit( Left( oArg:cDefault, 1 ) ), oArg:cDefault, ::cQtObject + "::" + oArg:cDefault ) )
               ENDIF
               ss := "( " + oArg:cCast + " ) " + ss
               oArg:cBody := "( HB_ISNUM( " + cHBIdx + " ) ? " + s + " : " + ss + " )"
            ELSE
               oArg:cBody := s
            ENDIF
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast $ "bool,GLboolean" .AND. oArg:lFar
            AAdd( oMtd:aPre, { "bool i" + oMtd:cDocNM + " = 0;", oMtd:nHBIdx, "i" + oMtd:cDocNM, "hb_stornl" } )
            oArg:cBody   := "&i" + oMtd:cDocNM
            oArg:cDoc    := "@l" + oMtd:cDocNM
            oArg:cTypeHB := "L"

         CASE oArg:cCast $ "bool,GLboolean"
            s := "hb_parl( " + cHBIdx + " )"
            IF ! Empty( oArg:cDefault )
               oArg:cBody := iif( oArg:cDefault == "false", s, "hb_parldef( " + cHBIdx + ", true )" )
            ELSE
               oArg:cBody := s
            ENDIF
            oArg:cDoc    := "l" + oMtd:cDocNM
            oArg:cTypeHB := "L"

         CASE oArg:cCast == "void" .AND. oArg:lFar /* and it must be void * */
            oArg:cBody   := "hb_parptr( " + cHBIdx + " )"
            oArg:cDoc    := "n" + oMtd:cDocNM
            oArg:cTypeHB := "N"

         CASE oArg:cCast == "QString"
            IF oArg:lFar
               oArg:cBody   := "( QString * ) hb_parstr_utf8( " + cHBIdx + ", &pText%%%, NULL )"
            ELSEIF oArg:lConst
               oArg:cBody   := "( QString ) hb_parstr_utf8( " + cHBIdx + ", &pText%%%, NULL )"
            ELSE
               oArg:cBody   := "hb_parstr_utf8( " + cHBIdx + ", &pText%%%, NULL )"
            ENDIF
            oArg:cDoc    := "c" + oMtd:cDocNM  // oArg:cCast - W R O N G
            oArg:cTypeHB := "C"

         CASE oArg:lFar
            cRef := oArg:cCast
            oArg:cBody := "hbqt_par_" + oArg:cCast + "( " + cHBIdx + " )"
            IF ! Empty( oArg:cDefault )
               oArg:cBody := "( HB_ISOBJECT( " + cHBIdx + " ) ? " + oArg:cBody + " : " + oArg:cDefault + " )"
            ENDIF
            oArg:cDoc    := "o" + oArg:cCast
            oArg:cTypeHB := "O"

         CASE oArg:lAnd .AND. oArg:lConst
            cRef := oArg:cCast
            s := "*hbqt_par_" + oArg:cCast + "( " + cHBIdx + " )"
            IF ! Empty( oArg:cDefault ) .AND. ( "(" $ oArg:cDefault )
               oArg:cBody := "( HB_ISOBJECT( " + cHBIdx + " ) ? " + s + " : " + oArg:cDefault + " )"
            ELSE
               oArg:cBody := s
            ENDIF
            oArg:cDoc    := "o" + oArg:cCast
            oArg:cTypeHB := "O"

         CASE oArg:lAnd
            cRef := oArg:cCast
            oArg:cBody   := "*hbqt_par_" + oArg:cCast + "( " + cHBIdx + " )"
            oArg:cDoc    := "o" + oArg:cCast
            oArg:cTypeHB := "O"

         CASE oArg:cCast == "QChar"
            cRef := oArg:cCast
            oArg:cBody   := "*hbqt_par_" + oArg:cCast + "( " + cHBIdx + " )"
            oArg:cDoc    := "o" + oArg:cCast
            oArg:cTypeHB := "O"

         OTHERWISE
            oArg:cBody   := ""   /* Just in case */
            oArg:cDoc    := ""
            oArg:cTypeHB := ""

         ENDCASE

         hbqtgen_AddRef( ::hRef, cRef )

         oMtd:cParas += oArg:cBody + ", "
         oMtd:cDocs  += oArg:cDoc + ", "
      NEXT
   ENDIF

   oMtd:nArgsReal := oMtd:nArgs - oMtd:nArgsOpt

   FOR EACH oArg IN oMtd:hArgs
      IF ( Left( oArg:cCast, 1 ) == "Q" .OR. Left( oArg:cCast, 3 ) == "HBQ" ) .AND. ;
                                            ! ( oArg:cCast $ "QString,QRgb" ) .AND. ;
                                            ! ( "::" $ oArg:cCast )
         oMtd:nArgQCast := oArg:__enumIndex()
         EXIT
      ENDIF
   NEXT
   FOR EACH oArg IN oMtd:hArgs
      IF oArg:cTypeHB $ "O"
         oMtd:nArgHBObj := oArg:__enumIndex()
         EXIT
      ENDIF
   NEXT

   IF right( oMtd:cParas, 2 ) == ", "
      oMtd:cParas := SubStr( oMtd:cParas, 1, Len( oMtd:cParas ) - 2 )
      oMtd:cDocs  := SubStr( oMtd:cDocs , 1, Len( oMtd:cDocs  ) - 2 )
   ENDIF

   ::buildCppCode( oMtd )

   RETURN oMtd:lValid

/*----------------------------------------------------------------------*/

STATIC PROCEDURE hbqtgen_AddRef( hRef, cRef )

   IF ! Empty( cRef ) .AND. !( ">" $ cRef ) .AND. !( cRef $ "uchar|QString|QRgb|Bool|char" )
      hRef[ cRef ] := NIL
   ENDIF

   RETURN

/*----------------------------------------------------------------------*/

METHOD HbQtSource:buildCppCode( oMtd )
   LOCAL oRet   := oMtd:oRet
   LOCAL cPara  := oMtd:cParas
   LOCAL cRef, cRefInList

   oMtd:cWdg      := "hbqt_par_" + ::cQtObject + "( 1 )->"
   oMtd:cParas    := iif( oMtd:isVariable(), "", "( " + oMtd:cParas + " )" )
   oMtd:cCmn      := oMtd:cWdg + oMtd:cFun + oMtd:cParas
   oMtd:cDocNMRet := HBQTGEN_THIS_PROPER( oRet:cName )

   DO CASE
   CASE oMtd:isConstructor
      oMtd:cCmd := "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "new " + ::cQtObject + "( " + cPara + " )" + ', "' + "HB_" + Upper( ::cQtObject ) + '", hbqt_del_' + ::cQtObject + ", " + qth_get_bits( ::cQtObject, .T. ) + " ) )"
      oMtd:cPrgRet := "o" + ::cQtObject

   CASE "<" $ oRet:cCast
      DO CASE
      CASE ! ( "QList" $ oRet:cCast )
         oMtd:cCmd := ""
         oMtd:cPrgRet := ""
      CASE "::" $ oRet:cCast
         oMtd:cCmd := ""
         oMtd:cPrgRet := ""
      CASE "QPair" $ oRet:cCast
         oMtd:cCmd := ""
         oMtd:cPrgRet := ""
      CASE "<T>" $ oRet:cCast
         oMtd:cCmd := ""
         oMtd:cPrgRet := ""
      OTHERWISE
         cRef := "QList"
         cRefInList := StrTran( oRet:cCast, "QList<" )
         cRefInList := StrTran( cRefInList, ">" )
         cRefInList := StrTran( cRefInList, "*" )
         cRefInList := StrTran( cRefInList, " " )
         oMtd:isRetList := .T.
         oMtd:cCmd := "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "new " + oRet:cCast + "( " + oMtd:cCmn + " )" + ', "' + "HB_" + "QList" + '", hbqt_del_' + "QList" + ", " + qth_get_bits( "QList", .T. ) + " ) )"
         oMtd:cPrgRet := "o" + oMtd:cDocNMRet
      ENDCASE

   CASE oRet:cCast == "T"
      oMtd:cCmd := "hb_itemReturn( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE oRet:cCast == "JavaVM"
      oMtd:cCmd := "hb_retptr( ( void * ) " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "p" + oMtd:cDocNMRet

   CASE oRet:cCast == "void"
      oMtd:cCmd := oMtd:cCmn
      oMtd:cPrgRet := "NIL"

   CASE oRet:cCast == "WId"
      oMtd:cCmd := "hb_retnint( ( HB_PTRDIFF ) " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "n" + oMtd:cDocNMRet

   CASE oRet:cCast $ ::cInt
      oMtd:cCmd := "hb_retni( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "n" + oMtd:cDocNMRet

   CASE oRet:cCast $ ::cIntLong
      oMtd:cCmd := "hb_retnl( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "n" + oMtd:cDocNMRet

   CASE oRet:cCast $ ::cIntLongLong
      oMtd:cCmd := "hb_retnint( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "n" + oMtd:cDocNMRet

   CASE oRet:cCast $ "double,qreal,float"
      oMtd:cCmd := "hb_retnd( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "n" + oMtd:cDocNMRet

   CASE "::" $ oRet:cCast
      oMtd:cCmd := "hb_retni( ( " + oRet:cCast + " ) " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "n" + oMtd:cDocNMRet

   CASE oRet:cCast == "bool"
      oMtd:cCmd := "hb_retl( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "l" + oMtd:cDocNMRet

   CASE oRet:cCast == "char" .AND. oRet:lFar
      oMtd:cCmd := "hb_retc( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "c" + oMtd:cDocNMRet

   CASE oRet:cCast == "char"
      oMtd:cCmd := "hb_retni( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "c" + oMtd:cDocNMRet

   CASE oRet:cCast == "QString"
      oMtd:cCmd := "hb_retstr_utf8( " + oMtd:cCmn + ".toUtf8().data()" + " )"
      oMtd:cPrgRet := "c" + oMtd:cDocNMRet

   CASE oRet:cCast == "FT_Face"
      oMtd:cCmd := "hb_retc( " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "c" + oMtd:cDocNMRet

   CASE oRet:lFar .AND. ( oRet:cCast $ "uchar" )
      oMtd:cCmd := "hb_retc( ( const char * ) " + oMtd:cCmn + " )"
      oMtd:cPrgRet := "c" + oMtd:cDocNMRet

   CASE oRet:lFar .AND. ! oRet:lConst
      cRef := oRet:cCast
    //oMtd:cCmd := hbqtgen_Get_Command( oRet:cCast, oMtd:cCmn, .F. )
      oMtd:cCmd := hbqtgen_Get_Command( oRet:cCast, oMtd:cCmn, .F., oMtd:nDetachRet > 0 )
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE hbqtgen_isAqtObject( oRet:cCast )  .AND. ;
                             oRet:lFar     .AND. ;
                             oRet:lConst   .AND. ;
                             "Abstract" $ oRet:cCast
      cRef := oRet:cCast

      oMtd:cCmd := "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "( void * ) " + oMtd:cCmn + ', "' + "HB_" + Upper( oRet:cCast ) + '", hbqt_del_' +  oRet:cCast + ", " + qth_get_bits( oRet:cCast, .F. ) + " ) )"
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE hbqtgen_isAqtObject( oRet:cCast )  .AND. ;
                             oRet:lFar     .AND. ;
                             oRet:lConst   .AND. ;
                             oRet:lVirt
      cRef := oRet:cCast

      oMtd:cCmd := "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "( void * ) " + oMtd:cCmn + ', "' + "HB_" + Upper( oRet:cCast ) + '", hbqt_del_' +  oRet:cCast + ", " + qth_get_bits( oRet:cCast, .F. ) + " ) )"
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE hbqtgen_isAqtObject( oRet:cCast )  .AND. ;
                             oRet:lFar     .AND. ;
                             oRet:lConst   .AND. ;
                             oRet:lConstL
      cRef := oRet:cCast
      oMtd:cCmd := hbqtgen_Get_Command_1( oRet:cCast, oMtd:cCmn, oMtd:nDetachRet != 9 )
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE oRet:lAnd .AND. oRet:lConst
      cRef := oRet:cCast
      oMtd:cCmd := hbqtgen_Get_Command( oRet:cCast, oMtd:cCmn, .T. )
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE oRet:lConst
      cRef := oRet:cCast
      oMtd:cCmd := hbqtgen_Get_Command( oRet:cCast, oMtd:cCmn, .T. )
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   CASE oRet:lAnd
      cRef := oRet:cCast
      oMtd:cCmd := hbqtgen_Get_Command( oRet:cCast, oMtd:cCmn, .T. )
      oMtd:cPrgRet := "o" + oMtd:cDocNMRet

   OTHERWISE
      /* No attribute is attached to return value */
      IF hbqtgen_isAqtObject( oRet:cCast )
         cRef := oRet:cCast
         oMtd:cCmd := hbqtgen_Get_Command( oRet:cCast, oMtd:cCmn, .T. )
         oMtd:cPrgRet := "o" + oMtd:cDocNMRet
      ELSE
         oMtd:cError := "<<< " + oMtd:cProto + " | " + oRet:cCast + " >>>"
         oMtd:cCmd := ""
         oMtd:cPrgRet := ""
      ENDIF
   ENDCASE

   /* Lists to be disabled in parameters - TODO */
   IF "<" $ oMtd:cPar
      oMtd:cCmd := ""
   ENDIF

   IF ( oMtd:lValid := ! Empty( oMtd:cCmd ) )
      AAdd( ::aMethods, oMtd )
      hbqtgen_AddRef( ::hRef, cRef )
      IF ! Empty( cRefInList ) .AND. ! ( cRefInList $ "int,qreal" )
         hbqtgen_AddRef( ::hRef, cRefInList )
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/
/*                          Class HbqtMethod                            */
/*----------------------------------------------------------------------*/

CREATE CLASS HbqtMethod

   VAR    name                                    INIT ""   //  widget
   VAR    isVariable                              INIT .F.
   VAR    lValid                                  INIT .T.
   VAR    nSiblings                               INIT 0    //  names post_fixed by number
   VAR    isSibling                               INIT .F.  //  is nother function with same name
   VAR    isConstructor                           INIT .F.
   VAR    areFuncClubbed                          INIT .T.
   VAR    isRetList                               INIT .F.

   VAR    cProto                                  INIT ""   //  QWidget * widget ( QWidget * parent, const QString & name ) const  [*D=4*]

   VAR    cPre                                    INIT ""   //  ^^^^^^^^^^^^^^^^
   VAR    cPar                                    INIT ""   //                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   VAR    cPas                                    INIT ""   //                                                              ^^^^^
   VAR    cMrk                                    INIT ""   //                                                                       ^^^

   VAR    nDetach                                 INIT 0
   VAR    nAttach                                 INIT 0
   VAR    cVersion                                INIT ""
   VAR    cDefine                                 INIT ""
   VAR    nDetachRet                              INIT -1

   VAR    cFun                                    INIT ""
   VAR    cRet                                    INIT ""

   VAR    cParas                                  INIT ""
   VAR    cParasN                                 INIT ""
   VAR    cDocs                                   INIT ""

   VAR    cDoc                                    INIT ""   // Qt_QWidget_setSize_1( nWidth, nHeight ) -> NIL

   VAR    cError                                  INIT ""
   VAR    cCmd                                    INIT ""
   VAR    cCmdN                                   INIT ""
   VAR    cCmn                                    INIT ""
   VAR    cCmnN                                   INIT ""
   VAR    cDocNM                                  INIT ""
   VAR    cDocNMRet                               INIT ""
   VAR    cPrgRet                                 INIT ""
   VAR    cWdg                                    INIT ""
   VAR    cHBFunc                                 INIT ""

   VAR    aPre                                    INIT {}
   VAR    aPreN                                   INIT {}
   VAR    nHBIdx
   VAR    nHBIdxN
   VAR    nArgQCast                               INIT 0    //  First argument position of type Q*Class
   VAR    nArgHBObj                               INIT 0    //  First argument position of type Q*Class

   VAR    oRet
   VAR    nArgs                                   INIT 0    //  Number of arguments contained
   VAR    nArgsOpt                                INIT 0    //  Number of optional arguments contained
   VAR    nArgsReal                               INIT 0    //  Number of minimum arguments to be supplied

   VAR    hArgs                                   INIT { => }

   VAR    fBody_                                  INIT {}

   VAR    cMtdDef
   VAR    cMtdCall

   METHOD new()

ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbqtMethod:new()
   hb_hKeepOrder( ::hArgs, .T. )
   RETURN Self

/*----------------------------------------------------------------------*/
/*                         Class HbqtArgument                           */
/*----------------------------------------------------------------------*/

CREATE CLASS HbqtArgument

   VAR    cRaw
   VAR    cNormal
   VAR    cName
   VAR    cCast                                INIT ""
   VAR    cBody
   VAR    cBodyN
   VAR    cDoc

   VAR    lRet                                 INIT .F.

   VAR    cTypeHb
   VAR    cTypeQt
   VAR    cObject

   VAR    lConst                               INIT .F.
   VAR    lAnd                                 INIT .F.
   VAR    lFar                                 INIT .F.
   VAR    lVirt                                INIT .F.
   VAR    lConstL                              INIT .F.

   VAR    lList                                INIT .F.

   VAR    lOptional                            INIT .F.
   VAR    cDefault

   METHOD new( cTxt, cQtObject, enum_, lConstL, lIsRetArg )

ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbqtArgument:new( cTxt, cQtObject, enum_, lConstL, lIsRetArg )
   LOCAL n

   ::cRaw    := cTxt
   ::lRet    := lIsRetArg
   ::lList   := "<" $ cTxt

   ::lConst  := "const"   $ cTxt
   ::lAnd    := "&"       $ cTxt
   ::lFar    := "*"       $ cTxt
   ::lVirt   := "virtual" $ cTxt
   ::lConstL := lConstL

   IF ( n := at( "=", cTxt ) ) > 0
      ::cDefault  := AllTrim( SubStr( cTxt, n + 1 ) )
      ::lOptional := .T.
      cTxt := SubStr( cTxt, 1, n - 1 )
   ENDIF

   cTxt := StrTran( cTxt, "virtual " )
   cTxt := StrTran( cTxt, "const "   )
   cTxt := StrTran( cTxt, "   "     , " " )
   cTxt := StrTran( cTxt, "  "      , " " )
   IF ! ::lList
      cTxt := StrTran( cTxt, "& " )
      cTxt := StrTran( cTxt, "&"  )
      cTxt := StrTran( cTxt, "* " )
      cTxt := StrTran( cTxt, "*"  )
   ENDIF
   ::cNormal := cTxt := AllTrim( cTxt )

   IF ::lList
      ::cCast := cTxt
      ::cName := ::cCast
   ELSE
      IF ( n := at( " ", cTxt ) ) > 0
         ::cCast := SubStr( cTxt, 1, n - 1 )
         ::cName := SubStr( cTxt, n + 1 )
      ELSE
         ::cCast := cTxt
         ::cName := cTxt
      ENDIF
   ENDIF

   IF AScan( enum_, {| e | iif( Empty( e ), .F., e == ::cCast ) } ) > 0
      ::cCast := cQtObject + "::" + ::cCast
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/
/*                        Helper Functions                              */
/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_Get_Command_1( cWgt, cCmn, lNew )
   IF lNew == NIL
      lNew := .T.
   ENDIF
   IF lNew
      RETURN "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "new " + cWgt + "( *( " + cCmn + " ) )" + ', "' + "HB_" + Upper( cWgt ) + '", hbqt_del_' + cWgt + ", " + qth_get_bits( cWgt, .T. ) + " ) )"
   ELSE
      RETURN "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "( void * ) " + cCmn + ', "' + "HB_" + Upper( cWgt ) + '", hbqt_del_' + cWgt + ", " + qth_get_bits( cWgt, .F. ) + " ) )"
   ENDIF
   RETURN ""

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_Get_Command( cWgt, cCmn, lNew, isRetDetached )

   IF lNew == NIL
      lNew := .T.
   ENDIF
   IF isRetDetached == NIL
      isRetDetached := .F.
   ENDIF

   IF lNew
      RETURN "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + "new " + cWgt + "( " + cCmn + " )" + ', "' + "HB_" + Upper( cWgt ) + '", hbqt_del_' + cWgt + ", " + qth_get_bits( cWgt, .T. ) + " ) )"
   ELSE
      RETURN "hb_itemReturnRelease( hbqt_bindGetHbObject( NULL, " + cCmn + ', "' + "HB_" + Upper( cWgt ) + '", hbqt_del_' + cWgt + ", " + qth_get_bits( cWgt, isRetDetached ) + " ) )"
   ENDIF
   RETURN ""

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_PullOutSection( cQth, cSec )
   LOCAL cTxt, n, nn, cTknB, cTknE
   LOCAL a_:={}

   cTknB := "<" + cSec + ">"
   cTknE := "</" + cSec + ">"

   IF ( n := at( cTknB, cQth ) ) > 0
      IF( nn := at( cTknE, cQth ) ) > 0
         cTxt := SubStr( cQth, n + Len( cTknB ), nn - 1 - ( n + Len( cTknB ) ) )
      ENDIF
      IF ! Empty( cTxt )
         a_:= hb_ATokens( cTxt, Chr( 10 ) )
      ENDIF
   ENDIF

   RETURN a_

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_PullOutFuncBody( protos_, nFrom )
   LOCAL s, nTo := 0,  a_:= {}

   FOR EACH s IN protos_
      IF s:__enumIndex() > nFrom
         IF Left( s, 1 ) == "}"
            nTo := s:__enumIndex()
            EXIT
         ENDIF
      ENDIF
   NEXT
   IF nTo > nFrom
      FOR EACH s IN protos_
         IF s:__enumIndex() > nFrom .AND. s:__enumIndex() < nTo
            AAdd( a_, s )
            s := ""
         ENDIF
      NEXT
   ENDIF

   RETURN a_

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_isAqtObject( cCast )
   RETURN Left( cCast, 1 ) == "Q" .OR. Left( cCast, 3 ) == "HBQ"

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_CreateTarget( cFile, txt_ )
   LOCAL cContent := ""

   AEval( txt_, {| e | cContent += RTrim( e ) + hb_eol() } )

   RETURN hb_MemoWrit( cFile, cContent )

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_BuildCopyrightText()
   LOCAL txt_ := {}

   AAdd( txt_, "/* WARNING: Automatically generated source file. DO NOT EDIT! */" )
   AAdd( txt_, ""                                                                 )
   AAdd( txt_, "/* Harbour QT wrapper"                                            )
   AAdd( txt_, "   Copyright 2009-2013 Pritpal Bedi <bedipritpal@hotmail.com>"    )
   AAdd( txt_, "   www - http://harbour-project.org */"                           )
   AAdd( txt_, ""                                                                 )
   AAdd( txt_, '#include "hbqt.h"'                                                )
   AAdd( txt_, '#include "hbapiitm.h"'                                            )
   AAdd( txt_, '#include "hbvm.h"'                                                )
   AAdd( txt_, '#include "hbapierr.h"'                                            )
   AAdd( txt_, '#include "hbstack.h"'                                             )
   AAdd( txt_, '#include "hbdefs.h"'                                              )
   AAdd( txt_, '#include "hbapicls.h"'                                            )
   AAdd( txt_, ""                                                                 )

   RETURN txt_

/*----------------------------------------------------------------------*/

STATIC PROCEDURE hbqtgen_BuildFooter( txt_ )
   AAdd( txt_, "#endif" )
   RETURN

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbqtgen_stripLastFrom( cStr, cDlm )
   LOCAL n
   IF ( n := rAt( cDlm, cStr ) ) > 0
      RETURN SubStr( cStr, 1, n - 1 )
   ENDIF
   RETURN cStr

/*----------------------------------------------------------------------*/

STATIC FUNCTION __TY( oM, nArgs )
   LOCAL i, s := ""
   FOR i := 1 TO nArgs
      s += PadR( oM:hArgs[ i ]:cTypeHB, 3 )
   NEXT
   RETURN s

/*----------------------------------------------------------------------*/

STATIC FUNCTION __TY_Method( oMtd, nArgs )
   LOCAL nArg, oArg, aIdx := {}, cRet

   FOR EACH oArg IN oMtd:hArgs
      IF oArg:__enumIndex() >= oMtd:nArgQCast
         IF ! ( "::" $ oArg:cCast ) .AND. ! ( oArg:cCast == "QString" ) .AND. ( Left( oArg:cCast, 1 ) == "Q" .OR. Left( oArg:cCast, 3 ) == "HBQ" )
            AAdd( aIdx, oArg:__enumIndex() )
         ENDIF
      ENDIF
      IF oArg:__enumIndex() == nArgs
         EXIT
      ENDIF
   NEXT

   cRet := ""
   FOR EACH nArg IN aIdx
      cRet += "hbqt_par_isDerivedFrom( " + hb_ntos( nArg ) + ', "' + upper( oMtd:hArgs[ nArg ]:cCast ) + '" )' + " && "
   NEXT
   cRet := SubStr( cRet, 1, Len( cRet ) - 4 )

   RETURN cRet

/*----------------------------------------------------------------------*/

STATIC FUNCTION qth_is_extended( cQTHFileName )
   LOCAL lYes := .F.
   LOCAL cQth, aTkn, n, s, class_, cls_:= {}

   cQth := hb_MemoRead( cQTHFileName )

   /* Prepare to be parsed properly */
   IF !( hb_eol() == Chr( 10 ) )
      cQth := StrTran( cQth, hb_eol(), Chr( 10 ) )
   ENDIF
   IF !( hb_eol() == Chr( 13 ) + Chr( 10 ) )
      cQth := StrTran( cQth, Chr( 13 ) + Chr( 10 ), Chr( 10 ) )
   ENDIF

   IF ! Empty( class_:= hbqtgen_PullOutSection( @cQth, "CLASS" ) )
      FOR EACH s IN class_
         IF ( n := at( "=", s ) ) > 0
            AAdd( cls_, { Upper( AllTrim( SubStr( s, 1, n - 1 ) ) ), Upper( AllTrim( SubStr( s, n + 1 ) ) ) } )
         ENDIF
      NEXT
   ENDIF

   FOR EACH aTkn IN cls_
      IF aTkn[ 1 ] $ "PAINTEVENT,xxx"
         IF aTkn[ 2 ] == "YES"
            lYes := .T.
         ENDIF
      ENDIF
   NEXT

   RETURN lYes

/*----------------------------------------------------------------------*/

#define HBQT_BIT_NONE                             0
#define HBQT_BIT_OWNER                            1
#define HBQT_BIT_QOBJECT                          2
#define HBQT_BIT_CONSTRUCTOR                      4
#define HBQT_BIT_DESTRUCTOR                       8
#define HBQT_BIT_QPOINTER                         16

STATIC FUNCTION qth_get_bits( cWidget, lNew )
   LOCAL cBits := "HBQT_BIT_NONE"

   IF lNew
      cBits += " | HBQT_BIT_OWNER"
   ENDIF
   IF qth_is_QObject( cWidget )
      cBits += " | HBQT_BIT_QOBJECT"
   ENDIF

   RETURN cBits

/*----------------------------------------------------------------------*/

STATIC FUNCTION IsQt5Widget( cWidget )

   STATIC s_b_ := { ;
         "QAbstractButton"                      => NIL , ;
         "QAbstractGraphicsShapeItem"           => NIL , ;
         "QAbstractItemDelegate"                => NIL , ;
         "QAbstractItemView"                    => NIL , ;
         "QAbstractScrollArea"                  => NIL , ;
         "QAbstractSlider"                      => NIL , ;
         "QAbstractSpinBox"                     => NIL , ;
         "QAction"                              => NIL , ;
         "QActionGroup"                         => NIL , ;
         "QApplication"                         => NIL , ;
         "QBoxLayout"                           => NIL , ;
         "QButtonGroup"                         => NIL , ;
         "QCalendarWidget"                      => NIL , ;
         "QCheckBox"                            => NIL , ;
         "QColorDialog"                         => NIL , ;
         "QColormap"                            => NIL , ;
         "QColumnView"                          => NIL , ;
         "QComboBox"                            => NIL , ;
         "QCommandLinkButton"                   => NIL , ;
         "QCommonStyle"                         => NIL , ;
         "QCompleter"                           => NIL , ;
         "QDataWidgetMapper"                    => NIL , ;
         "QDateEdit"                            => NIL , ;
         "QDateTimeEdit"                        => NIL , ;
         "QDesktopWidget"                       => NIL , ;
         "QDial"                                => NIL , ;
         "QDialog"                              => NIL , ;
         "QDialogButtonBox"                     => NIL , ;
         "QDockWidget"                          => NIL , ;
         "QDoubleSpinBox"                       => NIL , ;
         "QErrorMessage"                        => NIL , ;
         "QFileDialog"                          => NIL , ;
         "QFileIconProvider"                    => NIL , ;
         "QFileSystemModel"                     => NIL , ;
         "QFocusFrame"                          => NIL , ;
         "QFontComboBox"                        => NIL , ;
         "QFontDialog"                          => NIL , ;
         "QFormLayout"                          => NIL , ;
         "QFrame"                               => NIL , ;
         "QGesture"                             => NIL , ;
         "QGestureEvent"                        => NIL , ;
         "QGestureRecognizer"                   => NIL , ;
         "QGraphicsAnchor"                      => NIL , ;
         "QGraphicsAnchorLayout"                => NIL , ;
         "QGraphicsBlurEffect"                  => NIL , ;
         "QGraphicsColorizeEffect"              => NIL , ;
         "QGraphicsDropShadowEffect"            => NIL , ;
         "QGraphicsEffect"                      => NIL , ;
         "QGraphicsEllipseItem"                 => NIL , ;
         "QGraphicsGridLayout"                  => NIL , ;
         "QGraphicsItem"                        => NIL , ;
         "QGraphicsItemAnimation"               => NIL , ;
         "QGraphicsItemGroup"                   => NIL , ;
         "QGraphicsLayout"                      => NIL , ;
         "QGraphicsLayoutItem"                  => NIL , ;
         "QGraphicsLineItem"                    => NIL , ;
         "QGraphicsLinearLayout"                => NIL , ;
         "QGraphicsObject"                      => NIL , ;
         "QGraphicsOpacityEffect"               => NIL , ;
         "QGraphicsPathItem"                    => NIL , ;
         "QGraphicsPixmapItem"                  => NIL , ;
         "QGraphicsPolygonItem"                 => NIL , ;
         "QGraphicsProxyWidget"                 => NIL , ;
         "QGraphicsRectItem"                    => NIL , ;
         "QGraphicsRotation"                    => NIL , ;
         "QGraphicsScale"                       => NIL , ;
         "QGraphicsScene"                       => NIL , ;
         "QGraphicsSceneContextMenuEvent"       => NIL , ;
         "QGraphicsSceneDragDropEvent"          => NIL , ;
         "QGraphicsSceneEvent"                  => NIL , ;
         "QGraphicsSceneHelpEvent"              => NIL , ;
         "QGraphicsSceneHoverEvent"             => NIL , ;
         "QGraphicsSceneMouseEvent"             => NIL , ;
         "QGraphicsSceneMoveEvent"              => NIL , ;
         "QGraphicsSceneResizeEvent"            => NIL , ;
         "QGraphicsSceneWheelEvent"             => NIL , ;
         "QGraphicsSimpleTextItem"              => NIL , ;
         "QGraphicsTextItem"                    => NIL , ;
         "QGraphicsTransform"                   => NIL , ;
         "QGraphicsView"                        => NIL , ;
         "QGraphicsWidget"                      => NIL , ;
         "QGridLayout"                          => NIL , ;
         "QGroupBox"                            => NIL , ;
         "QHBoxLayout"                          => NIL , ;
         "QHeaderView"                          => NIL , ;
         "QInputDialog"                         => NIL , ;
         "QItemDelegate"                        => NIL , ;
         "QItemEditorCreator"                   => NIL , ;
         "QItemEditorCreatorBase"               => NIL , ;
         "QItemEditorFactory"                   => NIL , ;
         "QKeyEventTransition"                  => NIL , ;
         "QLCDNumber"                           => NIL , ;
         "QLabel"                               => NIL , ;
         "QLayout"                              => NIL , ;
         "QLayoutItem"                          => NIL , ;
         "QLineEdit"                            => NIL , ;
         "QListView"                            => NIL , ;
         "QListWidget"                          => NIL , ;
         "QListWidgetItem"                      => NIL , ;
         "QMacCocoaViewContainer"               => NIL , ;
         "QMacNativeWidget"                     => NIL , ;
         "QMainWindow"                          => NIL , ;
         "QMdiArea"                             => NIL , ;
         "QMdiSubWindow"                        => NIL , ;
         "QMenu"                                => NIL , ;
         "QMenuBar"                             => NIL , ;
         "QMessageBox"                          => NIL , ;
         "QMouseEventTransition"                => NIL , ;
         "QPanGesture"                          => NIL , ;
         "QPinchGesture"                        => NIL , ;
         "QPlainTextDocumentLayout"             => NIL , ;
         "QPlainTextEdit"                       => NIL , ;
         "QProgressBar"                         => NIL , ;
         "QProgressDialog"                      => NIL , ;
         "QProxyStyle"                          => NIL , ;
         "QPushButton"                          => NIL , ;
         "QRadioButton"                         => NIL , ;
         "QRubberBand"                          => NIL , ;
         "QScrollArea"                          => NIL , ;
         "QScrollBar"                           => NIL , ;
         "QScroller"                            => NIL , ;
         "QScrollerProperties"                  => NIL , ;
         "QShortcut"                            => NIL , ;
         "QSizeGrip"                            => NIL , ;
         "QSizePolicy"                          => NIL , ;
         "QSlider"                              => NIL , ;
         "QSpacerItem"                          => NIL , ;
         "QSpinBox"                             => NIL , ;
         "QSplashScreen"                        => NIL , ;
         "QSplitter"                            => NIL , ;
         "QSplitterHandle"                      => NIL , ;
         "QStackedLayout"                       => NIL , ;
         "QStackedWidget"                       => NIL , ;
         "QStandardItemEditorCreator"           => NIL , ;
         "QStatusBar"                           => NIL , ;
         "QStyle"                               => NIL , ;
         "QStyleFactory"                        => NIL , ;
         "QStyleHintReturn"                     => NIL , ;
         "QStyleHintReturnMask"                 => NIL , ;
         "QStyleHintReturnVariant"              => NIL , ;
         "QStyleOption"                         => NIL , ;
         "QStyleOptionButton"                   => NIL , ;
         "QStyleOptionComboBox"                 => NIL , ;
         "QStyleOptionComplex"                  => NIL , ;
         "QStyleOptionDockWidget"               => NIL , ;
         "QStyleOptionFocusRect"                => NIL , ;
         "QStyleOptionFrame"                    => NIL , ;
         "QStyleOptionGraphicsItem"             => NIL , ;
         "QStyleOptionGroupBox"                 => NIL , ;
         "QStyleOptionHeader"                   => NIL , ;
         "QStyleOptionMenuItem"                 => NIL , ;
         "QStyleOptionProgressBar"              => NIL , ;
         "QStyleOptionRubberBand"               => NIL , ;
         "QStyleOptionSizeGrip"                 => NIL , ;
         "QStyleOptionSlider"                   => NIL , ;
         "QStyleOptionSpinBox"                  => NIL , ;
         "QStyleOptionTab"                      => NIL , ;
         "QStyleOptionTabBarBase"               => NIL , ;
         "QStyleOptionTabWidgetFrame"           => NIL , ;
         "QStyleOptionTitleBar"                 => NIL , ;
         "QStyleOptionToolBar"                  => NIL , ;
         "QStyleOptionToolBox"                  => NIL , ;
         "QStyleOptionToolButton"               => NIL , ;
         "QStyleOptionViewItem"                 => NIL , ;
         "QStylePainter"                        => NIL , ;
         "QStylePlugin"                         => NIL , ;
         "QStyledItemDelegate"                  => NIL , ;
         "QSwipeGesture"                        => NIL , ;
         "QSystemTrayIcon"                      => NIL , ;
         "QTabBar"                              => NIL , ;
         "QTabWidget"                           => NIL , ;
         "QTableView"                           => NIL , ;
         "QTableWidget"                         => NIL , ;
         "QTableWidgetItem"                     => NIL , ;
         "QTableWidgetSelectionRange"           => NIL , ;
         "QTapAndHoldGesture"                   => NIL , ;
         "QTapGesture"                          => NIL , ;
         "QTextBrowser"                         => NIL , ;
         "QTextEdit"                            => NIL , ;
         "QTileRules"                           => NIL , ;
         "QTimeEdit"                            => NIL , ;
         "QToolBar"                             => NIL , ;
         "QToolBox"                             => NIL , ;
         "QToolButton"                          => NIL , ;
         "QToolTip"                             => NIL , ;
         "QTreeView"                            => NIL , ;
         "QTreeWidget"                          => NIL , ;
         "QTreeWidgetItem"                      => NIL , ;
         "QTreeWidgetItemIterator"              => NIL , ;
         "QUndoCommand"                         => NIL , ;
         "QUndoGroup"                           => NIL , ;
         "QUndoStack"                           => NIL , ;
         "QUndoView"                            => NIL , ;
         "QVBoxLayout"                          => NIL , ;
         "QWhatsThis"                           => NIL , ;
         "QWidget"                              => NIL , ;
         "QWidgetAction"                        => NIL , ;
         "QWidgetItem"                          => NIL , ;
         "QWizard"                              => NIL , ;
         "QWizardPage"                          => NIL   }

   RETURN cWidget $ s_b_

/*----------------------------------------------------------------------*/

STATIC FUNCTION IsQt5PrintSupport( cWidget )

   STATIC s_b_ := { ;
         "QAbstractPrintDialog"                 => NIL , ;
         "QPrintDialog"                         => NIL , ;
         "QPageSetupDialog"                     => NIL , ;
         "QPrintPreviewDialog"                  => NIL , ;
         "QPrinter"                             => NIL , ;
         "QPrintEngine"                         => NIL , ;
         "QPrinterInfo"                         => NIL , ;
         "QPrinterInfo"                         => NIL , ;
         "QPrintPreviewWidget"                  => NIL   }

   RETURN cWidget $ s_b_

/*----------------------------------------------------------------------*/

STATIC FUNCTION qth_is_QObject( cWidget )

   /* TOFIX: add this information to .qth.
             it breaks modularity and split the same king of information between
             this plugin and .qth files. */
   STATIC s_b_:= { ;
      "QObject"                                 => NIL , ;
      "QAbstractAnimation"                      => NIL , ;
      "QAbstractEventDispatcher"                => NIL , ;
      "QAbstractFontEngine"                     => NIL , ;
      "QAbstractItemDelegate"                   => NIL , ;
      "QAbstractItemModel"                      => NIL , ;
      "QAbstractMessageHandler"                 => NIL , ;
      "QAbstractState"                          => NIL , ;
      "QAbstractTextDocumentLayout"             => NIL , ;
      "QAbstractTransition"                     => NIL , ;
      "QAbstractUriResolver"                    => NIL , ;
      "QAbstractVideoSurface"                   => NIL , ;
      "QAccessibleBridgePlugin"                 => NIL , ;
      "QAccessiblePlugin"                       => NIL , ;
      "QAction"                                 => NIL , ;
      "QActionGroup"                            => NIL , ;
      "QAudioInput"                             => NIL , ;
      "QAudioOutput"                            => NIL , ;
      "QAxFactory"                              => NIL , ;
      "QAxObject"                               => NIL , ;
      "QAxScript"                               => NIL , ;
      "QAxScriptManager"                        => NIL , ;
      "QButtonGroup"                            => NIL , ;
      "QClipboard"                              => NIL , ;
      "QCompleter"                              => NIL , ;
      "QCopChannel"                             => NIL , ;
      "QCoreApplication"                        => NIL , ;
      "QDataWidgetMapper"                       => NIL , ;
      "QDBusAbstractAdaptor"                    => NIL , ;
      "QDBusAbstractInterface"                  => NIL , ;
      "QDBusPendingCallWatcher"                 => NIL , ;
      "QDBusServiceWatcher"                     => NIL , ;
      "QDeclarativeComponent"                   => NIL , ;
      "QDeclarativeContext"                     => NIL , ;
      "QDeclarativeEngine"                      => NIL , ;
      "QDeclarativeExpression"                  => NIL , ;
      "QDeclarativeExtensionPlugin"             => NIL , ;
      "QDeclarativePropertyMap"                 => NIL , ;
      "QDecorationPlugin"                       => NIL , ;
      "QDesignerFormEditorInterface"            => NIL , ;
      "QDesignerFormWindowManagerInterface"     => NIL , ;
      "QDirectPainter"                          => NIL , ;
      "QDrag"                                   => NIL , ;
      "QEventLoop"                              => NIL , ;
      "QExtensionFactory"                       => NIL , ;
      "QExtensionManager"                       => NIL , ;
      "QFileSystemWatcher"                      => NIL , ;
      "QFontEnginePlugin"                       => NIL , ;
      "QFtp"                                    => NIL , ;
      "QFutureWatcher"                          => NIL , ;
      "QGenericPlugin"                          => NIL , ;
      "QGesture"                                => NIL , ;
      "QGLShader"                               => NIL , ;
      "QGLShaderProgram"                        => NIL , ;
      "QGraphicsAnchor"                         => NIL , ;
      "QGraphicsEffect"                         => NIL , ;
      "QGraphicsItemAnimation"                  => NIL , ;
      "QGraphicsObject"                         => NIL , ;
      "QGraphicsScene"                          => NIL , ;
      "QGraphicsTransform"                      => NIL , ;
      "QHelpEngineCore"                         => NIL , ;
      "QHelpSearchEngine"                       => NIL , ;
      "QHttp"                                   => NIL , ;
      "QHttpMultiPart"                          => NIL , ;
      "QIconEnginePlugin"                       => NIL , ;
      "QIconEnginePluginV2"                     => NIL , ;
      "QImageIOPlugin"                          => NIL , ;
      "QInputContext"                           => NIL , ;
      "QInputContextPlugin"                     => NIL , ;
      "QIODevice"                               => NIL , ;
      "QItemSelectionModel"                     => NIL , ;
      "QKbdDriverPlugin"                        => NIL , ;
      "QLayout"                                 => NIL , ;
      "QLibrary"                                => NIL , ;
      "QLocalServer"                            => NIL , ;
      "QMimeData"                               => NIL , ;
      "QMouseDriverPlugin"                      => NIL , ;
      "QMovie"                                  => NIL , ;
      "QObjectCleanupHandler"                   => NIL , ;
      "QPictureFormatPlugin"                    => NIL , ;
      "QPlatformCursor"                         => NIL , ;
      "QPluginLoader"                           => NIL , ;
      "QScreenDriverPlugin"                     => NIL , ;
      "QScriptEngine"                           => NIL , ;
      "QScriptEngineDebugger"                   => NIL , ;
      "QScriptExtensionPlugin"                  => NIL , ;
      "QSessionManager"                         => NIL , ;
      "QSettings"                               => NIL , ;
      "QSharedMemory"                           => NIL , ;
      "QShortcut"                               => NIL , ;
      "QSignalMapper"                           => NIL , ;
      "QSignalSpy"                              => NIL , ;
      "QSocketNotifier"                         => NIL , ;
      "QSound"                                  => NIL , ;
      "QSqlDriver"                              => NIL , ;
      "QSqlDriverPlugin"                        => NIL , ;
      "QStyle"                                  => NIL , ;
      "QStylePlugin"                            => NIL , ;
      "QSvgRenderer"                            => NIL , ;
      "QSyntaxHighlighter"                      => NIL , ;
      "QSystemTrayIcon"                         => NIL , ;
      "QTcpServer"                              => NIL , ;
      "QTextCodecPlugin"                        => NIL , ;
      "QTextDocument"                           => NIL , ;
      "QTextObject"                             => NIL , ;
      "QThread"                                 => NIL , ;
      "QThreadPool"                             => NIL , ;
      "QTimeLine"                               => NIL , ;
      "QTimer"                                  => NIL , ;
      "QTranslator"                             => NIL , ;
      "QUiLoader"                               => NIL , ;
      "QUndoGroup"                              => NIL , ;
      "QUndoStack"                              => NIL , ;
      "QValidator"                              => NIL , ;
      "QWebFrame"                               => NIL , ;
      "QWebHistoryInterface"                    => NIL , ;
      "QWebPage"                                => NIL , ;
      "QWebPluginFactory"                       => NIL , ;
      "QWidget"                                 => NIL , ;
      "QWSClient"                               => NIL , ;
      "QWSInputMethod"                          => NIL , ;
      "QWSServer"                               => NIL , ;
      "QAbstractButton"                         => NIL , ;
      "QAbstractSlider"                         => NIL , ;
      "QAbstractSpinBox"                        => NIL , ;
      "QAxWidget"                               => NIL , ;
      "QCalendarWidget"                         => NIL , ;
      "QComboBox"                               => NIL , ;
      "QDesignerActionEditorInterface"          => NIL , ;
      "QDesignerFormWindowInterface"            => NIL , ;
      "QDesignerObjectInspectorInterface"       => NIL , ;
      "QDesignerPropertyEditorInterface"        => NIL , ;
      "QDesignerWidgetBoxInterface"             => NIL , ;
      "QDesktopWidget"                          => NIL , ;
      "QDialog"                                 => NIL , ;
      "QDialogButtonBox"                        => NIL , ;
      "QDockWidget"                             => NIL , ;
      "QFocusFrame"                             => NIL , ;
      "QFrame"                                  => NIL , ;
      "QGLWidget"                               => NIL , ;
      "QGroupBox"                               => NIL , ;
      "QHelpSearchQueryWidget"                  => NIL , ;
      "QHelpSearchResultWidget"                 => NIL , ;
      "QLineEdit"                               => NIL , ;
      "QMacCocoaViewContainer"                  => NIL , ;
      "QMacNativeWidget"                        => NIL , ;
      "QMainWindow"                             => NIL , ;
      "QMdiSubWindow"                           => NIL , ;
      "QMenu"                                   => NIL , ;
      "QMenuBar"                                => NIL , ;
      "QPrintPreviewWidget"                     => NIL , ;
      "QProgressBar"                            => NIL , ;
      "QRubberBand"                             => NIL , ;
      "QSizeGrip"                               => NIL , ;
      "QSplashScreen"                           => NIL , ;
      "QSplitterHandle"                         => NIL , ;
      "QStatusBar"                              => NIL , ;
      "QSvgWidget"                              => NIL , ;
      "QTabBar"                                 => NIL , ;
      "QTabWidget"                              => NIL , ;
      "QToolBar"                                => NIL , ;
      "QWebInspector"                           => NIL , ;
      "QWebView"                                => NIL , ;
      "QWizardPage"                             => NIL , ;
      "QWorkspace"                              => NIL , ;
      "QWSEmbedWidget"                          => NIL , ;
      "QX11EmbedContainer"                      => NIL , ;
      "QX11EmbedWidget"                         => NIL , ;
      "QAnimationGroup"                         => NIL , ;
      "QPauseAnimation"                         => NIL , ;
      "QVariantAnimation"                       => NIL , ;
      "QParallelAnimationGroup"                 => NIL , ;
      "QSequentialAnimationGroup"               => NIL , ;
      "QPropertyAnimation"                      => NIL , ;
      "QItemDelegate"                           => NIL , ;
      "QStyledItemDelegate"                     => NIL , ;
      "QSqlRelationalDelegate"                  => NIL , ;
      "QSqlRelationalTableModel"                => NIL , ;
      "QSqlTableModel"                          => NIL , ;
      "QSqlQueryModel"                          => NIL , ;
      "QIdentityProxyModel"                     => NIL , ;
      "QSortFilterProxyModel"                   => NIL , ;
      "QHelpIndexModel"                         => NIL , ;
      "QStringListModel"                        => NIL , ;
      "QAbstractListModel"                      => NIL , ;
      "QAbstractProxyModel"                     => NIL , ;
      "QAbstractTableModel"                     => NIL , ;
      "QDirModel"                               => NIL , ;
      "QFileSystemModel"                        => NIL , ;
      "QHelpContentModel"                       => NIL , ;
      "QProxyModel"                             => NIL , ;
      "QStandardItemModel"                      => NIL , ;
      "QNetworkDiskCache"                       => NIL , ;
      "QFinalState"                             => NIL , ;
      "QHistoryState"                           => NIL , ;
      "QState"                                  => NIL , ;
      "QStateMachine"                           => NIL , ;
      "QPlainTextDocumentLayout"                => NIL , ;
      "QEventTransition"                        => NIL , ;
      "QSignalTransition"                       => NIL , ;
      "QKeyEventTransition"                     => NIL , ;
      "QMouseEventTransition"                   => NIL , ;
      "QMenuItem"                               => NIL , ;
      "QWidgetAction"                           => NIL , ;
      "QAxScriptEngine"                         => NIL , ;
      "QApplication"                            => NIL , ;
      "QDBusConnectionInterface"                => NIL , ;
      "QDBusInterface"                          => NIL , ;
      "QPanGesture"                             => NIL , ;
      "QPinchGesture"                           => NIL , ;
      "QSwipeGesture"                           => NIL , ;
      "QTapAndHoldGesture"                      => NIL , ;
      "QTapGesture"                             => NIL , ;
      "QGraphicsBlurEffect"                     => NIL , ;
      "QGraphicsColorizeEffect"                 => NIL , ;
      "QGraphicsDropShadowEffect"               => NIL , ;
      "QGraphicsOpacityEffect"                  => NIL , ;
      "QDeclarativeItem"                        => NIL , ;
      "QGraphicsSvgItem"                        => NIL , ;
      "QGraphicsTextItem"                       => NIL , ;
      "QGraphicsWidget"                         => NIL , ;
      "QGraphicsProxyWidget"                    => NIL , ;
      "QGraphicsWebView"                        => NIL , ;
      "QGraphicsRotation"                       => NIL , ;
      "QGraphicsScale"                          => NIL , ;
      "QHelpEngine"                             => NIL , ;
      "QAbstractSocket"                         => NIL , ;
      "QBuffer"                                 => NIL , ;
      "QFile"                                   => NIL , ;
      "QLocalSocket"                            => NIL , ;
      "QNetworkReply"                           => NIL , ;
      "QProcess"                                => NIL , ;
      "QTcpSocket"                              => NIL , ;
      "QUdpSocket"                              => NIL , ;
      "QSslSocket"                              => NIL , ;
      "QTemporaryFile"                          => NIL , ;
      "QBoxLayout"                              => NIL , ;
      "QFormLayout"                             => NIL , ;
      "QGridLayout"                             => NIL , ;
      "QStackedLayout"                          => NIL , ;
      "QHBoxLayout"                             => NIL , ;
      "QVBoxLayout"                             => NIL , ;
      "QTextBlockGroup"                         => NIL , ;
      "QTextFrame"                              => NIL , ;
      "QTextList"                               => NIL , ;
      "QTextTable"                              => NIL , ;
      "QDoubleValidator"                        => NIL , ;
      "QIntValidator"                           => NIL , ;
      "QRegExpValidator"                        => NIL , ;
      "QCheckBox"                               => NIL , ;
      "QPushButton"                             => NIL , ;
      "QRadioButton"                            => NIL , ;
      "Q3Button"                                => NIL , ;
      "QToolButton"                             => NIL , ;
      "QCommandLinkButton"                      => NIL , ;
      "QDial"                                   => NIL , ;
      "QScrollBar"                              => NIL , ;
      "QSlider"                                 => NIL , ;
      "QDateTimeEdit"                           => NIL , ;
      "QDoubleSpinBox"                          => NIL , ;
      "QSpinBox"                                => NIL , ;
      "QDateEdit"                               => NIL , ;
      "QTimeEdit"                               => NIL , ;
      "QFontComboBox"                           => NIL , ;
      "QAbstractPrintDialog"                    => NIL , ;
      "QColorDialog"                            => NIL , ;
      "QErrorMessage"                           => NIL , ;
      "QFileDialog"                             => NIL , ;
      "QFontDialog"                             => NIL , ;
      "QInputDialog"                            => NIL , ;
      "QMessageBox"                             => NIL , ;
      "QPageSetupDialog"                        => NIL , ;
      "QPrintPreviewDialog"                     => NIL , ;
      "QProgressDialog"                         => NIL , ;
      "QWizard"                                 => NIL , ;
      "QPrintDialog"                            => NIL , ;
      "QAbstractScrollArea"                     => NIL , ;
      "QLabel"                                  => NIL , ;
      "QLCDNumber"                              => NIL , ;
      "QSplitter"                               => NIL , ;
      "QStackedWidget"                          => NIL , ;
      "QToolBox"                                => NIL , ;
      "QAbstractItemView"                       => NIL , ;
      "QGraphicsView"                           => NIL , ;
      "QMdiArea"                                => NIL , ;
      "QPlainTextEdit"                          => NIL , ;
      "QScrollArea"                             => NIL , ;
      "QTextEdit"                               => NIL , ;
      "QColumnView"                             => NIL , ;
      "QHeaderView"                             => NIL , ;
      "QListView"                               => NIL , ;
      "QTableView"                              => NIL , ;
      "QTreeView"                               => NIL , ;
      "QHelpIndexWidget"                        => NIL , ;
      "QListWidget"                             => NIL , ;
      "QUndoView"                               => NIL , ;
      "QTableWidget"                            => NIL , ;
      "QHelpContentWidget"                      => NIL , ;
      "QTreeWidget"                             => NIL , ;
      "QDeclarativeView"                        => NIL , ;
      "QTextBrowser"                            => NIL , ;
      "QGLShader"                               => NIL , ;
      "QGLShaderProgram"                        => NIL , ;
      "QGLWidget"                               => NIL , ;
      "QGraphicsSvgItem"                        => NIL , ;
      "QSvgRenderer"                            => NIL , ;
      "QScriptEngine"                           => NIL , ;
      "QScriptExtensionPlugin"                  => NIL , ;
      "QScroller"                               => NIL , ;
      "QInputMethod"                            => NIL , ;
      "QNetworkAccessManager"                   => NIL , ;
      "QNetworkConfigurationManager"            => NIL , ;
      "QNetworkCookieJar"                       => NIL , ;
      "QNetworkSession"                         => NIL , ;
      "QAbstractNetworkCache"                   => NIL , ;
      "QAbstractSocket"                         => NIL , ;
      "QDnsLookup"                              => NIL , ;
      "QFtp"                                    => NIL , ;
      "QHttp"                                   => NIL , ;
      "QHttpMultiPart"                          => NIL , ;
      "QLocalServer"                            => NIL , ;
      "QLocalSocket"                            => NIL , ;
      "QNetworkDiskCache"                       => NIL , ;
      "QNetworkProxyFactory"                    => NIL , ;
      "QNetworkReply"                           => NIL , ;
      "QNetworkSession"                         => NIL , ;
      "QSslSocket"                              => NIL , ;
      "QTcpServer"                              => NIL , ;
      "QTcpSocket"                              => NIL , ;
      "QUdpSocket"                              => NIL , ;
      "QCamera"                                 => NIL , ;
      "QAbstractVideoSurface"                   => NIL , ;
      "QAudioDecoder"                           => NIL , ;
      "QAudioDecoderControl"                    => NIL , ;
      "QAudioEncoderSettingsControl"            => NIL , ;
      "QAudioInput"                             => NIL , ;
      "QAudioInputSelectorControl"              => NIL , ;
      "QAudioOutput"                            => NIL , ;
      "QAudioOutputSelectorControl"             => NIL , ;
      "QAudioRecorder"                          => NIL , ;
      "QCameraCaptureBufferFormatControl"       => NIL , ;
      "QCameraCaptureDestinationControl"        => NIL , ;
      "QCameraControl"                          => NIL , ;
      "QCameraExposure"                         => NIL , ;
      "QCameraExposureControl"                  => NIL , ;
      "QCameraFeedbackControl"                  => NIL , ;
      "QCameraFlashControl"                     => NIL , ;
      "QCameraFocus"                            => NIL , ;
      "QCameraFocusControl"                     => NIL , ;
      "QCameraImageCapture"                     => NIL , ;
      "QCameraImageCaptureControl"              => NIL , ;
      "QCameraImageProcessing"                  => NIL , ;
      "QCameraImageProcessingControl"           => NIL , ;
      "QCameraInfoControl"                      => NIL , ;
      "QCameraLocksControl"                     => NIL , ;
      "QCameraViewfinderSettingsControl"        => NIL , ;
      "QCameraZoomControl"                      => NIL , ;
      "QImageEncoderControl"                    => NIL , ;
      "QMediaAudioProbeControl"                 => NIL , ;
      "QMediaAvailabilityControl"               => NIL , ;
      "QMediaContainerControl"                  => NIL , ;
      "QMediaControl"                           => NIL , ;
      "QMediaGaplessPlaybackControl"            => NIL , ;
      "QMediaNetworkAccessControl"              => NIL , ;
      "QMediaObject"                            => NIL , ;
      "QMediaPlayer"                            => NIL , ;
      "QMediaPlayerControl"                     => NIL , ;
      "QMediaPlaylist"                          => NIL , ;
      "QMediaRecorder"                          => NIL , ;
      "QMediaRecorderControl"                   => NIL , ;
      "QMediaService"                           => NIL , ;
      "QMediaServiceProviderPlugin"             => NIL , ;
      "QMediaStreamsControl"                    => NIL , ;
      "QMediaVideoProbeControl"                 => NIL , ;
      "QMetaDataReaderControl"                  => NIL , ;
      "QMetaDataWriterControl"                  => NIL , ;
      "QRadioData"                              => NIL , ;
      "QRadioDataControl"                       => NIL , ;
      "QRadioTuner"                             => NIL , ;
      "QRadioTunerControl"                      => NIL , ;
      "QSoundEffect"                            => NIL , ;
      "QVideoDeviceSelectorControl"             => NIL , ;
      "QVideoEncoderSettingsControl"            => NIL , ;
      "QVideoProbe"                             => NIL , ;
      "QVideoRendererControl"                   => NIL , ;
      "QVideoWindowControl"                     => NIL , ;
      "QCameraViewfinder"                       => NIL , ;
      "QVideoWidget"                            => NIL , ;
      "QVideoWidgetControl"                     => NIL , ;
      "QGeoAreaMonitorSource"                   => NIL , ;
      "QGeoPositionInfoSource"                  => NIL , ;
      "QGeoSatelliteInfoSource"                 => NIL , ;
      "QNmeaPositionInfoSource"                 => NIL , ;
      "QBluetoothDeviceDiscoveryAgent"          => NIL , ;
      "QBluetoothLocalDevice"                   => NIL , ;
      "QBluetoothServer"                        => NIL , ;
      "QBluetoothServiceDiscoveryAgent"         => NIL , ;
      "QBluetoothSocket"                        => NIL , ;
      "QBluetoothTransferManager"               => NIL , ;
      "QBluetoothTransferReply"                 => NIL , ;
      "QMaskGenerator"                          => NIL , ;
      "QWebSocket"                              => NIL , ;
      "QWebSocketServer"                        => NIL , ;
      "QQuickFramebufferObject"                 => NIL , ;
      "QQuickItem"                              => NIL , ;
      "QQuickPaintedItem"                       => NIL , ;
      "QQuickTextDocument"                      => NIL , ;
      "QQuickTextureFactory"                    => NIL , ;
      "QQuickView"                              => NIL , ;
      "QQuickWindow"                            => NIL , ;
      "QQuickWidget"                            => NIL , ;
      "QSGDynamicTexture"                       => NIL , ;
      "QSGTexture"                              => NIL , ;
      "QJSEngine"                               => NIL , ;
      "QQmlAbstractProfilerAdapter"             => NIL , ;
      "QQmlApplicationEngine"                   => NIL , ;
      "QQmlComponent"                           => NIL , ;
      "QQmlContext"                             => NIL , ;
      "QQmlEngine"                              => NIL , ;
      "QQmlExpression"                          => NIL , ;
      "QQmlExtensionPlugin"                     => NIL , ;
      "QQmlFileSelector"                        => NIL , ;
      "QQmlPropertyMap"                         => NIL , ;
      "QZXing"                                  => NIL , ;
      "QSensor"                                 => NIL , ;
      "QSensorBackend"                          => NIL , ;
      "QSensorGesture"                          => NIL , ;
      "QSensorGestureManager"                   => NIL , ;
      "QSensorReading"                          => NIL , ;
      "QAccelerometerReading"                   => NIL , ;
      "QAltimeterReading"                       => NIL , ;
      "QAmbientLightReading"                    => NIL , ;
      "QAmbientTemperatureReading"              => NIL , ;
      "QCompassReading"                         => NIL , ;
      "QGyroscopeReading"                       => NIL , ;
      "QHolsterReading"                         => NIL , ;
      "QIRProximityReading"                     => NIL , ;
      "QLightReading"                           => NIL , ;
      "QMagnetometerReading"                    => NIL , ;
      "QOrientationReading"                     => NIL , ;
      "QPressureReading"                        => NIL , ;
      "QProximityReading"                       => NIL , ;
      "QRotationReading"                        => NIL , ;
      "QTapReading"                             => NIL , ;
      "QTiltReading"                            => NIL , ;
      "QAccelerometer"                          => NIL , ;
      "QAltimeter"                              => NIL , ;
      "QAmbientLightSensor"                     => NIL , ;
      "QAmbientTemperatureSensor"               => NIL , ;
      "QCompass"                                => NIL , ;
      "QGyroscope"                              => NIL , ;
      "QHolsterSensor"                          => NIL , ;
      "QIRProximitySensor"                      => NIL , ;
      "QLightSensor"                            => NIL , ;
      "QMagnetometer"                           => NIL , ;
      "QOrientationSensor"                      => NIL , ;
      "QPressureSensor"                         => NIL , ;
      "QProximitySensor"                        => NIL , ;
      "QRotationSensor"                         => NIL , ;
      "QTapSensor"                              => NIL , ;
      "QTiltSensor"                             => NIL , ;
      "QGeoCodeReply"                           => NIL , ;
      "QGeoCodingManager"                       => NIL , ;
      "QGeoCodingManagerEngine"                 => NIL , ;
      "QGeoRouteReply"                          => NIL , ;
      "QGeoRoutingManager"                      => NIL , ;
      "QGeoRoutingManagerEngine"                => NIL , ;
      "QGeoServiceProvider"                     => NIL , ;
      "QPlaceContentReply"                      => NIL , ;
      "QPlaceDetailsReply"                      => NIL , ;
      "QPlaceIdReply"                           => NIL , ;
      "QPlaceManager"                           => NIL , ;
      "QPlaceManagerEngine"                     => NIL , ;
      "QPlaceMatchReply"                        => NIL , ;
      "QPlaceReply"                             => NIL , ;
      "QPlaceSearchReply"                       => NIL , ;
      "QPlaceSearchSuggestionReply"             => NIL , ;
      "QScreen"                                 => NIL , ;
      "x                      "                 => NIL   }

   IF lower( left( cWidget, 3 ) ) == "hbq"
      cWidget := SubStr( cWidget, 3 )
   ENDIF

   RETURN cWidget $ s_b_

/*----------------------------------------------------------------------*/

