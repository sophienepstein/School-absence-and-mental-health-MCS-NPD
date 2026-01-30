*analysis absence MH

cd 

use "Working\all_waves_data_files\mcs5to7_NPD2016_w.dta", clear


****************COHORT******************



misstable summarize CMID MCSID1 CNUM1 URN_ANON_161 LEA_ANON_161 ACADEMICYEAR_AB161 GENDER_AB161 NCYEARACTUAL_AB161 SESSIONSPOSSIBLE_6HTERM_AB16 OVERALLABSENCE_6HTERM_AB16 SESSIONSPOSSIBLE_5HTERM_AB16 OVERALLABSENCE_5HTERM_AB16 absence_rate_16 absence_rate_16_5ht absence_bin_16  absence_bin_16_5ht gender_num_16 absence16_flag NCYEARACTUAL_AB16 UNAUTHABSENCE_6HTERM_AB16 UNAUTHABSENCE_5HTERM_AB16  unauthabsence_rate_16  unauthabsence_rate_16_5ht AUTHABSENCE_6HTERM_AB16 authabsence_rate_16 authabsence_rate_16_5ht


misstable summarize MCSID CNUM GENDER_SPR16 YEAROFBIRTH_SPR16 MONTHOFBIRTH_SPR16 ETHNICGROUPMINOR_SPR16 ETHNICGROUPMAJOR_SPR16 FSMELIGIBLE_SPR16 EVERFSM_3_SPR16 EVERFSM_6_SPR16 EVERFSM_ALL_SPR16 NCYEARACTUAL_SPR16 SENPROVISION_SPR16 SENPROVISIONMAJOR_SPR16 IDACIRANK_15_SPR16 CMID

  

misstable summarize GEBDTOT_C GEBDTOT


 tab exclusion_mcs6, m
 misstable summarize exclusion_mcs6
 


  
*****variables list********

*exposures: all from NPD, absence variables 

*outcomes: all from MCS wave 7 - SDQ 

*covariates: all from NPD except exclusion from wave 6 MCS 

*other: wave 5 and 6 SDQ for sensitivity analysis 

*additional: years 7-9 (ie 2013-15) absence data to add to year 10 absence data 

************PREPARING VARIABLES***************

*EXPOSURE VARIABLES 

*percentage measures using 5 half terms 

summ absence_rate_16_5ht if absence_rate_16_5ht !=., detail
summ authabsence_rate_16_5ht if authabsence_rate_16_5ht !=., detail
summ unauthabsence_rate_16_5ht if unauthabsence_rate_16_5ht !=., detail


label variable absence_rate_16_5ht "Overall absence rate 2015/16 (% sessions attended)"

label variable authabsence_rate_16_5ht "Authorised absence rate 2015/16 (% sessions attended)"

label variable unauthabsence_rate_16_5ht "Unauthorised absence rate 2015/16 (% sessions attended)"

histogram absence_rate_16_5ht, bin(20) title ("Distribution of overall absence rates") percent
histogram authabsence_rate_16_5ht, bin(20) title ("Distribution of authorised absence rates") percent
histogram unauthabsence_rate_16_5ht, bin(20) title ("Distribution of unauthorised absence rates") percent

*main binary variables 

*binary overall absence using 10% threshold and using 5 half terms 
tab absence_bin_16_5ht, m


***different absence cutoffs***

misstable summarize absence_rate_16_5ht
misstable summarize authabsence_rate_16_5ht
misstable summarize unauthabsence_rate_16_5ht

tab absence_rate_16_5ht, m
tab authabsence_rate_16_5ht, m
tab unauthabsence_rate_16_5ht, m

*overall 
gen absence_bin_16_1per =.
replace absence_bin_16_1per =1 if absence_rate_16_5ht >=1 & absence_rate_16_5ht !=.
replace absence_bin_16_1per =0 if absence_rate_16_5ht <1 
tab absence_bin_16_1per, m

gen absence_bin_16_5per =.
replace absence_bin_16_5per =1 if absence_rate_16_5ht >=5 & absence_rate_16_5ht !=.
replace absence_bin_16_5per =0 if absence_rate_16_5ht <5
tab absence_bin_16_5per, m

tab absence_bin_16_5ht, m  //10 percent 

