#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
// this is pablo

// This is the code to run the complete analysis/ Tshift is the time shift between the Ca+2 recording
//and the EEG recording. Usually is 10 seconds.  sf is the sampling frequency
function getall(tshift,sf)
	variable tshift,sf
	setdatafolder root:data:C_raw:
	find_peaks2()
	string list=wavelist("wave"+"*",",","")
	variable k=itemsinlist(list, ",")
	sleep_plot((k*2)+2,tshift,sf)//  here is very important to look in the shift between EEG and Ca recording!!! 
	Display /W=(405.75,291.5,1121.25,587)/K=1  ::Sleep:REM,::Sleep:WAKE,::Sleep:NREM,::Sleep:REMWAKE
	setdatafolder root:data:C_raw:
	creategraphs("wave",0)
	setdatafolder root:data:S:
	creategraphs2("wave",0)	
	setdatafolder $"root:data:sleep:"
	Legend/C/N=text0/J/F=0/A=MC/X=30.47/Y=-62.46 "\\s(REM) REM \\s(WAKE) WAKE \\s(NREM) NREM"
	ModifyGraph mode(REM)=7,mode(WAKE)=7,mode(NREM)=7,mode(REMWAKE)=7
	ModifyGraph hbFill(REM)=2,hbFill(WAKE)=2,hbFill(NREM)=2,hbFill(REMWAKE)=2
	ModifyGraph rgb(REM)=(65535,49151,49151),rgb(WAKE)=(49151,65535,49151),rgb(NREM)=(49151,60031,65535),rgb(REMWAKE)=(26205,52428,1)
	ModifyGraph prescaleExp(bottom)=0
	ModifyGraph highTrip(bottom)=100000

	
	
	Label bottom "Time (s)"
	ModifyGraph noLabel(left)=2
	print "hour 1"
	get_stats2(sf,0,3600)
	print "hour 2"
	get_stats2(sf,3600,3600*2)
	print "hour 3"
	get_stats2(sf,3600*2,3600*3)
	
	
	concatenated_sleep(sf)
	getiei(sf)
	//raster_within_episodes()
	raster_within_episodes_not_scaled()
	
end

//========================================

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
		temp="graph"+trace
		Duplicate/O $trace, $temp
		wave twave=$temp
		SetScale/P x 0,0.199203,"", twave
		twave=twave+(i*2)
		AppendToGraph twave		
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
		temp="graph"+trace
		Duplicate/O $trace, $temp
		wave twave=$temp
		SetScale/P x 0,0.199203,"", twave
		twave = (twave[p] < 0.05) ? nan : twave[p]
		twave=twave+(i*2)
		AppendToGraph twave
		ModifyGraph rgb($temp+"#1")=(1,4,52428),marker($temp+"#1")=19,msize($temp+"#1")=1.5,mode($temp+"#1")=3
		
	endfor
end

// This function is to graph both, the raw and deconvolved Ca+2 signal. 
function graphall()
	setdatafolder root:Data:C_raw:
	creategraphs("wave",1)
	setdatafolder root:Data:C:
	creategraphs2("wave",0)
end


//========================================
//This function create the sleep arquitecture wave and calculate sleep stats. This program create a 
// square signal for the sleep stages of amplitude "a". You want "a" to be larger enough to cover the whole are
//of the plot. t is the time shift correctio (def 10 s). sf is the sampling frequency

function sleep_plot(a,t,sf) 
	variable a,t,sf
	// get numpnts
	Print "Time shift was "+num2str(t)+"s"
	setdatafolder root:data:C_raw:
	wave wave0
	variable puntos=numpnts(wave0)+floor(sf*t)

	setdatafolder $"root:data:sleep:"

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
// This function find region where I manually removed artifacts and exclude them from the analysis.

function find_artifacts()
	setdatafolder root:data:C_raw:
	execute "duplicate/o wave0 artifact"
	wave artifact
	artifact = (artifact[p] ==0) ? 500 : artifact[p]
	artifact = (artifact[p] <499) ? 0 : artifact[p]
	artifact=artifact/500
	execute "duplicate/o artifact  root:data:S:artifact"
	killwaves :artifact

end

//========================================
// Get avg amp and frequency for each sleep episode and for each cell. The code is used here is very stupid
//and hardwear consuming... but it's working as it should so..../ sf is the sampling frequency
function get_stats(sf)
variable sf
	find_artifacts()
	setdatafolder "root:data:S:"
	duplicate/o $"root:data:Sleep:NREM", root:data:S:NREM
	duplicate/o $"root:data:Sleep:REM", root:data:S:REM
	duplicate/o $"root:data:Sleep:WAKE", root:data:S:WAKE
	duplicate/o $"root:data:Sleep:M", root:data:S:M
	duplicate/o $"root:data:Sleep:REMWAKE", root:data:S:REMWAKE
	

	string list=wavelist("wave*",",",""),trace
	variable k=itemsinlist(list, ","),i,l
	
	duplicate/o root:data:S:WAKE temp
	integrate temp
	Print "Total wake time: "+num2str(wavemax(temp)/(2*K+2))
	duplicate/o root:data:S:REMWAKE temp
	integrate temp	
	Print "Total REMWAKE time: "+num2str(wavemax(temp)/(2*K+2))	
	duplicate/o root:data:S:NREM temp
	integrate temp	
	Print "Total NREM time: "+num2str(wavemax(temp)/(2*K+2))	
	duplicate/o root:data:S:REM temp
	integrate temp	
	Print "Total REM time: "+num2str(wavemax(temp)/(2*K+2))
	Print "================================="	

	
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
	print "                                            "
	print "    FORMAT   "

	print "W#events|WTime|Wamplitude|Warea...NREM....REM"
	print "======================================================="
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
	
	
		for (l=0;l<(numpnts($trace));l+=1)
		

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
			
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
			duplicate/o root:Data:Sleep:REM rems
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
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
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
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
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
			
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
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
	

		print EW,WT,WAKEA[i],WAKEAUC[i],ERW,RWT,REMWAKEA[i],REMWAKEAUC[i],EN,NT,NREMA[i],NREMAUC[i],ER,RT,REMA[i],REMAUC[i]
	
	endfor

end





// This funciton calculate stats per hour. 

function get_stats2(sf,st,ft) // starting time and finishing time in seconds
variable sf,st,ft
	find_artifacts()
	setdatafolder "root:data:S:"
	duplicate/o $"root:data:Sleep:NREM", root:data:S:NREM
	duplicate/o $"root:data:Sleep:REM", root:data:S:REM
	duplicate/o $"root:data:Sleep:WAKE", root:data:S:WAKE
	duplicate/o $"root:data:Sleep:M", root:data:S:M
	duplicate/o $"root:data:Sleep:REMWAKE", root:data:S:REMWAKE
	

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
	print "                                            "
	print "    FORMAT   "

	print "W#events|WTime|Wamplitude|Warea...NREM....REM"
	print "======================================================="
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
			
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
			duplicate/o root:Data:Sleep:REM rems
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
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
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
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
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
			
			
			duplicate/o $"root:Data:C:wave"+num2str(i) temporal	
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
	

		print EW,WT,WAKEA[i],WAKEAUC[i],ERW,RWT,REMWAKEA[i],REMWAKEAUC[i],EN,NT,NREMA[i],NREMAUC[i],ER,RT,REMA[i],REMAUC[i]
	
	endfor

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

//========================================
// This function create a event raster plot after concatenating WAKE, NREM and REM episodes, respectevely. 
//Run this after get_stats() function

Function concatenated_sleep(sf)
	variable sf
	setdatafolder "root:data:S:"

	string list=wavelist("wave*",",",""),trace
	wave wave0,REM,NREM,WAKE,artifact,M
	variable k=itemsinlist(list, ","),i,l,n=numpnts(wave0)
	make/o/n=1 WAKE_concatenated
	variable wake_count,wake_tT
	make/o/n=1 NREM_concatenated
	variable NREM_count,NREM_tT
	make/o/n=1 REM_concatenated
	variable REM_count,REM_tT


	for (i=0;i<n;i+=1)
		if (artifact[i]==0 && M[i]==0)	
			if (WAKE[i]>0)
				for (l=0;l<k;l+=1)
					trace=stringfromlist(l,list,",")
					wave temp=$trace
					if (temp[i]>0) // if this is true then there is a calcium event
						WAKE_concatenated[wake_count]=WAKE_tT
						wake_count=wake_count+1
						InsertPoints numpnts(WAKE_concatenated),1, WAKE_concatenated
					endif
				endfor		
				WAKE_tT=WAKE_tT+1/sf //this is the WAKE time integrator	
			else 	
				if (NREM[i]>0)
					for (l=0;l<k;l+=1)
						trace=stringfromlist(l,list,",")
						wave temp=$trace
						if (temp[i]>0) // if this is true then there is a calcium event
							NREM_concatenated[NREM_count]=NREM_tT
							NREM_count=NREM_count+1
							InsertPoints numpnts(NREM_concatenated),1, NREM_concatenated
						endif
					endfor		
					NREM_tT=NREM_tT+1/sf //this is the WAKE time integrator	
				else
					if (REM[i]>0)
						for (l=0;l<k;l+=1)
							trace=stringfromlist(l,list,",")
							wave temp=$trace
							if (temp[i]>0) // if this is true then there is a calcium event
								REM_concatenated[REM_count]=REM_tT
								REM_count=REM_count+1
								InsertPoints numpnts(REM_concatenated),1, REM_concatenated
							endif
						endfor		
						REM_tT=REM_tT+1/sf //this is the WAKE time integrator		
					endif
				endif
			endif
		endif
	endfor	
	deletepoints numpnts(WAKE_concatenated)-1,1, WAKE_concatenated
	deletepoints numpnts(NREM_concatenated)-1,1, NREM_concatenated
	deletepoints numpnts(REM_concatenated)-1,1, REM_concatenated

	duplicate /o WAKE_concatenated WAKE_concatenated_scale
	//WAKE_concatenated_scale=WAKE_concatenated_scale/WAKE_tT
	SetScale/I x 0,1,"", WAKE_concatenated_scale
	duplicate /o NREM_concatenated NREM_concatenated_scale
	//NREM_concatenated_scale=NREM_concatenated_scale/NREM_tT
	SetScale/I x 0,1,"", NREM_concatenated_scale
	duplicate /o REM_concatenated REM_concatenated_scale
	//REM_concatenated_scale=REM_concatenated_scale/REM_tT
	SetScale/I x 0,1,"", REM_concatenated_scale
	// plot stuff
	Display/K=1 root:data:S:WAKE_concatenated_scale
	ModifyGraph swapXY=1
	ModifyGraph mode=3,marker=19,rgb(WAKE_concatenated_scale)=(0,0,0)
	AppendToGraph root:data:S:NREM_concatenated_scale
	ModifyGraph mode=3,marker=19,rgb(NREM_concatenated_scale)=(1,4,52428)
	AppendToGraph root:data:S:REM_concatenated_scale
	ModifyGraph mode=3,marker=19,rgb(REM_concatenated_scale)=(65535,0,0)
	Label bottom "Time (s) ";DelayUpdate
	Label left "Event #"
	Legend/C/N=text0/J/A=MC "\\s(WAKE_concatenated_scale) WAKE\r\\s(NREM_concatenated_scale) NREM\r\\s(REM_concatenated_scale) REM"

end


