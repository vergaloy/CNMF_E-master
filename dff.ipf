#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
// ================================================================================
//********************************************************************************

//MAIN FUNCTION: batch analysis of all mice in a group

function getall_batch()
	make/o/n=(1,16) Results=nan
	make/o/n=(1,16) Results1=nan
	make/o/n=(1,16) Results2=nan
	make/o/n=(1,16) Results3=nan

	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		NVAR ts = tshift
		NVAR saf = sf
		getall(ts,saf,cdf2+"Results",1,1)	
	endfor
	
	setdatafolder $cdf2
	DeletePoints 0,1, Results
	DeletePoints 0,1, Results1
	DeletePoints 0,1, Results2
	DeletePoints 0,1, Results3
	delete_cells_with_0_Ca_transients()
end

// ================================================================================
//********************************************************************************

// This is the code to run the complete analysis/ Tshift is the time shift between the Ca+2 recording
//and the EEG recording. Usually is 10 seconds.  sf is the sampling frequency.ignore M and RW can be done.
function getall(tshift,sf,results,ignoreM,ignoreRW)
	variable tshift,sf,ignoreM,ignoreRW
	string results
	string folder=GetDataFolder(1)
	variable plot=1 // set as 0 to avoid creating plots
	setdatafolder folder+"data:C:"
	find_peaks(folder)
	string list=wavelist("wave"+"*",",","")
	variable k=itemsinlist(list, ",")
	sleep_plot((k*2)+2,tshift,sf,folder)//  here is very important to look in the shift between EEG and Ca recording!!! 
	wave WAKE,REMWAKE,M
	if (ignoreM==1)
		WAKE=WAKE+M
		M=0
	endif
	if (ignoreRW==1)
		WAKE=WAKE+REMWAKE
		REMWAKE=0
	endif
	if (plot==1)
		Display /W=(405.75,291.5,1121.25,587)/K=1  ::Sleep:REM,::Sleep:WAKE,::Sleep:NREM,::Sleep:REMWAKE
		setdatafolder folder+"data:C_raw:"
		creategraphs("wave",0)
		setdatafolder folder+"data:S:"
		creategraphs2("wave",0)	
		setdatafolder folder+"data:sleep:"
		Legend/C/N=text0/J/F=0/A=MC/X=30.47/Y=-62.46 "\\s(REM) REM \\s(WAKE) WAKE \\s(NREM) NREM"
		ModifyGraph mode(REM)=7,mode(WAKE)=7,mode(NREM)=7,mode(REMWAKE)=7
		ModifyGraph hbFill(REM)=2,hbFill(WAKE)=2,hbFill(NREM)=2,hbFill(REMWAKE)=2
		ModifyGraph rgb(REM)=(65535,49151,49151),rgb(WAKE)=(49151,65535,49151),rgb(NREM)=(49151,60031,65535),rgb(REMWAKE)=(26205,52428,1)
		ModifyGraph prescaleExp(bottom)=0
		ModifyGraph highTrip(bottom)=100000
		Label bottom "Time (s)"
		ModifyGraph noLabel(left)=2

	endif
	//print "hour 1"
	get_stats2(sf,0,3600,folder,results+"1")
	//print "hour 2"
	get_stats2(sf,3600,3600*2,folder,results+"2")
	//print "hour 3"
	get_stats2(sf,3600*2,3600*3,folder,results+"3")
	get_stats2(sf,0,3600*3,folder,results)
	
	
	//concatenated_sleep(sf)
	//getiei(sf)
	//raster_within_episodes()
	//raster_within_episodes_not_scaled()
	
end

//========================================

function delete_cells_with_0_Ca_transients()
	wave results,results1,results2,results3
	variable n=DimSize(results,0),i
	for (i=0;i<n;i+=1)
		variable t=results[i][0]+results[i][4]+results[i][8]+results[i][12]
		if (t==0)
			DeletePoints i,1, Results
			DeletePoints i,1, Results1
			DeletePoints i,1, Results2
			DeletePoints i,1, Results3
			i=i-1
			n=n-1
		endif
	endfor
end

//========================================

