*NPD 2015/16 

cd 

use"mcs_cm_npd_absence_2016_restricted.dta", clear

*ID variables 
misstable summarize MCSID 
tab CNUM, m 

*generating person specific ID 
egen CMID = concat (MCSID CNUM)  if CNUM >0

sort CMID
codebook CMID if CMID ! =""
count if CMID != "" 
count if CMID == "" 

*duplicate IDs
duplicates list CMID
duplicates report CMID



duplicates tag CMID, generate(dup)

tab dup, m
sort dup CMID

gen one_school =.
replace one_school =1 if dup ==0
tab one_school, m

summ SESSIONSPOSSIBLE_5HTERM_AB16



summ SESSIONSPOSSIBLE_6HTERM_AB16



Pos. = 11	Variable = PHASE_AB16	Variable label = Phase of education offered by mainstream schools
SPSS user missing values =        thru None
	Value label information for PHASE_AB16
	Value =       	Label = Missing information    
	Value = MS    	Label = Middle (Deemed Secondary)      
	Value = SP    	Label = Special
	Value = AT    	Label = All-Through (exc PRUs,special schools) 
	Value = PR    	Label = Pupil Referral Unit    
	Value = PS    	Label = Primary
	Value = SS    	Label = Secondary (incl CTC and Academies)     
	
	

*adding together duplicate rows 
*convert long to wide so each row is one individual with a unique CMID 
*also need to decide whether to use 5 or 6 half terms 
bysort CMID: gen cmid_dup = _n
reshape wide  MCSID CNUM MAINRECORD_AB16 URN_ANON_16 LEA_ANON_16 ONROLL_1_AB16 ONROLL_2_AB16 ONROLL_3_AB16 ACADEMICYEAR_AB16 GENDER_AB16 PHASE_AB16 YSSA_AB16 ENROLSTATUS_AB16 NCYEARACTUAL_AB16 SESSIONSPOSSIBLE_AUT_AB16 AUTHABSENCE_AUT_AB16 AUTHABSENCEFLAG_AUT_AB16 UNAUTHABSENCE_AUT_AB16 UNAUTHABSENCEFLAG_AUT_AB16 OVERALLABSENCE_AUT_AB16 SESSIONSPOSSIBLE_SPR_AB16 AUTHABSENCE_SPR_AB16 AUTHABSENCEFLAG_SPR_AB16 UNAUTHABSENCE_SPR_AB16 UNAUTHABSENCEFLAG_SPR_AB16 OVERALLABSENCE_SPR_AB16 SESSIONSPOSSIBLE_SUM_AB16 AUTHABSENCE_SUM_AB16 AUTHABSENCEFLAG_SUM_AB16 UNAUTHABSENCE_SUM_AB16 UNAUTHABSENCEFLAG_SUM_AB16 OVERALLABSENCE_SUM_AB16 SESSIONSPOSSIBLE_SUM6TH_AB16 AUTHABSENCE_SUM6TH_AB16 AUTHABSENCEFLAG_SUM6TH_AB16 UNAUTHABSENCE_SUM6TH_AB16 UNAUTHABSENCEFLAG_SUM6TH_AB16 OVERALLABSENCE_SUM6TH_AB16 SESSIONSPOSSIBLE_ANN_AB16 AUTHABSENCE_ANN_AB16 AUTHABSENCEFLAG_ANN_AB16 UNAUTHABSENCE_ANN_AB16 UNAUTHABSENCEFLAG_ANN_AB16 OVERALLABSENCE_ANN_AB16 SESSIONSPOSSIBLE_5HTERM_AB16 AUTHABSENCE_5HTERM_AB16 UNAUTHABSENCE_5HTERM_AB16 OVERALLABSENCE_5HTERM_AB16 SESSIONSPOSSIBLE_6HTERM_AB16 AUTHABSENCE_6HTERM_AB16 UNAUTHABSENCE_6HTERM_AB16 OVERALLABSENCE_6HTERM_AB16 , i (CMID) j (cmid_dup)

duplicates report CMID 



 *below is 6 then 5 half terms 
 
 *6 HALF TERMS

*sessions possible
replace SESSIONSPOSSIBLE_6HTERM_AB161 = 0 if SESSIONSPOSSIBLE_6HTERM_AB161 ==.
replace SESSIONSPOSSIBLE_6HTERM_AB162 = 0 if SESSIONSPOSSIBLE_6HTERM_AB162 ==.
replace SESSIONSPOSSIBLE_6HTERM_AB163 = 0 if SESSIONSPOSSIBLE_6HTERM_AB163 ==.
replace SESSIONSPOSSIBLE_6HTERM_AB164 = 0 if SESSIONSPOSSIBLE_6HTERM_AB164 ==.
replace SESSIONSPOSSIBLE_6HTERM_AB165 = 0 if SESSIONSPOSSIBLE_6HTERM_AB165 ==.

