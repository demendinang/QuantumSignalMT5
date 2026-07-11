//+------------------------------------------------------------------+
//|                                                  ADXEngine.mqh   |
//+------------------------------------------------------------------+
#ifndef __ADX_ENGINE_MQH__
#define __ADX_ENGINE_MQH__

class CADXEngine
{
private:
   int m_handle;

public:

   CADXEngine()
   {
      m_handle=INVALID_HANDLE;
   }

   bool Initialize(
      string symbol=NULL,
      ENUM_TIMEFRAMES tf=PERIOD_CURRENT,
      int period=14)
   {
      m_handle=iADX(symbol,tf,period);

      return(m_handle!=INVALID_HANDLE);
   }

   void Release()
   {
      if(m_handle!=INVALID_HANDLE)
         IndicatorRelease(m_handle);

      m_handle=INVALID_HANDLE;
   }

   bool GetValues(
      double &adx,
      double &plusDI,
      double &minusDI)
   {
      if(m_handle==INVALID_HANDLE)
         return(false);

      if(BarsCalculated(m_handle)<=0)
         return(false);

      double adxBuf[];
      double plusBuf[];
      double minusBuf[];

      if(CopyBuffer(m_handle,0,0,1,adxBuf)<=0)
         return(false);

      if(CopyBuffer(m_handle,1,0,1,plusBuf)<=0)
         return(false);

      if(CopyBuffer(m_handle,2,0,1,minusBuf)<=0)
         return(false);

      adx=adxBuf[0];
      plusDI=plusBuf[0];
      minusDI=minusBuf[0];

      return(true);
   }

   bool IsStrongTrend(double level=25.0)
   {
      double adx,plusDI,minusDI;

      if(!GetValues(adx,plusDI,minusDI))
         return(false);

      return(adx>=level);
   }

};

#endif