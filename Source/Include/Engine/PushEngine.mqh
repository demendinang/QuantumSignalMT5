//+------------------------------------------------------------------+
//|                                                PushEngine.mqh    |
//+------------------------------------------------------------------+
#ifndef __PUSH_ENGINE_MQH__
#define __PUSH_ENGINE_MQH__

class CPushEngine
{
private:

   datetime m_lastBuy;
   datetime m_lastSell;

public:

   CPushEngine()
   {
      m_lastBuy=0;
      m_lastSell=0;
   }

   //--------------------------------------------------------------

   void Buy(datetime bar)
   {
      if(bar==m_lastBuy)
         return;

      m_lastBuy=bar;

      string msg=
         "Quantum BUY\n"
         +Symbol()+" "
         +EnumToString((ENUM_TIMEFRAMES)Period());

      SendNotification(msg);
   }

   //--------------------------------------------------------------

   void Sell(datetime bar)
   {
      if(bar==m_lastSell)
         return;

      m_lastSell=bar;

      string msg=
         "Quantum SELL\n"
         +Symbol()+" "
         +EnumToString((ENUM_TIMEFRAMES)Period());

      SendNotification(msg);
   }

};

#endif