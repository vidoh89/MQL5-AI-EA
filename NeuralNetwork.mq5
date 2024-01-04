//+------------------------------------------------------------------+
//|                                                NeuralNetwork.mq5 |
//|                                      Copyright 2024,Vince Dority |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//---Python script

#property copyright "Copyright 2024,Vince Dority"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property link      "https://www.mql5.com"
#property strict
#property script_show_inputs

input string Date="2004.07.01 00:00";
input string DateOut="2010.12.31 23:00";
input int History=0;

double inB[22];
string Date1;

int HandleInputNet1Min;
int HandleInputNet1Max;

double DibMin1_1[];
double DibMax1_1[];
int DibMin1_1Handle;
int DibMax1_1Handle;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int k=iBars(NULL,PERIOD_H1)-1;
   
   DibMin1_1Handle=iCustom(NULL,PERIOD_H1,"DibMin1-1",History);
   CopyBuffer(DibMin1_1Handle,0,0,k,DibMin1_1);
   ArraySetAsSeries(DibMin1_1,true);
   
   DibMax1_1Handle=iCustom(NULL,PERIOD_H1,"DibMax1-1",History);
   CopyBuffer(DibMax1_1Handle,0,0,k,DibMax1_1);
   ArraySetAsSeries(DibMax1_1,true);
   
   HandleInputNet1Min=FileOpen(Symbol()+"InputNet1Min.csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI|FILE_COMMON,";");
   HandleInputNet1Max=FileOpen(Symbol()+"InputNet1Max.csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI|FILE_COMMON,";");
   
   FileSeek(HandleInputNet1Min,0,SEEK_END);
   FileSeek(HandleInputNet1Max,0,SEEK_END);
   
   if(HandleInputNet1Min>0)
      {
         Alert("Writing to the file InputNet1Min");
         
         for(int i=iBars(NULL,PERIOD_H1)-1;i>=0;i--)
               
            {
               Date1=TimeToString(iTime(NULL,PERIOD_H1,i));
               
               if(DateOut>=Date1 && Date<=Date1)
                  {
                     if((DibMin1_1[i]==-1 && DibMin1_1[i+1]==1 && DibMax1_1[i]==1)||(DibMin1_1[i]==1 && DibMax1_1[i]==1))
                        {
                           for(int m=0; m<=14;m++)
                              {
                                 inB[m]=inB[m+5];
                                 }
                                 inB[15]=(iOpen(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i)))-iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i))))*10000;
                                 inB[16]=(iHigh(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i)))-iOpen(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i))))*100000;
                                 inB[17]=(iHigh(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i)))-iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i))))*10000;
                                 inB[18]=(iHigh(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i)))-iOpen(NULL,PERIOD_H1,i+1))*10000;
                                 inB[19]=(iOpen(NULL,PERIOD_H1,i+1)-iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i))))*10000;
                                 
                                 inB[20]=(iHigh(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i)))-iOpen(NULL,PERIOD_H1,i))*10000;
                                 inB[21]=(iOpen(NULL,PERIOD_H1,i)-iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i))))*10000;
                                 
                                 FileWrite(HandleInputNet1Min,
                                           inB[0],inB[1],inB[2],inB[3],inB[4],inB[5],inB[6],inB[7],inB[8],inB[9],inB[10],inB[11],inB[12]
                                           ,inB[13],inB[14],inB[15],inB[16],inB[17],inB[18],inB[19],inB[20],inB[21]);
                              
                              }
                     }
               }
                                 FileClose(HandleInputNet1Min);
         
         }
   
   if(HandleInputNet1Max>0)
      {  
         Alert("Writing the file InputNetMax");
         
         for(int i = iBars(NULL,PERIOD_H1)-1;i>=0;i--)
            {
               Date1=TimeToString(iTime(NULL,PERIOD_H1,i));
               
               if(DateOut>=Date1 && Date<=Date1)
               
                  {
                     if(((DibMax1_1[i]==-1 && DibMax1_1[i+1]==1 && DibMin1_1[i]==1) ||( DibMin1_1[i]==1 && DibMax1_1[i]==1)))
                        {
                        
                           for(int m=0; m<=14;m++)
                           {
                              inB[m]=inB[m+5];
                           }
                        }
                     }
               }
         }
  }
//+------------------------------------------------------------------+
