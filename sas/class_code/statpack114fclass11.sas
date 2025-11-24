%let dirclass = C:\Users\NTPU\Downloads;
%let dirclass = C:\Users\NTPU\Desktop;
proc import datafile = "&dirclass\statpack114fclass11.xlsx"
	dbms = "EXCEL" out = class11 replace;
getnames = no;
dbdsopts = "firstobs = 2";
run;
data class11a class11b;
set class11;
if index(f4, '02') then output class11a;
else output class11b;
run;
proc freq data = class11b;
table f2 - f6;
run;

proc format;
value $educf
'(03) 國小', '(04) 國中' = '國中及以下'
other = '其他';run;
data class11b_1;
set class11b;
if index(f5, '幾乎天天') then do;
	internet1 = 7;
	if index(f5, '四小時以上') then internet2 = 4;
	else if index(f5, '二小時以上') then internet2 = 3;
	else if index(f5, '未滿二小時') then internet2 = 1;
end;
else if index(f5, '至少') then do;
	internet1 = 2;
end;
else if index(f5, '超過') then do;
	internet1 = 1;
end;
educ1 = put(f3, $educf.); 
if index(f3, '03') | index(f3, '04') then educ2 = '國中及以下';
else educ2 = '其他';
run;
proc freq data = class11b_1; tables f3 f6 educ1 educ2; format f3 $educf.; run;


/*現在的練習主要就是要用程式的方式 去設定複選題*/
data class11b_2;
set class11b_1;
item1 = 0; item2 = 0; item3 = 0; item4 = 0; item5 = 0; item6 = 0; item7 = 0; item8 = 0;
if index(f6, "01") then item1 = 1;
if index(f6, "02") then item2 = 1;
if index(f6, "03") then item3 = 1;
if index(f6, "04") then item4 = 1;
if index(f6, "05") then item5 = 1;
if index(f6, "06") then item6 = 1;
if index(f6, "07") then item7 = 1;
if index(f6, "08") then item8 = 1;
run;
proc freq data = class11b_2;
table item1 - item8;
run;
proc print data = class11b_1 (obs = 10); run;

/*接下來是看起來比較聰明的方法 迴圈的部分*/
data class11b_3;
set class11b_1;
format choice1 - choice8 $2.;
array allchoice choice1 - choice8 ("01" "02" "03" "04" "05" "06" "07" "08");
array allitem item1 - item8;
do i = 1 to  dim(allitem);
	allitem[i] = 0;   /* 初始化 = 0 */
	if index(f6, allchoice[i]) then allitem[i] = 1;  /* index 會回傳布林變數 */
end;
run;
proc print data = class11b_3 (obs = 10); run;

data f6;
infile cards truncover;
input ques $ 1- 80;
id = _n_;
cards;
(01) 桌上型電腦
(02) 筆記型電腦
(03) 平板電腦
(04) 智慧型手機
(05) 智慧電視（Chromecast, Google home, Apple TV
(06) 智慧型穿戴裝置(如 Apple Watch、智慧手錶等)
(07) 智慧家電
(08) 自己沒有，但借別人的資訊設備或公共服務資源(如圖書館)
(97) 其他
(98) 不知道/忘記了/沒意?
(99) 拒答
run;
data f6label;
infile cards truncover; /*字串長度不一 所以我們需要truncover*/
input _label_ $ 1- 80;
format id $80.;
id = put(_n_, 3.); /*_n_ 是一個流水馬 第幾底的觀察直*/
_name_ = compress('cqF' || id); /*  ||  表示要把它們兩個何在一起 希望新產出來的變數就可以直接是這個*/
cards;
桌上型電腦
筆記型電腦
平板電腦
智慧型手機
智慧電視
智慧型穿戴裝置(如 Apple Watch、智慧手錶等)
智慧家電
自己沒有，但借別人的資訊設備或公共服務資源(如圖書館)
其他
不知道/忘記了/沒意?
拒答
run;
proc print data = f6label (obs = 10); run;
/*他本來有11個觀察直 把她轉換成一列*/
proc transpose data = f6label out = tf6label;
var _label_;
run;
proc print data = tf6label (obs = 10); run;