gen SESSIONSPOSSIBLE_6HTERM_AB16 = SESSIONSPOSSIBLE_6HTERM_AB161 + SESSIONSPOSSIBLE_6HTERM_AB162 + SESSIONSPOSSIBLE_6HTERM_AB163 + SESSIONSPOSSIBLE_6HTERM_AB164 + SESSIONSPOSSIBLE_6HTERM_AB165

summ SESSIONSPOSSIBLE_6HTERM_AB16, detail


*overall absence 
replace OVERALLABSENCE_6HTERM_AB161  = 0 if OVERALLABSENCE_6HTERM_AB161 ==.
replace OVERALLABSENCE_6HTERM_AB162  = 0 if OVERALLABSENCE_6HTERM_AB162 ==.
replace OVERALLABSENCE_6HTERM_AB163  = 0 if OVERALLABSENCE_6HTERM_AB163 ==.
replace OVERALLABSENCE_6HTERM_AB164  = 0 if OVERALLABSENCE_6HTERM_AB164 ==.
replace OVERALLABSENCE_6HTERM_AB165  = 0 if OVERALLABSENCE_6HTERM_AB165 ==.

gen OVERALLABSENCE_6HTERM_AB16 = OVERALLABSENCE_6HTERM_AB161 + OVERALLABSENCE_6HTERM_AB162 + OVERALLABSENCE_6HTERM_AB163 + OVERALLABSENCE_6HTERM_AB164 + OVERALLABSENCE_6HTERM_AB165

summ OVERALLABSENCE_6HTERM_AB16, detail

gen absence_rate_16 =  OVERALLABSENCE_6HTERM_AB16 / SESSIONSPOSSIBLE_6HTERM_AB16 *100
summ absence_rate_16, detail

gen absence_bin_16 =.
replace absence_bin_16 =1 if absence_rate_16 >= 10 & absence_rate_16 !=.
replace absence_bin_16 =0 if absence_rate_16 < 10
tab absence_bin_16, m

label variable absence_bin_16 "binary absence 2016 10% 6HT"

*

*NOW 5 HALF TERMS

*sessions possible
replace SESSIONSPOSSIBLE_5HTERM_AB161 = 0 if SESSIONSPOSSIBLE_5HTERM_AB161 ==.
replace SESSIONSPOSSIBLE_5HTERM_AB162 = 0 if SESSIONSPOSSIBLE_5HTERM_AB162 ==.
replace SESSIONSPOSSIBLE_5HTERM_AB163 = 0 if SESSIONSPOSSIBLE_5HTERM_AB163 ==.
replace SESSIONSPOSSIBLE_5HTERM_AB164 = 0 if SESSIONSPOSSIBLE_5HTERM_AB164 ==.
replace SESSIONSPOSSIBLE_5HTERM_AB165 = 0 if SESSIONSPOSSIBLE_5HTERM_AB165 ==.

gen SESSIONSPOSSIBLE_5HTERM_AB16 = SESSIONSPOSSIBLE_5HTERM_AB161 + SESSIONSPOSSIBLE_5HTERM_AB162 + SESSIONSPOSSIBLE_5HTERM_AB163 + SESSIONSPOSSIBLE_5HTERM_AB164 + SESSIONSPOSSIBLE_5HTERM_AB165

summ SESSIONSPOSSIBLE_5HTERM_AB16, detail






*overall absence 
replace OVERALLABSENCE_5HTERM_AB161  = 0 if OVERALLABSENCE_5HTERM_AB161 ==.
replace OVERALLABSENCE_5HTERM_AB162  = 0 if OVERALLABSENCE_5HTERM_AB162 ==.
replace OVERALLABSENCE_5HTERM_AB163  = 0 if OVERALLABSENCE_5HTERM_AB163 ==.
replace OVERALLABSENCE_5HTERM_AB164  = 0 if OVERALLABSENCE_5HTERM_AB164 ==.
replace OVERALLABSENCE_5HTERM_AB165  = 0 if OVERALLABSENCE_5HTERM_AB165 ==.

gen OVERALLABSENCE_5HTERM_AB16 = OVERALLABSENCE_5HTERM_AB161 + OVERALLABSENCE_5HTERM_AB162 + OVERALLABSENCE_5HTERM_AB163 + OVERALLABSENCE_5HTERM_AB164 + OVERALLABSENCE_5HTERM_AB165

summ OVERALLABSENCE_5HTERM_AB16, detail

gen absence_rate_16_5ht =  OVERALLABSENCE_5HTERM_AB16 / SESSIONSPOSSIBLE_5HTERM_AB16 *100
summ absence_rate_16_5ht, detail

