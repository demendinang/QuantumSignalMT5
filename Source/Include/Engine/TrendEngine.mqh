//+------------------------------------------------------------------+
//|                                                 TrendEngine.mqh  |
//|                     Quantum Signal MT5                           |
//+------------------------------------------------------------------+
#ifndef __TREND_ENGINE_MQH__
#define __TREND_ENGINE_MQH__

enum ENUM_TREND
{
   TREND_UNKNOWN = 0,
   TREND_BULL,
   TREND_BEAR,
   TREND_SIDEWAY
};

class CTrendEngine
{
private:
   ENUM_TREND m_trend;

public:

   CTrendEngine()
   {
      m_trend = TREND_UNKNOWN;
   }

   ENUM_TREND Calculate(
      double ema20,
      double ema50,
      double ema200)
   {
      if(ema20 > ema50 && ema50 > ema200)
         m_trend = TREND_BULL;

      else if(ema20 < ema50 && ema50 < ema200)
         m_trend = TREND_BEAR;

      else
         m_trend = TREND_SIDEWAY;

      return m_trend;
   }

   ENUM_TREND GetTrend() const
   {
      return m_trend;
   }

   string GetTrendText() const
   {
      switch(m_trend)
      {
         case TREND_BULL:
            return "BULL";

         case TREND_BEAR:
            return "BEAR";

         case TREND_SIDEWAY:
            return "SIDEWAY";
      }

      return "UNKNOWN";
   }

   bool IsBull() const
   {
      return (m_trend==TREND_BULL);
   }

   bool IsBear() const
   {
      return (m_trend==TREND_BEAR);
   }

   bool IsSideway() const
   {
      return (m_trend==TREND_SIDEWAY);
   }

};

#endif