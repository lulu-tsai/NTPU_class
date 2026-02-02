%let class15 = C:\Users\NTPU\Downloads;
proc format;
value x2f
1=男
2=女;
value x4f
1=正常
2=稍大
3=過大;
value x5f
1=重
2=適中
3=輕
4=不知道;
value  x6f
1=木頭
2=鋁
3=玻璃纖維
4=石墨
5=鋼
6=合成
7=其他;
value x7f
1=尼龍線
2=腸線
3=不知道;
value yf
0=沒有
1=有;
run;
data class15a;
infile "&class15\statpackch7d3.txt";
input id x1 - x11;
y = (x3>1); /*讓他>1才都有網球肘次數*/
if x5 = 4 then x5 = .;
if x7 = 9 then x7 = .;
if x4 = 9 then x4 = .;
if x8 = 9 then x8 = .;
if x9 = 4 then x9 = .;
nmiss = nmiss(of x1 - x11);
label
id = '編號'
x1 =  '年齡 (年為單位)'
x2 = '性別' 
x3 = '網球肘次數'
x4 = '前一次使用球拍種類' 
x5 = '前一次使用球拍重量'
x6 = '前一次使用球拍材質'
x7 = '前一次使用球拍線的種類'
x8 = '這一次使用球拍種類' 
x9 = '這一次使用球拍重量'
x10 = '這一次使用球拍材質'
x11 = '這一次使用球拍線的種類';
format x2 x2f. x4 x8 x4f. x5 x9 x5f. x6 x10 x6f. x7 x11 x7f. y yf.;
run;
proc print data = class15a label;
	where nmiss > 0;
run;
proc freq data = class15a;
tables x1-x11;
run;
/*比例是4成看看有沒有一樣*/
/*比例檢定的部分*/
proc freq data = class15a;
tables y / binomial ( p = 0.4 );
run;
proc freq data = class15a;
tables y / testsp = (0.6, 0.4);
run;
/*檢視的是y=0的機率*/
/* y = 0  → 0.6  y = 1  → 0.4 */

/*卡方檢定*/
proc freq data = class15a;
tables x2*y/ chisq;
run;
/*0.3974 看起來是不顯著的*/
/*連續性調整卡方 他會修正連續的部分*/
/*格式是為了我們應該要整理每一個二維的列連表 都會是大的表格+統計值*/

/*這個表其實只會用到 卡方的機率 最多用到概度比卡方 的機率*/
/*所以要去整理他*/
proc freq data = class15a;
tables x2*y/ chisq;
ods output crosstabfreqs = ct_freqs
				  chisq = ct_chisq;
run;
proc print data = ct_freqs;
run;
proc print data = ct_chisq;
run;

data ct_freqs1;
	set ct_freqs;
	xvar = scan(table, 2);
	yvar = scan(table, 3);
	xvarvalue = vvaluex(xvar);
	xvarlabel = vlabelx(xvar);
	yvarvalue = vvaluex(yvar);
	yvarlabel = vlabelx(yvar);
	if _type_ in ('11');  /*細格的資訊*/
run;

/*整理成漂亮的表格!!!!*/
proc report data = ct_freqs1;
    column xvarlabel xvarvalue yvarvalue, (frequency rowpercent);
    define xvarlabel / group '變數';
    define xvarvalue / group '類別';
    define yvarvalue / across '網球肘';
    define frequency / analysis format=5. '人數';
    define rowpercent / analysis format=5.2 '百分比';
run;

/*有女男*/
/*比剛剛多出總計*/
data ct_freqs2;
	set ct_freqs;
	xvar = scan(table, 2);
	yvar = scan(table, 3);
	xvarvalue = vvaluex(xvar);
	xvarlabel = vlabelx(xvar);
	yvarvalue = vvaluex(yvar);
	yvarlabel = vlabelx(yvar);
	if _type_ in ('11' '10');  /*列邊際*/
	/*把邊際的persent copy 到 rowpercent */
	if _type_ in ('10') then do;
		yvarvalue =  '總計';
		rowpercent = percent;
	end;
run;

