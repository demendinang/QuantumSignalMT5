//+------------------------------------------------------------------+
//| Dashboard.mqh                                                    |
//| Build 034 - Professional Dashboard                              |
//+------------------------------------------------------------------+
#ifndef __DASHBOARD_MQH__
#define __DASHBOARD_MQH__

class CDashboard
{
private:

   string m_name;

   //--------------------------------------------------
   // STATUS
   //--------------------------------------------------

   string m_status;
   string m_trend;
   string m_market;
   string m_session;
   string m_htf;
   string m_signal;

   //--------------------------------------------------
   // MARKET QUALITY
   //--------------------------------------------------

   string m_health;
   string m_volatility;

   int    m_quality;
   int    m_confidence;

   double m_trendPower;

   //--------------------------------------------------
   // INDICATORS
   //--------------------------------------------------

   double m_atr;
   double m_adx;
   double m_rsi;

   int    m_score;

   int    m_candleLeft;

   //--------------------------------------------------
   // SIGNAL
   //--------------------------------------------------

   bool   m_buy;
   bool   m_sell;

   string m_reason;

public:

   //--------------------------------------------------

   CDashboard()
   {
      m_name="QS_Dashboard";

      m_status="INIT";

      m_trend ="UNKNOWN";
      m_market="UNKNOWN";
      m_session="OFF";
      m_htf="NONE";

      m_signal="WAIT";

      m_health="UNKNOWN";
      m_volatility="NORMAL";

      m_quality=0;
      m_confidence=0;

      m_trendPower=0;

      m_atr=0;
      m_adx=0;
      m_rsi=0;

      m_score=0;

      m_candleLeft=0;

      m_buy=false;
      m_sell=false;

      m_reason="";
   }

   //--------------------------------------------------

   bool Create()
   {
      if(ObjectFind(0,m_name)<0)
      {
         ObjectCreate(
            0,
            m_name,
            OBJ_LABEL,
            0,
            0,
            0
         );

         ObjectSetInteger(
            0,
            m_name,
            OBJPROP_CORNER,
            CORNER_LEFT_UPPER
         );

         ObjectSetInteger(
            0,
            m_name,
            OBJPROP_XDISTANCE,
            10
         );

         ObjectSetInteger(
            0,
            m_name,
            OBJPROP_YDISTANCE,
            20
         );

         ObjectSetInteger(
            0,
            m_name,
            OBJPROP_FONTSIZE,
            10
         );

         ObjectSetString(
            0,
            m_name,
            OBJPROP_FONT,
            "Consolas"
         );
      }

      Update();

      return(true);
   }

   //--------------------------------------------------

   void Destroy()
   {
      ObjectDelete(0,m_name);
   }

   //--------------------------------------------------
   // SETTERS
   //--------------------------------------------------

   void SetStatus(string value)
   {
      m_status=value;
   }

   //--------------------------------------------------

   void SetTrend(string value)
   {
      m_trend=value;
   }

   //--------------------------------------------------

   void SetTrendPower(double value)
   {
      if(value<0)
         value=0;

      if(value>100)
         value=100;

      m_trendPower=value;
   }

   //--------------------------------------------------

   void SetMarketState(string value)
   {
      m_market=value;
   }

   //--------------------------------------------------

   void SetSession(string value)
   {
      m_session=value;
   }

   //--------------------------------------------------

   void SetHTF(string value)
   {
      m_htf=value;
   }

   //--------------------------------------------------

   void SetSignal(string value)
   {
      m_signal=value;
   }

   //--------------------------------------------------

   void SetHealth(string value)
   {
      m_health=value;
   }

   //--------------------------------------------------

   void SetVolatility(string value)
   {
      m_volatility=value;
   }

   //--------------------------------------------------

   void SetQuality(int value)
   {
      if(value<0)
         value=0;

      if(value>100)
         value=100;

      m_quality=value;
   }

   //--------------------------------------------------

   void SetConfidence(int value)
   {
      if(value<0)
         value=0;

      if(value>100)
         value=100;

      m_confidence=value;
   }

   //--------------------------------------------------

   void SetATR(double value)
   {
      m_atr=value;
   }

   //--------------------------------------------------

   void SetADX(double value)
   {
      m_adx=value;
   }

   //--------------------------------------------------

   void SetRSI(double value)
   {
      m_rsi=value;
   }

   //--------------------------------------------------

   void SetScore(int value)
   {
      m_score=value;
   }

   //--------------------------------------------------

   void SetCandleLeft(int value)
   {
      if(value<0)
         value=0;

      m_candleLeft=value;
   }
      //--------------------------------------------------

   void SetBuySignal(bool value)
   {
      m_buy=value;
   }

   //--------------------------------------------------

   void SetSellSignal(bool value)
   {
      m_sell=value;
   }

   //--------------------------------------------------

   void SetReason(string value)
   {
      m_reason=value;
   }

   //--------------------------------------------------

   void Update()
   {
      int min=m_candleLeft/60;
      int sec=m_candleLeft%60;

      string candle=
         StringFormat("%02d:%02d",min,sec);

      string txt;

      txt=
      "====================================\n"
      "        Quantum Signal MT5\n"
      "====================================\n\n"

      +"Trend        : "+m_trend+"\n"
      +"Trend Power  : "+DoubleToString(m_trendPower,0)+"%\n"
      +"Market       : "+m_market+"\n"
      +"Session      : "+m_session+"\n"
      +"HTF          : "+m_htf+"\n\n"

      +"Health       : "+m_health+"\n"
      +"Quality      : "+IntegerToString(m_quality)+"%\n"
      +"Confidence   : "+IntegerToString(m_confidence)+"%\n\n"

      +"ATR          : "+DoubleToString(m_atr,2)+"\n"
      +"Volatility   : "+m_volatility+"\n"
      +"ADX          : "+DoubleToString(m_adx,1)+"\n"
      +"RSI          : "+DoubleToString(m_rsi,1)+"\n"
      +"Score        : "+IntegerToString(m_score)+"\n"
      +"Candle       : "+candle+"\n\n"

      +"Signal       : "+m_signal+"\n"
      +"BUY          : "+(m_buy ? "YES" : "NO")+"\n"
      +"SELL         : "+(m_sell ? "YES" : "NO")+"\n\n"

      +"------------------------------------\n"
      +"Reason\n"
      +"------------------------------------\n"

      +m_reason;

      ObjectSetString(
         0,
         m_name,
         OBJPROP_TEXT,
         txt
      );
   }

};

#endif