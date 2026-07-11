//+------------------------------------------------------------------+
//|                                                QuantumSignal.mq5 |
//|                        Quantum Signal MT5                        |
//|                           Version 0.1                            |
//+------------------------------------------------------------------+
#property copyright "Quantum Signal Project"
#property version   "0.10"
#property indicator_chart_window
#property strict

#include "Include/Dashboard.mqh"

//-------------------------------------------------------------------
// Global Dashboard Object
//-------------------------------------------------------------------
CDashboard Dashboard;

//+------------------------------------------------------------------+
//| Custom indicator initialization                                 |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("==========================================");
   Print(" Quantum Signal MT5");
   Print(" Version : 0.10");
   Print(" Status  : Initializing...");
   Print("==========================================");

   if(!Dashboard.Create())
   {
      Print("Dashboard Create Failed");
      return(INIT_FAILED);
   }

   Dashboard.SetStatus("READY");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Dashboard.Destroy();
}

//+------------------------------------------------------------------+
//| Custom indicator calculation                                    |
//+------------------------------------------------------------------+
int OnCalculate(
   const int rates_total,
   const int prev_calculated,
   const datetime &time[],
   const double &open[],
   const double &high[],
   const double &low[],
   const double &close[],
   const long &tick_volume[],
   const long &volume[],
   const int &spread[]
)
{
   Dashboard.Update();

   return(rates_total);
}
//+------------------------------------------------------------------+