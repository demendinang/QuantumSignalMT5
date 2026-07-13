//+------------------------------------------------------------------+
//|                                          SignalFilterEngine.mqh  |
//+------------------------------------------------------------------+
#ifndef __SIGNAL_FILTER_ENGINE_MQH__
#define __SIGNAL_FILTER_ENGINE_MQH__

class CSignalFilterEngine
{
private:

   bool m_buyPassed;
   bool m_sellPassed;

   double m_minADX;
   double m_minATR;
   int    m_minScore;

public:

   CSignalFilterEngine()
   {
      m_minADX   = 25.0;
      m_minATR   = 1.0;
      m_minScore = 70;

      Reset();
   }

   //------------------------------------------------------------
   void Reset()
   {
      m_buyPassed  = false;
      m_sellPassed = false;
   }

   //------------------------------------------------------------
   void SetMinADX(double value)
   {
      m_minADX = value;
   }

   //------------------------------------------------------------
   void SetMinATR(double value)
   {
      m_minATR = value;
   }

   //------------------------------------------------------------
   void SetMinScore(int value)
   {
      m_minScore = value;
   }

   //------------------------------------------------------------
   void Calculate(
      bool bullMarket,
      bool bearMarket,
      bool bullTrend,
      bool bearTrend,
      double atr,
      double adx,
      double rsi,
      int score
   )
   {
      Reset();

      //---------------------------------------------------------
      // BUY FILTER
      //---------------------------------------------------------
      if(
            bullMarket
         && bullTrend
         && adx >= m_minADX
         && atr >= m_minATR
         && rsi >= 50.0
         && rsi <= 70.0
         && score >= m_minScore
      )
      {
         m_buyPassed = true;
      }

      //---------------------------------------------------------
      // SELL FILTER
      //---------------------------------------------------------
      if(
            bearMarket
         && bearTrend
         && adx >= m_minADX
         && atr >= m_minATR
         && rsi >= 30.0
         && rsi <= 50.0
         && score >= m_minScore
      )
      {
         m_sellPassed = true;
      }
   }

   //------------------------------------------------------------
   bool BuyPassed() const
   {
      return m_buyPassed;
   }

   //------------------------------------------------------------
   bool SellPassed() const
   {
      return m_sellPassed;
   }

};

#endif