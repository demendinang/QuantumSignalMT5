//+------------------------------------------------------------------+
//| Dashboard.mqh                                                    |
//+------------------------------------------------------------------+
#ifndef __DASHBOARD_MQH__
#define __DASHBOARD_MQH__

class CDashboard
{
private:

   string m_status;

public:

   CDashboard()
   {
      m_status="INIT";
   }

   bool Create()
   {
      Print("Dashboard Created");
      return(true);
   }

   void Destroy()
   {
      Print("Dashboard Destroyed");
   }

   void SetStatus(string text)
   {
      m_status=text;
   }

   void Update()
   {

   }

};

#endif