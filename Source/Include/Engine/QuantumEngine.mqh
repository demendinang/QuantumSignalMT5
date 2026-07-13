//+------------------------------------------------------------------+
//|                                               QuantumEngine.mqh  |
//+------------------------------------------------------------------+
#ifndef __QUANTUM_ENGINE_MQH__
#define __QUANTUM_ENGINE_MQH__

#include "EMAEngine.mqh"
#include "TrendEngine.mqh"
#include "ATREngine.mqh"
#include "ADXEngine.mqh"
#include "RSIEngine.mqh"
#include "MarketStateEngine.mqh"
#include "SignalScoreEngine.mqh"
#include "SignalEngine.mqh"
#include "SignalFilterEngine.mqh"
#include "ArrowEngine.mqh"
#include "AlertEngine.mqh"
#include "PushEngine.mqh"
#include "MTFEngine.mqh"
#include "SessionEngine.mqh"

#include "../Dashboard.mqh"

class CQuantumEngine
{
private:

   CEMAEngine          EMA;
   CTrendEngine        Trend;
   CATREngine          ATR;
   CADXEngine          ADX;
   CRSIEngine          RSI;

   CMarketStateEngine  MarketState;
   CSignalScoreEngine  SignalScore;
   CSignalEngine       Signal;
   CSignalFilterEngine Filter;
   CArrowEngine        Arrow;
   CAlertEngine        Alert;
   CPushEngine Push;
   CMTFEngine MTF;
   CSessionEngine Session;

public:

   bool Initialize()
   {
      if(!EMA.Initialize())
         return(false);

      if(!ATR.Initialize())
         return(false);

      if(!ADX.Initialize())
         return(false);

      if(!RSI.Initialize())
         return(false);

      return(true);
   }

   //---------------------------------------------------------

   void Release()
   {
      EMA.Release();
      ATR.Release();
      ADX.Release();
      RSI.Release();
   }

   //---------------------------------------------------------

   void Update(CDashboard &dashboard)
   //=====================================================
// DATA LAYER
//=====================================================
   {
      double ema20   = 0.0;
      double ema50   = 0.0;
      double ema200  = 0.0;

      double atr     = 0.0;

      double adx     = 0.0;
      double plusDI  = 0.0;
      double minusDI = 0.0;

      double rsi     = 0.0;

      //------------------------------------------------------
      // EMA
      //------------------------------------------------------
      if(
         EMA.EMA20(ema20) &&
         EMA.EMA50(ema50) &&
         EMA.EMA200(ema200)
      )
      //=====================================================
// ANALYSIS LAYER
//=====================================================
      {
         Trend.Calculate(
            ema20,
            ema50,
            ema200
         );
      }

      //------------------------------------------------------
      // ATR
      //------------------------------------------------------
      ATR.Value(atr);

      //------------------------------------------------------
      // ADX
      //------------------------------------------------------
      ADX.GetValues(
         adx,
         plusDI,
         minusDI
      );

      //------------------------------------------------------
      // RSI
      //------------------------------------------------------
      RSI.Value(rsi);

      //------------------------------------------------------
      // Market State
      //------------------------------------------------------
      MarketState.Calculate(
         ema20,
         ema50,
         ema200,
         adx
      );

      //------------------------------------------------------
      // Signal Score
      //------------------------------------------------------
      int score =
         SignalScore.Calculate(
            MarketState.IsBull(),
            MarketState.IsBear(),
            adx,
            rsi
         );

      //------------------------------------------------------
      // Signal Engine
      //------------------------------------------------------
      //=====================================================
// SIGNAL FILTER
//=====================================================
Session.Calculate();

bool allowTrading = Session.AllowTrading();

bool bullHTF = MTF.IsBull();
bool bearHTF = MTF.IsBear();
Filter.Calculate(
   MarketState.IsBull(),
   MarketState.IsBear(),

   Trend.IsBull(),
   Trend.IsBear(),

   bullHTF,
   bearHTF,

   atr,
   adx,
   rsi,
   score
);
   
      Signal.Calculate(
         MarketState.IsBull(),
         MarketState.IsBear(),
         adx,
         rsi,
         score
      );

      //=====================================================
// DECISION LAYER
//=====================================================
      datetime signalBar=iTime(_Symbol,_Period,1);

      //------------------------------------------------------
      // BUY
      //------------------------------------------------------
      if(
   allowTrading &&
   Signal.IsBuySignal() &&
   Filter.BuyPassed()
)
      {
         Arrow.DrawBuy(
            signalBar,
            iLow(_Symbol,_Period,1)
         );

         Alert.Buy(signalBar);
Push.Buy(signalBar);
      }

      //------------------------------------------------------
      // SELL
      //------------------------------------------------------
     if(
   allowTrading &&
   Signal.IsSellSignal() &&
   Filter.SellPassed()
)
      {
         Arrow.DrawSell(
            signalBar,
            iHigh(_Symbol,_Period,1)
         );

         Alert.Sell(signalBar);
Push.Sell(signalBar);
      }

      //------------------------------------------------------
      // Dashboard
      //------------------------------------------------------
      //=====================================================
// OUTPUT LAYER
//=====================================================
      dashboard.SetTrend(
         Trend.GetTrendText()
      );

      dashboard.SetMarketState(
         MarketState.GetStateText()
      );

      dashboard.SetADX(adx);

      dashboard.SetRSI(rsi);

      dashboard.SetScore(score);

      dashboard.SetBuySignal(

   allowTrading &&

   Signal.IsBuySignal() &&

   Filter.BuyPassed()

);

      dashboard.SetSellSignal(

   allowTrading &&

   Signal.IsSellSignal() &&

   Filter.SellPassed()

);

      dashboard.Update();
   }

};

#endif