//==============================================================================
// This script find peaks in the deconvolved signal C, results are saved in the S folder.
// From 200608 this is modified to ignore peack inside a Ca+2 event (this was done by smoothing)
function find_peaks()
	setdatafolder root:data:C:
	string list=wavelist("wave*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l
	for (i=0;i<k;i+=1)	
		
		Wave w=$stringfromlist(i,list,",")		// peak data 
		duplicate/o w test
		smooth 20, test // this avoidedetecting spikes inside Ca+2 events.  
		variable maxPeaks=1000000,threshold=0.001
		Make/O/N=(maxPeaks) peakPositionsX= NaN, peakPositionsY= NaN    
		Variable peaksFound=0
		Variable startP=0
		Variable endP= DimSize(w,0)-1
		do
			FindPeak/P/M=(threshold)/Q/R=[startP,endP] test
			// FindPeak outputs are V_Flag, V_PeakLoc, V_LeadingEdgeLoc,
			// V_TrailingEdgeLoc, V_PeakVal, and V_PeakWidth. 
			if( V_Flag != 0 )
				break
			endif
    
			peakPositionsX[peaksFound]=round(V_PeakLoc)//pnt2x(w,V_PeakLoc)
			peakPositionsY[peaksFound]=V_PeakVal
			peaksFound += 1
    
			startP= V_TrailingEdgeLoc+1
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
		duplicate/o temp $"root:data:S:"+stringfromlist(i,list,",")	
	endfor
end

//==============================================================================
// 180608. This code is used to create tha raster plot by overlaping W,N and R episode. This is to see weather
// there is a frequency modulation inside wake and sleep episode. This Code bin data. So currently is
//not being used. 
function raster_within_episodes()

	variable bin=100,binplus
	binplus=bin+1

	setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0
	make/o/n=0 tempperiod
	make/o/n=0 tempspike
	make/o/n=(binplus) Twake=0,wakeHIST=0
	make/o/n=(binplus) TNREM=0,NREMHIST=0
	make/o/n=(binplus) TREM=0,REMHIST=0
	
	InsertPoints numpnts(WAKE),1,WAKE
	InsertPoints numpnts(NREM),1,NREM
	InsertPoints numpnts(REM),1,REM
	
	do
		make/o/n=0 tempperiod
		make/o/n=0 tempspike
		
		if(M[i]>0)
			i+=1
		else
		
			if (WAKE[i]>0)
				do	
					InsertPoints inf,1, tempperiod
					InsertPoints inf,1, tempspike
					if(artifact[i]==1)
						tempperiod[inf]=0
						i+=1
					else
						tempperiod[inf]=1
						tempspike[inf]=hist[i]
						i+=1
					endif	
					
				while (WAKE[i]>0)
				integrate tempspike
				SetScale/I x 0,1,"", tempperiod,tempspike
				Twake[0]+=tempperiod(0)
				for (j=1;j<binplus;j+=1)	
					Twake[j]=Twake[j]+tempperiod[x2pnt(tempperiod,(1/bin)*j)]
					wakeHIST[j]=wakeHIST[j]+tempspike[x2pnt(tempspike,(1/bin)*j)]-tempspike[x2pnt(tempspike,(1/bin)*(j-1))]
				endfor
			
			else
				//________________________________________________________________________
		
				if (NREM[i]>0)
					do	
						InsertPoints inf,1, tempperiod
						InsertPoints inf,1, tempspike
						if(artifact[i]==1)
							tempperiod[inf]=0
							i+=1
						else
							tempperiod[inf]=1
							tempspike[inf]=hist[i]
							i+=1
						endif	
					
					while (NREM[i]>0)
					integrate tempspike
					SetScale/I x 0,1,"", tempperiod,tempspike
					TNREM[0]+=tempperiod(0)
					for (j=1;j<binplus;j+=1)	
						TNREM[j]=TNREM[j]+tempperiod[x2pnt(tempperiod,(1/bin)*j)]
						NREMHIST[j]=NREMHIST[j]+tempspike[x2pnt(tempspike,(1/bin)*j)]-tempspike[x2pnt(tempspike,(1/bin)*(j-1))]
					endfor
			
				else
					//________________________________________________________________________
		
					if (REM[i]>0)
						do	
							InsertPoints inf,1, tempperiod
							InsertPoints inf,1, tempspike
							if(artifact[i]==1)
								tempperiod[inf]=0
								i+=1
							else
								tempperiod[inf]=1
								tempspike[inf]=hist[i]
								i+=1
							endif	
					
						while (REM[i]>0)
						integrate tempspike
						SetScale/I x 0,1,"", tempperiod,tempspike
						TREM[0]+=tempperiod(0)
						for (j=1;j<binplus;j+=1)	
							TREM[j]=TREM[j]+tempperiod[x2pnt(tempperiod,(1/bin)*j)]
							REMHIST[j]=REMHIST[j]+tempspike[x2pnt(tempspike,(1/bin)*j)]-tempspike[x2pnt(tempspike,(1/bin)*(j-1))]
						endfor
			
					endif
				endif
			endif
			i+=1
		endif
	while (i<puntos)
	
	make/o/n=(bin) Inside_wake
	Inside_wake=wakeHIST/(k*Twake)
	
		
	make/o/n=(bin) Inside_NREM
	Inside_NREM=NREMHIST/(k*TNREM)
	
	make/o/n=(bin) Inside_REM
	Inside_REM=REMHIST/(k*TREM)
			
	Inside_wake= (Inside_wake==0) ? nan : Inside_wake[p]
	Inside_NREM= (Inside_NREM==0) ? nan : Inside_NREM[p]
	Inside_REM= (Inside_REM==0) ? nan : Inside_REM[p]
	SetScale/I x 0,1,"", Inside_wake,Inside_NREM,Inside_REM
			
	deletePoints numpnts(WAKE)-1,1,WAKE
	deletePoints numpnts(NREM)-1,1,NREM
	deletePoints numpnts(REM)-1,1,REM
			
	//_________________________________________________________________
	Display/K=1 root:data:S:Inside_wake
	ModifyGraph/Z gbRGB=(57346,65535,49151)
	ModifyGraph mode=3,marker=19,msize=1
	ModifyGraph lowTrip(left)=0.01;DelayUpdate
	Label left "Calcium event Probability";DelayUpdate
	Label bottom "Scaled Time"
	CurveFit/q/M=2/W=0 line, Inside_wake/D
	ModifyGraph rgb(Inside_WAKE)=(0,0,0)

	Display/K=1 root:data:S:Inside_NREM
	ModifyGraph/Z gbRGB=(49151,60031,65535)
	ModifyGraph mode=3,marker=19,msize=1
	ModifyGraph lowTrip(left)=0.01;DelayUpdate
	Label left "Calcium event Probability";DelayUpdate
	Label bottom "Scaled Time"
	CurveFit/q/M=2/W=0 line, Inside_NREM/D
	ModifyGraph rgb(Inside_NREM)=(0,0,0)

	Display/K=1 root:data:S:Inside_REM
	ModifyGraph/Z gbRGB=(65535,49151,49151)
	ModifyGraph mode=3,marker=19,msize=1
	ModifyGraph lowTrip(left)=0.01;DelayUpdate
	Label left "Calcium event Probability";DelayUpdate
	Label bottom "Scaled Time"
	CurveFit/q/M=2/W=0 line, Inside_REM/D
	ModifyGraph rgb(Inside_REM)=(0,0,0)
	
end

// I dont rember what is the purporse of this function.


function conc_stats()
	string temp="WAKE_concatenated_scale"
	wave twave=$temp
	duplicate/o $temp line
	line=1*x
	variable n=numpnts(line)
	Make/N=(n)/O D_value;DelayUpdate
	D_value=abs(line-twave)
	variable D=wavemax(D_value),i
	make/o/n=1000000 D_P
	for (i=0;i<1000000;i+=1)
		D_P[i]=(sqrt(-0.5*ln((1-i*0.000001)/2)))/sqrt(n)

	endfor
	SetScale/I x 0,1,"", D_P
	display D_P
	print D
	findlevel/q D_P, D
	print 1-V_LevelX

end
// I dont rember what is the purporse of this function.
function conc_stats_random()
	variable sim=10000

	string temp="WAKE_concatenated_scale"
	wave twave=$temp
	duplicate/o $temp line
	duplicate/o $temp random
	SetScale/I x 0,1,"", line
	SetScale/I x 0,1,"", random
	line=1*x
	variable n=numpnts($temp)
	duplicate/o $temp D_value
	D_value=(line-twave)
	integrate D_value
	random=0
	variable D=D_value[inf],i,s

	make/o/n=(sim) D_P
	for (s=0;s<sim;s+=1)
		for (i=0;i<n;i+=1)
			random[i]=enoise(0.5)+0.5
		endfor
		sort random random
		random=line-random
		integrate random
		D_P[s]=(random[inf])
	endfor
	Make/N=1000/O D_P_Hist;DelayUpdate
	Histogram/B=1 D_P,D_P_Hist;DelayUpdate
	K0 = 0;
	CurveFit/q/M=2/W=0 gauss, D_P_Hist/D
	wave fit_D_P_Hist
	variable wmax=wavemax(fit_D_P_Hist)
	D_P_Hist=D_P_Hist/wmax
	fit_D_P_Hist=fit_D_P_Hist/wmax
	Display/K=1 root:Data:S:D_P_Hist
	ModifyGraph rgb=(0,0,0)
	ModifyGraph lowTrip(bottom)=0.001
	AppendToGraph root:Data:S:fit_D_P_Hist
	print "Integrated D calue is: "+num2str(D)
	wave W_coef
	print "and the probability of randomly observing a value equal or greater than this one is: "+num2str((W_coef[0]+W_coef[1]*exp(-((D-W_coef[2])/W_coef[3])^2))/wmax)
end


//========================================================================================================

function analyze_concatenated()
	wave WAKE_concatenated

	Make/N=600/O WAKE_concatenated_Hist;DelayUpdate
	Histogram/P/B={0,10,600} WAKE_concatenated,WAKE_concatenated_Hist;DelayUpdate
end

function random_concatenated()
	string wavenam="WAKE_concatenated_scaled"
	wave wavy =$wavenam
	variable sim=1000,n=numpnts(wavy),s,i
	duplicate/o wavy intervals
	duplicate/o wavy random
	duplicate/o wavy line
	line=1*x
	random=0
	differentiate/P intervals
	make/o/n=(sim) D_P
	for (s=0;s<sim;s+=1)
		for (i=0;i<n;i+=1)
			random[i]=intervals(enoise(0.5)+0.5)
		endfor
		integrate random
		variable m=wavemax(random)
		random=random/m
		random=abs(random-line)
		D_P[s]=wavemax(random)
	endfor
	Make/N=10000/O D_P_Hist;DelayUpdate
	Histogram/CUM/P/B=1 D_P,D_P_Hist;DelayUpdate
	display D_P_Hist
	duplicate/o $wavenam temp
	temp=abs(temp-line)
	variable D_Observed=wavemax(temp)
	print D_Observed
	print "the probability for "+wavenam+" is: "+num2str(1-D_P_Hist(D_observed))

end

//========================================================================================================
// This comperes the Ca+2 event distribution between cells. Useful to find outliers. This create a square 
//plot with a heatmap code representing the chi-squred value for the comparison of all pairs of cells/ 

Function Cell_index()

	string list=wavelist("wave"+"*",",",""),trace1,trace2
	variable row=itemsinlist(list, ",")
	variable column=row,c,r

	make/o /n=(row,column) Index=0
	make/o /n=(row) Avg_Index=0
	for (r=0;r<row;r+=1)
		variable suma=0
		for (c=0;c<column;c+=1)
			trace1=stringfromlist(r,list,",")
			trace2=stringfromlist(c,list,",")
			duplicate/o $trace1 temp1
			duplicate/o $trace2 temp2
			temp1=(temp1[p]>0) ? 1 : temp1[p]
			temp2=(temp2[p]>0) ? 1 : temp2[p]
			integrate temp1
			integrate temp2
			variable n1=temp1[inf],n2=temp2[inf]
			temp1=temp1/n1
			temp2=temp2/n2
			duplicate/o temp1 diff
			diff=abs(temp1-temp2)
			variable D=wavemax(diff)
			variable Chi=4*D^2*((n1*n2)/(n1+n2))
			Index[r][c]=Chi	
			suma=suma+chi
		endfor	
		Avg_Index[r]=suma/(row-1)
	endfor
	NewImage/K=0 root:Data:S:Index
	ModifyGraph width={Plan,1,top,left}, margin(right)=100
	ColorScale/N=text0/X=107.50/Y=0.00
	SetScale d, 0, 0, "Chi square", Index
	Label left "Cell #";DelayUpdate
	Label top "Cell #"
	ModifyImage Index ctab= {*,*,YellowHot,0}
	Duplicate/o Avg_Index Sort_index
	sort/R Sort_index Sort_index
	Display/K=0 root:Data:S:Sort_index
	ModifyGraph mode=3,marker=19
	Label left "Chi-square";DelayUpdate
	Label bottom "Sorted cell index"
end


//========================================================================================================

// Create confidence intervals by using a binomial estimations of firing probability and bootstraping cells

function createCI()

	wave wave0,wave1,wave2,wave3,wave4,wave5
	variable wt,nt,rt,we,ne,re
	wave WakeT
	if (Waveexists(wakeT)==0)
		movewave wave0 WakeT
		movewave wave1 NREMT
		movewave wave2 REMT
		movewave wave3 WakeE
		movewave wave4 NREME
		movewave wave5 REME
	endif
	wave WakeT,NREMT,REMT,WakeE,NREME,REME
	
	duplicate/o WakeT test
	integrate test
	wt=test(inf)
	duplicate/o NREMT test
	integrate test
	nt=test(inf)
	duplicate/o REMT test
	integrate test
	rt=test(inf)
	duplicate/o WakeE test
	integrate test
	we=test(inf)
	duplicate/o NREME test
	integrate test
	ne=test(inf)
	duplicate/o REME test
	integrate test
	re=test(inf)
	
	
	variable sim=10000

	variable i,n=numpnts(WakeT),randnum,s
	make/o/n=(sim) wakeP,NREMP,REMP

	for (s=0;s<sim;s+=1)
		variable WakeTR=0,NREMTR=0,REMTR=0,WakeER=0,NREMER=0,REMER=0
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			WakeTR=WakeTR+WakeT[randnum]
			NREMTR=NREMTR+NREMT[randnum]
			REMTR=REMTR+REMT[randnum]
			WakeER=WakeER+WakeE[randnum]
			NREMER=NREMER+NREME[randnum]
			REMER=REMER+REME[randnum]
		endfor
		wakeP[s]=WakeER/WakeTR
		NREMP[s]=NREMER/NREMTR
		REMP[s]=REMER/REMTR
	endfor
	sort wakeP wakeP
	sort NREMP NREMP
	sort REMP REMP

	variable CI95=(0.223606798/2)*sim,CI_MC95=(0.223606798/6)*sim
	print "wake CI is: "
	print "NREM CI is: "
	print "NREM CI is: "
	print num2str(we/wt)+" "+num2str(wakep(sim-CI95))+" "+num2str(wakep(CI95))
	print num2str(ne/nt)+" "+num2str(NREMp(sim-CI95))+" "+num2str(NREMp(CI95))
	print num2str(re/rt)+" "+num2str(REMp(sim-CI95))+" "+num2str(REMp(CI95))
	Print "For multiples comparision[MC]"
	print "wake CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print num2str(we/wt)+" "+num2str(wakep(sim-CI_MC95))+" "+num2str(wakep(CI_MC95))
	print num2str(ne/nt)+" "+num2str(NREMp(sim-CI_MC95))+" "+num2str(NREMp(CI_MC95))
	print num2str(re/rt)+" "+num2str(REMp(sim-CI_MC95))+" "+num2str(REMp(CI_MC95))
	print " ''WARNING! use createCI2() instad to create a CI of the difference'' "

end

function createCIt2()

	wave wave0,wave1,wave2,wave3,wave4,wave5
	variable wt,nt,rt,we,ne,re
	wave waket2
	if (Waveexists(waket2)==0)
		movewave wave0 waket2
		movewave wave1 nremt2
		movewave wave2 remt2
		movewave wave3 wakeE2
		movewave wave4 nremE2
		movewave wave5 remE2
	endif
	wave waket2,nremt2,remt2,wakeE2,nremE2,remE2
	
	duplicate/o waket2 test
	integrate test
	wt=test(inf)
	duplicate/o nremt2 test
	integrate test
	nt=test(inf)
	duplicate/o remt2 test
	integrate test
	rt=test(inf)
	duplicate/o wakeE2 test
	integrate test
	we=test(inf)
	duplicate/o nremE2 test
	integrate test
	ne=test(inf)
	duplicate/o remE2 test
	integrate test
	re=test(inf)
	
	
	variable sim=10000

	variable i,n=numpnts(waket2),randnum,s
	make/o/n=(sim) wakeP,NREMP,REMP

	for (s=0;s<sim;s+=1)
		variable waket2R=0,nremt2R=0,remt2R=0,wakeE2R=0,nremE2R=0,remE2R=0
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			waket2R=waket2R+waket2[randnum]
			nremt2R=nremt2R+nremt2[randnum]
			remt2R=remt2R+remt2[randnum]
			wakeE2R=wakeE2R+wakeE2[randnum]
			nremE2R=nremE2R+nremE2[randnum]
			remE2R=remE2R+remE2[randnum]
		endfor
		wakeP[s]=wakeE2R/waket2R
		NREMP[s]=nremE2R/nremt2R
		REMP[s]=remE2R/remt2R
	endfor
	sort wakeP wakeP
	sort NREMP NREMP
	sort REMP REMP

	variable CI95=(0.23606798/2)*sim,CI_MC95=(0.23606798/6)*sim
	print "wake CI is: "
	print "NREM CI is: "
	print "NREM CI is: "
	print num2str(we/wt)+" "+num2str(wakep(sim-CI95))+" "+num2str(wakep(CI95))
	print num2str(ne/nt)+" "+num2str(NREMp(sim-CI95))+" "+num2str(NREMp(CI95))
	print num2str(re/rt)+" "+num2str(REMp(sim-CI95))+" "+num2str(REMp(CI95))
	Print "For multiples comparision[MC]"
	print "wake CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print num2str(we/wt)+" "+num2str(wakep(sim-CI_MC95))+" "+num2str(wakep(CI_MC95))
	print num2str(ne/nt)+" "+num2str(NREMp(sim-CI_MC95))+" "+num2str(NREMp(CI_MC95))
	print num2str(re/rt)+" "+num2str(REMp(sim-CI_MC95))+" "+num2str(REMp(CI_MC95))
	print " ''WARNING! use createCI2() instad to create a CI of the difference'' "

end

function createblockCI()

	// Create confidence intervals by using a binomial estimations of firing probability and bootstraping cells.
	// In this casae bootstrap is weighted by the number of cells in each mice. Thus, mice with more cells
	//will weight more than mice with less cells.
	//wave 6 must include a list representing the mouse group. 

	wave wave0,wave1,wave2,wave3,wave4,wave5,wave6
	variable wt,nt,rt,we,ne,re
	
	wave mouse
	if (Waveexists(mouse)==0)
		movewave wave0 mouse
		movewave wave1 WakeT
		movewave wave2 NREMT
		movewave wave3 REMT
		movewave wave4 WakeE
		movewave wave5 NREME
		movewave wave6 REME
	endif
	
	wave WakeT,NREMT,REMT,WakeE,NREME,REME,mouse
	
	duplicate/o WakeT test
	integrate test
	wt=test(inf)
	duplicate/o NREMT test
	integrate test
	nt=test(inf)
	duplicate/o REMT test
	integrate test
	rt=test(inf)
	duplicate/o WakeE test
	integrate test
	we=test(inf)
	duplicate/o NREME test
	integrate test
	ne=test(inf)
	duplicate/o REME test
	integrate test
	re=test(inf)
	
	
	variable sim=10000

	variable i,n=numpnts(WakeT),randnum,s,rmice,rcell
	
	variable micenum=mouse(inf)
	
	
	make/o/n=(sim) wakeP,NREMP,REMP,R2NratioP

	for (s=0;s<sim;s+=1)
	
		variable WakeTR=0,NREMTR=0,REMTR=0,WakeER=0,NREMER=0,REMER=0
		for (i=0;i<n;i+=1)
			rmice=ceil((enoise(0.5)+0.5)*micenum)
			
			variable levels=binarysearch(mouse,rmice)-binarysearch(mouse,rmice-1)

			rcell=ceil((enoise(0.5)+0.5)*levels)
			findvalue/V=(rmice) mouse						
			randnum=V_value+rcell-1
			
			
			WakeTR=WakeTR+WakeT[randnum]
			NREMTR=NREMTR+NREMT[randnum]
			REMTR=REMTR+REMT[randnum]
			WakeER=WakeER+WakeE[randnum]
			NREMER=NREMER+NREME[randnum]
			REMER=REMER+REME[randnum]
		endfor
		wakeP[s]=WakeER/WakeTR
		NREMP[s]=NREMER/NREMTR
		REMP[s]=REMER/REMTR
		R2NratioP[s]=(REMER/REMTR)/(NREMER/NREMTR)
	endfor
	sort wakeP wakeP
	sort NREMP NREMP
	sort REMP REMP
	sort R2NratioP R2NratioP

	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/6)*sim
	print "wake CI is: "
	print "NREM CI is: "
	print "REM CI is: "
	print num2str(we/wt*60)+" "+num2str(60*wakep(sim-CI95))+" "+num2str(60*wakep(CI95))
	print num2str(ne/nt*60)+" "+num2str(60*NREMp(sim-CI95))+" "+num2str(60*NREMp(CI95))
	print num2str(re/rt*60)+" "+num2str(60*REMp(sim-CI95))+" "+num2str(60*REMp(CI95))
	Print "For multiples comparision[MC]"
	print "wake CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print "REM CI MC corrected (3) is: "
	print num2str(we/wt*60)+" "+num2str(60*wakep(sim-CI_MC95))+" "+num2str(60*wakep(CI_MC95))
	print num2str(ne/nt*60)+" "+num2str(60*NREMp(sim-CI_MC95))+" "+num2str(60*NREMp(CI_MC95))
	print num2str(re/rt*60)+" "+num2str(60*REMp(sim-CI_MC95))+" "+num2str(60*REMp(CI_MC95))
	print num2str((re/rt)/(ne/nt))+" "+num2str(R2NratioP(sim-CI_MC95))+" "+num2str(R2NratioP(CI_MC95))


