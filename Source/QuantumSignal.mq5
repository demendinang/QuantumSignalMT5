//+------------------------------------------------------------------+
//|                                                QuantumSignal.mq5 |
//+------------------------------------------------------------------+
#property copyright "Quantum Signal Project"
#property version   "1.001"
#property strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

#property indicator_label1 "Dummy"
#property indicator_type1 DRAW_NONE
#property indicator_color1 clrNONE

#include "Include/Dashboard.mqh"
#include "Include/ObjectManager.mqh"
#include "Include/Engine/EMAEngine.mqh"
#include "Include/Engine/TrendEngine.mqh"
#include "Include/Engine/ATREngine.mqh"

double DummyBuffer[];

CDashboard Dashboard;
CObjectManager Objects;
CEMAEngine EMA;
CTrendEngine Trend;
CATREngine ATR;

//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0,DummyBuffer,INDICATOR_DATA);

   Objects.SetPrefix("QS_");

   if(!Dashboard.Create())
      return(INIT_FAILED);

   if(!EMA.Initialize())
      return(INIT_FAILED);

   if(!ATR.Initialize())
      return(INIT_FAILED);

   Dashboard.SetStatus("READY");

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EMA.Release();
   ATR.Release();

   Dashboard.Destroy();
   Objects.DeleteAll();
}
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
   double ema20,ema50,ema200;
   double atr;

   if(
      EMA.EMA20(ema20) &&
      EMA.EMA50(ema50) &&
      EMA.EMA200(ema200)
   )
   {
      Trend.Calculate(
         ema20,
         ema50,
         ema200
      );
   }

   ATR.Value(atr);

   Dashboard.Update();

   return(rates_total);
}
//+------------------------------------------------------------------+