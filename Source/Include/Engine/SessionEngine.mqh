//+------------------------------------------------------------------+
//|                                               SessionEngine.mqh  |
//+------------------------------------------------------------------+
#ifndef __SESSION_ENGINE_MQH__
#define __SESSION_ENGINE_MQH__

class CSessionEngine
{
private:

   bool m_asian;
   bool m_london;
   bool m_newyork;

public:

   CSessionEngine()
   {
      m_asian   = false;
      m_london  = false;
      m_newyork = false;
   }

   //------------------------------------------------------------

   void Calculate()
{
   m_asian   = false;
   m_london  = false;
   m_newyork = false;

   MqlDateTime tm;
   TimeToStruct(TimeCurrent(), tm);

   int hour = tm.hour;

   // Asian : 00 -> 07
   if(hour >= 0 && hour < 8)
      m_asian = true;

   // London : 08 -> 15
   if(hour >= 8 && hour < 16)
      m_london = true;

   // New York : 13 -> 21
   if(hour >= 13 && hour < 22)
      m_newyork = true;
}

   //------------------------------------------------------------

   bool IsAsian() const
   {
      return m_asian;
   }

   //------------------------------------------------------------

   bool IsLondon() const
   {
      return m_london;
   }

   //------------------------------------------------------------

   bool IsNewYork() const
   {
      return m_newyork;
   }

   //------------------------------------------------------------

   bool AllowTrading() const
   {
      return (m_london || m_newyork);
   }
};

#endif