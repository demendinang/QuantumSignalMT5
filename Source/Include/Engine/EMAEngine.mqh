//+------------------------------------------------------------------+
//|                                                   EMAEngine.mqh  |
//|                     Quantum Signal MT5                           |
//+------------------------------------------------------------------+
#ifndef __EMA_ENGINE_MQH__
#define __EMA_ENGINE_MQH__

class CEMAEngine
{
private:
   int m_handle20;
   int m_handle50;
   int m_handle200;

public:
   CEMAEngine()
   {
      m_handle20  = INVALID_HANDLE;
      m_handle50  = INVALID_HANDLE;
      m_handle200 = INVALID_HANDLE;
   }

   bool Initialize(string symbol=NULL,ENUM_TIMEFRAMES tf=PERIOD_CURRENT)
   {
      m_handle20  = iMA(symbol,tf,20,0,MODE_EMA,PRICE_CLOSE);
      m_handle50  = iMA(symbol,tf,50,0,MODE_EMA,PRICE_CLOSE);
      m_handle200 = iMA(symbol,tf,200,0,MODE_EMA,PRICE_CLOSE);

      return(
         m_handle20  != INVALID_HANDLE &&
         m_handle50  != INVALID_HANDLE &&
         m_handle200 != INVALID_HANDLE
      );
   }

   void Release()
   {
      if(m_handle20  != INVALID_HANDLE) IndicatorRelease(m_handle20);
      if(m_handle50  != INVALID_HANDLE) IndicatorRelease(m_handle50);
      if(m_handle200 != INVALID_HANDLE) IndicatorRelease(m_handle200);

      m_handle20  = INVALID_HANDLE;
      m_handle50  = INVALID_HANDLE;
      m_handle200 = INVALID_HANDLE;
   }

private:

   bool ReadValue(int handle,double &value)
   {
      if(handle==INVALID_HANDLE)
         return false;

      if(BarsCalculated(handle)<=0)
         return false;

      double buffer[];

      if(CopyBuffer(handle,0,0,1,buffer)<=0)
         return false;

      value=buffer[0];
      return true;
   }

public:

   bool EMA20(double &value)
   {
      return ReadValue(m_handle20,value);
   }

   bool EMA50(double &value)
   {
      return ReadValue(m_handle50,value);
   }

   bool EMA200(double &value)
   {
      return ReadValue(m_handle200,value);
   }

};

#endif