/*可以直接把他們合併 合併會有一點點小技巧!*/
/*他應該是要左右合併 因為變數名稱不一樣*/
/*但是觀察直比數class11b_1應該有92筆資料 可是f6label只有一筆資料*/

data class11b_4;
set class11b_1;
set tf6label;
run;
proc print data = class11b_4 (obs = 10); run;  /* wrong */

data class11b_5;
merge class11b_1 tf6label;
run;
proc print data = class11b_5 (obs = 10); run;  /* wrong */

data class11b_6;
set class11b_1;
if _n_ = 1 then set tf6label;
array allchoice cqF1 - cqF11;
array allitem item1 - item11;
do i = 1 to  dim(allitem);
	allitem[i] = 0;   /* 初始化 = 0 */
	if index(f6, compress(allchoice[i])) then allitem[i] = 1;  /* index 會回傳布林變數 */
end;
run;
proc print data = class11b_6 (obs = 10); run;

/* character -- defult: display */
proc report data = class11b_6;
column f2 f3;
define f2/group '工作';
define f3/group '教育程度';
run;

/* 數值型 -- defult: analysis */
proc report data = class11b_6;
column item1 item2;
define item1/group '桌上型電腦';
define item2/group '筆記型電腦';
run;

proc report data = class11b_6;
column f2 f3 ('上網頻率' internet1 internet1 = mean_internet1);
define f2/ group '工作';
define f3/ group '教育程度';  /* 沒有across的都會在列 */
define internet1/ n '填答人數';
define mean_internet1/ mean '平均值';
run;

proc report data = class11b_6;
column f3 f2, ('上網頻率' internet1 internet1 = mean_internet1);
define f3/ group '教育程度';
define f2/ across '工作';  /* across的會在欄分層 */
define internet1/ n '填答人數';
define mean_internet1/ mean '平均值';
run;

proc freq data = class11b_6;
    table f2 f3 f5;
    ods output onewayfreqs = freqs;
    label
        f2 = '工作'
        f3 = '教育程度'
        f5 = '上網頻率';
run;
proc print data = freqs; 
run;

/*這樣會很佔空間 所以多半會整理一下*/
data freqs_1;
	set freqs;
	var = scan( table, 2 );
	f2label = vlabel( f2 );
	varlabel = vlabelx( var );
	f2value = vvalue( f2 );
	varvalue = vvaluex( var );
	varorder = input( compress( var, 'F' ), 8. );
run;

proc print data = freqs_1; run;

proc report data = freqs_1;
column varlabel varvalue frequency percent;
define varlabel/group '變數';
define varvalue/group '類別';
define frequency/analysis '人數' format = 5;
define percent/group '百分比' format = 5.2;
run;
proc print data = freqs_1; run;

data freqs_2;
	set freqs;
	var = scan( table, 2 );
	f2label = vlabel( f2 );
	varlabel = vlabelx( var );
	f2value = vvalue( f2 );
	varvalue = vvaluex( var );
	varorder = input( compress( var, 'F' ), 8. );
run;

proc print data = freqs_2; run;

proc report data = freqs_2;
column varorder varlabel varvalue frequency percent;
define varorder/group noprint;
define varlabel/group '變數';
define varvalue/group '類別';
define frequency/analysis '人數' format = 5;
define percent/group '百分比' format = 5.2;
run;
proc print data = freqs_2; run;

/*針對連續型的作分析*/
proc means data = class11b_6 stakods;
	var internet1 internet2;
	ods output summary = class11_sum;
run;
proc print data = class11_sum; run;
/*他是一個橫向的資料 但這個資料是不好整理的!*/
/*所以通常會加上 stakods 就會變成有推疊的輸出*/