gen absence_bin_16_5ht =.
replace absence_bin_16_5ht =1 if absence_rate_16_5ht >= 10 & absence_rate_16_5ht !=.
replace absence_bin_16_5ht =0 if absence_rate_16_5ht < 10
tab absence_bin_16_5ht, m

label variable absence_bin_16_5ht "binary absence 2016 10% 5HT"


*gender
codebook GENDER_AB161
gen gender_num_16 =.
replace gender_num_16 =1 if GENDER_AB161 == "F"
replace gender_num_16 =2 if GENDER_AB161 == "M"
label define gender 1 "F" 2 "M"
label values gender_num_16 gender

tab gender_num_16, m

gen absence16_flag =1

tab NCYEARACTUAL_AB161, m
tab NCYEARACTUAL_AB162, m
tab NCYEARACTUAL_AB163, m

codebook NCYEARACTUAL_AB161

*is the academic year the same for the duplicate entries for the same MCSID? 
count if NCYEARACTUAL_AB161 != NCYEARACTUAL_AB162 & NCYEARACTUAL_AB162 !="" & NCYEARACTUAL_AB161 !="" 
count if NCYEARACTUAL_AB161 != NCYEARACTUAL_AB163 & NCYEARACTUAL_AB163 !="" & NCYEARACTUAL_AB161 !="" 
count if NCYEARACTUAL_AB162 != NCYEARACTUAL_AB163 & NCYEARACTUAL_AB162 !="" & NCYEARACTUAL_AB163 !="" 

list CMID MCSID1 if NCYEARACTUAL_AB161 != NCYEARACTUAL_AB162 & NCYEARACTUAL_AB162 !="" & NCYEARACTUAL_AB161 !=""

count if NCYEARACTUAL_AB161 =="" &  NCYEARACTUAL_AB162 !="" 
count if NCYEARACTUAL_AB161 =="" &  NCYEARACTUAL_AB163 !="" 
count if NCYEARACTUAL_AB162 =="" &  NCYEARACTUAL_AB163 !="" 

encode NCYEARACTUAL_AB161, gen (NCYEARACTUAL_AB161_num)
encode NCYEARACTUAL_AB162, gen (NCYEARACTUAL_AB162_num)
encode NCYEARACTUAL_AB163, gen (NCYEARACTUAL_AB163_num)
encode NCYEARACTUAL_AB164, gen (NCYEARACTUAL_AB164_num)
encode NCYEARACTUAL_AB165, gen (NCYEARACTUAL_AB165_num)


codebook NCYEARACTUAL_AB161_num
tab NCYEARACTUAL_AB161
tab NCYEARACTUAL_AB161_num, m
tab NCYEARACTUAL_AB162_num, m
tab NCYEARACTUAL_AB163_num, m

*1 = year 10
*2 = year 11 
*3 = year 12



gen NCYEARACTUAL_AB16 =.
replace NCYEARACTUAL_AB16 = NCYEARACTUAL_AB161_num
replace NCYEARACTUAL_AB16 = NCYEARACTUAL_AB162_num if NCYEARACTUAL_AB16 ==.
replace NCYEARACTUAL_AB16 = NCYEARACTUAL_AB163_num if NCYEARACTUAL_AB16 ==.
replace NCYEARACTUAL_AB16 = NCYEARACTUAL_AB164_num if NCYEARACTUAL_AB16 ==.
replace NCYEARACTUAL_AB16 = NCYEARACTUAL_AB165_num if NCYEARACTUAL_AB16 ==.
label variable NCYEARACTUAL_AB16 "which academic year yp was in in 2016"

label define ncyear 1 "10" 2 "11" 3 "8" 4 "9"
label values NCYEARACTUAL_AB16 ncyear

tab  NCYEARACTUAL_AB16, m 


sort NCYEARACTUAL_AB16
	  
 
keep CMID MCSID1 CNUM1 URN_ANON_161 LEA_ANON_161 ACADEMICYEAR_AB161 GENDER_AB161 NCYEARACTUAL_AB161 SESSIONSPOSSIBLE_6HTERM_AB16 OVERALLABSENCE_6HTERM_AB16 SESSIONSPOSSIBLE_5HTERM_AB16 OVERALLABSENCE_5HTERM_AB16 absence_rate_16 absence_rate_16_5ht absence_bin_16  absence_bin_16_5ht gender_num_16 absence16_flag NCYEARACTUAL_AB16 UNAUTHABSENCE_6HTERM_AB16 UNAUTHABSENCE_5HTERM_AB16  unauthabsence_rate_16  unauthabsence_rate_16_5ht AUTHABSENCE_6HTERM_AB16 authabsence_rate_16 authabsence_rate_16_5ht one_school

replace one_school =0 if one_school ==.

misstable summarize 

save "Working\all_waves_data_files\npd_2016_w.dta", replace




*CENSUS

use"mcs_cm_npd_school_census_2016_restricted.dta", clear