/*整理成漂亮的表格!!!!*/
proc report data = ct_freqs2;
    column xvarlabel xvarvalue yvarvalue, (frequency rowpercent);
    define xvarlabel / group '變數';
    define xvarvalue / group '類別';
    define yvarvalue / across '網球肘';
    define frequency / analysis format=5. '人數';
    define rowpercent / analysis format=5.2 '百分比';
run;

/*還要提供 他有沒有顯著 的結果*/
proc print data = ct_chisq;
run;
/*在這裡面我們只需要Statistic=卡方的資訊*/
/*為了後續可整併 需要 	xvar = scan(table, 2) yvar = scan(table, 3);*/
data ct_chisq1;
	set ct_chisq;
	xvar = scan(table, 2);
	yvar = scan(table, 3);
if statistic = '卡方';
	keep xvar yvar value prob;
run;

/*接下來要合併ct_freqs2 為了等等先讓他排序*/
proc sort data  = ct_chisq1;
by xvar yvar;
proc sort data  = ct_freqs2;
by xvar yvar;
data ct_freq_chisq;
	merge ct_freqs2 ct_chisq1;
	by xvar yvar;
	if first.xvar then pvalue = prob;
run;

proc report data = ct_freq_chisq;
    column xvarlabel xvarvalue yvarvalue, (frequency rowpercent) prob;
    define xvarlabel / group '變數';
    define xvarvalue / group '類別';
    define yvarvalue / across '網球肘';
    define frequency / analysis format=5. '人數';
    define rowpercent / analysis format=5.2 '百分比';
    define prob / analysis format=pvalue5.3 'P';  /*pvalue5.3 這是一個格式 他就會有一個<0.001的呈現方式*/
run;

/*要第一次出現才要有pvalue*/
data ct_freq_chisq;
	merge ct_freqs2 ct_chisq1;
	by xvar yvar;
	if first.xvar then pvalue = prob;
run;
proc report data = ct_freq_chisq;
    column xvarlabel xvarvalue yvarvalue, (frequency rowpercent) pvalue;
    define xvarlabel / group '變數';
    define xvarvalue / group '類別' order = data; /*他在下面 為了要讓他上去*/
    define yvarvalue / across '網球肘';
    define frequency / analysis format=5. '人數';
    define rowpercent / analysis format=5.2 '百分比';
    define pvalue / analysis format=pvalue5.3 'P';  /*pvalue5.3 這是一個格式 他就會有一個<0.001的呈現方式*/
run;

/*多加上了幾個變數~~*/
proc freq data = class15a;
tables ( x2 x8 x9 x11 )*y/ chisq;
ods output crosstabfreqs = ct_freqs
				  chisq = ct_chisq;
run;
/*結果都不顯著*/
/*現在就有四個變數了*/
/*把剛剛地都在複製下來一下~*/
data ct_freqs2;
	set ct_freqs;
	xvar = scan(table, 2);
	yvar = scan(table, 3);
	xvarvalue = vvaluex(xvar);
	xvarlabel = vlabelx(xvar);
	yvarvalue = vvaluex(yvar);
	yvarlabel = vlabelx(yvar);
	if _type_ in ('11' '10');  /*列邊際*/
	/*把邊際的persent copy 到 rowpercent */
	if _type_ in ('10') then do;
		yvarvalue =  '總計';
		rowpercent = percent;
	end;
run;
data ct_chisq1;
	set ct_chisq;
	xvar = scan(table, 2);
	yvar = scan(table, 3);
if statistic = '卡方';
	keep xvar yvar value prob;
run;
proc sort data  = ct_chisq1;
by xvar yvar;
proc sort data  = ct_freqs2;
by xvar yvar;
data ct_freq_chisq;
	merge ct_freqs2 ct_chisq1;
	by xvar yvar;
	if first.xvar then pvalue = prob;
run;
proc report data = ct_freq_chisq;
    column xvarlabel xvarvalue yvarvalue, (frequency rowpercent) pvalue;
    define xvarlabel / group '變數';
    define xvarvalue / group '類別' order = data; /*他在下面 為了要讓他上去*/
    define yvarvalue / across '網球肘';
    define frequency / analysis format = 5. '人數';
    define rowpercent / analysis format = 5.2 '百分比';
    define pvalue / analysis format = pvalue5.3 'P';  /*pvalue5.3 這是一個格式 他就會有一個<0.001的呈現方式*/