end


//==========================================================================
// This calculate CI according to poisson distribution. This asume that the firing probability is
// homogenous across the recording. Prefer Bootstrap method over this one to create CI. 
function poissonCI(x,k,alpha)
	variable x,k,alpha   //x = sample points, k= observed events, aplha= type I error
	variable i
	make/n=(x)/o probability
	variable switchi=0
	if (k==0)
		K=x
		switchi=1
	endif	

	for (i=0;i<x;i+=1)
		probability[i]=exp(k*ln(i)-i-gammln(k+1, 10^-80))
	endfor
	duplicate/o probability raw
	integrate probability
	variable maxi=wavemax(probability)
	probability=probability/maxi
	SetScale/P x 0,(1/x),"", probability
	
	if (switchi==0)
		print "P :"+num2str(k/x)
		print "upper lim: "+num2str(leftx(probability)+deltax(probability)*binarysearchinterp(probability,1-(alpha/2)))
		print "bellow lim: "+num2str(leftx(probability)+deltax(probability)*binarysearchinterp(probability,alpha/2))
	else
		print "P :"+num2str(0)
		print "upper lim: "+num2str((leftx(probability)+deltax(probability)*binarysearchinterp(probability,alpha)))
		print "bellow lim: 0"
	endif
end
// not used, create CI using a Poisson aprox.


// Used to calculate z-score in paried analysis.

function get_z_score()
	wave wave0,wave1,wave2,wave3

	if (Waveexists(wave0)==1)
		movewave wave0 waketBL
		movewave wave1 wakecountBL
		movewave wave2 waketAL
		movewave wave3 wakecAL
	endif
	wave waketBL,wakecountBL,waketAL,wakecAL
	variable n=numpnts(waketBL),i,z
	make/o/n=(n,1) z_value=1
	for (i=0;i<n;i+=1)
		z_value[i][0]=BL_AL_P(wakecountBL[i],waketBL[i],wakecAL[i],waketAL[i])
	endfor
	duplicate/o z_value z_value_no_sort
	sort/r z_value z_value
	NewImage/K=0 z_value
	ModifyGraph swapXY=1
	SetAxis/A/R right
	ModifyGraph nticks(right)=5,sep(right)=100
	ColorScale/N=text0/X=30/Y=0.00
	ColorScale/C/N=text0 nticks=20,logLTrip=0.1
	ColorScale/C/N=text0 " Z-Sore"
	ModifyImage z_value ctab= {-10,10,RedWhiteBlue256,1}
end






// Calculate Z-value for each neuron. Used in get Z-score.

Function BL_AL_P(x1,s1,x2,s2)
	variable x1,x2,s1,s2
	variable p1,p2,pc,pg,sc,sg,zmulti=1  //pc pchico  pg pgrande
	p1=x1/s1
	p2=x2/s2
	variable z=0,CIchico,CIgrande,diff,P
	if (p1>p2) //BL is bigger than AL
		zmulti=-1
		pc=p2
		sc=s2
		Pg=p1
		sg=s1
	else
		zmulti=1
		pc=p1
		sc=s1
		Pg=p2
		sg=s2
	endif
	do 
		z=z+0.001
		if (pc==0)
			P = exp(-0.717*z-0.416*z^2)
			CIchico=-ln(P)/sc
		else
			CIchico=((pc+z^2/(2*sc))/(1+z^2/sc))+(z/(1+z^2/sc))*sqrt(((pc*(1-pc))/sc)+z^2/(4*sc^2))
		endif
		if (pg==0)
			P = exp(-0.717*z-0.416*z^2)
			CIgrande=-ln(P)/sg
		else
			CIgrande=((pg+z^2/(2*sg))/(1+z^2/sg))-(z/(1+z^2/sg))*sqrt(((pg*(1-pg))/sg)+z^2/(4*sg^2))
		endif
		
		if(z>100)
			CIgrande=CIgrande
			z=100
		endif
		diff=CIgrande-CIchico
	while(diff>0.000001)
	return z*zmulti
