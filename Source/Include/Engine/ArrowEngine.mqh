//+------------------------------------------------------------------+
//|                                                 ArrowEngine.mqh  |
//+------------------------------------------------------------------+
#ifndef __ARROW_ENGINE_MQH__
#define __ARROW_ENGINE_MQH__

class CArrowEngine
{
private:

   string m_prefix;

public:

   CArrowEngine()
   {
      m_prefix="QS_ARROW_";
   }

   void SetPrefix(string prefix)
   {
      m_prefix=prefix;
   }

   //--------------------------------------------------------------
   // BUY Arrow
   //--------------------------------------------------------------
   void DrawBuy(datetime barTime,double price)
   {
      string name=m_prefix+"BUY_"+IntegerToString((long)barTime);

      if(ObjectFind(0,name)>=0)
         return;

      ObjectCreate(
         0,
         name,
         OBJ_ARROW,
         0,
         barTime,
         price
      );

      ObjectSetInteger(0,name,OBJPROP_ARROWCODE,233);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrLime);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,2);
   }

   //--------------------------------------------------------------
   // SELL Arrow
   //--------------------------------------------------------------
   void DrawSell(datetime barTime,double price)
   {
      string name=m_prefix+"SELL_"+IntegerToString((long)barTime);

      if(ObjectFind(0,name)>=0)
         return;

      ObjectCreate(
         0,
         name,
         OBJ_ARROW,
         0,
         barTime,
         price
      );

      ObjectSetInteger(0,name,OBJPROP_ARROWCODE,234);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,2);
   }

};

#endif