*ID variables 
misstable summarize MCSID 
tab CNUM, m /

*generating person specific ID 
egen CMID = concat (MCSID CNUM)  if CNUM >0

sort CMID
codebook CMID if CMID ! =""
count if CMID != "" 
count if CMID == ""

*duplicate IDs
duplicates list CMID
duplicates report CMID s  
duplicates drop CMID, force 



CNUM 
MCSID
ACADEMICYEAR_SPR16
NCYEARACTUAL_SPR16 
YEAROFBIRTH_SPR16 
MONTHOFBIRTH_SPR16
FSMELIGIBLE_SPR16 //fsm this census
EVERFSM_3_SPR16 //fsm in last 3 years
EVERFSM_6_SPR16 ///fsm in last 6 years 
EVERFSM_ALL_SPR16 //fsm ever
ETHNICGROUPMINOR_SPR16 
ETHNICGROUPMAJOR_SPR16  
ACADEMICYEAR_SPR16 
SENPROVISION_SPR16 
SENPROVISIONMAJOR_SPR16 
IDACIRANK_15_SPR16

keep MCSID CNUM GENDER_SPR16 YEAROFBIRTH_SPR16 MONTHOFBIRTH_SPR16 ETHNICGROUPMINOR_SPR16 ETHNICGROUPMAJOR_SPR16 FSMELIGIBLE_SPR16 EVERFSM_3_SPR16 EVERFSM_6_SPR16 EVERFSM_ALL_SPR16 NCYEARACTUAL_SPR16 SENPROVISION_SPR16 SENPROVISIONMAJOR_SPR16 IDACIRANK_15_SPR16 CMID

misstable summarize 
tab SENPROVISION_SPR16, m 
tab SENPROVISIONMAJOR_SPR16, m
codebook SENPROVISION_SPR16

Pos. = 32	Variable = SENPROVISION_SPR16	Variable label = Provision types under the SEN code of practice  
	Value label information for SENPROVISION_SPR16
	Value = K  	Label = SEN support    
	Value = E  	Label = Education, health and care plan
	Value = N  	Label = No Special Educational Need    
	Value = A  	Label = School Action or Early Years Action    
	Value = S  	Label = Statement      
	Value = P  	Label = School/Early Years Action Plus 

Pos. = 33	Variable = SENPROVISIONMAJOR_SPR16	Variable label = Pupil's major SEN provision group based on SEN provision code   
	Value label information for SENPROVISIONMAJOR_SPR16
	Value = 3_SS              	Label = SEN with a Statement   
	Value = 2_SNS             	Label = SEN without a Statement
	Value = 1_NON             	Label = No identified SEN      
	Value = 4_UNCL            	Label = Unclassified   


tab FSMELIGIBLE_SPR16, m
tab EVERFSM_3_SPR16, m
tab EVERFSM_6_SPR16, m

tab ETHNICGROUPMINOR_SPR16, m
tab ETHNICGROUPMAJOR_SPR16, m  

save "Working\all_waves_data_files\npd_census_2016_w.dta", replace

*merging absence table with census 

use "Working\all_waves_data_files\npd_2016_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\npd_census_2016_w.dta" 



count if MCSID !=MCSID1 & MCSID !="" & MCSID1 !="" 

misstable summarize


*missing data 

codebook GENDER_SPR16
replace GENDER_SPR16 ="1" if GENDER_SPR16 =="F" 
replace GENDER_SPR16 ="2" if GENDER_SPR16 =="M" 
destring GENDER_SPR16, replace
label values GENDER_SPR16 gender
tab GENDER_SPR16, m




tab gender_num_16, m
codebook gender_num_16



	  count if gender_num_16 != GENDER_SPR16  & gender_num_16 !=. & GENDER_SPR16 !=. //0
	  
	  tab gender_num_16 GENDER_SPR16, m
	  
	  replace gender_num_16 = GENDER_SPR16 if gender_num_16 ==.
	  tab gender_num_16, m
	  label variable gender_num_16 "Gender combining absence and census tables"
	  	  
	  drop _merge 
	  
	
	  save "Working\all_waves_data_files\npd_abs_census_2016_w.dta", replace
	  
	  
	  ********bringing in gender from previous waves NPD*************
	  
	  
use"mcs_cm_npd_school_census_2015_restricted.dta", clear

*ID variables 
misstable summarize MCSID 
tab CNUM, m 
*generating person specific ID 
egen CMID = concat (MCSID CNUM)  if CNUM >0

sort CMID
codebook CMID if CMID ! =""
count if CMID != "" 
count if CMID == "" 

*duplicate IDs
duplicates list CMID
duplicates report CMID   
duplicates drop CMID, force

tab GENDER_SPR15, m

keep CMID GENDER_SPR15

save "Working\all_waves_data_files\npd_census_2015_w.dta", replace