end



// Basically remove from the analisis everithing that is labeled as an artifact in wave named
// "artifact" 
function remove_motion_artifact()
	wave artifact
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l
	for (i=0;i<k;i+=1)	
		string trace=stringfromlist(i,list,",")
		wave temp=$trace
		temp=temp/100
		for (l=0;l<numpnts(temp);l+=1)
			if (artifact[l]==1)
				temp[l]=0
			endif	
			
	
		endfor
	endfor

end


// This compare the frequency befor and after a a rem period defined by "rs" and "re" 

function peri(rs,re,sf) // rem start, rem ends (in points, not seconds), sf is sampling frequency
	variable rs, re,sf
	print                      "STRUCTURE"
	print   "BLOCK2 ||  BLOCK1  ||  REM || BLOCK3 || BLOCK4"
	variable shift=50 

	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l
	variable lo,block
	wave REM,NREM

	
	for (i=0;i<k;i+=1)
		variable checkpoint,pt =0,rt=0
	
		variable sb1=0,sb2=0,sr=0,sb3=0,sb4=0
	
	
		string trace=stringfromlist(i,list,",")
		wave temp=$trace
	
		
		
		// for block 1================================
		block=shift*sf	
		for (lo=0;lo<block;lo+=1)  
			if (NREM[rs-lo]>0)  // if this is NREM
				pt=pt+1
				if(temp[rs-lo]>0)
					sb1=sb1+1
				endif
			else
				block=block+1  // if not NREM, ignore and keep counting
			endif
		endfor	
		
		
		// for block 2================================	
		checkpoint =block+1
		pt=0
		for (lo=checkpoint;lo<block+shift*sf;lo+=1)  
			if (NREM[rs-lo]>0)  // if this is NREM
				pt=pt+1
				if(temp[rs-lo]>0)
					sb2=sb2+1
				endif
			else
				block=block+1  // if not NREM, ignore and keep counting
			endif
		endfor
		
		// for rem================================	

		for (lo=rs;lo<re;lo+=1)  
			if (REM[lo]>0)  // if this is REM
				rt=rt+1
				if(temp[lo]>0)
					sr=sr+1
				endif
			else
				block=block+1  // if not NREM, ignore and keep counting
			endif
		endfor	
		
		
		
		// for block 3================================
		block=shift*sf	
		for (lo=re;lo<re+block;lo+=1)  
			if (NREM[lo]>0)  // if this is NREM
				pt=pt+1
				if(temp[lo]>0)
					sb3=sb3+1
				endif
			else
				block=block+1  // if not NREM, ignore and keep counting
			endif
		endfor	
		
		
		// for block 4================================	
		checkpoint =block+1
		pt=0
		for (lo=checkpoint;lo<block+shift*sf;lo+=1)  
			if (NREM[lo]>0)  // if this is NREM
				pt=pt+1
				if(temp[lo]>0)
					sb4=sb4+1
				endif
			else
				block=block+1  // if not NREM, ignore and keep counting
			endif
		endfor						
		
		
		print sb2, sb1,sr,sb3,sb4			
	endfor
	print "REM time is: "+num2str(rt/sf)
end


//================================================================
// I dont rember what is this
function within2()

	variable bin=30000,binplus
	binplus=bin+1

	setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0
	make/o/n=0 tempperiod
	make/o/n=0 tempspike
	make/o/n=(binplus) Twake=0,wakeHIST=0
	make/o/n=(binplus) TNREM=0,NREMHIST=0
	make/o/n=(binplus) TREM=0,REMHIST=0

	variable lo=0
	do
		
		if(M[i]>0)
			i+=1
		endif
		
		if (WAKE[i]>0)
			lo=0
			make/o/n=(bin) tempperiod=0
			make/o/n=(bin) tempspike=0
			do
				if(artifact[i]==1)
					tempperiod[lo]=0
					i+=1
				else
					tempperiod[lo]=1
					tempspike[lo]=hist[i]
					i+=1
				endif
				lo+=1	
				
				if(M[i]>0)
					do
						i+=1
					while (M[i]>0)	
				endif		
			while (WAKE[i]>0)
			Twake=Twake+tempperiod
			wakeHIST=wakeHIST+tempspike

		endif
			
			
		//________________________________________________________________________
		
		
		if (NREM[i]>0)
			lo=0
			make/o/n=(bin) tempperiod=0
			make/o/n=(bin) tempspike=0
			do
				if(artifact[i]==1)
					tempperiod[lo]=0
					i+=1
				else
					tempperiod[lo]=1
					tempspike[lo]=hist[i]
					i+=1
				endif
				lo+=1	
				
				if(M[i]>0)
					do
						i+=1
					while (M[i]>0)	
				endif		
			while (NREM[i]>0)
			TNREM=TNREM+tempperiod
			NREMHIST=NREMHIST+tempspike

		endif
		//________________________________________________________________________
		
				
		if (REM[i]>0)
			lo=0
			make/o/n=(bin) tempperiod=0
			make/o/n=(bin) tempspike=0
			do
				if(artifact[i]==1)
					tempperiod[lo]=0
					i+=1
				else
					tempperiod[lo]=1
					tempspike[lo]=hist[i]
					i+=1
				endif
				lo+=1	
				
				if(M[i]>0)
					do
						i+=1
					while (M[i]>0)	
				endif		
			while (REM[i]>0)
			TREM=TREM+tempperiod
			REMHIST=REMHIST+tempspike

		endif
		i+=1

	while (i<puntos)
end


//==============================================================
// Not used any more. Is to exclude those event with amplitude smaller to 3SD of the calculated from a window
// of 300 points.

function clean_events()
	variable window_size=300
	string list,trace,temp
	variable k,i,r
	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	variable sp,fp
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		for (r=0;r<numpnts($trace);r+=1)
			if (twave[r]>0)
				sp=r-window_size
				fp=r+window_size
			
				if (sp<0)
					sp=0
				endif
			
				if(fp>numpnts($trace))
					fp=numpnts($trace)
				endif
				duplicate/o/r=[sp,fp] $"root:Data:C_raw:"+trace temp1
				duplicate/o/r=[sp,fp] $"root:Data:C:"+trace temp2
				wave temp1,temp2
				temp1=temp1-temp2;
				wavestats/q temp1
				variable dummy=V_sdev*3
				variable dummy2=twave[r]
				if(twave[r]<V_sdev*3)
					twave[r]=0
				endif
			endif	
		endfor
	endfor
end

//======================================================
// This was used when comparing 0-3h recording with a not matching 3-6h recording. I hypothetized
//that any event appearing in the no corresponding file will be considered an error. Use to stimate
// the amount of false positives when concatenating files. 

function get_error(sf)
variable sf
	string list,trace,temp
	variable k,i,r
	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	variable prep,postp,fp,frerror,tp,frtrue
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		prep=0
		postp=0
		for (r=0;r<numpnts($trace)/2;r+=1)
			if (twave[r]>0)
				prep=prep+1	
			endif	
		endfor	
		for (;r<numpnts($trace);r+=1)
			if (twave[r]>0)
				postp=postp+1	
			endif
		endfor		
		if (prep>=postp)	
			fp=fp+postp
			tp=tp+prep
		else
			fp=fp+prep
			tp=tp+postp
		endif	
	endfor
	frerror=fp*sf*60/(numpnts($trace)*k)
	frtrue=tp*sf*60/(numpnts($trace)*k)
	print frerror, frtrue
	
end

// Same as raster_within_episodes(), but without scaling.

function raster_within_episodes_not_scaled()

	variable bin=100,binplus
	binplus=bin+1

	//setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j,t0
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0

	make/o/n=10000 Twake=0,wakeHIST=0
	make/o/n=10000 TNREM=0,NREMHIST=0
	make/o/n=10000 TREM=0,REMHIST=0
	variable switch1=0
	
	do
		make/o/n=10000 tempperiod=0
		make/o/n=10000 tempspike=0
		
		if(M[i]>0)
			i+=1
			switch1=1
				else
		
					if (switch1==1)
						switch1=0
								continue
							endif
		
							if (WAKE[i]>0)
								t0=i
								do	
									if(artifact[i]==1)
										tempperiod[i-t0]=0
										i+=1
									else
										if (i-t0>=numpnts(tempperiod))
											break
										endif
										tempperiod[i-t0]=1
										tempspike[i-t0]=hist[i]
										i+=1
									endif	
					
									if (i>=numpnts(wake))
										break
									endif
					
								while (WAKE[i]>0)
								if (M[i]>0)
									continue
								endif
								//integrate tempspike
								//SetScale/I x 0,1,"", tempperiod,tempspike
								Twake+=tempperiod
								wakeHIST+=tempspike
			
							else
								//________________________________________________________________________
		
								if (NREM[i]>0)
									t0=i
									do	

										if(artifact[i]==1)
											tempperiod[i-t0]=0
											i+=1
										else
											if (i-t0>=numpnts(tempperiod))
												break
											endif
											tempperiod[i-t0]=1
											tempspike[i-t0]=hist[i]
											i+=1
										endif
						
										if (i>=numpnts(nrem))
											break
										endif	
					
									while (NREM[i]>0)
									if (M[i]>0)
										continue
									endif
									TNREM+=tempperiod
									NREMHIST+=tempspike

			
								else
									//________________________________________________________________________
		
									if (REM[i]>0)
										t0=i
										do	
											if(artifact[i]==1)
												tempperiod[i-t0]=0
												i+=1
											else
												if (i-t0>=numpnts(tempperiod))
													break
												endif
												tempperiod[i-t0]=1
												tempspike[i-t0]=hist[i]
												i+=1
											endif	
											if (i>=numpnts(rem))
												break
											endif	
					
										while (REM[i]>0)
										if (M[i]>0)
											continue
										endif
										TREM+=tempperiod
										REMHIST+=tempspike
			
									endif
								endif
							endif
							i+=1
						endif
					while (i<puntos)
					twake=twake*k
					tnrem=tnrem*k
					trem=trem*k

	
		
end
			
//_________________________________________________________________
	
// This function creat bootstrap of the difference between two lists.
//del0 can be 1 or 0. if it's 1. any 0 value while be zapped out of the wave.	
	
function bootstrap2(wavenom1,wavenom2,sim,del0)  //del0==1 delete 0 from wave

	
	
	
	string wavenom1,wavenom2
	variable sim,del0
	

	
	
	wave tt=$wavenom1,tt2=$wavenom2
	
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


	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/6)*sim
	print "This is bootstrap of the difference between to samples"
	
	print "CI is: "

	print num2str(aver)+" "+num2str(bootstrapdist(sim-CI95))+" "+num2str(bootstrapdist(CI95))

	Print "For multiples comparision[MC]"
	print num2str(aver)+" "+num2str(bootstrapdist(sim-CI_MC95))+" "+num2str(bootstrapdist(CI_MC95))
end



//===============================================================
// This create the CI of a list by bootstrap. Better use bootstrap2(wavenom1,wavenom2,sim,del0) when comparing
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

	Print "For multiples comparision[MC]"
	print num2str(aver)+" "+num2str(bootstrapdist(sim-CI_MC95))+" "+num2str(bootstrapdist(CI_MC95))
	print "This code is not recomended, use bootstrap2(wavenom1,wavenom2,sim) instead to calculate bootstrap of the difference"
end

//===============================================================

