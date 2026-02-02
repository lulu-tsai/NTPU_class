*%let dirclass = C:\Users\hwang\Dropbox\School\statpack\114fall\chapter8;
%let dirclass = C:\Users\NTPU\Downloads;

/*聚集變數可以放的東西：一串文字一串數字 浮動的重複使用的一個資料*/

%let filename = statpackch8_1.xls;
%let outname = class16d1;
%let sn = sheet 1;
%let outname1 = class16d1b;
%let sn1 = sheet 2;

proc import datafile = "&dirclass\&filename"
	out = &outname replace DBMS = EXCEL;
getnames = yes;
sheet = "&sn";
run;

proc import datafile = "&dirclass\&filename"
	out = &outname1 replace DBMS = EXCEL;
getnames = yes;
sheet = "&sn1";
run;

/*所以他今天想要交的就是 重複處理一個資料 可以不要一職打一樣的程式碼*/
/*所以他就要開始教學 聚集ㄌ*/
/*希望不要開頭是 AF DMS SQL SYS*/
/*大小寫是一樣的*/
/*引用巨集變數要是雙引號!!!*/

/*感覺有點像是function的感覺嗎*/
/*這裡一共有三個一變動的部分*/
%macro readfile(fn, outf, sn);
/*fn：檔案名稱*/
/*outf：輸出檔案名稱*/
/*sn：表單*/
	proc import datafile = "&dirclass\&fn"
		out = &outf replace DBMS = EXCEL;
	getnames = yes;
	sheet = "&sn";
	run;
%mend readfile;

/*去執行這個指令*/
%readfile(statpackch8_1.xls, class16_1a, sheet 1);
%readfile(statpackch8_1.xls, class16_1b, sheet 2);
%readfile(statpackch8_1.xls, class16_1c, sheet 3);
/*這樣寫起來就可以比較整齊很多*/

%readfile(statpackch8_2.xls, class16_2a, sheet 1);
%readfile(statpackch8_2.xls, class16_2b, sheet 2);
%readfile(statpackch8_2.xls, class16_2c, sheet 3);


/*要怎麼樣去用這個指令*/
/*因為變動的只有檔案名稱後面的數字*/
%macro readfile1(nb, outf, sn);
/*fn：檔案名稱*/
/*outf：輸出檔案名稱*/
/*sn：表單*/
	proc import datafile = "&dirclass\statpackch8_&nb..xls"  /*設定輸入檔案的數目*/
/*.xls 也是想要固定的 所以我只要多一個.就可以知道 只有.前面是變動的*/
		out = class16_&outf replace DBMS = EXCEL;
	getnames = yes;
	sheet = "sheet &sn";
	run;
%mend readfile1;
%readfile1(3, 3a, 1);
%readfile1(3, 3b, 2);
%readfile1(3, 3c, 3);

%readfile1(4, 4a, 1);
%readfile1(4, 4b, 2);
%readfile1(4, 4c, 3);

%readfile1(5, 5a, 1);
%readfile1(5, 5b, 2);
%readfile1(5, 5c, 3);

/*就是簡單的巨集 !*/
data allfile1;
set class16_1a class16_1b class16_1c;
run;

/*一次匯入所有*/
data allfile;
set class16_:;
/*: 表示納入所有檔案名以class16_為首的*/
run;

/*看一下他的欄位名稱*/
proc print data = allfile (obs=1);
run;
/*freq*/
proc freq data = allfile;
	table dept_no;
run;

/*所以我們也可以用巨集*/
%macro freqtb1(varlist);
	proc freq data = allfile;
		table &varlist;
	run;
%mend freqtb1;
%freqtb1(dept_no);
/*除了設定檔案名稱 也可以設定變數名稱*/
%freqtb1(vs_item vs_type); 
/*因為她的table後面可以放兩個變數的!*/

/*在修改一下~~ 多加上輸出名稱!!*/
%macro freqtb11(inname, varlist, outn);
	proc freq data = &inname;
		table &varlist;
		ods output onewayfreqs = &outn;
	run;
%mend freqtb11;
%freqtb11(allfile, vs_item vs_type, vs_freq); 
proc print data = vs_freq; run;


data vs_freq1;
	set vs_freq;
	xvar = scan( table, 2 );   /*表格的變數名稱*/
	xvarvalue = vvaluex(xvar);
run;
proc print data = vs_freq1; run;

/*敘述性統計 又會是這樣 清楚的表格*/
proc report data = vs_freq1;
	column xvar xvarvalue frequency percent;
	define xvar/group '變數';
	define xvarvalue/group '類別';
	define frequency/group '人數' format = 8.;
	define percent/group '%' format = 5.2;
run;
/*敘述性統計不太會跟別的變數做交叉 就是簡簡單單的這樣*/

/*這個就把資料擷取好變數數值 等等就可以直接用proc report*/
%macro freqtb12(inname, varlist, outn);
	proc freq data = &inname;
		table &varlist;
		ods output onewayfreqs = freq_table;
	run;
	data &outn;
		set freq_table;
		xvar = scan( table, 2 );   /*表格的變數名稱*/
		xvarvalue = vvaluex(xvar);
	run;
%mend freqtb12;
/*加上輸出之後的*/
%freqtb12(allfile, vs_item vs_type, vs_freq3)

/*一樣的輸出!*/
proc report data = vs_freq3;
	column xvar xvarvalue frequency percent;
	define xvar/group '變數';
	define xvarvalue/group '類別';
	define frequency/group '人數' format = 8.;
	define percent/group '%' format = 5.2;
	/*就會有表頭*/
	compute before _page_;
		line @1 "表1：敘述性統計";
	endcomp;
