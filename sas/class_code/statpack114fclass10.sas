*libname class10 "c:\users\hwang\dropbox\school\statpack\114fall\practice";
*%let dirclass = C:\Users\NTPU\Desktop\;
libname class10 "C:\Users\NTPU\Desktop";
proc print data = class10.statpack114fclass10a (obs= 10); run;
proc print data = class10.statpack114fclass10b (obs= 10); run;
proc print data = class10.statpack114fclass10c (obs= 10); run;

proc format;
value trtf
1 = 'AZ'
2 = 'AZ+MP';
value pretrtf
0 = '沒有'
1 = '有';
run;

proc sort data = class10.statpack114fclass10a;
by id;
run;
proc sort data = class10.statpack114fclass10b;
by id;
run;
proc sort data = class10.statpack114fclass10c;
by id;
run;
data class10a;
merge  class10.statpack114fclass10a (in=one)
	class10.statpack114fclass10b (in = two);
by id;
if one = 1 & two =1 then flag = 1;
else flag = 0;
format trt trtf. pretrt pretrtf.;
label 
id = '編號'
trt = '組別'
pretrt = '前期治療'
age = '年紀'
time = '測量時間';
run;
proc freq data = class10a; table flag; run;
proc print data = class10a (obs = 10); run;

data class10b;
merge class10.statpack114fclass10a  class10.statpack114fclass10c;
by id;
format trt trtf. pretrt pretrtf.;
label 
id = '編號'
trt = '組別'
pretrt = '前期治療'
age = '年紀'
acfr_0 = 'ACFR 基準時間'
acfr_3 = 'ACFR 第 3 個月'
acfr_6 = 'ACFR 第 6 個月'
acfr_9 = 'ACFR 第 9 個月'
acfr_12 = 'ACFR 第 12 個月'
acfr_15 = 'ACFR 第 15 個月'
acfr_18 = 'ACFR 第 18 個月';
run;

proc report data = class10b;
column id trt pretrt age;
define id/ display "編號";
define trt/ display "組別";
define pretrt/ display "前期治療";
define age/ display "年齡";
run;

proc report data = class10b;
column trt age;
define trt/ group "組別";
define age/ analysis "年齡" mean; /* defult: sum */
run;

proc report data = class10b;
column trt pretrt age;
define trt/ group "組別" format = trtf.;
define pretrt/ group "前期治療" format = pretrtf.;  /* defult order = format */
define age/ analysis "年齡" mean format = 5.2; /* defult: sum */
run;

proc report data = class10b;
column trt pretrt age;
define trt/ group "組別" format = trtf.;
define pretrt/ group "前期治療" format = pretrtf. order = internal;  /* order: 原始數值（0: 沒有; 1: 有） */
define age/ analysis "年齡" mean format = 5.2; /* defult: sum */
run;

/* 組別 時間 ACFR平均值 */
proc report data = class10a;
column trt time acfr;
define trt/ group "組別";
define time/ group "時間";
define acfr/ mean "ACFR" format = 5.2;
run;

proc report data = class10a;
column trt time acfr = acfr_1 acfr = acfr_2 acfr = acfr_3;
define trt/ group "組別";
define time/ group "時間";
define acfr_1/ mean "ACFR平均值" format = 5.2;
define acfr_2/ std "ACFR標準差" format = 5.2;
define acfr_3/ n "人數";
run;

proc report data = class10a out = out;
column trt time ("ACFR" acfr = acfr_1 acfr = acfr_2 acfr = acfr_3);
define trt/ group "組別";
define time/ group "時間";
define acfr_1/ mean "ACFR平均值" format = 5.2;
define acfr_2/ std "ACFR標準差" format = 5.2;
define acfr_3/ n "人數";
run;

proc report data = class10b;
column trt pretrt;
define trt/ group "組別" format = trtf.;
define pretrt/ group "前期治療" format = pretrtf.;  /* no analysis */
run;

proc report data = class10b;
column trt pretrt;
define trt/ group "組別" format = trtf.;
define pretrt/ across "前期治療"  format = pretrtf.; /* 這個的值是加總 */
run;

proc report data = class10b;
column trt pretrt, (acfr_0);   /* , 必須跟著acroos的變數 */
define trt/ group "組別" format = trtf.;
define pretrt/ across "前期治療"  format = pretrtf.; /* 這個的值是加總 */
define acfr_0/ mean "ACFR" format = 5.2;
run;

proc report data = class10b;
column trt pretrt, ("ACFR0" acfr_0 = mean_0  acfr_0  = std_0 acfr_0 = n_0) ;   /* , 必須跟著acroos的變數 */
define trt/ group "組別" format = trtf.;
define pretrt/ across "前期治療"  format = pretrtf.; /* 這個的值是加總 */
define mean_0/ mean "ACFR0平均值" format = 5.2;
define std_0/ mean "ACFR0標準差" format = 5.2;
define n_0/ n "ACFR0人數" format = 5.;
run;

proc report data = class10b;
column trt pretrt, ("ACFR0" acfr_0 = mean_0  acfr_0  = std_0) acfr_0 = n_0;   /* , 必須跟著acroos的變數 */
define trt/ group "組別" format = trtf.;
define pretrt/ across "前期治療"  format = pretrtf.; /* 這個的值是加總 */
define mean_0/ mean "ACFR0平均值" format = 5.2;
define std_0/ mean "ACFR0標準差" format = 5.2;
define n_0/ n "ACFR0人數" format = 5.;
run;

proc print data = class10a(obs = 10);  run;

proc report data = class10a;
column time trt, ("ACFR" acfr = acfr_mean acfr = acfr_dev) ACFR = n_0;
define time/ group "時間";
define trt/ across "治療分組";
define acfr_mean/ mean "平均值" format = 5.2;
define acfr_dev/ std "標準差" format = 5.2;
define n_0/ n "人數" format = 5.;
run;

proc report data = class10a;
column pretrt time trt, ("ACFR" acfr = acfr_mean acfr = acfr_std) acfr = acfr_n;
define pretrt/ group "前期治療";
define time/ group "時間";
define trt/ across "治療分組" format = trtf.;
define acfr_mean/ mean "平均值" format = 5.2;
define acfr_std/ std "標準差" format = 5.2;
define acfr_n/ n "人數" format = 5.;
run;

proc report data = class10a;
column time trt, (pretrt, ("ACFR" acfr = acfr_mean acfr = acfr_std)) acfr = acfr_n;
define time/ group "時間";
define trt/ across "治療分組" format = trtf.;
define pretrt/ across "前期治療" format = pretrtf.;
define acfr_mean/ mean "平均值" format = 5.2;
define acfr_std/ std "標準差" format = 5.2;
define acfr_n/ n "人數" format = 5.;
run;

proc report data = class10b;
column pretrt trt ("年齡" age = age_mean age = age_std) ("ACFR基期"acfr_0 = acfr_0_mean acfr_0 = acfr_0_std);
define pretrt/ group "前期治療" format = pretrtf.;
define trt/ group "治療分組" format = trtf.;
define age_mean/ mean "平均值" format = 5.1; 
define age_std/ std "標準差" format = 5.1; 
define acfr_0_mean/ mean "平均值" format = 5.2;
define acfr_0_std/ std "標準差" format = 5.2;
run;

