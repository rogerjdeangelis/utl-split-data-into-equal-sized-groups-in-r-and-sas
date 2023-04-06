%let pgm=utl-split-data-into-equal-sized-groups-in-r-and-sas;

Split Data into Equal Sized Groups in R and sas

Assign my baseball players into equal groups of low, medium and high home run production of home.

github
https://tinyurl.com/ycn9dth3
https://github.com/rogerjdeangelis/utl-split-data-into-equal-sized-groups-in-r-and-sas

stackOverflow
https://tinyurl.com/mu5h4kau
https://stackoverflow.com/questions/75944793/how-can-i-use-the-clevels-statement-to-specify-my-class-levels-for-the-surveyimp

statology
https://www.statology.org/r-split-data-into-equal-sized-groups/

github
https://tinyurl.com/upcx6ot
https://github.com/rogerjdeangelis/utl-partioning-data-into-equal-size-bins-using-proc-hpbin

SAS Forum
https://communities.sas.com/t5/SAS-Procedures/creating-equal-size-bins/m-p/627647

Rick_SAS Profile
https://communities.sas.com/t5/user/viewprofilepage/user-id/13684

/*     _     _           _   _
  ___ | |__ (_) ___  ___| |_(_)_   _____
 / _ \| `_ \| |/ _ \/ __| __| \ \ / / _ \
| (_) | |_) | |  __/ (__| |_| |\ V /  __/
 \___/|_.__// |\___|\___|\__|_| \_/ \___|
          |__/
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Up to 40 obs from last table WORK.WANT total obs=12 06APR2023:10:58:08                                                */
/*                                                                                                                        */
/*                  9 characters                                                                                          */
/*                  ========                                                                                              */
/*                    HOME_                                                                                               */
/*  Obs    PLAYER      RUNS    GROUP           STATUS                                                                     */
/*                                                                                                                        */
/*    1    Alfred        1       1    Low HomeRun Production                                                              */
/*    2    Henry         2       1    Low HomeRun Production                                                              */
/*    3    James         2       1    Low HomeRun Production                                                              */
/*    4    Jeffrey       2       1    Low HomeRun Production                                                              */
/*                                                                                                                        */
/*    5    Joseph        4       2    Medium HomeRun Production                                                           */
/*    6    John          5       2    Medium HomeRun Production                                                           */
/*    7    Philip        7       2    Medium HomeRun Production                                                           */
/*    8    Robert        9       2    Medium HomeRun Production                                                           */
/*                                                                                                                        */
/*    9    Roger        12       3    High HomeRun Production                                                             */
/*   10    Ronald       14       3    High HomeRun Production                                                             */
/*   11    Thomas       15       3    High HomeRun Production                                                             */
/*   12    William      22       3    High HomeRun Production                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data sd1.have;

input Player$   Home_Runs;

cards4;
Alfred     1
Henry      2
James      2
Jeffrey    2
Joseph     4
John       5
Philip     7
Robert     9
Roger     12
Ronald    14
Thomas    15
William   22
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Up to 40 obs from last table SD1.HAVE total obs=12 06APR2023:10:34:57                                                 */
/*                                                                                                                        */
/*  Obs    PLAYER     HOME_RUNS                                                                                           */
/*                                                                                                                        */
/*    1    Alfred         1                                                                                               */
/*    2    Henry          2                                                                                               */
/*    3    James          2                                                                                               */
/*    4    Jeffrey        2                                                                                               */
/*    5    Joseph         4                                                                                               */
/*    6    John           5                                                                                               */
/*    7    Philip         7                                                                                               */
/*    8    Robert         9                                                                                               */
/*    9    Roger         12                                                                                               */
/*   10    Ronald        14                                                                                               */
/*   11    Thomas        15                                                                                               */
/*   12    William       22                                                                                               */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

proc datasets lib=work nodetails nolist mt=data mt=view;
  delete want_r want;
run;quit;

%utlfkil(d:/xpt/want_r.xpt) ;

%utl_submit_r64("
library(haven);
library(ggplot2);
library(data.table);
library(SASxport);
have<-read_sas('d:/sd1/have.sas7bdat');
have;
have$GROUP <- cut_number(have$HOME_RUNS, 3);
for (i in seq_along(have)) {label(have[[i]])<-colnames(have)[i]};
want_r<-as.data.frame(have);
write.xport(want_r,file='d:/xpt/want_r.xpt');
");

options label;

libname xpt xport "d:/xpt/want_r.xpt";

proc contents data=xpt._all_;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/* Note HOME_RUNS is 9 characters and has been truncated to 8 characters                                                  */
/*                                                                                                                        */
/* Alphabetic List of Variables and Attributes                                                                            */
/* The code below will rename variable HOME_RUN to HOME_RUNS                                                              */
/*                                                                                                                        */
/* #    Variable    Type    Len    Label                                                                                  */
/*                                                                                                                        */
/* 3    GROUP       Char     37    GROUP                                                                                  */
/* 2    HOME_RUN    Num       8    HOME_RUNS                                                                              */
/* 1    PLAYER      Char      7    PLAYER                                                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/

data want ;

   %utl_rens(xpt.want_r);
   set want_r;

   select (group);
      when (1) status = "Low HomeRun Production    " ;
      when (2) status = "Medium HomeRun Production " ;
      when (3) status = "High HomeRun Production   " ;
      /*--- leave off otherwise to force error in not exclusive ----*/
   end;

run;quit;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Up to 40 obs from last table WORK.WANT total obs=12 06APR2023:10:58:08                                                */
/*                                                                                                                        */
/*                  9 characters                                                                                          */
/*                  ========                                                                                              */
/*                    HOME_                                                                                               */
/*  Obs    PLAYER      RUNS    GROUP           STATUS                                                                     */
/*                                                                                                                        */
/*    1    Alfred        1       1    Low HomeRun Production                                                              */
/*    2    Henry         2       1    Low HomeRun Production                                                              */
/*    3    James         2       1    Low HomeRun Production                                                              */
/*    4    Jeffrey       2       1    Low HomeRun Production                                                              */
/*                                                                                                                        */
/*    5    Joseph        4       2    Medium HomeRun Production                                                           */
/*    6    John          5       2    Medium HomeRun Production                                                           */
/*    7    Philip        7       2    Medium HomeRun Production                                                           */
/*    8    Robert        9       2    Medium HomeRun Production                                                           */
/*                                                                                                                        */
/*    9    Roger        12       3    High HomeRun Production                                                             */
/*   10    Ronald       14       3    High HomeRun Production                                                             */
/*   11    Thomas       15       3    High HomeRun Production                                                             */
/*   12    William      22       3    High HomeRun Production                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