function createCI2()  // this create CI of the difference for the wake-nrem-rem data (used for frequency analisis, 12 wave must be input).
	// the structure of the list is the following:
	// WT1|NT1|RT1|WE1|NE1|RE1|WT2|NT2|RT2|WE2|NE2|RE2
	wave wave0,wave1,wave2,wave3,wave4,wave5,wave6,wave7,wave8,wave9,wave10,wave11
	variable wt,nt,rt,we,ne,re,wt2,nt2,rt2,we2,ne2,re2
	wave WakeT
	if (Waveexists(wakeT)==0)
		movewave wave0 WakeT
		movewave wave1 NREMT
		movewave wave2 REMT
		movewave wave3 WakeE
		movewave wave4 NREME
		movewave wave5 REME
		movewave wave6 WakeT2
		movewave wave7 NREMT2
		movewave wave8 REMT2
		movewave wave9 WakeE2
		movewave wave10 NREME2
		movewave wave11 REME2
	endif
	
	wave WakeT,NREMT,REMT,WakeE,NREME,REME,WakeT2,NREMT2,REMT2,WakeE2,NREME2,REME2
	
	duplicate/o WakeT test
	integrate test
	wt=test(inf)
	duplicate/o NREMT test
	integrate test
	nt=test(inf)
	duplicate/o REMT test
	integrate test
	rt=test(inf)
	duplicate/o WakeE test
	integrate test
	we=test(inf)
	duplicate/o NREME test
	integrate test
	ne=test(inf)
	duplicate/o REME test
	integrate test
	re=test(inf)
	
	duplicate/o WakeT2 test
	integrate test
	wt2=test(inf)
	duplicate/o NREMT2 test
	integrate test
	nt2=test(inf)
	duplicate/o REMT2 test
	integrate test
	rt2=test(inf)
	duplicate/o WakeE2 test
	integrate test
	we2=test(inf)
	duplicate/o NREME2 test
	integrate test
	ne2=test(inf)
	duplicate/o REME2 test
	integrate test
	re2=test(inf)
	
	
	variable sim=10000,w1,nr1,r1,w2,nr2,r2

	variable i,n=numpnts(WakeT),randnum,s,i2,n2=numpnts(WakeT2)
	make/o/n=(sim) wakeP,NREMP,REMP

	for (s=0;s<sim;s+=1)
		variable WakeTR=0,NREMTR=0,REMTR=0,WakeER=0,NREMER=0,REMER=0,WakeTR2=0,NREMTR2=0,REMTR2=0,WakeER2=0,NREMER2=0,REMER2=0
		
		for (i=0;i<n;i+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n-1))
			WakeTR=WakeTR+WakeT[randnum]
			NREMTR=NREMTR+NREMT[randnum]
			REMTR=REMTR+REMT[randnum]
			WakeER=WakeER+WakeE[randnum]
			NREMER=NREMER+NREME[randnum]
			REMER=REMER+REME[randnum]
		endfor
		
		for (i2=0;i2<n2;i2+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n2-1))
			WakeTR2=WakeTR2+WakeT2[randnum]
			NREMTR2=NREMTR2+NREMT2[randnum]
			REMTR2=REMTR2+REMT2[randnum]
			WakeER2=WakeER2+WakeE2[randnum]
			NREMER2=NREMER2+NREME2[randnum]
			REMER2=REMER2+REME2[randnum]
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

	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/6)*sim
	print "wake CI is: "
	print "NREM CI is: "
	print "NREM CI is: "
	print num2str(-((we/wt)-(we2/wt2)))+" "+num2str(wakep(sim-CI95))+" "+num2str(wakep(CI95))
	print num2str(-((ne/nt)-(ne2/nt2)))+" "+num2str(NREMp(sim-CI95))+" "+num2str(NREMp(CI95))
	print num2str(-((re/rt)-(re2/rt2)))+" "+num2str(REMp(sim-CI95))+" "+num2str(REMp(CI95))
	Print "For multiples comparision[MC]"
	print "wake CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print "NREM CI MC corrected (3) is: "
	print num2str(-((we/wt)-(we2/wt2)))+" "+num2str(wakep(sim-CI_MC95))+" "+num2str(wakep(CI_MC95))
	print num2str(-((ne/nt)-(ne2/nt2)))+" "+num2str(NREMp(sim-CI_MC95))+" "+num2str(NREMp(CI_MC95))
	print num2str(-((re/rt)-(re2/rt2)))+" "+num2str(REMp(sim-CI_MC95))+" "+num2str(REMp(CI_MC95))


end

//=================================================

function raster_within_episodes_not_scaled2()

	variable bin=100,binplus
	binplus=bin+1

	//setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j,t0
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0

	make/o/n=10000 Twake=0,wakeHIST=0
	make/o/n=10000 TNREM=0,NREMHIST=0
	make/o/n=10000 TREM=0,REMHIST=0

	
	do
		make/o/n=10000 tempperiod=0
		make/o/n=10000 tempspike=0
		
		if(M[i]>0)
			i+=1
		else
		
			if (WAKE[i]>0)
				t0=i
				do	
					if(artifact[i]==1)
						tempperiod[i-t0]=0
						i+=1
					else
						if (i-t0>=numpnts(tempperiod))
							break
						endif
						tempperiod[i-t0]=1
						tempspike[i-t0]=hist[i]
						i+=1
					endif	
					
					if (i>=numpnts(wake))
						break
					endif
					
				while (WAKE[i]>0)
				//integrate tempspike
				//SetScale/I x 0,1,"", tempperiod,tempspike
				Twake+=tempperiod
				wakeHIST+=tempspike
			
			else
				//________________________________________________________________________
		
				if (NREM[i]>0)
					t0=i
					do	

						if(artifact[i]==1)
							tempperiod[i-t0]=0
							i+=1
						else
							if (i-t0>=numpnts(tempperiod))
								break
							endif
							tempperiod[i-t0]=1
							tempspike[i-t0]=hist[i]
							i+=1
						endif
						
						if (i>=numpnts(nrem))
							break
						endif	
					
					while (NREM[i]>0)

					TNREM+=tempperiod
					NREMHIST+=tempspike

			
				else
					//________________________________________________________________________
		
					if (REM[i]>0)
						t0=i
						do	
							if(artifact[i]==1)
								tempperiod[i-t0]=0
								i+=1
							else
								if (i-t0>=numpnts(tempperiod))
									break
								endif
								tempperiod[i-t0]=1
								tempspike[i-t0]=hist[i]
								i+=1
							endif	
							if (i>=numpnts(rem))
								break
							endif	
					
						while (REM[i]>0)
						TREM+=tempperiod
						REMHIST+=tempspike
			
					endif
				endif
			endif
			i+=1
		endif
	while (i<puntos)
	twake=twake*k
	tnrem=tnrem*k
	trem=trem*k
	
	
	
	wakehist=wakehist/(twake)
	nremhist=nremhist/(tnrem)
	remhist=remhist/(trem)

	integrate wakehist
	integrate nremhist
	integrate remhist
	
	SetScale/P x 0,0.199203187250996, wakehist
	SetScale/P x 0,0.199203187250996, nremhist
	SetScale/P x 0,0.199203187250996, remhist
	
	variable binn=1
	make/n=(300/binn)/o wakehist_bin,nremhist_bin,remhist_bin
	for (i=binn;i<(300/binn);i+=1)
		wakehist_bin[i]=wakehist(i)-wakehist(i-binn)
		nremhist_bin[i]=nremhist(i)-nremhist(i-binn)
		remhist_bin[i]=remhist(i)-remhist(i-binn)
	endfor
	DeletePoints 0,binn, wakehist_bin
	DeletePoints 0,binn, nremhist_bin
	DeletePoints 0,binn, remhist_bin
	
	SetScale/P x 0,binn, wakehist_bin
	SetScale/P x 0,binn, nremhist_bin
	SetScale/P x 0,binn, remhist_bin
	
end
//=====================================================			

function inverse_raster_within_episodes_not_scaled2()

	variable bin=100,binplus
	binplus=bin+1

	//setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	duplicate/o WAKE WAKE_flip
	duplicate/o NREM NREM_flip
	duplicate/o REM REM_flip
	duplicate/o artifact artifact_flip
	duplicate/o M M_flip
	
	
	waveTransform/o flip WAKE_flip
	waveTransform/o flip NREM_flip
	waveTransform/o flip REM_flip
	waveTransform/o flip artifact_flip
	waveTransform/o flip M_flip
	
	
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j,t0
	
	
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp
		waveTransform/o flip temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0

	make/o/n=10000 Twake=0,wakeHIST=0
	make/o/n=10000 TNREM=0,NREMHIST=0
	make/o/n=10000 TREM=0,REMHIST=0

	
	do
		make/o/n=10000 tempperiod=0
		make/o/n=10000 tempspike=0
		
		if(M_flip[i]>0)
			i+=1
		else
		
			if (WAKE_flip[i]>0)
				t0=i
				do	
					if(artifact_flip[i]==1)
						tempperiod[i-t0]=0
						i+=1
					else
						if (i-t0>=numpnts(tempperiod))
							break
						endif
						tempperiod[i-t0]=1
						tempspike[i-t0]=hist[i]
						i+=1
					endif	
					
					if (i>=numpnts(wake_flip))
						break
					endif
					
				while (WAKE_flip[i]>0)
				//integrate tempspike
				//SetScale/I x 0,1,"", tempperiod,tempspike
				Twake+=tempperiod
				wakeHIST+=tempspike
			
			else
				//________________________________________________________________________
		
				if (NREM_flip[i]>0)
					t0=i
					do	

						if(artifact_flip[i]==1)
							tempperiod[i-t0]=0
							i+=1
						else
							if (i-t0>=numpnts(tempperiod))
								break
							endif
							tempperiod[i-t0]=1
							tempspike[i-t0]=hist[i]
							i+=1
						endif
						
						if (i>=numpnts(nrem_flip))
							break
						endif	
					
					while (NREM_flip[i]>0)

					TNREM+=tempperiod
					NREMHIST+=tempspike

			
				else
					//________________________________________________________________________
		
					if (REM_flip[i]>0)
						t0=i
						do	
							if(artifact_flip[i]==1)
								tempperiod[i-t0]=0
								i+=1
							else
								if (i-t0>=numpnts(tempperiod))
									break
								endif
								tempperiod[i-t0]=1
								tempspike[i-t0]=hist[i]
								i+=1
							endif	
							if (i>=numpnts(rem_flip))
								break
							endif	
					
						while (REM_flip[i]>0)
						TREM+=tempperiod
						REMHIST+=tempspike
			
					endif
				endif
			endif
			i+=1
		endif
	while (i<puntos)
	twake=twake*k
	tnrem=tnrem*k
	trem=trem*k
	
	
	
	wakehist=wakehist/(twake)
	nremhist=nremhist/(tnrem)
	remhist=remhist/(trem)

	integrate wakehist
	integrate nremhist
	integrate remhist
	
	SetScale/P x 0,0.199203187250996, wakehist
	SetScale/P x 0,0.199203187250996, nremhist
	SetScale/P x 0,0.199203187250996, remhist
	
	variable binn=1
	make/n=(300/binn)/o wakehist_bin,nremhist_bin,remhist_bin
	for (i=binn;i<(300/binn);i+=1)
		wakehist_bin[i]=wakehist(i)-wakehist(i-binn)
		nremhist_bin[i]=nremhist(i)-nremhist(i-binn)
		remhist_bin[i]=remhist(i)-remhist(i-binn)
	endfor
	DeletePoints 0,binn, wakehist_bin
	DeletePoints 0,binn, nremhist_bin
	DeletePoints 0,binn, remhist_bin
	
	SetScale/P x 0,binn, wakehist_bin
	SetScale/P x 0,binn, nremhist_bin
	SetScale/P x 0,binn, remhist_bin		
end

//=====================================================================
//This get the inter-event interval for each cell
function getiei(sf)
variable sf
	string list,trace,output
	variable k,i
	wave rem,nrem,wake
	variable mw=wavemax(wake),mr=wavemax(rem), mn=wavemax(nrem)
	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		
		//for wake
		duplicate/o $trace temp
		temp = (wake[p]==0) ? nan : temp[p]
		WaveTransform zapNaNs temp
		output="wakeiei_"+trace
		findlevels/edge=1/Q/D=$output temp 0.01
		wave temp_wake=$output
		if (numpnts(temp_wake)>1)
			temp_wake=temp_wake/sf
		else
			deletepoints 0,3,temp_wake
		endif
		differentiate/EP=1/METH=2 $output
		
		//for nrem
		duplicate/o $trace temp
		temp = (nrem[p]==0) ? nan : temp[p]
		WaveTransform zapNaNs temp
		output="nremiei_"+trace
		findlevels/edge=1/Q/D=$output temp 0.01
		wave temp_nrem=$output
		if (numpnts(temp_nrem)>1)
			temp_nrem=temp_nrem/sf
		else
			deletepoints 0,3,temp_nrem
		endif
		differentiate/EP=1/METH=2 $output
		
		//for rem
		duplicate/o $trace temp
		temp = (rem[p]==0) ? nan : temp[p]
		WaveTransform zapNaNs temp
		output="remiei_"+trace
		findlevels/edge=1/Q/D=$output temp 0.01
		wave temp_rem=$output
		if (numpnts(temp_rem)>1)
			temp_rem=temp_rem/sf
		else
			deletepoints 0,3,temp_rem
		endif
		
		differentiate/EP=1/METH=2 $output
	endfor
end