gen absence_bin_16_20per =.
replace absence_bin_16_20per =1 if absence_rate_16_5ht >=20  & absence_rate_16_5ht !=.
replace absence_bin_16_20per =0 if absence_rate_16_5ht <20
tab absence_bin_16_20per, m

gen absence_bin_16_30per =.
replace absence_bin_16_30per =1 if absence_rate_16_5ht >=30 & absence_rate_16_5ht !=.
replace absence_bin_16_30per =0 if absence_rate_16_5ht <30
tab absence_bin_16_30per, m

gen absence_bin_16_40per =.
replace absence_bin_16_40per =1 if absence_rate_16_5ht >=40  & absence_rate_16_5ht !=.
replace absence_bin_16_40per =0 if absence_rate_16_5ht <40
tab absence_bin_16_40per, m

gen absence_bin_16_50per =.
replace absence_bin_16_50per =1 if absence_rate_16_5ht >=50 & absence_rate_16_5ht !=.
replace absence_bin_16_50per =0 if absence_rate_16_5ht <50
tab absence_bin_16_50per, m



*SDQ OUTCOME AND PREVIOUS SWEEPS

*Sweep 7 SDQ 


tab GEBDTOT_C, m	//Self-reported CM s response SDQ Total Difficulties sweep 7

tab GEBDTOT, m		//Parent-reported CM SDQ Total Difficulties sweep 7 

tab  FEBDTOT, m    //parent report SDQ sweep 6

*self report SDQ using cutoff of 'high' in 4 band categorisation 
gen sdq_self_sw7_bin = .
replace sdq_self_sw7_bin =1 if GEBDTOT_C >17 & GEBDTOT_C !=.
replace sdq_self_sw7_bin =0 if GEBDTOT_C <18 & GEBDTOT_C !=.
tab sdq_self_sw7_bin, m


count if GEBDTOT_C >17 & GEBDTOT_C !=.

*parent report using cutoff of 'high' in 4 band categorisation 
gen sdq_parent_sw7_bin =.
replace sdq_parent_sw7_bin =1 if GEBDTOT >16 & GEBDTOT !=.
replace sdq_parent_sw7_bin =0 if GEBDTOT <17 & GEBDTOT !=.
tab sdq_parent_sw7_bin, m


count if GEBDTOT >17 & GEBDTOT !=.

*wave 6 parent report SDQ

*parent report using cutoff of 'high' in 4 band categorisation 
gen sdq_parent_sw6_bin =.
replace sdq_parent_sw6_bin =1 if FEBDTOT >16 & FEBDTOT !=.
replace sdq_parent_sw6_bin =0 if FEBDTOT <17 & FEBDTOT !=.
tab sdq_parent_sw6_bin, m




*COVARIATES 

*SEN
tab SENPROVISION_SPR16, m
gen SEN_bin_2016 =.
replace SEN_bin_2016 = 1 if SENPROVISION_SPR16 == "E" | SENPROVISION_SPR16 == "K" | SENPROVISION_SPR16 == "S" 
replace SEN_bin_2016 = 0 if SENPROVISION_SPR16 == "N"
tab SEN_bin_2016, m

*FSM
tab FSMELIGIBLE_SPR16, m
codebook FSMELIGIBLE_SPR16 // 0 and 1

	  
*gender
tab GENDER_SPR16, m
codebook GENDER_SPR16 // 1=F 2=M

tab AHCSEX00, m

tab AHCSEX00 GENDER_SPR16, m

		 
*age/summer born 
		
tab dob, m
codebook dob, detail


gen summer_birth =.
replace summer_birth =1 if dob == td(01may2001) | dob == td(01jun2001)  | dob == td(01jul2001)  |dob == td(01aug2001) 
replace summer_birth =0 if dob == td(01sep2001) | dob == td(01oct2001)  | dob == td(01nov2001)  | dob == td(01dec2001) | dob == td(01jan2001) | dob == td(01feb2001) | dob == td(01mar2001) | dob == td(01apr2001) | dob == td(01sep2000) | dob == td(01oct2000)  | dob == td(01nov2000)  | dob == td(01dec2000) | dob == td(01jan2002) 
tab summer_birth, m



tab exclusion_mcs6, m //"permanent or fixed term exclusion ever as reported by parent in mcs6"

tab age_years_1sept_2015 



save "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w.dta", replace



