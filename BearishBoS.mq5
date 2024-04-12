//+------------------------------------------------------------------+
//|                                 Bearish Break of Structure Alert |
//                                                    BearishBoS.mq5 |
//|                                                Author: n30dyn4m1c|
//|                                     https://medium.com/neomalesa |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Neo Malesa."
#property link      "https://medium.com/neomalesa"
#property version   "1.01"

// Global variables to track the current and previous lows
double currentLow = 0.0; // Variable to hold the current low
double previousLow = 0.0; // Variable to hold the previous low
double closePrice = 0.0; // Variable to hold the closePrice

bool alertSent = false; //Variable to flag alert


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
    
    // Calculate timer interval based on the chart's timeframe
    int timerInterval = 60; // Default interval in seconds

    // Set timer to check for alerts after each candle closes
    EventSetTimer(timerInterval); // Timer interval in seconds
    
    return(INIT_SUCCEEDED);
    
//---

  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
    // Clean up timer when the EA is removed
    EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double low1 = iLow(_Symbol, _Period, 1); // Low of the previous candle
   double low2 = iLow(_Symbol, _Period, 2); // Low of two candles ago
   double low3 = iLow(_Symbol, _Period, 3); // Low of three candles ago
   closePrice = iClose(_Symbol, _Period, 1); // Get the closing price of the current candle
  
  // Check if the middle candle is a new low
   if(low2 < low1 && low2 < low3)
     {
      previousLow = currentLow;  // Update previousLow before changing currentLow
      currentLow = low2;         // Now update currentLow to the new low
      
     }
  
      // Check if the close price is below the current low and no alert has been sent yet 
    if (closePrice < currentLow && !alertSent && currentLow!=0.0)
    {
        Alert("Bearish BoS: ", _Symbol, "(", EnumToString(_Period), ") close at ", DoubleToString(closePrice, _Digits)," below currentLow ", DoubleToString(currentLow, _Digits));
        alertSent = true; // Set alertSent to true to avoid repeated alerts
    }
 
  }

//+------------------------------------------------------------------+
//| Timer function to check for alerts after candle closes           |
//+------------------------------------------------------------------+
void OnTimer()
{
    alertSent = false;   // Reset alertSent flag for new candle
    
}