// THESE CODES ARE FOR CREATING THE WITHIN EVENT ANALYSIS
//==================================================================================
function plot_within(num_bins,bin_size)
variable bin_size,num_bins
	Whithin_episode_forward_all("wake",num_bins,bin_size)
	Whithin_episode_forward_all("nrem",num_bins,bin_size)  
	Whithin_episode_backward_all("wake",num_bins,bin_size)
	Whithin_episode_backward_all("nrem",num_bins,bin_size)  

	wave wakebin_backward_corr,wakebin_corr,nrembin_backward_corr,nrembin_corr

	Display/K=1 wakebin_backward_corr
	ModifyGraph rgb=(1,39321,19939)
	Label left "Autocorrelation";DelayUpdate
	Label bottom "Time lag (s)"
	Display/K=1 wakebin_corr
	ModifyGraph rgb=(1,39321,19939)
	Label left "Autocorrelation";DelayUpdate
	Label bottom "Time lag (s)"
	Display/K=1 nrembin_backward_corr
	ModifyGraph rgb=(0,0,65535)
	Label left "Autocorrelation";DelayUpdate
	Label bottom "Time lag (s)"
	Display/K=1 nrembin_corr
	ModifyGraph rgb=(0,0,65535)
	Label left "Autocorrelation";DelayUpdate
	Label bottom "Time lag (s)"
end



// FORWARD ANALYSIS

function Whithin_episode_forward_all(wstr,bins,bin_size)  
	string wstr
	variable bins,bin_size
	S_folder_loop(wstr+"hist")
	S_folder_loop("t"+wstr)

	wave tim=$"t"+wstr+"total", hist=$wstr+"histtotal"
	sort/r tim tim
	hist=hist/tim
	integrate hist /D=$wstr+"histtotal_forward_hist_int"
	wave hist_int=$wstr+"histtotal_forward_hist_int"
	SetScale/P x 0,0.199203187250996, hist_int
	make/n=(bins)/o $wstr+"bin"
	wave binhist=$wstr+"bin"
	variable i
	for (i=0;i<bins;i+=1)
		binhist[i]=hist_int((i+1)*bin_size)-hist_int((i+1)*bin_size-bin_size)
	endfor
	SetScale/P x 0,bin_size, binhist
	Duplicate/O binhist,$wstr+"bin_corr";DelayUpdate
	Correlate/NODC/AUTO $wstr+"bin_corr", $wstr+"bin_corr";DelayUpdate

end


function S_folder_loop(wavn) // 
	string wavn
	make/o/n=10000 $wavn+"total"
	wave ttoal=$wavn+"total"
	Variable numDataFolders = CountObjects(":", 4), i
	variable s,d,m
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		Whithin_episode_forward()
		wave temp=$cdf2+nextPath+":"+wavn
		ttoal=ttoal+temp
	endfor
	setdatafolder $cdf2
end




function Whithin_episode_forward()

	variable bin=100,binplus
	binplus=bin+1

	//setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j,t0
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0

	make/o/n=10000 Twake=0,wakeHIST=0
	make/o/n=10000 TNREM=0,NREMHIST=0
	make/o/n=10000 TREM=0,REMHIST=0

	
	do
		make/o/n=10000 tempperiod=0
		make/o/n=10000 tempspike=0
		
		if(M[i]>0)
			i+=1
		else
		
			if (WAKE[i]>0)
				t0=i
				do	
					if(artifact[i]==1)
						tempperiod[i-t0]=0
						i+=1
					else
						if (i-t0>=numpnts(tempperiod))
							break
						endif
						tempperiod[i-t0]=1
						tempspike[i-t0]=hist[i]
						i+=1
					endif	
					
					if (i>=numpnts(wake))
						break
					endif
					
				while (WAKE[i]>0)
				//integrate tempspike
				//SetScale/I x 0,1,"", tempperiod,tempspike
				Twake+=tempperiod
				wakeHIST+=tempspike
			
			else
				//________________________________________________________________________
		
				if (NREM[i]>0)
					t0=i
					do	

						if(artifact[i]==1)
							tempperiod[i-t0]=0
							i+=1
						else
							if (i-t0>=numpnts(tempperiod))
								break
							endif
							tempperiod[i-t0]=1
							tempspike[i-t0]=hist[i]
							i+=1
						endif
						
						if (i>=numpnts(nrem))
							break
						endif	
					
					while (NREM[i]>0)

					TNREM+=tempperiod
					NREMHIST+=tempspike

			
				else
					//________________________________________________________________________
		
					if (REM[i]>0)
						t0=i
						do	
							if(artifact[i]==1)
								tempperiod[i-t0]=0
								i+=1
							else
								if (i-t0>=numpnts(tempperiod))
									break
								endif
								tempperiod[i-t0]=1
								tempspike[i-t0]=hist[i]
								i+=1
							endif	
							if (i>=numpnts(rem))
								break
							endif	
					
						while (REM[i]>0)
						TREM+=tempperiod
						REMHIST+=tempspike
			
					endif
				endif
			endif
			i+=1
		endif
	while (i<puntos)
	twake=twake*k
	tnrem=tnrem*k
	trem=trem*k	
end


// BACKWARD ANALYSIS

function Whithin_episode_backward_all(wstr,bins,bin_size)
	string wstr
	variable bins,bin_size
	S_folder_loop_backward(wstr+"hist")
	S_folder_loop_backward("t"+wstr)

	wave tim=$"t"+wstr+"total_backward", hist=$wstr+"histtotal_backward"
	sort/r tim tim
	hist=hist/tim
	integrate hist /D=$wstr+"histtotal_backward_hist_int"
	wave hist_int=$wstr+"histtotal_backward_hist_int"
	SetScale/P x 0,0.199203187250996, hist_int
	make/n=(bins)/o $wstr+"bin_backward"
	wave binhist=$wstr+"bin_backward"
	variable i
	for (i=0;i<bins;i+=1)
		binhist[i]=hist_int((i+1)*bin_size)-hist_int((i+1)*bin_size-bin_size)
	endfor
	SetScale/P x 0,bin_size, binhist
	Duplicate/O binhist,$wstr+"bin_backward_corr";DelayUpdate
	Correlate/NODC/AUTO $wstr+"bin_backward_corr", $wstr+"bin_backward_corr";DelayUpdate
end



function S_folder_loop_backward(wavn) // 
	string wavn
	make/o/n=10000 $wavn+"total_backward"
	wave ttoal=$wavn+"total_backward"
	Variable numDataFolders = CountObjects(":", 4), i
	variable s,d,m
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		//CDF=GetDataFolder(1)
		//print cdf2+nextPath+":"+wavn
		Whithin_episode_backward()
		wave temp=$cdf2+nextPath+":"+wavn
		ttoal=ttoal+temp
	endfor
	setdatafolder $cdf2
end



function Whithin_episode_backward()



	wave WAKE,NREM,REM,artifact,wave0,M
	
	duplicate/o WAKE WAKE_flip
	duplicate/o NREM NREM_flip
	duplicate/o REM REM_flip
	duplicate/o artifact artifact_flip
	duplicate/o M M_flip
	
	
	waveTransform/o flip WAKE_flip
	waveTransform/o flip NREM_flip
	waveTransform/o flip REM_flip
	waveTransform/o flip artifact_flip
	waveTransform/o flip M_flip
	
	variable puntos=numpnts(wave0)
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j,t0
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp
		wave temp
		waveTransform/o flip temp			
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor


	i=0

	make/o/n=10000 Twake=0,wakeHIST=0
	make/o/n=10000 TNREM=0,NREMHIST=0
	make/o/n=10000 TREM=0,REMHIST=0

	
	do
		make/o/n=10000 tempperiod=0
		make/o/n=10000 tempspike=0
		
		if(M_flip[i]>0)
			i+=1
		else
		
			if (WAKE_flip[i]>0)
				t0=i
				do	
					if(artifact_flip[i]==1)
						tempperiod[i-t0]=0
						i+=1
					else
						if (i-t0>=numpnts(tempperiod))
							break
						endif
						tempperiod[i-t0]=1
						tempspike[i-t0]=hist[i]
						i+=1
					endif	
					
					if (i>=numpnts(wake_flip))
						break
					endif
					
				while (WAKE_flip[i]>0)
				//integrate tempspike
				//SetScale/I x 0,1,"", tempperiod,tempspike
				Twake+=tempperiod
				wakeHIST+=tempspike
			
			else
				//________________________________________________________________________
		
				if (NREM_flip[i]>0)
					t0=i
					do	

						if(artifact_flip[i]==1)
							tempperiod[i-t0]=0
							i+=1
						else
							if (i-t0>=numpnts(tempperiod))
								break
							endif
							tempperiod[i-t0]=1
							tempspike[i-t0]=hist[i]
							i+=1
						endif
						
						if (i>=numpnts(nrem_flip))
							break
						endif	
					
					while (NREM_flip[i]>0)

					TNREM+=tempperiod
					NREMHIST+=tempspike

			
				else
					//________________________________________________________________________
		
					if (REM_flip[i]>0)
						t0=i
						do	
							if(artifact_flip[i]==1)
								tempperiod[i-t0]=0
								i+=1
							else
								if (i-t0>=numpnts(tempperiod))
									break
								endif
								tempperiod[i-t0]=1
								tempspike[i-t0]=hist[i]
								i+=1
							endif	
							if (i>=numpnts(rem_flip))
								break
							endif	
					
						while (REM_flip[i]>0)
						TREM+=tempperiod
						REMHIST+=tempspike
			
					endif
				endif
			endif
			i+=1
		endif
	while (i<puntos)
	twake=twake*k
	tnrem=tnrem*k
	trem=trem*k	
end


function random_oscillator()
	make/o/n=1000 oscillator
	make/o/n=1000 temp_oscillator
	variable random,s,sim=10000,random2
	SetScale/I x 0,1,"", oscillator
	SetScale/I x 0,1,"", temp_oscillator
	for (s=0;s<sim;s+=1)
		random=enoise(1)
		random2=gnoise(0.1)
		temp_oscillator=sin(2*pi*p*((5)/1000)+2*pi*(random))
		//temp_oscillator= (temp_oscillator<0) ? 0:temp_oscillator[p]
		oscillator=oscillator+temp_oscillator
	endfor
	oscillator=oscillator/sim
	Duplicate/O oscillator,oscillator_corr;DelayUpdate
	Correlate/c/NODC oscillator, oscillator_corr;DelayUpdate

	DoWindow /F oscillator_corr0   // /F means 'bring to front if it exists'
	if (V_flag == 0)
		// window does not exist
		Display/k=1/N=oscillator_corr oscillator_corr // note '/N=' flag
		ModifyGraph lowTrip(left)=0.001

	else

	endif


end


//=====================================================================

//RANDOM permutations
//=====================================================================



function simulated_corr(sim)
	variable sim
	tic()
	variable i
	make/o/n=(sim) random_perm_nrem
	make/o/n=(sim) random_perm_wake
	for (i=0;i<sim;i+=1)
		random_permutation_correlation(300)
		wave nhistran_bin,whistran_bin
		wavestats/q nhistran_bin
		random_perm_nrem[i]=V_sdev
		wavestats/q whistran_bin
		random_perm_wake[i]=V_sdev
	endfor
	toc()
end


function random_permutation_correlation(bins)  
	variable bins
	S_folder_loop_random()
	wave whistran,nhistran

	integrate nhistran
	integrate whistran

	SetScale/P x 0,0.199203187250996, nhistran
	SetScale/P x 0,0.199203187250996, whistran

	make/n=(bins)/o nhistran_bin
	make/n=(bins)/o whistran_bin

	variable i

	for (i=1;i<bins;i+=1)
		whistran_bin[i]=whistran(i)-whistran(i-1)
		nhistran_bin[i]=nhistran(i)-nhistran(i-1)
	endfor
	DeletePoints 0,1, whistran_bin
	DeletePoints 0,1, nhistran_bin
	Correlate/NODC/AUTO whistran_bin, whistran_bin
	Correlate/NODC/AUTO nhistran_bin, nhistran_bin
end


function S_folder_loop_random() // 
	make/o/n=10000 whistran
	make/o/n=10000 nhistran
	make/o/n=10000 wtran
	make/o/n=10000 ntran
	wave whr=$"root:DS:AL:whistran"
	wave nhr=$"root:DS:AL:nhistran"
	wave wtr=$"root:DS:AL:wtran"
	wave ntr=$"root:DS:AL:ntran"




	Variable numDataFolders = CountObjects(":", 4), i
	variable s,d,m
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		Whithin_episode_random()
		wave wh=$cdf2+nextPath+":wakeHIST"
		wave nh=$cdf2+nextPath+":nremHIST"
		wave tw=$cdf2+nextPath+":twake"
		wave tn=$cdf2+nextPath+":tnrem"
		whr=whr+wh
		nhr=nhr+nh
		wtr=wtr+tw
		ntr=ntr+tn
	endfor
	setdatafolder $cdf2
	sort/r wtr wtr
	sort/r ntr ntr
	whr=whr/wtr
	nhr=nhr/ntr