function find_peaks(folder)
	string folder
	string list=wavelist("wave*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l
	make/o/n=(k) SDev
	
	for (i=0;i<k;i+=1)	
	
		string temp_w=stringfromlist(i,list,",")
		Wave w=$temp_w		// peak data 
		duplicate/o w test
		smooth 20, test // this avoidedetecting spikes inside Ca+2 events.  
		variable maxPeaks=1000000,threshold=0.001
		Make/O/N=(maxPeaks) peakPositionsX= NaN, peakPositionsY= NaN    
		Variable peaksFound=0
		Variable startP=0
		Variable endP= DimSize(w,0)-1
		variable not_event,control1=0,control2=0,control3=0,control4=0
		duplicate/o w noise
		wave c1=$folder+"data:C_raw:"+stringfromlist(i,list,","),c2=$folder+"data:C:"+stringfromlist(i,list,",")
		noise=c1-c2
		smooth 5, noise
		wavestats/Q noise
		SDev[i]=V_sdev
		
		variable switch1=0
		do
			not_event=0
			FindPeak/P/M=(threshold)/Q/R=[startP,endP] test
			// FindPeak outputs are V_Flag, V_PeakLoc, V_LeadingEdgeLoc,
			// V_TrailingEdgeLoc, V_PeakVal, and V_PeakWidth. 
			if( V_Flag != 0 )
				break
			endif
			
			// control 1  minimal amplitude must be 0.1
			if (V_PeakVal<0.1)
				control1=control1+1
				not_event=1
			endif
			// control 2 amplitude must be 3 times the Sdev of the local noise.
			wavestats/q/r=[V_PeakLoc-100,V_PeakLoc+100] noise //150
			if (w[V_PeakLoc]<5*V_sdev)
				control2=control2+1
				not_event=1	
			endif		
			
			if (not_event==0)
				peakPositionsX[peaksFound]=round(V_PeakLoc)//pnt2x(w,V_PeakLoc)
				peakPositionsY[peaksFound]=V_PeakVal
				peaksFound += 1
			endif
			startP= V_TrailingEdgeLoc+5 // control 3
		while( peaksFound < maxPeaks )

		if( peaksFound )
			Redimension/N=(peaksFound) peakPositionsX, peakPositionsY
		endif
		duplicate/o $stringfromlist(i,list,",") temp
		temp=0
		variable P=0
		InsertPoints numpnts(peakPositionsX),1, peakPositionsX
		peakPositionsX[inf]=inf
		for (l=0;l<numpnts(temp);l+=1)
			if(peakPositionsX[p]==l)
				temp[l]=peakPositionsY[p]
				P+=1		
			endif
		endfor
		
		//control 3 If the average Sdev of the noise is more than 0.2 the whole signal is discarded to avoid underestimation of frequency.
		// this threshold was determined using de data of 200 cells (4 mices) and finding the 0.1 % outlier. 
		if (SDev[i]>0.1)
			control4=control4+1
			temp=0
			switch1=1
					print "cell "+num2str(i)+" was discarded (too noisy)!"
				endif
		
				duplicate/o temp $folder+"data:S:"+stringfromlist(i,list,",")
				if	(switch1==0)
					print "cell "+num2str(i)+" done!"
				endif
			endfor
end
end

//========================================
//This function create the sleep arquitecture wave and calculate sleep stats. This program create a 
// square signal for the sleep stages of amplitude "a". You want "a" to be larger enough to cover the whole area
//of the plot. t is the time shift correctio (def 10 s). sf is the sampling frequency

function sleep_plot(a,t,sf,folder) 
	variable a,t,sf
	string folder
	// get numpnts
	Print "Time shift was "+num2str(t)+"s"
	setdatafolder $folder+"data:C_raw:"
	wave wave0
	variable puntos=numpnts(wave0)+floor(sf*t)

	setdatafolder $folder+"data:sleep:"

	variable p=0,tiempo=0,i=0
	wave wave0
	wave/t wave1
	SetScale d 0,0,"s", wave0
	InsertPoints numpnts(wave0),1, wave0
	wave0[inf]=inf
	variable we,se,re,me,rwe

	make/o/n=(puntos) WAKE,NREM,REM,REMWAKE,M

	// for first episode
	if (stringmatch(wave1[p],"M"))
		me=me+1
	else
		if (stringmatch(wave1[p],"W"))
			we=we+1
		else
			if (stringmatch(wave1[p],"S"))
				se=se+1
			else
				if (stringmatch(wave1[p],"R"))
					re=re+1
				else
					if (stringmatch(wave1[p],"RW"))
						rwe=rwe+1
					endif
				endif
			endif
		endif
	endif


	do

		//for each transiton

		if(tiempo>=wave0[p+1])  //if there is a transition
			p=p+1
			
			if (stringmatch(wave1[p],"M"))
				me=me+1
			else 
				if (stringmatch(wave1[p],"W"))
					we=we+1
				else
					if (stringmatch(wave1[p],"S"))
						se=se+1
					else
						if (stringmatch(wave1[p],"R"))
							re=re+1
						else
							if (stringmatch(wave1[p],"RW"))
								rwe=rwe+1
							endif
						endif
					endif
				endif		
			endif
		endif	

		if (stringmatch(wave1[p],"W")) //then is wake
			WAKE[i]=a
			NREM[i]=0
			M[i]=0
			REM[i]=0
			REMWAKE[i]=0
		else
			if (stringmatch(wave1[p],"S")) // then is NREM
				WAKE[i]=0
				NREM[i]=a
				REM[i]=0
				M[i]=0
				REMWAKE[i]=0
			else
				if (stringmatch(wave1[p],"R")) //then is REM
					WAKE[i]=0
					NREM[i]=0
					REM[i]=a	
					M[i]=0
					REMWAKE[i]=0
				else
					if (stringmatch(wave1[p],"M")) //then is unknown
						WAKE[i]=0
						NREM[i]=0
						REM[i]=0	
						M[i]=a
						REMWAKE[i]=0
					else
						if (stringmatch(wave1[p],"RW")) //then is REMWAKE
							WAKE[i]=0
							NREM[i]=0
							REM[i]=0	
							M[i]=0
							REMWAKE[i]=a
						endif
					endif
				endif		
			endif
		endif
		i=i+1
		tiempo=tiempo+1/sf
	while (tiempo<floor(puntos/sf))

	deletepoints 0,sf*t, NREM
	deletepoints 0,sf*t, REM
	deletepoints 0,sf*t, WAKE
	deletepoints 0,sf*t, M
	deletepoints 0,sf*t, REMWAKE

	SetScale/P x 0,0.199203,"", NREM
	SetScale/P x 0,0.199203,"", REM
	SetScale/P x 0,0.199203,"", WAKE
	SetScale/P x 0,0.199203,"", M
	SetScale/P x 0,0.199203,"", REMWAKE
	deletepoints numpnts(wave0),1, wave0
	
	Print "                           "
	Print "Data for the sleep architecture"
	print "======================================"
	print "wake episodes= "+num2str(we)
	print "REMWAKE episodes= "+num2str(rwe)
	print "NREM episodes= "+num2str(se)
	print "REM episodes= "+num2str(re)
	print "M episodes= "+num2str(me)
		

end

//=======================================

// This function save all average data into results.

function get_stats2(sf,st,ft,folder,outwave) // starting time and finishing time in seconds
	variable sf,st,ft
	string folder,outwave
	wave notewave=$outwave
	find_artifacts(folder)
	
	setdatafolder folder+"data:S:"
	duplicate/o $folder+"data:Sleep:NREM", $folder+"data:S:NREM"
	duplicate/o $folder+"data:Sleep:REM", $folder+"data:S:REM"
	duplicate/o $folder+"data:Sleep:WAKE", $folder+"data:S:WAKE"
	duplicate/o $folder+"data:Sleep:M", $folder+"data:S:M"
	duplicate/o $folder+"data:Sleep:REMWAKE", $folder+"data:S:REMWAKE"
	
	string list=wavelist("wave*",",",""),trace
	variable k=itemsinlist(list, ","),i,l
	
	make/o/n=(k) REMF
	make/o/n=(k) NREMF
	make/o/n=(k) WAKEF
	make/o/n=(k) REMWAKEF
	make/o/n=(k) WAKEFRATE
	make/o/n=(k) REMWAKEFRATE
	make/o/n=(k) REMFRATE
	make/o/n=(k) NREMFRATE
	make/o/n=(k) REMA
	make/o/n=(k) NREMA
	make/o/n=(k) WAKEA
	make/o/n=(k) REMWAKEA
	make/o/n=(k) WAKEARATE
	make/o/n=(k) REMWAKEARATE
	make/o/n=(k) REMARATE
	make/o/n=(k) NREMARATE	
	make/o/n=(k) WAKEAUC
	make/o/n=(k) NREMAUC
	make/o/n=(k) REMAUC
	make/o/n=(k) REMWAKEAUC
	wave REM,NREM,WAKE,artifact,M,REMWAKE
	variable RT,NT,WT,RWT,ER,EN,EW,ERW,t,AW,ARW,AR,AN,tt=wavemax(NREM)
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		RT=0
		NT=0
		WT=0
		RWT=0
		ER=0
		EN=0
		EW=0
		ERW=0
		t=0
		AW=0
		AR=0
		AN=0
		ARW=0
		wave tempwave=$trace
		for (l=st*sf;l<(ft*sf);l+=1)
		
			if (numpnts(artifact)<=l)
		
				break
			endif
			if (artifact[l]==0 && M[l]==0)	
		
				if (WAKE[l]>0)
					WT=WT+1
					if (tempwave[l]>0)
						EW=EW+1
						AW=AW+tempwave[l]
					endif
				else
					if (NREM[l]>0)
						NT=NT+1
						if (tempwave[l]>0)
							EN=EN+1
							AN=AN+tempwave[l]
						endif
					else		
					
						if (REM[l]>0)
							RT=RT+1
							if (tempwave[l]>0)
								ER=ER+1
								AR=AR+tempwave[l]
							endif
						else		
					
							if (REMWAKE[l]>0)
								RWT=RWT+1
								if (tempwave[l]>0)
									ERW=ERW+1
									ARW=ARW+tempwave[l]
								endif
							endif			
						endif	
					endif
				endif
			endif					
		endfor	
		RT=RT/sf
		NT=NT/sf
		WT=WT/sf
		RWT=RWT/sf
		if (ER==0)
			REMF[i]=0
			REMA[i]=0
			REMAUC[i]=0
		else
			REMF[i]=ER*60/RT
			REMA[i]=AR/ER	
			duplicate/o $folder+"Data:C:wave"+num2str(i) temporal	
			duplicate/o $folder+"Data:Sleep:REM" rems
			temporal=temporal*REM
			temporal=temporal/tt
			SetScale/P x 0,0.199203,"", temporal
			integrate temporal
			REMAUC[i]=wavemax(temporal)/ER		
		endif
		if (EN==0)
			NREMF[i]=0
			NREMA[i]=0
			NREMAUC[i]=0
		else
			NREMF[i]=EN*60/NT
			NREMA[i]=AN/EN
			duplicate/o $folder+"Data:C:wave"+num2str(i) temporal	
			temporal=temporal*NREM
			temporal=temporal/tt
			SetScale/P x 0,0.199203,"", temporal
			integrate temporal
			NREMAUC[i]=wavemax(temporal)/EN
		endif
		if (EW==0)	
			WAKEF[i]=0
			WAKEA[i]=0
			WAKEAUC[i]=0
		else		
			WAKEF[i]=EW*60/WT
			WAKEA[i]=AW/EW
			
			duplicate/o $folder+"Data:C:wave"+num2str(i) temporal	
			temporal=temporal*wake
			temporal=temporal/tt
			SetScale/P x 0,0.199203,"", temporal
			integrate temporal
			WAKEAUC[i]=wavemax(temporal)/EW
		endif		
		
		if (ERW==0)
			REMWAKEF[i]=0
			REMWAKEA[i]=0
			REMWAKEAUC[i]=0
		else
			REMWAKEF[i]=ERW*60/RT
			REMWAKEA[i]=ARW/ERW
			
			
			duplicate/o $folder+"Data:C:wave"+num2str(i) temporal	
			temporal=temporal*REMWAKE
			temporal=temporal/tt
			SetScale/P x 0,0.199203,"", temporal
			integrate temporal
			REMWAKEAUC[i]=wavemax(temporal)/ERW
			
		endif

		REMFRATE[i]=(2*REMF[i]-NREMF[i]-WAKEF[i])/(REMF[i]+NREMF[i]+WAKEF[i])
		NREMFRATE[i]=(2*NREMF[i]-REMF[i]-WAKEF[i])/(REMF[i]+NREMF[i]+WAKEF[i])
		WAKEFRATE[i]=(2*WAKEF[i]-REMF[i]-NREMF[i])/(REMF[i]+NREMF[i]+WAKEF[i])
	
		WAKEARATE[i]=(2*WAKE[i]-REMA[i]-NREMA[i])/(WAKE[i]+REMA[i]+NREMA[i])
		REMARATE[i]=(2*REMA[i]-WAKE[i]-NREMA[i])/(WAKE[i]+REMA[i]+NREMA[i])
		NREMARATE[i]=(2*NREMA[i]-REMA[i]-WAKE[i])/(WAKE[i]+REMA[i]+NREMA[i])
	
		//print EW,WT,WAKEA[i],WAKEAUC[i],ERW,RWT,REMWAKEA[i],REMWAKEAUC[i],EN,NT,NREMA[i],NREMAUC[i],ER,RT,REMA[i],REMAUC[i]
		InsertPoints/v=(nan) DimSize(notewave,0),1,$outwave
		notewave[dimsize(notewave,0)-1][0]=EW
		notewave[dimsize(notewave,0)-1][1]=WT
		notewave[dimsize(notewave,0)-1][2]=WAKEA[i]
		notewave[dimsize(notewave,0)-1][3]=WAKEAUC[i]
		notewave[dimsize(notewave,0)-1][4]=EN
		notewave[dimsize(notewave,0)-1][5]=NT
		notewave[dimsize(notewave,0)-1][6]=NREMA[i]
		notewave[dimsize(notewave,0)-1][7]=NREMAUC[i]
		notewave[dimsize(notewave,0)-1][8]=ER
		notewave[dimsize(notewave,0)-1][9]=RT
		notewave[dimsize(notewave,0)-1][10]=REMA[i]
		notewave[dimsize(notewave,0)-1][11]=REMAUC[i]
		notewave[dimsize(notewave,0)-1][12]=ERW
		notewave[dimsize(notewave,0)-1][13]=RWT
		notewave[dimsize(notewave,0)-1][14]=REMWAKEA[i]
		notewave[dimsize(notewave,0)-1][15]=REMWAKEAUC[i]
	endfor
end

//=======================================
// This function find region where I manually removed artifacts and exclude them from the analysis.

function find_artifacts(folder)
	string folder
	setdatafolder folder+"data:C_raw:"
	execute "duplicate/o wave0 artifact"
	wave artifact
	artifact = (artifact[p] ==0) ? 500 : artifact[p]
	artifact = (artifact[p] <499) ? 0 : artifact[p]
	artifact=artifact/500
	execute "duplicate/o artifact  "+folder+"data:S:artifact"
	killwaves :artifact

end

//========================================
// This function is to manually remove aritfacts in the signal using the data cursos on a graph.
// Just select a region to remove with the data cursos and run this funciton to remove what is in between them.
 

function remove_artifacts()

	string list,trace,temp
	variable k,i

	variable a=pcsr(A),b=pcsr(B)

	setdatafolder root:data:C_raw:
	list=wavelist("wave"+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		twave[a,b]=0		
	endfor
	updategraphs("wave",0)

	setdatafolder root:data:C:
	list=wavelist("wave"+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		twave[a,b]=0		
	endfor
	updategraphs("wave",0)

	setdatafolder root:data:S:
	list=wavelist("wave"+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		twave[a,b]=0		
	endfor
	updategraphs("wave",0)
end

//========================================
//This function is used in remove_artifacts() to update the traces.

function updategraphs(wavenames,disp)
	string wavenames
	variable disp
	string list,trace,temp
	variable k,i
	if (disp==1)
		display/k=1
	endif
	list=wavelist(wavenames+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		temp="graph"+trace
		Duplicate/O $trace, $temp	
		wave twave=$temp
		twave=twave+(i*2)	
	endfor
end

//========================================
// same as remove_artifacts, but used when working only with C_raw signal.
// Use this when you are only lookin at C_raw. 

function remove_artifacts2()

	string list,trace,temp
	variable k,i

	variable a=pcsr(A),b=pcsr(B)

	setdatafolder root:data:C_raw:
	list=wavelist("wave"+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		twave[a,b]=0		
	endfor
	updategraphs("wave",0)

end


// ================================================================================
//********************************************************************************

//***** THIS FUNCTIOnS ARE FOR showing traces*****

// main function for ploting (Set raster to 0 to plot the traces and to 1 to plot the raster)
function plot_data_from_all_subfolders(raster)
	variable raster
	display/k=1
	Variable numDataFolders = CountObjects(":", 4), l
	string cdf,list
	cdf=GetDataFolder(1)
	variable offset=0,b
	for(l=0; l<(numDataFolders); l+=1)
		String nextPath =GetIndexedObjNameDFR($cdf, 4, l )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf+nextPath
		list = tracenamelist("",";", 1)
		b=itemsinlist(list)
		String w=stringfromlist(b-1,list,";")
		offset=GetTraceOffset("",w, 0, 1)+4
		
		if (offset==4)
			offset=0
		endif
		
		append_traces(raster)
		offset_traces(b,offset)
	
	endfor
	modify_wave_apparence()
	setdatafolder $cdf
end


//This is to save rasters and traces as PDF

function save_graph(raster)
	variable raster
	if (raster==1)
		SavePICT/O/E=-8/EF=1/I/W=(0,0,130,10)
	else
		SavePICT/O/E=-8/EF=1/I/W=(0,0,130,50)
	endif
end

// graph traces
function graph_traces()
	display
	append_traces(0)
	modify_wave_apparence()
end

function append_traces(raster) // plot everything inside a folder!!
	variable raster
	string folder=GetDataFolder(1)
	wave t=$folder+"data:S:artifact",w=$folder+"data:SLeep:WAKE"
	
	variable j=wavemax(w),k=wavemax(t)
	t=(t/t)*j
	appendtograph  $folder+"data:SLeep:REM",$folder+"data:SLeep:WAKE",$folder+"data:SLeep:NREM",$folder+"data:S:artifact"
	copyScales $folder+"data:SLeep:WAKE", $folder+"data:S:artifact"
	if (raster==0)
		setdatafolder folder+"data:C_raw:"
		creategraphs("wave",0)
	endif
	setdatafolder folder+"data:S:"
	creategraphs2("wave",0)	
	setdatafolder folder+"data:sleep:"	
	setdatafolder folder
end
// This function is to graph the raw calcium signals

function creategraphs(wavenames,disp)
	string wavenames
	variable disp
	string list,trace,temp
	variable k,i
	if (disp==1)
		display/k=1
	endif
	list=wavelist(wavenames+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		SetScale/P x 0,0.199203,"", twave
		AppendToGraph twave	/TN=raw	
		string traces = tracenamelist("",";", 1) 
		ModifyGraph offset[itemsinlist(traces, ";")-1]={0,i*2}
	endfor	
end
		

// This function is to graph the deconvolved calcium signals.

function creategraphs2(wavenames,disp)
	string wavenames
	variable disp
	string list,trace,temp
	variable k,i
	if (disp==1)
		display/k=1
	endif
	list=wavelist(wavenames+"*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		duplicate/o $trace $"graph_"+num2str(i)
		wave twave=$"graph_"+num2str(i)
		twave= (twave==0) ? nan : twave[p]
		SetScale/P x 0,0.199203,"", twave
		AppendToGraph twave	/TN=S	
		string traces = tracenamelist("",";", 1) 
		ModifyGraph offset[itemsinlist(traces, ";")-1]={0,i*2}		
	endfor
end

// used in append_traces(raster)

function offset_traces(b,offset)
	variable b,offset
	string list2 = tracenamelist("",";", 1) 
	variable t=itemsinlist(list2),i
	
	for(i=b; i<t; i+=1)
		String w=stringfromlist(i,list2,";")
		ModifyGraph offset($w)={0,GetTraceOffset("",w, 0, 1)+offset}
	endfor	
end

// used in append_traces(raster)

function modify_wave_apparence()
	variable i
	string list = tracenamelist("",";", 1)
	string temp

	string REM=ListMatch(list, "REM*")
	for(i=0; i<itemsinlist(REM); i+=1)
		temp=stringfromlist(i, REM, ";")
		ModifyGraph mode($temp)=7,hbFill($temp)=2,rgb($temp)=(65535,49151,49151)
	endfor
	string artifacts=ListMatch(list, "artifact*")
	for(i=0; i<itemsinlist(artifacts); i+=1)
		temp=stringfromlist(i, artifacts, ";")
		ModifyGraph mode($temp)=7,hbFill($temp)=2,rgb($temp)=(61166,61166,61166)
	endfor

	string NREM=ListMatch(list, "NREM*")
	for(i=0; i<itemsinlist(NREM); i+=1)
		temp=stringfromlist(i, NREM, ";")
		ModifyGraph mode($temp)=7,hbFill($temp)=2,rgb($temp)=(49151,60031,65535)
	endfor

	string WAKE=ListMatch(list, "WAKE*")
	for(i=0; i<itemsinlist(WAKE); i+=1)
		temp=stringfromlist(i, WAKE, ";")
		ModifyGraph mode($temp)=7,hbFill($temp)=2,rgb($temp)=(49151,65535,49151)
	endfor

	string RAW=ListMatch(list, "raw*")
	for(i=0; i<itemsinlist(RAW); i+=1)
		temp=stringfromlist(i, RAW, ";")
		ModifyGraph lsize($temp)=0.1,rgb($temp)=(0,0,0)
	endfor

	string S=ListMatch(list, "S*")
	for(i=0; i<itemsinlist(S); i+=1)
		temp=stringfromlist(i, S, ";")
		ModifyGraph mode($temp)=3,marker($temp)=19,msize($temp)=1
	endfor
	ModifyGraph prescaleExp(bottom)=0
	ModifyGraph highTrip(bottom)=100000
	Label bottom "Time (s)"
	ModifyGraph noLabel(left)=2
	Legend/C/N=text0/J/F=0/A=MC/X=30.47/Y=-57.46 "\\s(REM) REM \\s(WAKE) WAKE \\s(NREM) NREM"

end

//used in offset_traces(b,offset)

Function GetTraceOffset(graphName, traceName, instance, which)
	String graphName    // "" for top graph
	String traceName
	Variable instance   // Usually 0
	Variable which      // 0 for X, 1 for Y
   
	String info= TraceInfo(graphName,traceName, instance)
   
	String offsets = StringByKey("offset(x)",info,"=",";") // "{xOffset,yOffset}"
   
	Variable xOffset,yOffset
	sscanf offsets, "{%g,%g}",xOffset,yOffset
   
	if (which)
		return yOffset
	else
		return xOffset
	endif
End

// ================================================================================
//********************************************************************************

//=======================================================
// Function to start a new timer

function tic()
	variable i
	for (i=0;i<10;i+=1)
		variable t=StopMSTimer(i)
	endfor

	variable/G tictoc = startMSTimer
end
// Function to stop timer and print time.
function toc()
	NVAR/Z tictoc
	variable ttTime = stopMSTimer(tictoc)
	printf "%g seconds\r", (ttTime/1e6)
	
end

// ================================================================================
//********************************************************************************

//========================================
//BOOTSTRAP and random permutations

// This is only used to create Confidence interval. Is not okay for hypothesis testing
function bootstrap(wavenom1,sim,alpha)
	string wavenom1
	variable sim,alpha
	wave tt=$wavenom1
	variable aver=mean($wavenom1)
	duplicate/o $wavenom1 bootstrapsample

	
	
	
	variable s,n=numpnts($wavenom1),i
	make/o/n=(sim) bootstrapdist
	variable randnum

	for (s=0;s<sim;s+=1)
	
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			bootstrapsample[i]=tt[randnum]
		endfor
		
		
		
		bootstrapdist[s]=mean(bootstrapsample)
	endfor
	sort bootstrapdist bootstrapdist


	variable CI95=(alpha/2)*sim,CI_MC95=(alpha/6)*sim
	print "CI is: "

	print num2str(aver)+" "+num2str(bootstrapdist(sim-CI95))+" "+num2str(bootstrapdist(CI95))
	print "This is only used to create Confidence interval. Is not okay for hypothesis testing"
end

// This function creat bootstrap of the average difference between two data sets.
//del0 can be 1 or 0. if it's 1. any 0 value while be zapped out of the wave.	
	
function bootstrap2(wavenom1,wavenom2,sim,del0,comparisons)  //del0==1 delete 0 from wave
	string wavenom1,wavenom2
	variable sim,del0,comparisons
	
	wave tt=$wavenom1,tt2=$wavenom2
	WaveTransform zapNaNs tt
	WaveTransform zapNaNs tt2
	
	if (Del0==1)
		Extract/o $wavenom1, $wavenom1, tt!=0
		Extract/o $wavenom2, $wavenom2, tt2!=0
	endif
	variable ms1=mean($wavenom1),ms2=mean($wavenom2)
	variable aver=ms2-ms1
	duplicate/o $wavenom1 bootstrapsample
	duplicate/o $wavenom2 bootstrapsample2

	variable s,n=numpnts($wavenom1),i,n2=numpnts($wavenom2),i2
	make/o/n=(sim) bootstrapdist
	variable randnum

	for (s=0;s<sim;s+=1)
	
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			bootstrapsample[i]=tt[randnum]
		endfor
		for (i2=0;i2<n2;i2+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n2-1))
			bootstrapsample2[i2]=tt2[randnum]
		endfor
		
		variable m2=	mean(bootstrapsample2)
		variable m1=	mean(bootstrapsample)
		
		bootstrapdist[s]=m2-m1
	endfor
	sort bootstrapdist bootstrapdist
	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/(2*comparisons))*sim
	print num2str(aver)+" "+num2str(bootstrapdist(sim-CI_MC95))+" "+num2str(bootstrapdist(CI_MC95))
end

// create confindence interval of the mean difference of several data sets.
//this will compare all datasets named "wave" inside the current folder.

function bootstrap_allwaves()  // create CI for all the waves named "wave*" in the folder
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i
	variable b=binomial(k,2)
	Make/O/N=(k) combi
	combi = p
	StatsSample/N=2/ACMB combi
	wave M_combinations
	
	for (i=0;i<b;i+=1)	
		string swave1=stringfromlist(M_combinations[i][0],list,",")
		string swave2=stringfromlist(M_combinations[i][1],list,",")
		
		print "   Comp"+num2str(M_combinations[i][1]+1)+"-"+num2str(M_combinations[i][0]+1)
		bootstrap2(swave1,swave2,10000,1,b)
	endfor
end

//
function shuffle(inwave)	//	in-place random permutation of input wave elements
	wave inwave
	variable N	=	numpnts(inwave)
	variable i, j, emax, temp
	for(i = N; i>1; i-=1)
		emax = i / 2
		j =  floor(emax + enoise(emax))		//	random index
		// 		emax + enoise(emax) ranges in random value from 0 to 2*emax = i
		temp		= inwave[j]
		inwave[j]		= inwave[i-1]
		inwave[i-1]	= temp
	endfor
end

// This is used for creating the CI for the data obtained from getall_batch(), 
//list1 is the full path for the 2d list 

function createCI_Results(list1)  //creae ci auto from 2d wave results
	string list1
	wave temp=$list1
	variable wt,nt,rt,we,ne,re
	wave WakeT

	wave WakeT,NREMT,REMT,WakeE,NREME,REME
	
	duplicate/o/RMD=[][1] temp test
	integrate test
	wt=test(inf)
	duplicate/o/RMD=[][5] temp test
	integrate test
	nt=test(inf)
	duplicate/o/RMD=[][9] temp test
	integrate test
	rt=test(inf)
	duplicate/o/RMD=[][0] temp test
	integrate test
	we=test(inf)
	duplicate/o/RMD=[][4] temp test
	integrate test
	ne=test(inf)
	duplicate/o/RMD=[][8] temp test
	integrate test
	re=test(inf)
	
	
	variable sim=10000

	variable i,n=dimsize(temp,0),randnum,s
	make/o/n=(sim) wakeP,NREMP,REMP

	for (s=0;s<sim;s+=1)
		variable WakeTR=0,NREMTR=0,REMTR=0,WakeER=0,NREMER=0,REMER=0
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			WakeTR=WakeTR+temp[randnum][1]
			NREMTR=NREMTR+temp[randnum][5]
			REMTR=REMTR+temp[randnum][9]
			WakeER=WakeER+temp[randnum][0]
			NREMER=NREMER+temp[randnum][4]
			REMER=REMER+temp[randnum][8]
		endfor
		wakeP[s]=WakeER/WakeTR
		NREMP[s]=NREMER/NREMTR
		REMP[s]=REMER/REMTR
	endfor
	sort wakeP wakeP
	sort NREMP NREMP
	sort REMP REMP

	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/6)*sim
	print "wake CI is: "
	print "NREM CI is: "
	print "NREM CI is: "
	print num2str(we/wt)+" "+num2str(wakep(sim-CI95))+" "+num2str(wakep(CI95))
	print num2str(ne/nt)+" "+num2str(NREMp(sim-CI95))+" "+num2str(NREMp(CI95))
	print num2str(re/rt)+" "+num2str(REMp(sim-CI95))+" "+num2str(REMp(CI95))
	print " ''WARNING! use createCI2_****() for hypothesis testing''"
	print " ''Use to CreateCI2_groups(list1,list2,mc) to compare between groups (eg DS vs IMS)"
	print " ''Use to CreateCI2_sleep(list1) to compare between sleep stages (BL wake vs BL REM)"
	
	killwaves wakeP,NREMP,REMP,test

end

// This is used for statistical testing, list1 and list2 are the full path for the 2d list 
//with the data obtained from getall_batch()

function createCI2_groups(list1,list2,mc)  
	string list1,list2
	variable mc
	wave temp1=$list1,temp2=$list2
	// the structure of the list is the following:
	// WT1|NT1|RT1|WE1|NE1|RE1|WT2|NT2|RT2|WE2|NE2|RE2
	variable wt,nt,rt,we,ne,re,wt2,nt2,rt2,we2,ne2,re2

	
	duplicate/o/RMD=[][1] temp1 test
	integrate test
	wt=test(inf)
	duplicate/o/RMD=[][5] temp1 test
	integrate test
	nt=test(inf)
	duplicate/o/RMD=[][9] temp1 test
	integrate test
	rt=test(inf)
	duplicate/o/RMD=[][0] temp1 test
	integrate test
	we=test(inf)
	duplicate/o/RMD=[][4] temp1 test
	integrate test
	ne=test(inf)
	duplicate/o/RMD=[][8] temp1 test
	integrate test
	re=test(inf)
	
	duplicate/o/RMD=[][1] temp2 test
	integrate test
	wt2=test(inf)
	duplicate/o/RMD=[][5] temp2 test
	integrate test
	nt2=test(inf)
	duplicate/o/RMD=[][9] temp2 test
	integrate test
	rt2=test(inf)
	duplicate/o/RMD=[][0] temp2 test
	integrate test
	we2=test(inf)
	duplicate/o/RMD=[][4] temp2 test
	integrate test
	ne2=test(inf)
	duplicate/o/RMD=[][8] temp2 test
	integrate test
	re2=test(inf)
	
	
	variable sim=10000,w1,nr1,r1,w2,nr2,r2

	variable i,n=dimsize(temp1,0),randnum,s,i2,n2=dimsize(temp2,0)
	make/o/n=(sim) wakeP,NREMP,REMP

	for (s=0;s<sim;s+=1)
		variable WakeTR=0,NREMTR=0,REMTR=0,WakeER=0,NREMER=0,REMER=0,WakeTR2=0,NREMTR2=0,REMTR2=0,WakeER2=0,NREMER2=0,REMER2=0
		
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			WakeTR=WakeTR+temp1[randnum][1]
			NREMTR=NREMTR+temp1[randnum][5]
			REMTR=REMTR+temp1[randnum][9]
			WakeER=WakeER+temp1[randnum][0]
			NREMER=NREMER+temp1[randnum][4]
			REMER=REMER+temp1[randnum][8]
		endfor
		
		for (i2=0;i2<n2;i2+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n2-1))
			WakeTR2=WakeTR2+temp2[randnum][1]
			NREMTR2=NREMTR2+temp2[randnum][5]
			REMTR2=REMTR2+temp2[randnum][9]
			WakeER2=WakeER2+temp2[randnum][0]
			NREMER2=NREMER2+temp2[randnum][4]
			REMER2=REMER2+temp2[randnum][8]
		endfor
		w1=WakeER/WakeTR
		nr1=NREMER/NREMTR
		r1=REMER/REMTR
		w2=WakeER2/WakeTR2
		nr2=NREMER2/NREMTR2
		r2=REMER2/REMTR2
		
		
		
		wakeP[s]=w2-w1
		NREMP[s]=nr2-nr1
		REMP[s]=r2-r1
	endfor
	sort wakeP wakeP
	sort NREMP NREMP
	sort REMP REMP

	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/(2*mc))*sim
	//print "wake CI is: "
	//print "NREM CI is: "
	//print "NREM CI is: "
	//print num2str(-((we/wt)-(we2/wt2)))+" "+num2str(wakep(sim-CI95))+" "+num2str(wakep(CI95))
	//print num2str(-((ne/nt)-(ne2/nt2)))+" "+num2str(NREMp(sim-CI95))+" "+num2str(NREMp(CI95))
	//print num2str(-((re/rt)-(re2/rt2)))+" "+num2str(REMp(sim-CI95))+" "+num2str(REMp(CI95))
	//Print "For multiples comparision[MC]"
	//print "wake CI MC corrected (3) is: "
	//print "NREM CI MC corrected (3) is: "
	//print "NREM CI MC corrected (3) is: "
	print num2str(-((we/wt)-(we2/wt2)))+" "+num2str(wakep(sim-CI_MC95))+" "+num2str(wakep(CI_MC95))
	print num2str(-((ne/nt)-(ne2/nt2)))+" "+num2str(NREMp(sim-CI_MC95))+" "+num2str(NREMp(CI_MC95))
	print num2str(-((re/rt)-(re2/rt2)))+" "+num2str(REMp(sim-CI_MC95))+" "+num2str(REMp(CI_MC95))

	killwaves wakeP,NREMP,REMP,test
end

// this is for hypothesis tesis for sleep conditions in a same group

function createCI2_sleep(list,mc)
	string list
	variable mc
	duplicate/o $list list2
	wave temp=$list

	list2[][0]=temp[p][4]    
	list2[][1]=temp[p][5]    //W-N
	list2[][4]=temp[p][8]
	list2[][5]=temp[p][9]    //N-R
	list2[][8]=temp[p][0]
	list2[][9]=temp[p][1]    //R-W
	print "these confidence interval are for W-N  N-R  R-W comparisons"
	createCI2_groups(list,"list2",mc)
end

function bootstrap_sum(list1,list2,sim,comparisons)

	wave list1,list2
	variable sim,comparisons
	make/o/n=(sim,6) boot_dist

	variable i, total_set=(dimsize(list1,1)+dimsize(list2,1)),s,c
	for (s=0;s<sim;s+=1)
		bootstrap_2d(list1)
		wave bootstrapsample
		SumDimension/DEST=out/D=0 bootstrapsample
		out=out/sum(bootstrapsample)
		boot_dist[s][0]=out[0]
		boot_dist[s][1]=out[1]
		boot_dist[s][2]=out[2]
				
		bootstrap_2d(list2)
		wave bootstrapsample
		SumDimension/DEST=out/D=0 bootstrapsample
		out=out/sum(bootstrapsample)
		boot_dist[s][3]=out[0]
		boot_dist[s][4]=out[1]
		boot_dist[s][5]=out[2]
	endfor
	variable b=binomial(total_set,2)
	make/o/t/n=6 labels={"BW","BN","BR","AW","AN","AR"}
	make/o/n=(sim,b) boot_dist_diff
	
	Make/O/N=(total_set) combi
	combi = p
	StatsSample/N=2/ACMB combi
	wave M_combinations
	
	for (i=0;i<b;i+=1)	//set labels
		SetDimLabel 1,i,$labels(M_combinations[i][0])+"-"+labels(M_combinations[i][1]), boot_dist_diff
	endfor
	
	for (s=0;s<sim;s+=1)
		for (i=0;i<b;i+=1)	//set labels
			boot_dist_diff[s][i]=boot_dist[s][(M_combinations[i][0])]-boot_dist[s][(M_combinations[i][1])]
		endfor
	endfor
	sort2dwave(boot_dist_diff)
	sort2dwave(boot_dist)
	
	if (comparisons==0)
		c=b
	else
		c=comparisons
	endif
	
	variable CI=(0.05/(2))*sim,CI_M=(0.05/(2*c))*sim
	
	SumDimension/DEST=out/D=0 list1
	out=out/sum(list1)
	SumDimension/DEST=temp/D=0 list2
	temp=temp/sum(list2)
	Concatenate/NP=0   {temp}, out
	
	print "	WAKE baseline CI:"
	print num2str(out[0])+" "+num2str(boot_dist[sim-CI][0])+" "+num2str(boot_dist[CI][0])
	print "	NREM baseline CI:"
	print num2str(out[1])+" "+num2str(boot_dist[sim-CI][1])+" "+num2str(boot_dist[CI][1])
	print "	REM baseline CI:"
	print num2str(out[2])+" "+num2str(boot_dist[sim-CI][2])+" "+num2str(boot_dist[CI][2])
	

	print "	WAKE aftershock CI:"
	print num2str(out[3])+" "+num2str(boot_dist[sim-CI][3])+" "+num2str(boot_dist[CI][3])
	print "	NREM aftershock CI:"
	print num2str(out[4])+" "+num2str(boot_dist[sim-CI][4])+" "+num2str(boot_dist[CI][4])
	print "	REM aftershock CI:"
	print num2str(out[5])+" "+num2str(boot_dist[sim-CI][5])+" "+num2str(boot_dist[CI][5])
	
	
	print "=================hypothesis testing==========="

	
	for (i=0;i<b;i+=1)	
		print "	"+GetDimLabel(boot_dist_diff, 1, i)
		print num2str(out[M_combinations[i][0]]-out[M_combinations[i][1]])+" "+num2str(boot_dist_diff[sim-CI_M][i])+" "+num2str(boot_dist_diff[CI_M][i])
	endfor
	
end

//--------------------------
function bootstrap_2d(wavenom1)  
	wave wavenom1
	
	duplicate/o wavenom1 bootstrapsample

	variable n=dimsize(wavenom1,0),i

	variable randnum
	
	for (i=0;i<n;i+=1)
		randnum=ceil((enoise(0.5)+0.5)*(n-1))
		bootstrapsample[i][]=wavenom1[randnum][q]
	endfor

end
//--------------------------

function sort2dwave(name)
	wave name
	variable i
	for (i=0;i<dimsize(name,1);i+=1)
		duplicate/o/RMD=[][i] name temp
		Redimension/N=-1 temp
		sort temp temp
		name[][i]=temp[p]
	endfor
	killwaves temp
end



// ================================================================================
//********************************************************************************

// functions to prin sleep stats. THIS IS NOT CONSIDERiNg REMWAKE AND M as wake

//format is TOTAL DURATIO WNR/AVERAGE DURATION WNR/EPISODEperHOUR WNR


function sleep_stats_batch() // main function for batch analysis
	Variable numDataFolders = CountObjects(":", 4), l
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	print "Total Duration, average duratio, episode/h"  
	for(l=0; l<(numDataFolders); l+=1)
		String nextPath =stringfromlist(l,dflist,";")
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":data:S"
		sleep_stats() 
	endfor
	setdatafolder $cdf2
end
//--------------------------

function sleep_stats() // get sleep relevant data, used in sleep_stats_batch()
	variable MisW,RWisW
	wave wake,nrem,rem,remwake,M,artifact
	duplicate/o Wake hypno
	variable t1,t2

	artifact = (numtype(artifact[p]) == 2) ? 0 : artifact
	hypno=nrem+rem*2-artifact
	variable ti=wavemax(hypno)
	hypno=hypno/ti
	variable new,nen,ner,nem,nerw
	
	duplicate/o wake temp
	temp=wake+M+remwake
	
	findlevels/q/edge=1 temp 0.99
	new=V_LevelsFound
	
	if (temp[0]>0.99)
		new=new+1
	endif
	
	findlevels/q/edge=1 Nrem 0.99
	nen=V_LevelsFound
	
	if (nrem[0]>0.99)
		nen=nen+1
	endif
	
	findlevels/q/edge=1 rem 0.99
	ner=V_LevelsFound
	
	if (rem[0]>0.99)
		ner=ner+1
	endif

	variable t3
	duplicate/o wake temp
	t3=wavemax(temp)
	
	temp=(wake+M+REMwake)/t3
	integrate temp
	
	variable tw=wavemax(temp)	
	temp=(NREM)/t3
	integrate temp	
	
	variable tN=wavemax(temp)	
	temp=(REM)/t3
	integrate temp	
	
	variable tR=wavemax(temp)	
	temp=1
	integrate temp	
	
	variable ttime=wavemax(temp)	
	print tw,tn,tr,tw/new,tn/nen,tr/ner,new*3600/ttime,nen*3600/ttime,ner*3600/ttime	
end

//--------------------------

Function/S SortedDataFolderList(sourceFolderStr, sortOptions) // sort data folders
	String sourceFolderStr  // e.g., "root:'A Data Folder'"
	Variable sortOptions    // e.g., 16 - See SortList for details
   
	String dfList = ""
   
	Variable numDataFolders = CountObjects(sourceFolderStr, 4)
	Variable i
	for (i=0; i< numDataFolders; i+=1)
		String dfName = GetIndexedObjName(sourceFolderStr, 4, i)
		dfList += dfName + ";"
	endfor
   
	dfList = SortList(dfList, ";", sortOptions)
	return dfList
End

// ================================================================================
//********************************************************************************
// ANOVA TESTS

function anova() // normal anova, datasets  to compare mus be named "anova"
	string list=wavelist("anova*",";","DF:0")

	variable k=itemsinlist(list, ";"),i
	make/o/n=(k) ng,xg,sumg,sumsqr,sumsqrP
	
	
	for (i=0;i<k;i+=1)	
		string trace=stringfromlist(i,list,";")
		ng[i]=numpnts($trace)
		xg[i]=mean($trace)
		sumg[i]=sum($trace)
		duplicate/o $trace $"res_"+num2str(i)
		wave temp=$"res_"+num2str(i)
		temp=(temp-xg[i])^2
		sumsqr[i]=sum(temp)
	endfor
	
	variable NP=sum(ng)
	variable xP=sum(sumg)/NP
	variable SSw=sum(sumsqr)
	variable MSSw=SSW/(NP-k)
	
	sumsqrP=ng*(xg-XP)^2
	
	variable MSSb=sum(sumsqrP)/(k-1)
	
return MSSb/MSSw //print F
end

//--------------------------
function call_anova2way()
variable q1,q2,q3
[q1,q2,q3]=anova2way()
print q1,q2,q3
end

function [variable q1,variable q2,variable q3]anova2way() // two way anova, datasets  to compare must be 3d matrix named "anova2"
	wave anova2
	variable n_v1=dimsize(anova2,1),n_v2=dimsize(anova2,2),i,l,n
	
	Variable A=0//get [A]
	for (l=0;l<n_v1;l+=1) 
		make/o/n=0 pile
		for (i=0;i<n_v2;i+=1) 
			make/o/n=(dimsize(anova2,0)) temp
			temp=anova2[x][l][i]
			WaveTransform zapNaNs temp
			concatenate/NP=0 {temp}, pile
		endfor
		n=numpnts(pile)
		A=A+(sum(pile))^2/n
	endfor

	
	Variable B=0//get [B]
	for (l=0;l<n_v2;l+=1) 
		make/o/n=0 pile
		for (i=0;i<n_v1;i+=1) 
			make/o/n=(dimsize(anova2,0)) temp
			temp=anova2[x][i][l]
			WaveTransform zapNaNs temp
			concatenate/NP=0 {temp}, pile
		endfor
		n=numpnts(pile)
		B=B+(sum(pile))^2/n
	endfor

	
	Variable AB=0//get [AB]
	for (l=0;l<n_v2;l+=1) 
		for (i=0;i<n_v1;i+=1) 
			make/o/n=(dimsize(anova2,0)) temp
			temp=anova2[x][i][l]
			WaveTransform zapNaNs temp
			n=numpnts(temp)
			AB=AB+(sum(temp))^2/n
		endfor	
	endfor

	
	Variable Y=0//get [Y]
	for (l=0;l<n_v2;l+=1) 
		for (i=0;i<n_v1;i+=1) 
			make/o/n=(dimsize(anova2,0)) temp
			temp=anova2[x][i][l]
			WaveTransform zapNaNs temp
			temp=temp^2
			Y=Y+(sum(temp))
		endfor	
	endfor

	
	Variable T=0//get [T]
	n=0
	for (l=0;l<n_v2;l+=1) 
		for (i=0;i<n_v1;i+=1) 
			make/o/n=(dimsize(anova2,0)) temp
			temp=anova2[x][i][l]
			WaveTransform zapNaNs temp
			n=n+numpnts(temp)
			T=T+(sum(temp))
		endfor	
	endfor
	T=T^2/n
	
	variable A_MS, B_MS, AB_MS,Y_MS
	A_MS=(A-T)/(n_v1-1)
	B_MS=(B-T)/(n_v2-1)
	AB_MS=(ab-a-b+t)/((n_v1-1)*(n_v2-1))
	Y_MS=(y-ab)/(n-n_v1*n_v2)
	q1=A_MS/Y_MS
	q2=B_MS/Y_MS
	q3=AB_MS/Y_MS
	
return [q1,q2,q3]	
end

//--------------------------

// Use this for non-normal/non-homoscedastic  data sets must be named wave"
function anova_bootstrap(sims)
variable sims

	string list=wavelist("wave*",";","DF:0")
	variable k=itemsinlist(list, ";"),i
	for (i=0;i<k;i+=1)	
		string trace=stringfromlist(i,list,";")
		WaveTransform zapNaNs $trace
		duplicate/o $trace $"anova"+num2str(i)
	endfor

	variable sample_F=anova()
	wave xg
	duplicate/o xg xg_stored

	make/o/n=(sims) bstrap
	variable l
	string list2=wavelist("anova*",";","DF:0")
	for (l=0;l<sims;l+=1)

	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,";")
		duplicate/o $trace temp
		temp=temp-xg_stored[i]
		
		string trace2=stringfromlist(i,list2,";")
		wave tmp=$trace2
		tmp=temp[ceil((enoise(0.5)+0.5)*(numpnts(temp)-1))]
	endfor
	
	
	bstrap[l]=anova()	
	endfor
	
sort bstrap bstrap
Make/N=1000000/O bstrap_Hist;DelayUpdate
Histogram/CUM/P/C/B=1 bstrap,bstrap_Hist;DelayUpdate

print "the F-value of the sample is "+num2str(sample_F)

findlevel/q bstrap_Hist,0.9999
if (sample_F>V_LevelX)
print "the probability of randomly observing this value is <0.0001"
else
print "the probability of randomly observing this value is "+num2str(1-bstrap_Hist(sample_F))
endif
findlevel/q bstrap_Hist,0.95
if (sample_F>V_LevelX)
return 1
else
return 0
endif
end

// Use this for non-normal/non-homoscedastic  data sets must be named wave"
function anova2_bootstrap(sims)
variable sims

	string list=wavelist("wave*",";","DF:0")
	variable k=itemsinlist(list, ";"),i
	for (i=0;i<k;i+=1)	
		string trace=stringfromlist(i,list,";")
		WaveTransform zapNaNs $trace
		duplicate/o $trace $"anova"+num2str(i)
	endfor

	variable sample_F=anova()
	wave xg
	duplicate/o xg xg_stored

	make/o/n=(sims) bstrap
	variable l
	string list2=wavelist("anova*",";","DF:0")
	for (l=0;l<sims;l+=1)

	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,";")
		duplicate/o $trace temp
		temp=temp-xg_stored[i]
		
		string trace2=stringfromlist(i,list2,";")
		wave tmp=$trace2
		tmp=temp[ceil((enoise(0.5)+0.5)*(numpnts(temp)-1))]
	endfor
	
	
	bstrap[l]=anova()	
	endfor
	
sort bstrap bstrap
Make/N=1000000/O bstrap_Hist;DelayUpdate
Histogram/CUM/P/C/B=1 bstrap,bstrap_Hist;DelayUpdate

print "the F-value of the sample is "+num2str(sample_F)

findlevel/q bstrap_Hist,0.9999
if (sample_F>V_LevelX)
print "the probability of randomly observing this value is <0.0001"
else
print "the probability of randomly observing this value is "+num2str(1-bstrap_Hist(sample_F))
endif
findlevel/q bstrap_Hist,0.95
if (sample_F>V_LevelX)
return 1
else
return 0
endif
end

//--------------------------
// To test bootstrap_anova power
function test_anova_power(sims,n)
	variable sims,n
tic()
	variable l
	make/o/n=(sims) typeI_parametric
	make/o/n=(sims) typeI_permutation
	for (l=0;l<sims;l+=1)
		make/o/n=(n) wave0=expnoise(30)// function to be teste. you can change this to other function
		make/o/n=(n) wave1=expnoise(30)// function to be teste. you can change this to other function
		make/o/n=(n) wave2=expnoise(30)// function to be teste. you can change this to other function
		StatsANOVA1Test/q wave0,wave1,wave2
		wave M_anova1
		if (M_anova1[2][5]<0.05)
			typeI_parametric[l]=1
		else
			typeI_parametric[l]=0
		endif

typeI_permutation[l]=anova_bootstrap(1000)
	endfor
print "Type I error for ANOVA is "+num2str(sum(typeI_parametric)/sims)
print "Type I error for ANOVA with resampling method is "+num2str(sum(typeI_permutation)/sims)
toc()
end

// ================================================================================
//********************************************************************************


function export_data() //export all data into a txt file
create_hypnogram()
	Variable numDataFolders = CountObjects(":", 4), i,j
	string cdf,list,t1,nextPath
	cdf=GetDataFolder(1)
	
newpath/O Data
	
	for(i=0; i<(numDataFolders); i+=1)
	nextPath =GetIndexedObjNameDFR($cdf, 4, i )
	nextPath="'"+nextpath+"'"
	setdatafolder $cdf+nextPath+":data:s:"
	t1=wavelist("wave*",";","")
	t1=SortList(t1,",", 16)	
	Save/P=Data/o/B/G/M="\r\n"/DLIM=" " t1 as "mouse_"+num2str(i+1)+"_S.txt"	
	
	setdatafolder $cdf+nextPath+":data:C_raw:"
	t1=wavelist("wave*",";","")
	t1=SortList(t1,",", 16)	
	Save/P=Data/o/B/G/M="\r\n"/DLIM=" " t1 as "mouse_"+num2str(i+1)+"_raw.txt"	
	
	setdatafolder $cdf+nextPath+":data:sleep:"
	Save/P=Data/B/o/G/M="\r\n"/DLIM=" " "hypno" as "mouse_"+num2str(i+1)+"_hypnogram.txt"
	
	endfor
setdatafolder cdf
end
//--------------------------
function create_hypnogram()// create the hypnogram data

	Variable numDataFolders = CountObjects(":", 4), i,j
	string cdf,list,t1,nextPath
	cdf=GetDataFolder(1)
	
	for(i=0; i<(numDataFolders); i+=1)
		nextPath =GetIndexedObjNameDFR($cdf, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf+nextPath+":data:Sleep:"
	duplicate/o $cdf+nextPath+":data:S:artifact" $cdf+nextPath+":data:Sleep:artifact"
	wave wake,nrem,rem,artifact
	make/o/n=(numpnts(wake)) hypno
	artifact = (numtype(artifact) == 2) ? 0 : artifact
	
	variable nm=wavemax(nrem),rm=wavemax(rem)
	wave hypno
	hypno=(nrem/nm)+2*(rem/rm)
	hypno = (artifact>0) ? -1 : hypno
	endfor
setdatafolder cdf

end

// ================================================================================
//********************************************************************************

//DANGER ZONE

function kill_non_active_cells() //delete waves with 0 events.
	Variable numDataFolders = CountObjects(":", 4), i,j
	string cdf,list,t1,nextPath
	cdf=GetDataFolder(1)
	
	for(i=0; i<(numDataFolders); i+=1)
		nextPath =GetIndexedObjNameDFR($cdf, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf+nextPath+":data:S:"
		list=wavelist("wave*",";","")
		list=SortList(list,",", 16)
		variable k=itemsinlist(list, ";"),l
		
		for (l=0;l<k;l+=1)	
			string trace=stringfromlist(l,list,";")
			if (wavemax($trace)==0)	
			print nextPath
			print trace
			killwaves/z $cdf+nextPath+":data:S:wave"+num2str(l),$cdf+nextPath+":data:C_raw:wave"+num2str(l), $cdf+nextPath+":data:C:wave"+num2str(l)
			endif
		endfor
		reorder_waves()	
		setdatafolder $cdf+nextPath+":data:C_raw:"
		reorder_waves()
		setdatafolder $cdf+nextPath+":data:C:"
		reorder_waves()	
	endfor
setdatafolder cdf
end
//--------------------------
function reorder_waves() // Asign new sorted names after delting in kill_non_active_cells()
	string	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable 	k=itemsinlist(list, ","),i
	for (i=0;i<k;i+=1)
	string trace=stringfromlist(i,list,",")
	duplicate/o $trace temp
	killwaves $trace
	duplicate/o temp $"wave"+num2str(i)
	endfor
end

