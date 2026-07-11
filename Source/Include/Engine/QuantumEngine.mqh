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

#include "../Dashboard.mqh"

class CQuantumEngine
{
private:

   CEMAEngine EMA;
   CTrendEngine Trend;
   CATREngine ATR;
   CADXEngine ADX;
   CRSIEngine RSI;
   CMarketStateEngine MarketState;
   CSignalScoreEngine SignalScore;

public:

   bool Initialize()
   {
      if(!EMA.Initialize()) return(false);
      if(!ATR.Initialize()) return(false);
      if(!ADX.Initialize()) return(false);
      if(!RSI.Initialize()) return(false);

      return(true);
   }

   void Release()
   {
      EMA.Release();
      ATR.Release();
      ADX.Release();
      RSI.Release();
   }

   void Update(CDashboard &dashboard)
   {
      double ema20=0.0;
      double ema50=0.0;
      double ema200=0.0;

      double atr=0.0;

      double adx=0.0;
      double plusDI=0.0;
      double minusDI=0.0;

      double rsi=0.0;

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

      ADX.GetValues(
         adx,
         plusDI,
         minusDI
      );

      RSI.Value(rsi);

      MarketState.Calculate(
         ema20,
         ema50,
         ema200,
         adx
      );

      int score=
         SignalScore.Calculate(
            MarketState.IsBull(),
            MarketState.IsBear(),
            adx,
            rsi
         );

      dashboard.SetTrend(Trend.GetTrendText());
      dashboard.SetMarketState(MarketState.GetStateText());
      dashboard.SetADX(adx);
      dashboard.SetRSI(rsi);
      dashboard.SetScore(score);

      dashboard.Update();
   }
};

#endif