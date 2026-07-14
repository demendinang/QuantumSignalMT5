//+------------------------------------------------------------------+
//|                                               QuantumEngine.mqh  |
//|                    Build 033 - Signal Confidence                 |
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
   CPushEngine         Push;
   CMTFEngine          MTF;
   CSessionEngine      Session;

public:

   bool Initialize()
   {
      if(!EMA.Initialize()) return(false);
      if(!ATR.Initialize()) return(false);
      if(!ADX.Initialize()) return(false);
      if(!RSI.Initialize()) return(false);

      return(true);
   }

   //--------------------------------------------------

   void Release()
   {
      EMA.Release();
      ATR.Release();
      ADX.Release();
      RSI.Release();
   }

   //--------------------------------------------------

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

      //--------------------------------------------------
      // EMA
      //--------------------------------------------------

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

      //--------------------------------------------------

      ATR.Value(atr);

      //--------------------------------------------------

      ADX.GetValues(
         adx,
         plusDI,
         minusDI
      );

      //--------------------------------------------------

      RSI.Value(rsi);

      //--------------------------------------------------

      MarketState.Calculate(
         ema20,
         ema50,
         ema200,
         adx
      );

      //--------------------------------------------------

      int score=
      SignalScore.Calculate(
         MarketState.IsBull(),
         MarketState.IsBear(),
         adx,
         rsi
      );

      //--------------------------------------------------

      Session.Calculate();

      bool allowTrading=
      Session.AllowTrading();

      //--------------------------------------------------

      bool bullHTF=MTF.IsBull();
      bool bearHTF=MTF.IsBear();

      //--------------------------------------------------

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

      //--------------------------------------------------

      Signal.Calculate(
         MarketState.IsBull(),
         MarketState.IsBear(),
         adx,
         rsi,
         score
      );

      //--------------------------------------------------

      bool finalBuy=
         allowTrading &&
         Signal.IsBuySignal() &&
         Filter.BuyPassed();

      bool finalSell=
         allowTrading &&
         Signal.IsSellSignal() &&
         Filter.SellPassed();

      //--------------------------------------------------

      string signal="WAIT";

      if(finalBuy)
         signal="BUY";
      else
      if(finalSell)
         signal="SELL";

      //--------------------------------------------------

      double trendPower=
         Trend.GetTrendPower();

      //--------------------------------------------------

      datetime openTime=
         iTime(_Symbol,_Period,0);

      int periodSeconds=
         PeriodSeconds(_Period);

      int candleLeft=
         (int)(openTime+periodSeconds-TimeCurrent());

      if(candleLeft<0)
         candleLeft=0;

      //--------------------------------------------------
      // Confidence
      //--------------------------------------------------

      int confidence=0;

      if(finalBuy)
      {
         if(Trend.IsBull()) confidence+=20;
         if(MarketState.IsBull()) confidence+=20;
         if(bullHTF) confidence+=20;
      }

      if(finalSell)
      {
         if(Trend.IsBear()) confidence+=20;
         if(MarketState.IsBear()) confidence+=20;
         if(bearHTF) confidence+=20;
      }

      if(adx>=25.0)
         confidence+=15;

      if((rsi>=50 && rsi<=70) ||
         (rsi>=30 && rsi<=50))
         confidence+=15;

      confidence+=score/10;

      if(confidence>100)
         confidence=100;

      //--------------------------------------------------
      // Market Health
      //--------------------------------------------------

      string health="WEAK";
      int quality=score;
            if(score>=90 && adx>=30)
      {
         health="EXCELLENT";
         quality=95;
      }
      else
      if(score>=80 && adx>=25)
      {
         health="VERY GOOD";
         quality=85;
      }
      else
      if(score>=70)
      {
         health="GOOD";
         quality=75;
      }
      else
      if(score>=60)
      {
         health="FAIR";
         quality=60;
      }
      else
      {
         health="WEAK";
         quality=40;
      }

      //--------------------------------------------------
      // Signal Reason
      //--------------------------------------------------

      string reason="";

      reason+="Confidence : ";
      reason+=IntegerToString(confidence);
      reason+="%\n\n";

      if(Trend.IsBull())
         reason+="✓ Trend Bull\n";
      else
      if(Trend.IsBear())
         reason+="✓ Trend Bear\n";
      else
         reason+="• Sideway\n";

      if(MarketState.IsBull())
         reason+="✓ Market Bull\n";
      else
      if(MarketState.IsBear())
         reason+="✓ Market Bear\n";

      if(adx>=25.0)
         reason+="✓ ADX Strong\n";
      else
         reason+="• ADX Weak\n";

      if(rsi>=50.0 && rsi<=70.0)
         reason+="✓ RSI Buy Zone\n";
      else
      if(rsi>=30.0 && rsi<=50.0)
         reason+="✓ RSI Sell Zone\n";
      else
         reason+="• RSI Neutral\n";

      if(bullHTF)
         reason+="✓ HTF Bull\n";
      else
      if(bearHTF)
         reason+="✓ HTF Bear\n";
      else
         reason+="• HTF Neutral\n";

      if(allowTrading)
         reason+="✓ Session OK\n";
      else
         reason+="• Session Closed\n";

      int min=candleLeft/60;
      int sec=candleLeft%60;

      reason+="✓ Candle Left : ";
      reason+=StringFormat("%02d:%02d",min,sec);

      //--------------------------------------------------
      // Output
      //--------------------------------------------------

      datetime signalBar=iTime(_Symbol,_Period,1);

      if(finalBuy)
      {
         Arrow.DrawBuy(
            signalBar,
            iLow(_Symbol,_Period,1)
         );

         Alert.Buy(signalBar);
         Push.Buy(signalBar);
      }

      if(finalSell)
      {
         Arrow.DrawSell(
            signalBar,
            iHigh(_Symbol,_Period,1)
         );

         Alert.Sell(signalBar);
         Push.Sell(signalBar);
      }

      //--------------------------------------------------
      // Dashboard
      //--------------------------------------------------

      dashboard.SetTrend(
         Trend.GetTrendText()
      );

      dashboard.SetTrendPower(
         trendPower
      );

      dashboard.SetMarketState(
         MarketState.GetStateText()
      );

      dashboard.SetSession(
         allowTrading ? "ON" : "OFF"
      );

      dashboard.SetHTF(
         bullHTF ? "BULL" :
         bearHTF ? "BEAR" : "NONE"
      );

      dashboard.SetHealth(
         health
      );

      dashboard.SetQuality(
         quality
      );

      dashboard.SetConfidence(
         confidence
      );

      dashboard.SetADX(
         adx
      );

      dashboard.SetRSI(
         rsi
      );

      dashboard.SetScore(
         score
      );

      dashboard.SetCandleLeft(
         candleLeft
      );

      dashboard.SetSignal(
         signal
      );

      dashboard.SetReason(
         reason
      );

      dashboard.SetBuySignal(
         finalBuy
      );

      dashboard.SetSellSignal(
         finalSell
      );

      dashboard.Update();
   }

};

#endif