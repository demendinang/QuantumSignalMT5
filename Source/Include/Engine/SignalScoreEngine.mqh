//+------------------------------------------------------------------+
//|                                          SignalScoreEngine.mqh   |
//+------------------------------------------------------------------+
#ifndef __SIGNAL_SCORE_ENGINE_MQH__
#define __SIGNAL_SCORE_ENGINE_MQH__

class CSignalScoreEngine
{
private:
   int m_score;

public:

   CSignalScoreEngine()
   {
      m_score=0;
   }

   int Calculate(
      bool bullTrend,
      bool bearTrend,
      double adx,
      double rsi)
   {
      m_score=0;

      // Trend
      if(bullTrend || bearTrend)
         m_score+=40;

      // Trend strength
      if(adx>=25)
         m_score+=30;
      else
      if(adx>=20)
         m_score+=15;

      // RSI Filter
      if(bullTrend)
      {
         if(rsi>50 && rsi<70)
            m_score+=30;
      }

      if(bearTrend)
      {
         if(rsi<50 && rsi>30)
            m_score+=30;
      }

      if(m_score>100)
         m_score=100;

      return(m_score);
   }

   int Score() const
   {
      return(m_score);
   }

};

#endif