//+------------------------------------------------------------------+
//|                                                 AlertEngine.mqh  |
//+------------------------------------------------------------------+
#ifndef __ALERT_ENGINE_MQH__
#define __ALERT_ENGINE_MQH__

class CAlertEngine
{
private:

   datetime m_lastBuyBar;
   datetime m_lastSellBar;

public:

   CAlertEngine()
   {
      m_lastBuyBar=0;
      m_lastSellBar=0;
   }

   //----------------------------------------------------------
   // BUY Alert
   //----------------------------------------------------------
   void Buy(datetime barTime)
   {
      if(barTime==m_lastBuyBar)
         return;

      m_lastBuyBar=barTime;

      string msg=
         "Quantum Signal BUY : "
         +Symbol()
         +" "
         +EnumToString((ENUM_TIMEFRAMES)Period());

      Print(msg);

      Alert(msg);
   }

   //----------------------------------------------------------
   // SELL Alert
   //----------------------------------------------------------
   void Sell(datetime barTime)
   {
      if(barTime==m_lastSellBar)
         return;

      m_lastSellBar=barTime;

      string msg=
         "Quantum Signal SELL : "
         +Symbol()
         +" "
         +EnumToString((ENUM_TIMEFRAMES)Period());

      Print(msg);

      Alert(msg);
   }

};

#endif