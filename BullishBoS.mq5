//+------------------------------------------------------------------+
//|                                 Bullish Break of Structure Alert |
//                                                    BullishBoS.mq5 |
//|                                                Author: n30dyn4m1c|
//|                                     https://medium.com/neomalesa |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Neo Malesa."
#property link      "https://medium.com/neomalesa"
#property version   "1.01"

// Global variables to track the current and previous highs
double currentHigh = 0.0; // Variable to hold the current high
double previousHigh = 0.0; // Variable to hold the previous high
double closePrice = 0.0; // Variable to hold the closePrice

bool alertSent = false; //Variable to flag alert
bool newHigh = false; //Variable to flag newHigh

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
   double high1 = iHigh(_Symbol, _Period, 1); // High of the previous candle
   double high2 = iHigh(_Symbol, _Period, 2); // High of two candles ago
   double high3 = iHigh(_Symbol, _Period, 3); // High of three candles ago
   closePrice = iClose(_Symbol, _Period, 1); // Get the closing price of the current candle
  
  // Check if the middle candle is a new high
   if(high2 > high1 && high2 > high3)
     {
      previousHigh = currentHigh;  // Update previousHigh before changing currentHigh
      currentHigh = high2;         // Now update currentHigh to the new high
      newHigh = true; //flag that a new high has formed
     }
     else ;
    
        // Check if the close price is above the current high and no alert has been sent yet and a new high has formed
    if (closePrice > currentHigh && !alertSent && currentHigh!=0.0 && newHigh)
    {
        Alert(_Symbol," is Bullish on ", "(", EnumToString(_Period), "). Closed at ", DoubleToString(closePrice, _Digits)," above recent high of ", DoubleToString(currentHigh, _Digits));
        alertSent = true; // Set alertSent to true to avoid repeated alerts
    }
    else ;
}
  
//+------------------------------------------------------------------+
//| Timer function to check for alerts after candle closes           |
//+------------------------------------------------------------------+
void OnTimer()
{   
    alertSent = false;// Reset alertSent flag for new candle
    newHigh = false;// Reset alertSent flag for new high
}
