/*
 * $Id$
 */

#include "hbqtgui.ch"


FUNCTION main()
   LOCAL window, chart, categories, axis, series, legend
   LOCAL set0 , set1, set2, set3, set4, chartView

   set0 := QBarSet("Jane")
   set1 := QBarSet("John")
   set2 := QBarSet("Axel")
   set3 := QBarSet("Mary")
   set4 := QBarSet("Samantha")

   set0:append( 1.0 )
   set0:append( 2.0 )
   set0:append( 3.0 )
   set0:append( 4.0 )
   set0:append( 5.0 )
   set0:append( 6.0 )

   set1:append( 5 )
   set1:append( 0 )
   set1:append( 0 )
   set1:append( 4 )
   set1:append( 0 )
   set1:append( 7 )

   set2:append( 3 )
   set2:append( 5 )
   set2:append( 8 )
   set2:append( 13 )
   set2:append( 8 )
   set2:append( 5 )

   set3:append( 5 )
   set3:append( 6 )
   set3:append( 7 )
   set3:append( 3 )
   set3:append( 4 )
   set3:append( 5 )

   set4:append( 9 )
   set4:append( 7 )
   set4:append( 5 )
   set4:append( 3 )
   set4:append( 1 )
   set4:append( 2 )

   series := QBarSeries()
   series:append( set0 )
   series:append( set1 )
   series:append( set2 )
   series:append( set3 )
   series:append( set4 )


   chart := QChart()
   chart:addSeries( series )
   chart:setTitle( "Simple barchart example" )
   chart:setAnimationOptions( QChart_SeriesAnimations )

   categories := QStringList()
   categories:append( "Jan" )
   categories:append( "Feb" )
   categories:append( "Mar" )
   categories:append( "Apr" )
   categories:append( "May" )
   categories:append( "Jun" )

   axis := QBarCategoryAxis()
   axis:append( categories )

   chart:createDefaultAxes()
   chart:setAxisX( axis, series )

   legend := chart:legend()
   //legend:setVisible( .T. )                // raises GPF
   legend:setAlignment( Qt_AlignBottom )

   chartView := QChartView( chart )
   chartView:setRenderHint( QPainter_Antialiasing )

   window := QMainWindow()
   window:setCentralWidget( chartView )
   window:resize( 420, 300 )
   window:show()

   QApplication():exec()

   RETURN NIL

