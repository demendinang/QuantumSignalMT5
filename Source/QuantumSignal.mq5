//+------------------------------------------------------------------+
//|                                                QuantumSignal.mq5 |
//|                        Quantum Signal MT5                        |
//+------------------------------------------------------------------+
#property copyright "Quantum Signal Project"
#property version   "1.006"
#property strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

#property indicator_label1  "Dummy"
#property indicator_type1   DRAW_NONE
#property indicator_color1  clrNONE

#include "Include/Dashboard.mqh"
#include "Include/ObjectManager.mqh"
#include "Include/Engine/QuantumEngine.mqh"

//------------------------------------------------------------------
// Indicator Buffer
//------------------------------------------------------------------
double DummyBuffer[];

//------------------------------------------------------------------
// Global Objects
//------------------------------------------------------------------
CDashboard Dashboard;
CObjectManager Objects;
CQuantumEngine Engine;

//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0,DummyBuffer,INDICATOR_DATA);

   Objects.SetPrefix("QS_");

   if(!Dashboard.Create())
      return(INIT_FAILED);

   if(!Engine.Initialize())
      return(INIT_FAILED);

   Dashboard.SetStatus("READY");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Engine.Release();

   Dashboard.Destroy();
   Objects.DeleteAll();
}

//+------------------------------------------------------------------+
//| Main Calculation                                                 |
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
   Engine.Update(Dashboard);

   return(rates_total);
}
//+------------------------------------------------------------------+