//+------------------------------------------------------------------+
//|                                                  RSIEngine.mqh   |
//+------------------------------------------------------------------+
#ifndef __RSI_ENGINE_MQH__
#define __RSI_ENGINE_MQH__

class CRSIEngine
{
private:
   int m_handle;

public:

   CRSIEngine()
   {
      m_handle = INVALID_HANDLE;
   }

   bool Initialize(
      string symbol=NULL,
      ENUM_TIMEFRAMES tf=PERIOD_CURRENT,
      int period=14)
   {
      m_handle = iRSI(symbol,tf,period,PRICE_CLOSE);

      return(m_handle!=INVALID_HANDLE);
   }

   void Release()
   {
      if(m_handle!=INVALID_HANDLE)
         IndicatorRelease(m_handle);

      m_handle = INVALID_HANDLE;
   }

   bool Value(double &rsi)
   {
      if(m_handle==INVALID_HANDLE)
         return(false);

      if(BarsCalculated(m_handle)<=0)
         return(false);

      double buffer[];

      if(CopyBuffer(m_handle,0,0,1,buffer)<=0)
         return(false);

      rsi = buffer[0];

      return(true);
   }

   bool IsOverBought()
   {
      double rsi;

      if(!Value(rsi))
         return(false);

      return(rsi>=70.0);
   }

   bool IsOverSold()
   {
      double rsi;

      if(!Value(rsi))
         return(false);

      return(rsi<=30.0);
   }

};

#endif