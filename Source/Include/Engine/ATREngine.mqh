//+------------------------------------------------------------------+
//|                                                  ATREngine.mqh   |
//+------------------------------------------------------------------+
#ifndef __ATR_ENGINE_MQH__
#define __ATR_ENGINE_MQH__

class CATREngine
{
private:
   int m_handle;

public:

   CATREngine()
   {
      m_handle = INVALID_HANDLE;
   }

   bool Initialize(
      string symbol=NULL,
      ENUM_TIMEFRAMES tf=PERIOD_CURRENT,
      int period=14)
   {
      m_handle=iATR(symbol,tf,period);

      return(m_handle!=INVALID_HANDLE);
   }

   void Release()
   {
      if(m_handle!=INVALID_HANDLE)
         IndicatorRelease(m_handle);

      m_handle=INVALID_HANDLE;
   }

   bool Value(double &atr)
   {
      if(m_handle==INVALID_HANDLE)
         return(false);

      if(BarsCalculated(m_handle)<=0)
         return(false);

      double buffer[];

      if(CopyBuffer(m_handle,0,0,1,buffer)<=0)
         return(false);

      atr=buffer[0];

      return(true);
   }

};

#endif