run;

/*再把剛剛的東西放進去*/
%macro report_freq(inname, mtitle);
	proc report data = &inname;
		column xvar xvarvalue frequency percent;
		define xvar/group '變數';
		define xvarvalue/group '類別';
		define frequency/group '人數' format = 8.;
		define percent/group '%' format = 5.2;
		/*就會有表頭*/
		compute before _page_;
			line @1 "&mtitle";
		endcomp;
	run;
%mend report_freq;
%report_freq(vs_freq3, 表1：敘述性統計);
/*老師說她多半會先測試再把它包裝進去一個巨集*/
/*會變得只有dataset跟你的title*/


libname ch7 "C:\Users\NTPU\Downloads\Chapter7";
data ch7d1;
set ch7.statpackch7d1;
run;
proc print data = ch7d1(obs = 10); run;

proc means data = ch7d1;
	var Invoice EngineSize MPG_City MPG_Highway Weight Length;
	/*這兩個的結果 一模一樣*/
	ods output summary = mean_cont;   /*新*/
	output out = mean_cont1;
run;
/*兩個長的不一樣*/
proc print data = mean_cont1; run;
proc print data = mean_cont; run;

proc means data = ch7d1 stackods;
	var Invoice EngineSize MPG_City MPG_Highway Weight Length;
	ods output summary = mean_cont2;
run;
proc print data = mean_cont2; run;
/*這個輸出 會比較像是平常的敘述性統計*/

proc report data = mean_cont2 missing;
	column variable label mean stddev;
	define variable/ group '變數';
	define label/ group '標籤';
	define mean/ analysis '平均值' format = 5.2;
	define stddev/ analysis  '標準差' format = 5.2;
run;

proc means data = ch7d1 stackods;
	class origin;   /*分層變數 來源國*/
	var Invoice EngineSize MPG_City MPG_Highway Weight Length;
	ods output summary = mean_cont3;
run;
proc print data = mean_cont3; run;
proc report data = mean_cont3 missing;
	column variable label origin, ( mean stddev );
	define variable/ group '變數';
	define label/ group '標籤';
	define origin/ across '來源國';
	define mean/ analysis '平均值' format = 5.2;
	define stddev/ analysis  '標準差' format = 5.2;
	compute before _page_;
		line @1 "表2：連續變數的敘述統計";
	endcomp;
run;
/*組別會在上面 列的部分會是變數 上面會放平均值標準差*/

%macro meantbl(inname, varlist, outn);
	proc means data = &inname stackods;
		class origin;   /*分層變數 來源國*/
		var &varlist;
		ods output summary = mean_&outn;
	run;
%mend meantbl;
%meantbl(ch7d1, 
				Invoice EngineSize MPG_City MPG_Highway Weight Length, 
				cont4);

/*二維分析*/
/*有組別變數的 敘述性統計*/
%macro report_mean(inname, gpvar, gpvarlabel, mtitle);
	proc report data = mean_cont3 missing;
		column variable label &gpvar, ( mean stddev );
		define variable/ group '變數';
		define label/ group '標籤';
		define origin/ across "&gpvarlabel";
		define mean/ analysis '平均值' format = 5.2;
		define stddev/ analysis  '標準差' format = 5.2;
		compute before _page_;
			line @1 "&mtitle";
		endcomp;
	run;
%mend report_mean;
%report_mean(
	mean_cont4, 
	origin,
	來源國, 
	表2：區分來源國的連續變數敘述統計);

/*put：想要知道巨集變數儲存的內容為何*/
%put &sn;
run;
/*會出現在log裡面*/


/*練習 do */
%readfile1(1, 1a, 1);
%readfile1(1, 1b, 2);
%readfile1(1, 1c, 3);

%readfile1(2, 2a, 1);
%readfile1(2, 2b, 2);
%readfile1(2, 2c, 3);

%readfile1(3, 3a, 1);
%readfile1(3, 3b, 2);
%readfile1(3, 3c, 3);

%readfile1(4, 4a, 1);
%readfile1(4, 4b, 2);
%readfile1(4, 4c, 3);

%readfile1(5, 5a, 1);
%readfile1(5, 5b, 2);
%readfile1(5, 5c, 3);

/*檔名變成是 1-1 1-2 1-3*/
%macro manyfile(counter);
	%do i  = 1 %to &counter;
		%readfile1(1, 1_&i, &i)
	%end;
%mend manyfile;
%manyfile(3);

/*因為還有檔案希望可以自定義的*/
%macro manyfile1(infile, counter);
	%do i  = 1 %to &counter;
		%readfile1(&infile, &infile._&i, &i)  /*因為有兩個巨集變數所以中間要有一個.*/
	%end;
%mend manyfile1;
%manyfile1(2, 3);
/*就會出現2-1 2-2 2-3*/
/*do 跟 end 一定要在巨集底下才能使用*/
/*put 跟 let 不一定需要再巨集的環境下就可以使用*/

/*這次有五個資料 我們可以把它們全部弄好*/
%macro allfile;
	%do fn  = 1 %to 5;  /*檔案名稱*/
		%do sn  = 1 %to 3;  /*sheet 名稱*/
			%readfile1(&fn, &fn._&sn, &sn) 
		%end;
	%end;
%mend allfile;
%allfile;
/*這裡沒有讓她浮動 因為他就是by case*/