end



//=========================================================

function Whithin_episode_random()

	variable bin=100,binplus
	binplus=bin+1

	//setdatafolder root:data:S:
	wave WAKE,NREM,REM,artifact,wave0,M
	variable puntos=numpnts(wave0)
	
	string list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,j,t0
	wave wave0
	duplicate/o wave0 hist
	hist=0
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		duplicate/o $swave temp		
		temp= (temp>0.00001) ? 1:temp[p]
		hist=hist+temp
	endfor
	shuffle(hist)

	i=0

	make/o/n=10000 Twake=0,wakeHIST=0
	make/o/n=10000 TNREM=0,NREMHIST=0
	make/o/n=10000 TREM=0,REMHIST=0

	
	do
		make/o/n=10000 tempperiod=0
		make/o/n=10000 tempspike=0
		
		if(M[i]>0)
			i+=1
		else
		
			if (WAKE[i]>0)
				t0=i
				do	
					if(artifact[i]==1)
						tempperiod[i-t0]=0
						i+=1
					else
						if (i-t0>=numpnts(tempperiod))
							break
						endif
						tempperiod[i-t0]=1
						tempspike[i-t0]=hist[i]
						i+=1
					endif	
					
					if (i>=numpnts(wake))
						break
					endif
					
				while (WAKE[i]>0)
				//integrate tempspike
				//SetScale/I x 0,1,"", tempperiod,tempspike
				Twake+=tempperiod
				wakeHIST+=tempspike
			
			else
				//________________________________________________________________________
		
				if (NREM[i]>0)
					t0=i
					do	

						if(artifact[i]==1)
							tempperiod[i-t0]=0
							i+=1
						else
							if (i-t0>=numpnts(tempperiod))
								break
							endif
							tempperiod[i-t0]=1
							tempspike[i-t0]=hist[i]
							i+=1
						endif
						
						if (i>=numpnts(nrem))
							break
						endif	
					
					while (NREM[i]>0)

					TNREM+=tempperiod
					NREMHIST+=tempspike

			
				else
					//________________________________________________________________________
		
					if (REM[i]>0)
						t0=i
						do	
							if(artifact[i]==1)
								tempperiod[i-t0]=0
								i+=1
							else
								if (i-t0>=numpnts(tempperiod))
									break
								endif
								tempperiod[i-t0]=1
								tempspike[i-t0]=hist[i]
								i+=1
							endif	
							if (i>=numpnts(rem))
								break
							endif	
					
						while (REM[i]>0)
						TREM+=tempperiod
						REMHIST+=tempspike
			
					endif
				endif
			endif
			i+=1
		endif
	while (i<puntos)
	twake=twake*k
	tnrem=tnrem*k
	trem=trem*k	
end


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


//=======================================================
// Function to start a new timer

function tic()
	variable/G tictoc = startMSTimer
end
// Function to stop timer and print time.
function toc()
	NVAR/Z tictoc
	variable ttTime = stopMSTimer(tictoc)
	printf "%g seconds\r", (ttTime/1e6)
	
end

//====================================================================

// This function plot the concatenated event distribution a cuts at the specific time "cut".
// if nom is "wake" and cut is 1000. only the first 1000 second of the concatenated wake will be plotted.
// This funciton loops through folders and plot all the concatenated event distribution in that group.  

function concatenated_cut(nom,cut)
	string nom
	variable cut
	display
	Variable numDataFolders = CountObjects(":", 4), i
	variable s,d,m
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		//CDF=GetDataFolder(1)
		string tempy=cdf2+nextPath+":"+nom+"_concatenated"
		wave cut_concat_W=$cdf2+nextPath+"cut_concat_"+nom
		duplicate/o $cdf2+nextPath+":"+nom+"_concatenated" cut_concat_W
		cut_concat_W = (cut_concat_W[p] > cut) ? nan : cut_concat_W[p]
		WaveTransform zapNaNs cut_concat_W
		//SetScale/I x 0,1,"", cut_concat_W
		appendtograph cut_concat_W
	endfor
	setdatafolder $cdf2
end
//====================================================
// Same as concatend_cut but whithout cutting. 
function concatenated_raw(nom) 
	string nom
	display
	wave times
	Variable numDataFolders = CountObjects(":", 4), i
	variable s,d,m
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		//CDF=GetDataFolder(1)
		string tempy=cdf2+nextPath+":"+nom+"_concatenated"
		wave cut_concat_W=$cdf2+nextPath+"cut_concat_"+nom
		duplicate/o $cdf2+nextPath+":"+nom+"_concatenated" cut_concat_W
		appendtograph cut_concat_W
	endfor
	setdatafolder $cdf2
end

// This function concatenate the IEI distribution of each cell into one file. 
// This function loops though folders.
function get_IEI()
	string nom
	Variable numDataFolders = CountObjects(":", 4), i
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		concatenate/o wavelist("wakeiei_wave*",";",""), wake_iei_all
		concatenate/o wavelist("NREMiei_wave*",";",""), NREM_iei_all
		concatenate/o wavelist("REMiei_wave*",";",""), REM_iei_all
	
	endfor
	setdatafolder $cdf2
	group_IEI_all_mice()
end

// used in get_IEI()
function group_IEI_all_mice()
	string nom
	Variable numDataFolders = CountObjects(":", 4), i
	make/o/n=0 iei_wake,iei_NREM,iei_rem
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		wave wake_iei_all,NREM_iei_all,REM_iei_all
		concatenate {wake_iei_all}, $cdf2+"iei_wake"
		concatenate {NREM_iei_all}, $cdf2+"iei_NREM"
		concatenate {REM_iei_all}, $cdf2+"iei_REM"	
	endfor
	setdatafolder $cdf2
end

//This funciton copy all the iei files inside a folder outside of it. 
// This loop though all the folders in a file.


function get_iei_state(state,name)  // steate must be wake,nrem or rem. name could be anything.
// name is used to add a label before each wave such as "BL" or "Al".
	string state,name
	string nom
	Variable numDataFolders = CountObjects(":", 4), i

	variable cell=0
	string CDF,cdf2
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
	
		string list=wavelist(state+"iei_wave*",",","")
		list=SortList(list,",", 16)
		variable k=itemsinlist(list, ","),h
		for (h=0;h<k;h+=1)	
			string swave=stringfromlist(h,list,",")
			string output=cdf2+name+state+"_iei_"+num2str(cell)
			duplicate/o $cdf2+nextPath+":"+swave $output
			cell=cell+1	
		endfor
	endfor
	setdatafolder $cdf2
end


//=========================================
// Calculate the CI of difference between two list of iei distributions.
// sim is the number of simulaitions. 10000 is okay. 
function bootstrap_iei(state1,state2,sim)
	string state1,state2
	variable sim

	


	string list1=wavelist(state1+"_iei_*",",","")
	string list2=wavelist(state2+"_iei_*",",","")

	make/o/n=(sim) Diff
	variable s,i1,i2,n1=itemsinlist(list1, ","),n2=itemsinlist(list2, ","),randnum,f1,f2
	string swave
	
	for (s=0;s<sim;s+=1)
		make/o/n=0 randomS1
		
		for (i1=0;i1<n1;i1+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n1-1))
			swave=stringfromlist(randnum,list1,",")
			concatenate {$swave}, randomS1

		endfor

		f1=mean(randomS1)
		f1=1/f1
	
		make/o/n=0 randomS2
		for (i2=0;i2<n2;i2+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n2-1))
			swave=stringfromlist(randnum,list2,",")
			concatenate {$swave}, randomS2
		endfor
		
		f2=mean(randomS2)
		f2=1/f2

		Diff[s]=f2-f1
	endfor
	
	concatenate/o wavelist(state1+"_iei_*",";",""), state1_iei_all
	concatenate/o wavelist(state2+"_iei_*",";",""), state2_iei_all
	f1=mean(state1_iei_all)
	f1=1/f1
	f2=mean(state2_iei_all)
	f2=1/f2
	
	sort diff diff
	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/6)*sim
	
	print "The CI corrected for multiple comparison (3) is: "
	print num2str((f2-f1)*60)+" "+num2str(60*diff(sim-CI_MC95))+" "+num2str(60*diff(CI_MC95))
end

// Same as bootstrap_iei(state1,state2,sim) but only for one sample. 

function bootstrap_iei_one_sample(state1,sim)
	string state1
	variable sim


	string list1=wavelist(state1+"_iei_*",",","")

	make/o/n=(sim) Diff
	variable s,i1,i2,n1=itemsinlist(list1, ","),randnum,f1,f2
	string swave
	
	for (s=0;s<sim;s+=1)
		make/o/n=0 randomS1
		
		for (i1=0;i1<n1;i1+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n1-1))
			swave=stringfromlist(randnum,list1,",")
			concatenate {$swave}, randomS1

		endfor

		f1=mean(randomS1)
		f1=1/f1

		Diff[s]=f1
	endfor
	
	concatenate/o wavelist(state1+"_iei_*",";",""), state1_iei_all
	f1=mean(state1_iei_all)
	f1=1/f1

	
	sort diff diff
	variable CI_MC95=(0.05/2)*sim
	
	print "The CI is: "
	print num2str((f1)*60)+" "+num2str(60*diff(sim-CI_MC95))+" "+num2str(60*diff(CI_MC95))
end
//=========================================================================================
// This function print the average iei of each cells.
//Run get_iei_state(state,name) and then this funciton.


function print_avg_iei(state1)
	string state1
	variable sim

	string list1=wavelist(state1+"_iei_*",",","")

	variable s,i1,i2,n1=itemsinlist(list1, ","),randnum,f1,f2
	string swave

		
	for (i1=0;i1<n1;i1+=1)

		swave=stringfromlist(i1,list1,",")
		print 60/mean($swave)
	endfor
end

//=========================================================================================
// Delete waves with less than 20 points

function kill_less_20(nombre)
	string nombre
	string list1=wavelist(nombre+"*",",","")
	variable s,n=itemsinlist(list1, ",")
	for (s=0;s<n;s+=1)
		string swave=stringfromlist(s,list1,",")
		wave temp=$swave
		if (numpnts(temp)<20)
		killwaves $swave
		endif
	endfor
end


function CI_corr(ref,sim)
string ref
variable sim
wave name=$ref
variable s,n=numpnts(name)
tic()

make/O/N=(n,sim) shuff=0
make/O/N=(sim) shuff2=0
duplicate/o name temp
for (s=0;s<sim;s+=1)
shuffle(temp)
duplicate/o temp tempc
Correlate/NODC/AUTO tempc, tempc
DeletePoints 0,149, tempc
shuff[][s]=tempc[p][0]
tempc[0]=0
tempc=abs(tempc)
shuff2[s]=wavemax(tempc)
endfor
sort shuff2 shuff2
print shuff2[sim*0.95]
variable dummy=1

MatrixTranspose shuff
make/o/n=(n) $"CI_avg_"+ref
wave avg=$"CI_avg_"+ref
make/o/n=(n) $"CI_plus_"+ref
wave plu=$"CI_plus_"+ref
make/o/n=(n) $"CI_minus_"+ref
wave minu=$"CI_minus_"+ref
variable a=0.05/n
variable i
make/O/N=(sim) temp2
for (i=0;i<n;i+=1)
temp2=shuff[p][i]
sort temp2 temp2
avg[i]=mean(temp2)
plu[i]=temp2[sim*(1-a)]
minu[i]=temp2[sim*a]
endfor
plu=plu-avg
minu=avg-minu
SetScale/P x 0,2,"", avg

toc()

end


function plot_amp_corr(state,sf)  // steate must be wake,nrem or rem. name could be anything.
	string state
	variable sf
	string nom
	display
	make/o/n=0 amp_all,time_all
	string CDF,cdf2
	Variable numDataFolders = CountObjects(":", 4), i
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		amp_corr(sf)
		wave wt=$state+"_times", wa=$state+"_amps"
		concatenate {wa},amp_all
		concatenate {wt},time_all
	endfor
	setdatafolder $cdf2
	sort time_all,amp_all
	sort time_all time_all
	AppendToGraph amp_all vs time_all
	ModifyGraph mode=3,marker=19,msize=1,rgb=(17476,17476,17476,19661)
end


