//+------------------------------------------------------------------+
//|                                                  MTFEngine.mqh   |
//+------------------------------------------------------------------+
#ifndef __MTF_ENGINE_MQH__
#define __MTF_ENGINE_MQH__

class CMTFEngine
{
private:

   ENUM_TIMEFRAMES m_tf;

public:

   CMTFEngine()
   {
      m_tf=PERIOD_H4;
   }

   //--------------------------------------------------------

   void SetTimeframe(ENUM_TIMEFRAMES tf)
   {
      m_tf=tf;
   }

   //--------------------------------------------------------

   bool IsBull()
   {
      double ema20=iMA(
         _Symbol,
         m_tf,
         20,
         0,
         MODE_EMA,
         PRICE_CLOSE
      );

      double ema50=iMA(
         _Symbol,
         m_tf,
         50,
         0,
         MODE_EMA,
         PRICE_CLOSE
      );

      return(ema20>ema50);
   }

   //--------------------------------------------------------

   bool IsBear()
   {
      double ema20=iMA(
         _Symbol,
         m_tf,
         20,
         0,
         MODE_EMA,
         PRICE_CLOSE
      );

      double ema50=iMA(
         _Symbol,
         m_tf,
         50,
         0,
         MODE_EMA,
         PRICE_CLOSE
      );

      return(ema20<ema50);
   }

};

#endif