#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.




function lazy()



Transient_batch()
setdatafolder root:'CN21 20uM':Data:SCR:Late:
Transient_batch()
setdatafolder root:'CN21 20uM':Data:CN21:Early:
Transient_batch()
setdatafolder root:'CN21 20uM':Data:CN21:Late:
Transient_batch()
setdatafolder root:'CN21 5uM':Data:SCR:Late:
Transient_batch()
setdatafolder root:'CN21 5uM':Data:SCR:Early:
Transient_batch()
setdatafolder root:'CN21 5uM':Data:CN21:late:
Transient_batch()
setdatafolder root:'CN21 5uM':Data:CN21:Early:
Transient_batch()
end


function Transient_batch()
// PARAMETERS************
variable sf=20000

// *************


	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	
	for(i=0; i<(numDataFolders); i+=1)

		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":"
		wave fullsweep
		duplicate/o fullsweep origial
		//fullsweep=fullsweep*-1
		Get_transients("fullsweep",20000,0)
		setdatafolder $cdf2+nextPath+":events"
		Event_fitting_batch()
		get_Kinetics()
		delete_bad_events()
	endfor
	
	end


function Get_AUC_and_Amplitude()
	string list=wavelist("wave*"+"_ev*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i
	make/o/n=(k) AUC
	make/o/n=(k) Amp
	make/o/n=(k) Rise
	for (i=0;i<k;i+=1)	
		string raw=stringfromlist(i,list,",")
		duplicate/o $raw temp
		amp[i]=wavemax(temp)
		findlevel/q temp, wavemax(temp)*0.9
		RIse[i]=V_LevelX
		integrate temp
		AUC[i]=wavemax(temp)
	endfor
end





function move_Events()
	string list=wavelist("*_ev*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i
	killdatafolder/z events
	newdatafolder/o events
	for (i=0;i<k;i+=1)	
		string raw=stringfromlist(i,list,",")
		movewave $raw $":events:"+raw
	endfor
end




function Get_transients_batch(sf)
	variable sf

	string list=wavelist("wave*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l	
	for (i=0;i<k;i+=1)	
		string raw=stringfromlist(i,list,",")
		Get_transients(raw,sf,0)
	endfor
	move_Events()
end

//complete_transient_border($fullsweep,c_fullsweep,20000,th2,disp)
function Get_transients(raw,sf,disp)
	string raw
	variable sf,disp
	//detect_events_first_estimation(raw,sf,disp)
	//get_real_threshold($raw,sf,disp)
	get_noise($raw)
	variable th3 = 7
	NVAR th2 = noise_thr
	//print "Threshold corrected for 5% FDR is "+num2str(th3)
	print "Get final calcium transients"
	get_dirty_transients(raw,7)
	remove_short_transients($"c_"+raw,sf,disp)
	complete_transient_border($raw,$"c_"+raw,sf,th2,disp)
	find_peak_ca($"c_"+raw)
	
	//killwaves/z filtered, noise, peak, peak_first_run,peak_first_run_hist
	//killwaves/z peak_hist, p_time, p_time_first_run,temp,C_temp
	//killvariables ev_thr,noise_thr,true_noise_thr

	Extract_each_transient(raw,"c_"+raw,sf)
	move_Events()
end

function get_real_threshold(raw,sf,disp)
	wave raw
	variable sf,disp
	Print "Now getting real treshold value..."
	wave peak,p_time
	duplicate/o peak peak_first_run
	duplicate/o p_time p_time_first_run
	duplicate/o raw temp
	temp=temp*-1
	NVAR th1 = ev_thr
	NVAR th2 = noise_thr
	get_dirty_transients("temp",th1)
	remove_short_transients($"c_temp",sf,disp)
	if (disp==1)
		display $"temp"
		appendtograph $"c_temp"
		ModifyGraph rgb($"c_temp")=(0,0,65535)
	endif
	complete_transient_border($"temp",$"c_temp",sf,th2,disp)
	find_peak_ca($"c_temp")

	variable m,thr_out
	if (numpnts(peak)!=0)
	
		Make/N=2000/O peak_first_run_Hist
		Histogram/CUM/B={0,0.01,2000} peak_first_run,peak_first_run_Hist
		m=Wavemax(peak_first_run_Hist)
		peak_first_run_Hist=peak_first_run_Hist*-1
		peak_first_run_Hist=peak_first_run_Hist+m

		Make/N=2000/O peak_Hist
		Histogram/CUM/B={0,0.01,2000} peak,peak_Hist
		m=Wavemax(peak_Hist)
		peak_Hist=peak_Hist*-1
		peak_Hist=peak_Hist+m
		m=wavemin(peak_hist)
		peak_hist-=m
		m=wavemin(peak_first_run_Hist)
		peak_first_run_Hist-=m
		
		duplicate/o peak_hist FDR
		
		FDR=(peak_hist/peak_first_run_Hist)*100
		if (disp==1)
			Display FDR
			Label left "% False Discovery"
			SetAxis left *,30
			ModifyGraph mode=5,hbFill=2
		endif
		findlevel/q/EDGE=2 FDR, 5
		thr_out=V_LevelX
		wavestats/q FDR
		if (numtype(V_LevelX)==2)
			thr_out=th1
		endif
		if (thr_out<5)
		thr_out=5
		endif
		
		
		
	else
		thr_out=th1
	
	endif

	variable/G True_noise_thr=thr_out
end





Function detect_events_first_estimation(raw,sf,disp)
	string raw
	variable sf,disp
	Print "........"
	print "Getting first stimations of Calcium transients...."
	get_noise($raw)
	NVAR th1 = ev_thr
	NVAR th2 = noise_thr
	get_dirty_transients(raw,th1)
	remove_short_transients($"c_"+raw,sf,disp)
	if (disp==1)
		display $raw
		appendtograph $"c_"+raw
		ModifyGraph rgb($"c_"+raw)=(0,0,65535)
	endif
	complete_transient_border($raw,$"c_"+raw,sf,th2,disp)
	find_peak_ca($"c_"+raw)
	print "Estimated Treshold is:"+num2str(th1)
end



Function get_noise(raw)
	wave raw
	duplicate/o raw noise
	//smooth 5, noise
	noise = (noise[p] >0) ? nan : noise[p]
	WaveTransform zapNaNs noise
	sort noise noise
	variable n=numpnts(noise)
	variable/G ev_thr=-noise[0.05*n]
	variable/G noise_thr=-noise[0.95*n]
end

Function get_dirty_transients(raw,thr)
	string raw
	variable thr
	duplicate/o $raw $"C_"+raw
	wave temp=$"C_"+raw
	temp = (temp[p] <thr) ? nan : temp[p]
end



function remove_short_transients(clean,sf,disp)

	wave clean
	variable sf,disp
	variable l=numpnts(clean),i
	variable t,ts,tf
	variable min_transient_duration=47

	for (i=0;i<l;i+=1)
		if (numtype(clean[i])==0)  //stop if a transient is detected
			ts=i
			for (i=i;i<l;i+=1)
				if (numtype(clean[i])==2)
					tf=i
					break
				endif
			endfor
			if (tf-ts<min_transient_duration)
				clean[ts,tf-1]=nan
			endif	
		endif
	endfor
end


Function complete_transient_border(raw,clean,sf,thr,disp)
	wave raw,clean
	variable sf,thr,disp
	variable maxduration=5
	variable l=numpnts(clean),i
	variable m,dummy=-1,event_detected=0
	variable win_size=20

	for (i=0;i<l;i+=1)
		
		if (dummy==i)
			//abort "Algorithm is stuck"
		endif
		if (event_detected==0)
			if (numtype(clean[i])==0)  //stop if a transient is detected
				event_detected=1
				i=i-1
				dummy=i
				if (disp==1)
					cursor/P A  $stringfromlist(0, TraceNameList("",";",1)) i
					SetAxis bottom xcsr(a)-50,xcsr(a)+50
					doupdate
				endif
				for (i=i;i>=0;i-=1)
					m=mean(raw,pnt2x(raw,i-win_size),pnt2x(raw,i+win_size))
					if (m>thr)
						clean[i]=raw[i]
						if (disp==1)
							cursor/P A  $stringfromlist(0, TraceNameList("",";",1)) i
							doupdate
						endif
					else
						clean[i-5,i]=raw
						if (numtype(clean[i-win_size-1])==2) //the algortihm will not stop in case two event become joined
							i=i+1
							break
						endif	
					endif
				endfor
			endif
		endif
				
		if (event_detected==1)
			if (disp==1)
				cursor/P A  $stringfromlist(0, TraceNameList("",";",1)) i
				doupdate
			endif
			if (numtype(clean[i])==2)  //stop if a transient is detected
				event_detected=0
			
				for (i=i;i<l;i+=1)
					m=mean(raw,pnt2x(raw,i-win_size),pnt2x(raw,i+win_size))
					if (m>thr)	
						clean[i]=raw[i]
						if (disp==1)
							cursor/P A  $stringfromlist(0, TraceNameList("",";",1)) i
							doupdate
						endif
						clean[i,i+win_size]=raw
					else
						break
					endif
				endfor	
			endif
		endif	
	endfor		
end

function find_peak_ca(clean)
	wave clean
	duplicate/o clean filtered
	wave filtered
	variable l=numpnts(filtered),i
	make/o/n=0 peak,p_time

	variable ev_start,ev_finish	
	for (i=0;i<l;i+=1)	
		if (numtype(filtered[i])==0)  //stop if a transient is detected
			ev_start=i
			for (i=i;i<l;i+=1)
				if (numtype(filtered[i])==2)  //stop when transient finish
					ev_finish=i
					break
				endif
			endfor
			wavestats/q/R=[ev_start,ev_finish] filtered
			insertpoints/V=(V_max)/M=0 inf,1,peak
			insertpoints/V=(V_maxLoc)/M=0 inf,1,p_time	
		endif
	endfor
end			
end

function Extract_each_transient(raw,clean,sf)
	string raw,clean
	variable sf
	variable shift=600  //limits from transient border

	variable l=numpnts($clean),i

	variable ev_start,ev_finish
	variable ev_num=0
	duplicate/o $clean filt
	filt = (numtype(filt[p])==2) ? 0 : filt[p]	
	for (i=shift;i<l-shift;i+=1)
	
		if (filt[i]!=0)  //stop if a transient is detected
			ev_start=i
			for (i=i;i<l;i+=1)
				if (filt[i]==0)  //stop when transient finish
					ev_finish=i
					break
				endif
			endfor
			duplicate/o/r=[ev_start-shift,ev_finish+shift] filt temp
			temp[0,shift]=0
			temp[shift+ev_finish-ev_start,ev_finish-ev_start+2*shift]=0
			duplicate/o/r=[ev_start-shift,ev_finish+shift] $raw raw1
			duplicate/o/r=[ev_start-shift,ev_finish+shift] $raw Bl
			smooth/m=0 50,BL
			temp=raw1-BL+temp
			duplicate/o temp $raw+"_ev"+num2str(ev_num)
			SetScale/P x 0,1/sf,"", $raw+"_ev"+num2str(ev_num)
			ev_num+=1
		endif
	endfor
end			
end
end



function Event_fitting(wname)
	string wname
	variable e=0
	variable smt=20
	variable stop=0
	do
		stop+=1
		e= MPF2_AutoMPFit("","ExpCOnvEXP","PeakCoefs%d","Constant","BL",wname,"",5,smFact=smt,minAutoFindFraction=5,doDerivedResults=1,doFitCurves=1)
		if (e!=0)
			//print e
			//print wname
			smt+=5
		else
			wave data=:'_0':PeakCoefs0DER
			if (numtype(data[1][0])==2 || data[1][0]<5)
				e=-24
				//print e
				//print wname
				smt+=5
		
			endif
		endif

	while (e!=0 && stop<10)
	if (stop>10)

		print e
		print "no solution"
	endif	
	
	
end

function Event_fitting_batch()
	KillDataFolder/z :fit
	newdatafolder/o fit

	string list=wavelist("fullsweep*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l
	make/o/n=(k) Timing,Amplitude,Areaw,Chi2
	for (i=0;i<k;i+=1)
		string temp=stringfromlist(i,list,",")
		Event_fitting(temp)
		movewave :'_0':MPF2FitCurve_PlusBL $":fit:ev_"+num2str(i)
		wave data=:'_0':PeakCoefs0DER
		Timing[i]=data[0][0]
		Amplitude[i]=data[1][0]
		Areaw[i]=data[2][0]
		NVAR chi = :'_0':MPFChiSquare
		Chi2[i]=chi
		
		KillDataFolder :'_0'
	endfor
	//duplicate/o Timing IEI
	//differentiate/EP=1/METH=2 IEI
	//Make/N=2000/O IEI_Hist;DelayUpdate
	//  Histogram/CUM/P/B={0,1,2000} IEI,IEI_Hist;DelayUpdate

end

function See_event()
	display

	string list=wavelist("fullsweep*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l
	for (i=0;i<k;i+=1)
		string temp=stringfromlist(i,list,",")
		appendtograph $temp
		appendtograph $"root:events:fit:ev_"+num2str(i)
		ModifyGraph rgb($"ev_"+num2str(i))=(1,3,39321)
		doupdate
		sleep/s 0.4
		RemoveFromGraph $"ev_"+num2str(i), $"fullsweep_ev"+num2str(i)
	endfor

end

function delete_bad_events()
	string savedDF= GetDataFolder(1)
	wave amplitude,Chi2,rise,decay
	duplicate/o amplitude discard
	discard=0
	variable k=numpnts(Amplitude),i

	for (i=0;i<k;i+=1)
		variable kill=0
		if (numtype(Amplitude[i])==2)
				kill=1
		endif
		if (chi2[i]>2500)
				kill=1
		endif
		if (decay[i]>0.03)
				kill=1
		endif
		if (Rise[i]>0.004)
				kill=1
		endif	
		if (kill==1)
		discard[i]=1
		killwaves/z $"fullsweep_ev"+num2str(i),$":fit:ev_"+num2str(i)	
		discard[i]=1
		chi2[i]=nan
		decay[i]=nan
		Rise[i]=nan
		Amplitude[i]=nan
		endif
	endfor
	string	list=wavelist("fullsweep_ev*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)
		string trace=stringfromlist(i,list,",")
		duplicate/o $trace temp
		killwaves $trace
		duplicate/o temp $"fullsweep_ev"+num2str(i)
	endfor
	setdatafolder fit
	list=wavelist("ev_*",",","")
	list=SortList(list,",", 16)
	k=itemsinlist(list, ",")
	for (i=0;i<k;i+=1)
		trace=stringfromlist(i,list,",")
		duplicate/o $trace temp
		killwaves $trace
		duplicate/o temp $"ev_"+num2str(i)
	endfor	
	setdatafolder $savedDF
	wave Amplitude, Areaw
	wavetransform zapnans Amplitude 
	wavetransform zapnans Areaw
	wavetransform zapnans decay
	wavetransform zapnans Rise
	wavetransform zapnans Chi2	
	
end


function get_Kinetics()
	string savedDF= GetDataFolder(1)
	setdatafolder fit
	string list=wavelist("ev_*",",",""),trace
	list=SortList(list,",", 16)
	variable k=itemsinlist(list, ","),i,l,t1,t2
	string tiempo= savedDF+"timing"
	make/o/n=(k) decay,rise
	for (i=0;i<k;i+=1)
		string temp=stringfromlist(i,list,",")
		duplicate/o $temp test
		wavestats/q test
		
		Findlevel/q/EDGE=2/R=(V_maxloc,inf) test, V_max*0.36787944117
		decay[i]=V_LevelX-V_maxloc
		Findlevel/q/EDGE=1 test, V_max*0.1
		t1=V_LevelX
		Findlevel/q/EDGE=1 test, V_max*0.9
		t2=V_LevelX
		rise[i]=t2-t1		
	endfor
	duplicate/o decay $savedDF+"decay"
	killwaves decay
	duplicate/o rise $savedDF+"rise"
	killwaves rise	
	setdatafolder $savedDF
	
end

function Loop_decay()
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 decay_all
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
				setdatafolder cdf2+nextPath+":events:"
		get_Kinetics()
		setdatafolder cdf2
		wave temp2=$cdf2+nextPath+":events:decay"
		print mean(temp2)*1000
		Concatenate/NP=0   {temp2}, decay_all
	endfor	
end
	
function Loop_iei()
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 decay_all,rise_all
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
		wave temp=$cdf2+nextPath+":events:decay"
		print mean(temp)*1000
		Concatenate/NP=0   {temp}, decay_all
	endfor	
end
	
	
function Loop_Rise()
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 rise_all
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
		setdatafolder cdf2+nextPath+":events:"
		get_Kinetics()
		setdatafolder cdf2
		wave temp2=$cdf2+nextPath+":events:rise"
		print mean(temp2)*1000
		setdatafolder $cdf2
		Concatenate/NP=0   {temp2}, rise_all
	endfor
end
		
	
	
	
function Loop_amplitude()

	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 Amp
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
		get_amplitude(cdf2,nextPath)
		wave temp=$cdf2+nextPath+":events:amplitude"
		print mean(temp)
		Concatenate/NP=0   {temp}, Amp
		setdatafolder $cdf2
	endfor	
end


function get_amplitude(cdf2,nextPath)
	string cdf2,nextPath

	setdatafolder cdf2+nextPath+":events:fit:"
	string list=wavelist("ev*",";","")
	list=SortList(list,";", 16)
	variable k=itemsinlist(list, ";"),i
	
	make/o/n=(k) amp=0
	for (i=0;i<k;i+=1)
		String temp =stringfromlist(i,list,";")
		amp[i]=wavemax($temp)
	endfor
	duplicate/o amp $cdf2+nextPath+":events:amplitude"
	setdatafolder cdf2+nextPath
end
	
	
	
	
	
	
		
	
function export_all()
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	make/o/n=0 Amp
	
	for(i=0; i<(numDataFolders); i+=1)

		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		wave full=$cdf2+nextPath+":fullsweep"
		duplicate/o full export

		export=export*-10^-12
		SetScale/P x 0,5e-5,"s", export
		Save/C export as nextPath+".ibw"
	endfor
end
	
	
		
function fix_amplitude()
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 Amp
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
		wave temp=$cdf2+nextPath+":events:amplitude"
		wave disc=$cdf2+nextPath+":events:discard"
		temp = (disc[p]==1) ? nan : temp[p]
		wavetransform zapnans temp
	endfor
end



function Plot_each_transient_batch()
// PARAMETERS************
variable sf=20000
// *************
	display
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =GetIndexedObjNameDFR($cdf2, 4, i )
		nextPath="'"+nextpath+"'"
		setdatafolder $cdf2+nextPath+":events:"
		Plot_each_transient()	
endfor
setdatafolder cdf2
end


function Plot_each_transient()

	string list=wavelist("*_ev*",";","")
	list=SortList(list,";", 16)
	variable k=itemsinlist(list, ";"),i
	for (i=0;i<k;i+=1)
	String temp =stringfromlist(i,list,";")
	duplicate/o $":fit:ev_"+num2str(i) tempw
	differentiate tempw
	wavestats/q tempw
	SetScale/P x -V_maxloc,5e-5,"", $temp
   appendtograph $temp
	
	
endfor
end

function rise_time_sorted_analysis(destination,reference) // detination can be "amplitude"
// reference can be "rise time"
	wave destination,reference
	duplicate/o reference w2
	duplicate/o destination w1
	variable s=0.0005,e=0.003, delta=0.0001
	variable cut
	for (s=s;s<e;s+=delta)
		findlevel/q w2, s
		cut=floor(V_LevelX)
		variable dummy=V_LevelX
		duplicate/o/r=[0,cut] w1 boots
		deletepoints 0, cut+1, w2
		deletepoints 0, cut+1, w1
		//print numpnts(boots)
		bootstrap_mini("boots",1000,0.05)
	endfor
end

function rise_time_sorted_analysis_diff(destination,reference,group_comparisons)
//rise_time_sorted_analysis_diff("amp_rise_sorted","rise_sorted")
	string destination,reference
	variable group_comparisons
	string cdf=GetDataFolder(1)
	variable s=0.0005,e=0.003, delta=0.0001
	variable cut,start=s
	for (s=start;s<e;s+=delta)
		if (s==start)
		duplicate/o $cdf+"Early:"+reference w12
		duplicate/o $cdf+"Early:"+destination w11
		endif
		findlevel/q w12, s
		cut=floor(V_LevelX)
		variable dummy=V_LevelX
		duplicate/o/r=[0,cut] w11 boots1
		deletepoints 0, cut+1, w12
		deletepoints 0, cut+1, w11
		if (s==start)
		duplicate/o $cdf+"Late:"+reference w22
		duplicate/o $cdf+"Late:"+destination w21
		endif
		findlevel/q w22, s
		cut=floor(V_LevelX)
		duplicate/o/r=[0,cut] w21 boots2
		deletepoints 0, cut+1, w22
		deletepoints 0, cut+1, w21
		
		//wave boots1,boots2
		
		//print numpnts(boots)
		
		bootstrap_dif("boots1",cdf+"boots2",10000,0,(e-start)/delta*group_comparisons)
	endfor
	//killwaves w11,w12,w21,w22
end


function bootstrap_mini(wavenom1,sim,alpha)
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
			randnum=ceil((enoise(0.5)+0.5)*(n))-1
			bootstrapsample[i]=tt[randnum]
		endfor
		bootstrapdist[s]=mean(bootstrapsample)
	endfor
	sort bootstrapdist bootstrapdist
	variable CI95=(alpha/2)*sim,CI_MC95=(alpha/6)*sim
	print num2str(aver)+" "+num2str(sqrt(variance(bootstrapdist)))
	killwaves bootstrapdist,bootstrapsample
end

// This function creat bootstrap of the average difference between two data sets.
//del0 can be 1 or 0. if it's 1. any 0 value while be zapped out of the wave.	
	
function bootstrap_dif(wavenom1,wavenom2,sim,del0,comparisons)  //del0==1 delete 0 from wave
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
			randnum=ceil((enoise(0.5)+0.5)*(n))-1
			bootstrapsample[i]=tt[randnum]
		endfor
		for (i2=0;i2<n2;i2+=1)
			randnum=ceil((enoise(0.5)+0.5)*(n2))-1
			bootstrapsample2[i2]=tt2[randnum]
		endfor
		
		variable m2=	mean(bootstrapsample2)
		variable m1=	mean(bootstrapsample)
		
		bootstrapdist[s]=m2-m1
	endfor
	sort bootstrapdist bootstrapdist
	variable CI95=(0.05/2)*sim,CI_MC95=(0.05/(2*comparisons))*sim
	print num2str(mean(bootstrapdist))+" "+num2str(sqrt(variance(bootstrapdist)))+" "+num2str(bootstrapdist(sim-CI_MC95))+" "+num2str(bootstrapdist(CI_MC95))+"  "+num2str(n)+"  "+num2str(n2)
killwaves bootstrapdist,bootstrapsample
end


function get_parameter_rise_thr_by_cell(parameter,thr,thr2)//parameter= "amplitude","rise","frequecny",etc...
	string parameter
	variable thr,thr2
   thr=thr/1000
   thr2=thr2/1000
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 Amp
	print "Thr 1   Thr 2"
	print num2str(thr)+"<  <"+num2str(thr2)
	print "=================="
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
		wave temp=$cdf2+nextPath+":events:"+parameter
		duplicate/o temp parameter_temp
		duplicate/o $cdf2+nextPath+":events:rise" rise_temp
		sort rise_temp parameter_temp
		sort rise_temp rise_temp
		findlevel/q rise_temp, thr
		variable cut=floor(V_LevelX)
		duplicate/o/r=[0,cut] parameter_temp temp1
		findlevel/q rise_temp, thr2
		cut=floor(V_LevelX)
		duplicate/o/r=[cut,numpnts(parameter_temp)] parameter_temp temp2
		print mean(temp1),mean(temp2),numpnts(temp1),numpnts(temp2)
		
	endfor	
	//killwaves parameter_temp,temp2,rise_temp
end





function get_parameter_interval(parameter,thr,thr2)//parameter= "amplitude","rise","frequecny",etc...
	string parameter
	variable thr,thr2
   thr=thr/1000
   thr2=thr2/1000
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	make/o/n=0 Amp
	print "Thr 1   Thr 2"
	print num2str(thr)+"<  <"+num2str(thr2)
	print "=================="
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath="'"+nextpath+"'"
		wave temp=$cdf2+nextPath+":events:"+parameter
		duplicate/o temp parameter_temp
		duplicate/o $cdf2+nextPath+":events:rise" rise_temp
		sort rise_temp parameter_temp
		sort rise_temp rise_temp
		findlevel/q rise_temp, thr
		variable cut1=floor(V_LevelX)
		findlevel/q rise_temp, thr2
		variable cut2=floor(V_LevelX)
		
		duplicate/o/r=[cut1,cut2] parameter_temp temp1
		print mean(temp1)
	endfor	
	killwaves parameter_temp,rise_temp
end




function get_parameter_rise_thr(parameter,thr,thr2)//parameter= "amplitude","rise","frequecny",etc...
	string parameter
	variable thr,thr2
   thr=thr/1000
   thr2=thr2/1000
   string cdf=GetDataFolder(1)
	print "Thr 1   Thr 2"
	print num2str(thr)+"<  <"+num2str(thr2)
	print "=================="

		wave temp=$cdf+"Early:"+parameter
		wave rise_temp=$cdf+"Early:rise_sorted"
		findlevel/q rise_temp, thr
		variable cut=floor(V_LevelX)
		duplicate/o/r=[0,cut] temp temp1
		findlevel/q rise_temp, thr2
		cut=floor(V_LevelX)
		duplicate/o/r=[cut,numpnts(temp)] temp temp2
		
		wave temp=$cdf+"late:"+parameter
		wave rise_temp=$cdf+"late:rise_sorted"
		findlevel/q rise_temp, thr
		cut=floor(V_LevelX)
		duplicate/o/r=[0,cut] temp temp3
		findlevel/q rise_temp, thr2
		cut=floor(V_LevelX)
		duplicate/o/r=[cut,numpnts(temp)] temp temp4
		
		temp3=temp3-mean(temp1)
		temp4=temp4-mean(temp2)
		
		bootstrap_mini("temp3",1000,0.05)
		bootstrap_mini("temp4",1000,0.05)
		
		bootstrap_dif("temp3","temp4",1000,0,2)			
	killwaves temp2,temp1,temp3,temp4
end


function get_parameter_rise_thr_interval(parameter,thr1,thr2,thr3,thr4)//parameter= "amplitude","rise","frequecny",etc...
	string parameter
	variable thr1,thr2,thr3,thr4
   thr1=thr1/1000
   thr2=thr2/1000
   thr3=thr3/1000
   thr4=thr4/1000
   string cdf=GetDataFolder(1)
	print "Thr 1   Thr 2"
	print "=================="

		wave temp=$cdf+"Early:"+parameter
		wave rise_temp=$cdf+"Early:rise_sorted"
		findlevel/q rise_temp, thr1
		variable c1=floor(V_LevelX)
		findlevel/q rise_temp, thr2
		variable c2=floor(V_LevelX)
		duplicate/o/r=[c1,c2] temp temp1
		findlevel/q rise_temp, thr3
		c1=floor(V_LevelX)
		findlevel/q rise_temp, thr4
		c2=floor(V_LevelX)
		
		duplicate/o/r=[c1,c2] temp temp2
		
		wave temp=$cdf+"late:"+parameter
		wave rise_temp=$cdf+"late:rise_sorted"
		findlevel/q rise_temp, thr1
		c1=floor(V_LevelX)
		findlevel/q rise_temp, thr2
		c2=floor(V_LevelX)
		duplicate/o/r=[c1,c2] temp temp3
		findlevel/q rise_temp, thr3
		c1=floor(V_LevelX)
		findlevel/q rise_temp, thr4
		c2=floor(V_LevelX)

		duplicate/o/r=[c1,c2] temp temp4
		
		sort temp3 temp3
		Interpolate2/T=1/N=(numpnts(temp1))/Y=temp3_L temp3
		sort temp4 temp4
		Interpolate2/T=1/N=(numpnts(temp2))/Y=temp4_L temp4

		
		bootstrap_mini("temp1",1000,0.05)
		bootstrap_mini("temp2",1000,0.05)
		bootstrap_mini("temp3_L",1000,0.05)
		bootstrap_mini("temp4_L",1000,0.05)
		
		bootstrap_dif("temp1","temp3_L",1000,0,2)
		bootstrap_dif("temp2","temp4_L",1000,0,2)
		
		
	killwaves temp2,temp1,temp3,temp4,temp3_L,temp4_L
end
	
function pring()
	variable i	
	for(i=0; i<100; i+=1)
		print (gnoise(2)+5)
	endfor
end







function get_amp_rise_sorted()
loop_rise()
loop_amplitude()
loop_decay()
wave rise_all,amp,decay_all
duplicate/o rise_all rise_sorted
duplicate/o Amp Amp_rise_sorted
duplicate/o decay_all decay_sorted
sort rise_all Amp_rise_sorted
sort rise_sorted rise_sorted
sort rise_all decay_sorted 
end


function rise_time_sorted_analysis_diff_per_cell(reference)
	string reference
	Variable numDataFolders = CountObjects(":", 4), i
	string cdf2
	cdf2=GetDataFolder(1)
	String dfList = SortedDataFolderList(cdf2, 16)
	variable start=0.0005,e=0.003, delta=0.0001
	
	variable bin=(e-start)/delta+1
	
	make/o/n=(numDataFolders,bin) binned_data=0
	
	for(i=0; i<(numDataFolders); i+=1)
		String nextPath =stringfromlist(i,dflist,";")
		nextPath=cdf2+"'"+nextpath+"':events:"
		setdatafolder nextpath
		variable cut,index=0,s
		for (s=start;s<e;s+=delta)
			if (s==start)
				wave rise
				duplicate/o rise w11
				duplicate/o $reference w12
			endif
			sort w11 w12
			sort w11 w11
			findlevel/q w11, s
			cut=floor(V_LevelX)
			variable dummy=V_LevelX
			duplicate/o/r=[0,cut] w12 boots1

			binned_data[i][index]=mean(boots1)
			index+=1
		endfor
	endfor
	setdatafolder $cdf2
end
