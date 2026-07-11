//+------------------------------------------------------------------+
//| ObjectManager.mqh                                                |
//| Quantum Signal MT5                                               |
//| Version 0.100                                                    |
//+------------------------------------------------------------------+
#ifndef __OBJECT_MANAGER_MQH__
#define __OBJECT_MANAGER_MQH__

class CObjectManager
{
private:
   string m_prefix;

public:

   // Constructor
   CObjectManager()
   {
      m_prefix = "QS_";
   }

   // Set object prefix
   void SetPrefix(string prefix)
   {
      m_prefix = prefix;
   }

   // Return full object name
   string Name(string objectName)
   {
      return(m_prefix + objectName);
   }

   // Delete one object
   void Delete(string objectName)
   {
      string name = Name(objectName);

      if(ObjectFind(0,name)>=0)
         ObjectDelete(0,name);
   }

   // Delete all Quantum objects
   void DeleteAll()
   {
      int total=ObjectsTotal(0);

      for(int i=total-1;i>=0;i--)
      {
         string obj=ObjectName(0,i);

         if(StringFind(obj,m_prefix)==0)
            ObjectDelete(0,obj);
      }
   }

};

#endif