function amp_corr(sf)
variable sf
	string list,trace,output
	variable k,i
	wave rem,nrem,wake
	variable mw=wavemax(wake),mr=wavemax(rem), mn=wavemax(nrem)
	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	make/o/n=0 wake_times
	make/o/n=0 wake_amps
	make/o/n=0 nrem_times
	make/o/n=0 nrem_amps
	make/o/n=0 rem_times
	make/o/n=0 rem_amps

	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		
		//for wake
		duplicate/o $trace temp
		duplicate/o $trace temp_time
		temp_time=p/sf
		
		temp = (wake[p]==0) ? nan : temp[p]
		temp_time = (wake[p]==0) ? nan : temp_time[p]
		temp_time = (temp[p]<0.001) ? nan : temp_time[p]
		temp = (temp[p]<0.001) ? nan : temp[p]
		
		WaveTransform zapNaNs temp
		WaveTransform zapNaNs temp_time

		concatenate {temp}, wake_amps
		concatenate {temp_time}, wake_times

		
		//for nrem
		duplicate/o $trace temp
		duplicate/o $trace temp_time
		temp_time=p/sf
		
		temp = (nrem[p]==0) ? nan : temp[p]
		temp_time = (nrem[p]==0) ? nan : temp_time[p]
		temp_time = (temp[p]<0.001) ? nan : temp_time[p]
		temp = (temp[p]<0.001) ? nan : temp[p]
		
		WaveTransform zapNaNs temp
		WaveTransform zapNaNs temp_time

		concatenate {temp}, nrem_amps
		concatenate {temp_time}, nrem_times
		
		//for rem
		duplicate/o $trace temp
		duplicate/o $trace temp_time
		temp_time=p/sf
		
		temp = (rem[p]==0) ? nan : temp[p]
		temp_time = (rem[p]==0) ? nan : temp_time[p]
		temp_time = (temp[p]<0.001) ? nan : temp_time[p]
		temp = (temp[p]<0.001) ? nan : temp[p]
		
		WaveTransform zapNaNs temp
		WaveTransform zapNaNs temp_time

		concatenate {temp}, rem_amps
		concatenate {temp_time}, rem_times
	endfor
end


function reduce(waven)
string waven
wave w=$waven
Duplicate/o w, $waven+"x"
wave wx=$waven+"x"
variable n=wavemax(w)
differentiate w
wx = x
wx= (w[p]<=0) ? nan : wx[p]
WaveTransform zapNaNs wx
duplicate/o wx w
w=n
end	


// remove zeros from a list of waves
function remove0(nam)
string nam

string list=wavelist(nam+"*",",","")
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i
	for (i=0;i<k;i+=1)	
		string swave=stringfromlist(i,list,",")
		wave temp=$swave
		temp = (temp[p]==0) ? nan : temp[p]
		WaveTransform zapNaNs temp	
		endfor
end

//===============================================================================
// THIS FUNCTIONS ARE USED TO PLOT ALL traces from all mices. A folder named BL that icludes the folder data of each mouse is needed.
function plop_offset()
plotraw()
setdatafolder root:BL:

	string CDF,cdf2
	Variable numDataFolders = CountObjects(":", 4), i
	cdf2=GetDataFolder(1)
	string list2 = tracenamelist("",";", 1) 
	variable off_set=itemsinlist(list2)
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":'new method':Data:S:"
		creategraphs4(off_set-i)
	endfor

end


function plotraw()
	display

	string CDF,cdf2
	Variable numDataFolders = CountObjects(":", 4), i
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":'new method':Data:S:"
		wave wake,nrem,rem,artifact
		SetScale/P x 0,0.199203,"", artifact
		variable t=wavemax(artifact)
		artifact=artifact/t
		t=wavemax(nrem)
		artifact=artifact*t
		AppendToGraph wake,nrem,rem,artifact
		
		string list2 = tracenamelist("",";", 1) 
		variable off_set=itemsinlist(list2)
		string ws=stringfromlist(off_set-4, list2, ";"),ns=stringfromlist(off_set-3, list2, ";"),rs=stringfromlist(off_set-2, list2, ";"),as=stringfromlist(off_set-1, list2, ";")
		
		ModifyGraph mode=7,rgb($ws)=(49151,65535,49151),rgb($ns)=(49151,60031,65535),rgb($rs)=(65535,49151,49151)
		ModifyGraph hbFill($ws)=2
		ModifyGraph hbFill($ns)=2
		ModifyGraph hbFill($rs)=2
		ModifyGraph hbFill($as)=2
		ModifyGraph offset($ws)={0,((off_set-3*(i+1))*2-0.5)}
		ModifyGraph offset($ns)={0,((off_set-3*(i+1))*2)-0.5}
		ModifyGraph offset($rs)={0,((off_set-3*(i+1))*2)-0.5}
		ModifyGraph offset($as)={0,((off_set-3*(i+1))*2)-0.5}
		setdatafolder $cdf2+nextPath+":'new method':Data:C_raw:"
		creategraphs3(i+1)
		
	endfor
end


function creategraphs3(num)
	variable num
	variable disp
	string list,trace,temp
	variable k,i

	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		wave twave=$trace
		AppendToGraph twave	
		
		string list2 = tracenamelist("",";", 1) 
		variable off_set=itemsinlist(list2)-1
		string last=stringfromlist(off_set, list2, ";")
		SetScale/P x 0,0.199203,"", twave
		ModifyGraph offset($last)={0,(off_set-num*3)*2}	
	endfor
end

function creategraphs4(num)
	variable num
	variable disp
	string list,trace,temp
	variable k,i

	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
      string wn="raster_"+num2str(i)
		duplicate/o $trace $wn
		wave twave=$wn
		
		twave = (twave[p]==0) ? nan : twave[p]
		twave = (twave[p]>0) ? 0.5 : twave[p]
		
		
		AppendToGraph twave
		
		string list2 = tracenamelist("",";", 1) 
		variable off_set=itemsinlist(list2)
		string last=stringfromlist(off_set-1, list2, ";")
		SetScale/P x 0,0.199203,"", twave
		ModifyGraph offset($last)={0,(off_set-num)*2}	
		ModifyGraph rgb($last)=(1,12815,52428)
		ModifyGraph mode($last)=3,marker($last)=10,msize($last)=1
		//ModifyGraph rgb(iei_freq)=(1,4,52428)
		//ModifyGraph rgb(real_freq)=(0,0,0)
	endfor
end


// THIS FUNCTIONS CREATE A RASTER PLOT.. SAME IDEA AS plop_offset()


function plot_raster_all()
	display

	string CDF,cdf2
	Variable numDataFolders = CountObjects(":", 4), i
	cdf2=GetDataFolder(1)
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":'new method':Data:S:"
		wave wake,nrem,rem,artifact
		SetScale/P x 0,0.199203,"", artifact
		variable t=wavemax(artifact)
		artifact=artifact/t
		t=wavemax(nrem)
		artifact=artifact*t
		AppendToGraph wake,nrem,rem,artifact
		
		string list2 = tracenamelist("",";", 1) 
		variable off_set=itemsinlist(list2)
		string ws=stringfromlist(off_set-4, list2, ";"),ns=stringfromlist(off_set-3, list2, ";"),rs=stringfromlist(off_set-2, list2, ";"),as=stringfromlist(off_set-1, list2, ";")
		
		ModifyGraph mode=7,rgb($ws)=(49151,65535,49151),rgb($ns)=(49151,60031,65535),rgb($rs)=(65535,49151,49151)
		ModifyGraph hbFill($ws)=2
		ModifyGraph hbFill($ns)=2
		ModifyGraph hbFill($rs)=2
		ModifyGraph hbFill($as)=2
		ModifyGraph offset($ws)={0,((off_set-3*(i+1))*2-0.5)}
		ModifyGraph offset($ns)={0,((off_set-3*(i+1))*2)-0.5}
		ModifyGraph offset($rs)={0,((off_set-3*(i+1))*2)-0.5}
		ModifyGraph offset($as)={0,((off_set-3*(i+1))*2)-0.5}
		setdatafolder $cdf2+nextPath+":'new method':Data:S:"
		add_raster(i+1)
		
	endfor
end


function add_raster(num)
	variable num
	variable disp
	string list,trace,temp
	variable k,i

	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		string wn="raster_"+num2str(i)
		duplicate/o $trace $wn
		wave twave=$wn
		
		twave = (twave[p]==0) ? nan : twave[p]
		twave = (twave[p]>0) ? 0.5 : twave[p]
		
		
		AppendToGraph twave
		
		string list2 = tracenamelist("",";", 1) 
		variable off_set=itemsinlist(list2)-1
		string last=stringfromlist(off_set, list2, ";")
		SetScale/P x 0,0.199203,"", twave
		ModifyGraph offset($last)={0,(off_set-num*3)*2}	
		ModifyGraph mode($last)=3,marker($last)=10,rgb($last)=(0,0,0)
	endfor
end



function extract_allData()
setdatafolder root:BL:

	string CDF,cdf2
	Variable numDataFolders = CountObjects(":", 4), i
	cdf2=GetDataFolder(1)
	string list2 = tracenamelist("",";", 1) 
	variable off_set=itemsinlist(list2)
	variable d1=0,d2=0
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":'new method':Data:C:"
		d1=d1+copy_waves("C",d1)
		setdatafolder $cdf2+nextPath+":'new method':Data:C_raw:"
		d2=d2+copy_waves("C_raw",d2)
	endfor

end


function copy_waves(name,num)
	string name
	variable num
	variable disp
	string list,trace,temp
	variable k,i

	list=wavelist("wave*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)	
		trace=stringfromlist(i,list,",")
		duplicate /o $trace	 $"root:"+name+":wave"+num2str(i+num)
	endfor
	return k
end



//================================================================================================================
function bootstrap_model(sim,inicial,delta)
variable sim,inicial,delta
variable i
make/o/n=(sim) real_freq,con_freq,iei_freq
for (i=0;i<sim;i+=1) 
variable r1,r2,r3
[ r1,r2,r3]=createfakespikes(100,10^(-5+0.005*i))
real_freq[i]=r1
con_freq[i]=r2
iei_freq[i]=r3
endfor


Display iei_freq vs real_freq
AppendToGraph con_freq vs real_freq
AppendToGraph real_freq vs real_freq
ModifyGraph log=1
ModifyGraph mode(iei_freq)=3,marker(iei_freq)=19,msize(iei_freq)=1.5,useMrkStrokeRGB(con_freq)=1,mode(con_freq)=3,marker(con_freq)=19,msize(con_freq)=1.5,rgb(iei_freq)=(1,4,52428),useMrkStrokeRGB(con_freq)=1,lstyle(real_freq)=1,rgb(real_freq)=(0,0,0)
ModifyGraph useMrkStrokeRGB(iei_freq)=1
end

function [ Variable r1,Variable r2,Variable r3 ]createfakespikes(variable sim,variable startfreq)
// recordar agregar un 0 la wave tremtotal!!!!
	variable i	
	
	make/o/n=4000 exp_poiss
	wave tremtotal

	
	variable t1,t2=0,t3=0,totaltime=0,active_iei=0

	for (i=0;i<sim;i+=1) 
	variable rand=enoise(0.5)+0.5
		t1=binarysearchInterp(tremtotal,rand)
		if (numtype(t1)==2)
		variable dummy=1
		endif

		variable s,s1,s2,iei=0,spike=0
		s1=expnoise(1/startfreq+enoise(1/(startfreq)))
		do
			if (numtype(s1)!=0)
				break
			endif
			
			if (s1>t1)
				break
			endif
			
			spike=spike+1
			
			s2=expnoise(1/startfreq+enoise(1/(startfreq)))
			s1=s1+s2
			if (s1>t1)
				break
			endif
			iei=iei+s2	
		while (1==1)
		iei=iei/(spike-1)
		totaltime=totaltime+t1
		t3=t3+spike
		
		if (iei==0)
			iei=nan
		endif
		
		if (numtype(iei)==0)
			active_iei=active_iei+1
			t2=t2+iei
		endif
		
	endfor
r1=startfreq
r2=t3/totaltime
r3=1/(t2/active_iei)
return [r1,r2,r3]
end

// ============================================================
// Same as find_peaks but with 3 different restrictions. 

function find_peaks2()
	setdatafolder root:data:C:
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
		wave c1=$"root:data:C_raw:"+stringfromlist(i,list,","),c2=$"root:data:C:"+stringfromlist(i,list,",")
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
			wavestats/q/r=[V_PeakLoc-150,V_PeakLoc+150] noise 
			if (w[V_PeakLoc]<3*V_sdev)
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
		
		duplicate/o temp $"root:data:S:"+stringfromlist(i,list,",")
		if	(switch1==0)
		print "cell "+num2str(i)+" done!"
		endif
	endfor
end

