//+------------------------------------------------------------------+
//|                                            MarketStateEngine.mqh |
//+------------------------------------------------------------------+
#ifndef __MARKET_STATE_ENGINE_MQH__
#define __MARKET_STATE_ENGINE_MQH__

enum ENUM_MARKET_STATE
{
   MARKET_UNKNOWN = 0,
   MARKET_BULL,
   MARKET_BEAR,
   MARKET_RANGE
};

class CMarketStateEngine
{
private:

   ENUM_MARKET_STATE m_state;

public:

   CMarketStateEngine()
   {
      m_state = MARKET_UNKNOWN;
   }

   ENUM_MARKET_STATE Calculate(
      double ema20,
      double ema50,
      double ema200,
      double adx
   )
   {
      if(adx < 20)
      {
         m_state = MARKET_RANGE;
      }
      else
      {
         if(ema20 > ema50 && ema50 > ema200)
            m_state = MARKET_BULL;

         else if(ema20 < ema50 && ema50 < ema200)
            m_state = MARKET_BEAR;

         else
            m_state = MARKET_RANGE;
      }

      return m_state;
   }

   ENUM_MARKET_STATE GetState() const
   {
      return m_state;
   }

   string GetStateText() const
   {
      switch(m_state)
      {
         case MARKET_BULL:
            return "BULL";

         case MARKET_BEAR:
            return "BEAR";

         case MARKET_RANGE:
            return "RANGE";
      }

      return "UNKNOWN";
   }

   bool IsBull() const
   {
      return (m_state==MARKET_BULL);
   }

   bool IsBear() const
   {
      return (m_state==MARKET_BEAR);
   }

   bool IsRange() const
   {
      return (m_state==MARKET_RANGE);
   }

};

#endif