run;
/*就會出現該有結果了!*/
/*都沒有改就可以出現我想要的結果了*/
/*所以可以記錄下來!! 這個程式碼~~*/

/*作業的部分 有稍微帶到?*/
proc format;
   value $sctrfmt 'se' = 'Southeast'
                  'ne' = 'Northeast'
                  'nw' = 'Northwest'
                  'sw' = 'Southwest';

   value $mgrfmt '1' = 'Smith'   '2' = 'Jones'
                 '3' = 'Reveiz'  '4' = 'Brown'
                 '5' = 'Taylor'  '6' = 'Adams'
                 '7' = 'Alomar'  '8' = 'Andrews'
                 '9' = 'Pelfrey';

   value $deptfmt 'np1' = 'Paper'
                  'np2' = 'Canned'
                  'p1'  = 'Meat/Dairy'
                  'p2'  = 'Produce';
run;
data class15b;
   input Sector $ Manager $ Department $ Sales @@;
   datalines;
se 1 np1 50    se 1 p1 100   se 1 np2 120   se 1 p2 80
se 2 np1 40    se 2 p1 300   se 2 np2 220   se 2 p2 70
nw 3 np1 60    nw 3 p1 600   nw 3 np2 420   nw 3 p2 30
nw 4 np1 45    nw 4 p1 250   nw 4 np2 230   nw 4 p2 73
nw 9 np1 45    nw 9 p1 205   nw 9 np2 420   nw 9 p2 76
sw 5 np1 53    sw 5 p1 130   sw 5 np2 120   sw 5 p2 50
sw 6 np1 40    sw 6 p1 350   sw 6 np2 225   sw 6 p2 80
ne 7 np1 90    ne 7 p1 190   ne 7 np2 420   ne 7 p2 86
ne 8 np1 200   ne 8 p1 300   ne 8 np2 420   ne 8 p2 125
;

proc report data=class15b split='*' out = outtable; /*把它輸出了*/
column sector manager department, sales;
define sector / group format=$sctrfmt. 'Sector';
define manager / group format=$mgrfmt. 'Manager*';
define department / across format=$deptfmt. 'Department';
define sales / analysis sum format=dollar11.2 ' ';	
run;
proc print data = outtable;
run;
proc report data=class15b split='*';
column sector manager department, sales perish;
define sector / group format=$sctrfmt. 'Sector';
define manager / group format=$mgrfmt. 'Manager*';
define department / across format=$deptfmt. 'Department';
define sales / analysis sum format=dollar11.2 ' ';	

/*computed 新計算一個變數 */
/*增加這個 會腐爛的東西 希望可以把這兩個欄位的銷售金額累加*/
define perish/ computed format=dollar11.2 'Perishable';  
compute perish;
	perish = _c3_ + _c4_;
endcomp;

run;


proc report data=class15b nowd
style(report)=[cellspacing=5 borderwidth=10 bordercolor=blue]
style(header)=[foreground=grey font_face=lucida font_style=italic font_size=6]
style(column)=[foreground=moderate brown font_face=helvetica font_size=4]
style(lines)=[foreground=white background=black font_face=lucida font_style=italic font_weight=bold font_size=5]
style(summary)=[foreground=cx3e3d73 background=cxaeadd9 font_face=helvetica font_size=3 just=r];
column manager department sales;
define manager /group order=formatted 
	 format=$mgrfmt. 'Manager';
define department /group order=internal format=
	$deptfmt. 'Department';
/* 每一個manager 後面 會sub total 這個 銷售的總金額 會分割 然後再給一個總金額的sum */
break after manager / summarize; /*manager 之後摘要*/
compute after manager; 
  line 'Subtotal for ' manager $mgrfmt. 'is ' 
       sales.sum dollar7.2 '.';
endcomp;
compute after; 
  line 'Total for all departments is:'  
        sales.sum dollar7.2 '.';
endcomp;
run;
/*這個結果真的長得很漂亮~~*/
