//+------------------------------------------------------------------+
//| Dashboard.mqh                                                    |
//+------------------------------------------------------------------+
#ifndef __DASHBOARD_MQH__
#define __DASHBOARD_MQH__

class CDashboard
{
private:

   string m_name;

   string m_status;
   string m_trend;
   string m_market;
   double m_adx;
   double m_rsi;
   int    m_score;

public:

   CDashboard()
   {
      m_name="QS_Dashboard";

      m_status="INIT";
      m_trend="UNKNOWN";
      m_market="UNKNOWN";

      m_adx=0.0;
      m_rsi=0.0;
      m_score=0;
   }

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

         ObjectSetInteger(0,m_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,m_name,OBJPROP_XDISTANCE,10);
         ObjectSetInteger(0,m_name,OBJPROP_YDISTANCE,20);

         ObjectSetInteger(0,m_name,OBJPROP_FONTSIZE,10);

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

   void Destroy()
   {
      ObjectDelete(0,m_name);
   }

   void SetStatus(string value)
   {
      m_status=value;
   }

   void SetTrend(string value)
   {
      m_trend=value;
   }

   void SetMarketState(string value)
   {
      m_market=value;
   }

   void SetADX(double value)
   {
      m_adx=value;
   }

   void SetRSI(double value)
   {
      m_rsi=value;
   }

   void SetScore(int value)
   {
      m_score=value;
   }

   void Update()
   {
      string txt;

      txt =
      "Quantum Signal MT5\n\n"

      +"Status : "+m_status+"\n"

      +"Trend  : "+m_trend+"\n"

      +"Market : "+m_market+"\n"

      +"ADX    : "+DoubleToString(m_adx,1)+"\n"

      +"RSI    : "+DoubleToString(m_rsi,1)+"\n"

      +"Score  : "+IntegerToString(m_score);

      ObjectSetString(
         0,
         m_name,
         OBJPROP_TEXT,
         txt
      );
   }

};

#endif