Attribute VB_Name = "Module2Submission"
Sub TickerTapeParade()
'Create a script that loops through all the stocks for one year and outputs the following information:
'1.     The ticker symbol.
'2.     Yearly change from the opening price at the beginning of a given year to the closing price at the end of that year.
'3.     The percentage change from the opening price at the beginning of a given year to the closing price at the end of that year.
'4.     The total stock volume of the stock. The result should match the following image:'
'5.     Add functionality to your script to return the stock with the "Greatest % increase", "Greatest % decrease", and "Greatest total volume".
'6.     Make the appropriate adjustments to your VBA script to enable it to run on every worksheet (that is, every year) at once.
'------------------
    Dim r, c, OutputRow As Integer
    Dim FirstRow As Boolean
    Dim YearlyChange(2) As Double
    '(0) = opening Price on first day of year
    '(1) = Closing Price on last day of year
    '(2) = Change in Price
    Dim PercentChange As Double
    Dim TotalStockVolume As LongLong
    Dim GreatestInc, GreatestDec As Double
    Dim GreatestVol As LongLong
    Dim GreatestTicker(2) As String 'Ticker names for (0,1,2) = (inc, dec, vol)
    

    For Each ws In Worksheets
    
        'intialize values, runs only once per worksheet
        OutputRow = 2
        FirstRow = True
        c = 9
        r = 2
        GreatestInc = 0: GreatestTicker(0) = ""
        GreatestDec = 0: GreatestTicker(1) = ""
        GreatestVol = 0: GreatestTicker(2) = ""
        '--------
        
        'Sets Headers and labels for columns I through Q
        For c = 9 To 17
            Select Case c
                Case 9, 16
                    ws.Cells(1, c).Value = "Ticker"
                Case 10
                    ws.Cells(1, c).Value = "Yearly Change"
                Case 11
                    ws.Cells(1, c).Value = "Percent Change"
                Case 12
                    ws.Cells(1, c).Value = "Total Stock Volume"
                Case 15
                    ws.Cells(2, c).Value = "Greatest % Increase"
                    ws.Cells(3, c).Value = "Greatest % Decrease"
                    ws.Cells(4, c).Value = "Greatest Total Volume"
                Case 17
                    ws.Cells(1, c).Value = "Volume"
            End Select
        Next c
        '----------------
            
        'Outputs data and checks for hall of famew values
        For r = 2 To ws.Cells(Rows.Count, 1).End(xlUp).Row
            
            If FirstRow = True Then 'Pull opening price if we are on the first line of a discrete ticker
                    YearlyChange(0) = ws.Cells(r, "C").Value
                    FirstRow = False 'Turn firstrow false now that we've pulled the opening price
            End If
            
            TotalStockVolume = TotalStockVolume + ws.Cells(r, "G").Value 'keeps running total of all stock volume for the current ticker value
            
            'Checks to see if we are at last row of current ticker by compoaring it to the ticker on the next row, triggers if different
            If ws.Cells(r, "A").Value <> ws.Cells(r + 1, 1).Value Then
                YearlyChange(1) = ws.Cells(r, "F").Value 'set closing price
                YearlyChange(2) = YearlyChange(1) - YearlyChange(0) ' calculate change in price by subtracting opening price from closing price
                PercentChange = YearlyChange(2) / YearlyChange(0) ' calculate percent change in price by dividing change in price by opening price
                '-------------
                
                'Printing Values
                ws.Cells(OutputRow, "I").Value = ws.Cells(r, "A").Value 'Print ticker name to output column
                ws.Cells(OutputRow, "J").Value = YearlyChange(2) ' Print Yearly change to output column
                    'format yearychange cell as grreen if positive or red if negative
                    If YearlyChange(2) >= 0 Then
                        ws.Cells(OutputRow, "J").Interior.ColorIndex = 4 'turn cell green
                    Else
                        ws.Cells(OutputRow, "J").Interior.ColorIndex = 3 'turn cell red
                    End If
                    
                ws.Cells(OutputRow, "K").Value = FormatPercent(PercentChange, 2, vbTrue, vbFalse, vbFalse) 'print Percentchange formatted as percentage to output column
                ws.Cells(OutputRow, "L").Value = TotalStockVolume 'output total stock volume
                '--------------
                
                'check to see if any value goes into hall of fame
                If PercentChange > GreatestInc Then ' Checking if current percentchange is larger than previous
                    GreatestInc = PercentChange
                    GreatestTicker(0) = ws.Cells(r, "A").Value
                End If
                    
                If PercentChange < GreatestDec Then ' checking for greatest decrease
                    GreatestDec = PercentChange
                    GreatestTicker(1) = ws.Cells(r, "A").Value
                End If
                
                If TotalStockVolume > GreatestVol Then
                     GreatestVol = TotalStockVolume
                     GreatestTicker(2) = ws.Cells(r, "A").Value
                End If
                '----------
                           
                'intiliaze values for next discrete ticker
                OutputRow = OutputRow + 1
                TotalStockVolume = 0
                FirstRow = True
                YearlyChange(0) = 0
                YearlyChange(1) = 0
                YearlyChange(2) = 0
                
            End If
        Next r
        
        'End of Worksheet.
        ws.Cells(2, 16).Value = GreatestTicker(0)   'prints greatest increase ticker
        ws.Cells(2, 17).Value = FormatPercent(GreatestInc, 2, vbTrue, vbFalse, vbFalse) 'prints greatest increase value as a percent
        ws.Cells(3, 16).Value = GreatestTicker(1)   'prints greatest decrease ticker
        ws.Cells(3, 17).Value = FormatPercent(GreatestDec, 2, vbTrue, vbFalse, vbFalse) 'prints greatest decrease value as aa percent
        ws.Cells(4, 16).Value = GreatestTicker(2)         'prints greatest volume ticker
        ws.Cells(4, 17).Value = GreatestVol         'prints greatest volume
           
        ws.Range("I:r").Columns.AutoFit         'makes all columns entered autofit
        ws.Range("J:J").NumberFormat = "0.00"   'ensures all yearlychange values go to two deciemal places
        
    Next ws
    
End Sub

