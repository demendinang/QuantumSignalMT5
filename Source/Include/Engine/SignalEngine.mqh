//+------------------------------------------------------------------+
//|                                                SignalEngine.mqh  |
//+------------------------------------------------------------------+
#ifndef __SIGNAL_ENGINE_MQH__
#define __SIGNAL_ENGINE_MQH__

class CSignalEngine
{
private:

   bool m_buySignal;
   bool m_sellSignal;

public:

   CSignalEngine()
   {
      Reset();
   }

   void Reset()
   {
      m_buySignal  = false;
      m_sellSignal = false;
   }

   void Calculate(
      bool isBull,
      bool isBear,
      double adx,
      double rsi,
      int score
   )
   {
      Reset();

      //----------------------------------------------------------
      // BUY
      //----------------------------------------------------------
      if(
            isBull
         && adx >= 25.0
         && rsi > 50.0
         && score >= 70
      )
      {
         m_buySignal = true;
      }

      //----------------------------------------------------------
      // SELL
      //----------------------------------------------------------
      if(
            isBear
         && adx >= 25.0
         && rsi < 50.0
         && score >= 70
      )
      {
         m_sellSignal = true;
      }
   }

   bool IsBuySignal() const
   {
      return m_buySignal;
   }

   bool IsSellSignal() const
   {
      return m_sellSignal;
   }

};

#endif