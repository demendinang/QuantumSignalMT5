//+------------------------------------------------------------------+
//|                                                 TrendEngine.mqh  |
//|                     Quantum Signal MT5                           |
//|                       Build 031                                  |
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

   double m_power;

public:

   //------------------------------------------------------------

   CTrendEngine()
   {
      m_trend = TREND_UNKNOWN;
      m_power = 0.0;
   }

   //------------------------------------------------------------

   ENUM_TREND Calculate(
      double ema20,
      double ema50,
      double ema200)
   {
      if(ema20 > ema50 && ema50 > ema200)
         m_trend = TREND_BULL;

      else
      if(ema20 < ema50 && ema50 < ema200)
         m_trend = TREND_BEAR;

      else
         m_trend = TREND_SIDEWAY;

      //---------------------------------------------------------
      // Trend Power
      //---------------------------------------------------------

      double d1=MathAbs(ema20-ema50);
      double d2=MathAbs(ema50-ema200);

      m_power=(d1+d2)*100.0;

      if(m_power>100.0)
         m_power=100.0;

      return(m_trend);
   }

   //------------------------------------------------------------

   ENUM_TREND GetTrend() const
   {
      return(m_trend);
   }

   //------------------------------------------------------------

   string GetTrendText() const
   {
      switch(m_trend)
      {
         case TREND_BULL:

            if(m_power>=90)
               return("VERY STRONG BULL");

            if(m_power>=75)
               return("STRONG BULL");

            return("BULL");

         case TREND_BEAR:

            if(m_power>=90)
               return("VERY STRONG BEAR");

            if(m_power>=75)
               return("STRONG BEAR");

            return("BEAR");

         case TREND_SIDEWAY:
            return("SIDEWAY");
      }

      return("UNKNOWN");
   }

   //------------------------------------------------------------

   double GetTrendPower() const
   {
      return(m_power);
   }

   //------------------------------------------------------------

   int GetTrendPowerPercent() const
   {
      return((int)MathRound(m_power));
   }

   //------------------------------------------------------------

   bool IsBull() const
   {
      return(m_trend==TREND_BULL);
   }

   //------------------------------------------------------------

   bool IsBear() const
   {
      return(m_trend==TREND_BEAR);
   }

   //------------------------------------------------------------

   bool IsSideway() const
   {
      return(m_trend==TREND_SIDEWAY);
   }

};

#endif