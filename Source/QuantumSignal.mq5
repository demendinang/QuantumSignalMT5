//+------------------------------------------------------------------+
//|                                                QuantumSignal.mq5 |
//|                        Quantum Signal MT5                        |
//+------------------------------------------------------------------+
#property copyright "Quantum Signal Project"
#property version   "1.004"
#property strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

#property indicator_label1  "Dummy"
#property indicator_type1   DRAW_NONE
#property indicator_color1  clrNONE

#include "Include/Dashboard.mqh"
#include "Include/ObjectManager.mqh"

#include "Include/Engine/EMAEngine.mqh"
#include "Include/Engine/TrendEngine.mqh"
#include "Include/Engine/ATREngine.mqh"
#include "Include/Engine/ADXEngine.mqh"
#include "Include/Engine/RSIEngine.mqh"
#include "Include/Engine/MarketStateEngine.mqh"
#include "Include/Engine/SignalScoreEngine.mqh"

//------------------------------------------------------------------
// Indicator Buffer
//------------------------------------------------------------------
double DummyBuffer[];

//------------------------------------------------------------------
// Global Objects
//------------------------------------------------------------------
CDashboard Dashboard;
CObjectManager Objects;

CEMAEngine EMA;
CTrendEngine Trend;
CATREngine ATR;
CADXEngine ADX;
CRSIEngine RSI;
CMarketStateEngine MarketState;
CSignalScoreEngine SignalScore;

//------------------------------------------------------------------
int gSignalScore = 0;

//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0,DummyBuffer,INDICATOR_DATA);

   Print("==========================================");
   Print(" Quantum Signal MT5");
   Print(" Version : 1.004");
   Print(" Status  : Initializing...");
   Print("==========================================");

   Objects.SetPrefix("QS_");

   if(!Dashboard.Create())
      return(INIT_FAILED);

   if(!EMA.Initialize())
      return(INIT_FAILED);

   if(!ATR.Initialize())
      return(INIT_FAILED);

   if(!ADX.Initialize())
      return(INIT_FAILED);

   if(!RSI.Initialize())
      return(INIT_FAILED);

   Dashboard.SetStatus("READY");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EMA.Release();
   ATR.Release();
   ADX.Release();
   RSI.Release();

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
   double ema20   = 0.0;
   double ema50   = 0.0;
   double ema200  = 0.0;

   double atr     = 0.0;

   double adx     = 0.0;
   double plusDI  = 0.0;
   double minusDI = 0.0;

   double rsi     = 0.0;

   //--------------------------------------------------------------
   // EMA
   //--------------------------------------------------------------
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

   //--------------------------------------------------------------
   // ATR
   //--------------------------------------------------------------
   ATR.Value(atr);

   //--------------------------------------------------------------
   // ADX
   //--------------------------------------------------------------
   ADX.GetValues(
      adx,
      plusDI,
      minusDI
   );

   //--------------------------------------------------------------
   // RSI
   //--------------------------------------------------------------
   RSI.Value(rsi);

   //--------------------------------------------------------------
   // Market State
   //--------------------------------------------------------------
   MarketState.Calculate(
      ema20,
      ema50,
      ema200,
      adx
   );

   //--------------------------------------------------------------
   // Signal Score
   //--------------------------------------------------------------
   gSignalScore =
      SignalScore.Calculate(
         MarketState.IsBull(),
         MarketState.IsBear(),
         adx,
         rsi
      );

   //--------------------------------------------------------------
   // Dashboard
   //--------------------------------------------------------------
   Dashboard.Update();

   return(rates_total);
}
//+------------------------------------------------------------------+