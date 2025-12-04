%let dirclass = C:\Users\NTPU\Downloads;

proc import datafile = "&dirclass\statpack114fclass13.xlsx" 
	out = class13 DBMS = EXCEL replace;
getnames = no;
dbdsopts = "firstobs = 2";  /* 只能在excel 裡面 去做設定 希望他可以不要加上本來的欄位名稱 */
run;
proc format;
value yesnof
0 = '沒有'
1 = '有';
run;
data class13a;
set class13;
if f3 = . then age = floor((f4-f2)/365.25);
else age = floor((f3 - f2)/365.25);
array cvar f11 - f20;
array nvar comb1 - comb10;
do i = 1 to dim(cvar);
	if index(cvar[i], 'N') or cvar[i]=' ' then nvar[i] = 0;
	else if index(cvar[i], 'P') then nvar[i] = 1;
end;
if f5 ^ =  ' ' then status = 1;
else status = 0;
format comb1 - comb10 status yesnof.;
label
f1 = '編號'
f5 = '腫瘤'
f6 = '最低生長賀爾蒙'
f7 = '術前生長賀爾蒙'
f8 = '術後生長賀爾蒙 (1 個月)'
f9 = '術前泌乳激素 (Prolactin)'
f10 = '術後泌乳激素'
comb1 = '高血壓'
comb2 = '糖尿病'
comb3 = '診斷口服葡萄糖耐受'
comb4 = '無月經'
comb5 = '甲狀腺腫大'
comb6 = '溢乳'
comb7 = '骨關節炎'
comb8 = '視覺受損'
comb9 = '冠心病'
comb10 = '頭痛';
run;

proc print data=class13 ( obs= 10 ); run;

proc freq data=class13a;
    tables status comb1-comb10;
run;

/*F7 與 F8 關聯性 ( 線性 )  -- 散步圖*/ 
proc sgplot data = class13a;
	scatter x = f7 y = f8 / 
		markerattrs = ( symbol = circlefilled size = 10 );  /*讓他變大一點*/
	/*設定他要顯示的範圍*/
	xaxis value = ( 0 to 350 by 50 ) valueattrs = (  color = blue size = 20 )
		labelattrs = (  color = blue size = 20);
	yaxis value = ( 0 to 150 by 30 ) valueattrs = (  color = blue size = 20 )
		labelattrs = (  color = blue size = 20);
run;

/*想要跟另一個指標一起看*/
proc sgplot data = class13a;
	scatter x = f7 y = f8 / 
		markerattrs = ( symbol = circlefilled size = 10 ); 
	scatter x = f9 y = f10 / x2axis y2axis
		markerattrs = ( symbol = circle size = 10 ); 
	xaxis value = ( 0 to 350 by 50 ) valueattrs = (  color = blue size = 20 )
		labelattrs = (  color = blue size = 20);
	yaxis value = ( 0 to 150 by 30 ) valueattrs = (  color = blue size = 20 )
		labelattrs = (  color = blue size = 20);
	x2axis value = ( 0 to 120 by 30 ) valueattrs = (  color = blue size = 20 )
		labelattrs = (  color = blue size = 20);
	y2axis value = ( 0 to 150 by 30 ) valueattrs = (  color = blue size = 20 )
		labelattrs = (  color = blue size = 20);
run;

/*想要看狀態與手術後 f8 & f10 的關係*/
proc sgplot data = class13a;
	dot status / response = f8 limits = both
		stat = mean markerattrs= ( symbol = starfilled size = 10 ) /*他會給你一個區間*/
		limitattrs = ( pattern = 3 thickness = 5 )/*換一下他的線*/
;  
run;

ods graphics / attrpriority = none;
/*把它預設先關掉*/
/*如果有group 的話圖形的選項 要不要多設定幾個組別*/

/*group 一下 pattern自己設定*/
proc sgplot data = class13a;
	styleattrs datasymbols = ( starfilled circlefilled )
/* ods graphics / attrpriority = none; 前面一定要有跑這個後面才會改變 */
/*		datalinepatterns = ( solid longdash )*/;
	dot status / response = f8 limits = both
		stat = mean markerattrs= ( symbol = starfilled size = 10 )
		limitattrs = ( thickness = 5 ) 
		group = comb10
;    
run;

/*類別 可以用盒型圖 去呈現*/
proc sgplot data=class13a;
	vbox f8/ group = status;
