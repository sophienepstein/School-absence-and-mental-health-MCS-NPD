*merging MCS and NPD

cd 

use "Working\all_waves_data_files\waves_5to7_merged_w.dta", clear
*this is a version which has not limited to those in england 

merge 1:1 CMID using "Working\all_waves_data_files\npd_abs_census_2016_w.dta"

drop _merge



merge 1:1 CMID using "Working\all_waves_data_files\mcs1_hhgrid_w.dta"
	
tab GCMCS7AG, m	//Age at interview to nearest 10th of year

*from MCS wave 1 

tab AHCDBY00, m
tab AHCDBM00, m

gen firstofmonth =1
gen dob_mcs = mdy(AHCDBM00, firstofmonth,  AHCDBY00) 
tab dob_mcs, m
format dob_mcs %td
tab dob_mcs,m
label variable dob_mcs "From MCS"

*from NPD 
tab YEAROFBIRTH_SPR16, m
tab MONTHOFBIRTH_SPR16, m

gen dob = mdy(MONTHOFBIRTH_SPR16, firstofmonth,  YEAROFBIRTH_SPR16) 
tab dob, m
format dob %td
tab dob,m
label variable dob "From NPD"

count if dob_mcs != dob & dob_mcs !=. & dob !=.

tab dob dob_mcs if dob_mcs != dob & dob_mcs !=. & dob !=.


*age at start of follow up (using MCS data)

gen age_1sept_2015 =.
replace age_1sept_2015 = td(01sep2015) - dob_mcs
gen age_years_1sept_2015 = age_1sept_2015/365.25

tab age_years_1sept_2015, m

gen age_22july_2016 =.
replace age_22july_2016 = td(22jul2016) - dob_mcs
gen age_years_22july_2016 = age_22july_2016/365.25

tab age_years_22july_2016, m

gen age_31may_2016 =.
replace age_31may_2016 = td(31may2016) - dob_mcs
gen age_years_31may_2016 = age_31may_2016/365.25

tab age_years_31may_2016, m

*from mcs wave 7
tab interview_date, m
codebook interview_date

*age at interview to nearest 10th of a year 
tab GCMCS7AG, m
summ GCMCS7AG 
codebook GCMCS7AG 
replace GCMCS7AG =. if GCMCS7AG ==-1

*age gap in years between 31st may july 2016 and date they were interviewed

gen exposure_outcome_lag =.
replace exposure_outcome_lag = GCMCS7AG - age_years_31may_2016 if GCMCS7AG !=. & age_years_31may_2016 !=.
tab exposure_outcome_lag, m 
summ exposure_outcome_lag

summ exposure_outcome_lag, detail

             
*(NB this is all if we use 5half terms ie to the end of may)

*VARIABLES FOR ANALYSIS 

*EXPOSURE VARIABLES 
absence_rate_16
absence_bin_16
authabsence_rate_16
unauthabsence_rate_16

*COVARIATES 
tab SENPROVISION_SPR16, m
tab FSMELIGIBLE_SPR16, m
tab ETHNICGROUPMAJOR_SPR16, m
tab GENDER_SPR16, m
tab age_1sept_2016 

tab EPTSUS00, m	//Has CM ever been temp suspended excluded from school for at least a day 
tab EPTEXC00, m	// Has CM ever been expelled or permanently excluded from school?  
codebook EPTSUS00
codebook EPTEXC00
*1 = yes 2 = no 
replace EPTSUS00 =. if EPTSUS00 ==-1
replace EPTEXC00 =. if EPTEXC00 ==-1
 

gen exclusion_mcs6 =.
replace exclusion_mcs6 =1 if EPTSUS00 ==1 | EPTEXC00 ==1
replace exclusion_mcs6 =0 if EPTSUS00 ==2 | EPTEXC00 ==2 & exclusion_mcs6 ==.
label variable exclusion_mcs6 "permanent or fixed term exclusion ever as reported by parent in mcs6"
tab exclusion_mcs6, m

*OUTCOME VARIABLES 

tab GEBDTOT_C, m	//Self-reported CM s response SDQ Total Difficulties
replace GEBDTOT_C =. if GEBDTOT_C ==-1
summ GEBDTOT_C
*range 0-34

tab GEBDTOT, m		//Parent-reported CM SDQ Total Difficulties
replace GEBDTOT =. if GEBDTOT ==-1
summ GEBDTOT
*range 0-35

save "Working\all_waves_data_files\mcs5to7_NPD2016_w.dta", replace