run;
proc sgplot data=class13a;
	vbox f8/ group = status boxwidth = 0.9;  /*讓盒子變胖一點*/
run;

/*設定vline類別軸*/
/*先看一下年紀的部分*/
proc freq data=class13a;
    tables age;
run;

proc format;
    value agegf
        low - 25 = '<25歲'
        26  - 34 = '26-34歲'
        35 - high = '>35歲';
run;


/*有序的類別變數 與f8及f10的關聯*/
proc sgplot data = class13a;
	vline age/response = f8 stat = mean markers;
	vline age/y2axis response = f10 stat = mean markers ;
	format age agegf.;
	y2axis valueattrs = (  color = blue size = 20 )
		labelattrs = ( color = blue size = 20);
	xaxis  valueattrs = (  size = 10 color = cx39163c ); /*直接打顏色號碼*/
/*	xaxis values =( '<25歲' '26-34' '>35歲' ) ; 這個不這樣 因為她要用標記去改 */
run;

ods graphics / attrpriority = color;
/*給他一個預設的概念*/

/*矩陣散步圖*/
proc sgscatter data = class13a;
	matrix f6 f7 f8/ diagonal = ( histogram );
run;
/*從這個圖形就可以看出來他極度的右偏 所以關聯性會不太準*/
/*最低賀爾蒙就會友一些關係*/
/*以這樣的變數還是建議大家 設定一下*/
/*醫療的資料常常會幫他做對數*/
data class13b;
	set class13a;
	array av f6 - f8;
	array alogv lf6 - lf8;
	do i = 1 to dim (av);
		if av[i] ^ in ( ., 0) then alogv[i] = log( av[i] );  /*不等於遺失跟0才會做這件事情*/
	end;
run;

/*這樣資料就會比較平衡一點*/
proc sgscatter data = class13b;
	matrix lf6 lf7 lf8/ diagonal = ( histogram );
run;

/*分組去看一下 就會有兩個顏色*/
proc sgscatter data = class13b;
	matrix lf6 lf7 lf8/ diagonal = ( histogram ) group = status;
run;

/*中間的括號 就會讓它顯示兩個變數*/
proc sgscatter data = class13b;
	 compare x = ( lf6 lf7 ) y = lf8;
run;

/*compare 跟 plot 差不多 只是說選項會有一點差異*/
proc sgscatter data = class13b;
	 plot ( lf6 lf7 )* lf8;
run;
/*如果不是每一個變數都需要畫散步圖的話 就會用compare或是plot*/

/*劃出來也是矩陣的型式 但他可以設定 每一個圖形的group by 哪一個欄位 然後 需要占比多少 怎麼分配圖形 */
proc sgpanel data = class13b;
	panelby status;
	reg x = lf6 y= lf7 / clm;
	colaxis label = '最低 GH';
	rowaxis label = '術前 GH';
run;

data random;
	unif1 = uniform ( 1 );
	unif3 = uniform ( 123 );
	bin1 = ranbin(1, 20, 0.05 );
	bin2 = ranbin(123, 20, 0.05 );
	norm1 = normal ( 1 ); 
	norm12 = normal ( 123 ); 
run;
proc print data = random; run;

data random1;
	do i = 1 to 50 ;
		unif1 = uniform ( 1 );
		unif3 = uniform ( 123 );
		bin1 = ranbin(1, 20, 0.05 );
		bin2 = ranbin(123, 20, 0.05 );
		norm1 = normal ( 1 ); 
		norm12 = normal ( 123 ); 
		output;  /*必須是要讓他強迫輸出的*/
	end;
run;
proc print data = random1; run;

/*來看看他的分布*/
proc sgplot data = random1;
	vbar bin1;
run;

/*看分佈*/
proc sgplot data = random1;
	histogram norm1;
run;
/*他就會是常態分布*/


proc reg data =  class13b;run;
proc reg data =  class13b;
	model lf8 = lf7;
run;

/*當她有遺失職的時候 我們就用她去設定 再加上一點點誤差*/
/* 有訊息的資料差補*/
data class13c;
	set class13b;
	if lf8 = . then do;
		lf8 = -1.38 + 0.816 * lf7 + normal (111);
	end;
run;
/*因為這裡也大概知道lf8跟7跟6有關聯的*/
proc print data = class13c; run;
/*lf8這樣就把她補好了*/


