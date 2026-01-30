*parent_cm_interview all waves

cd 

*WAVE 5
use "Original_data\UKDA-7464-stata\stata\stata13\mcs5_parent_cm_interview", clear

*keeping only main respondent in family 
codebook EELIG00
tab EELIG00, m
keep if EELIG00 ==1

*ID variables
tab ECNUM00, m 
misstable summarize MCSID //no missing 

duplicates report MCSID

*generating person specific ID 
egen CMID = concat (MCSID ECNUM00)  if ECNUM00 >0

duplicates report CMID

codebook CMID
count if CMID != "" 
count if CMID == "" 

gen parent_cm_interview_flag =1
gen parent_cm_interview_flag_5 =1

save "Working\all_waves_data_files\mcs5_parent_cm_interview_w.dta", replace



*WAVE 6
use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_parent_cm_interview", clear

*keeping only main respondent in family 
tab FELIG00, m
keep if FELIG00 ==1

*ID variables
tab FCNUM00, m  
misstable summarize MCSID 

*generating person specific ID 
egen CMID = concat (MCSID FCNUM00)  if FCNUM00 >0

duplicates report CMID


codebook CMID
count if CMID != "" 
count if CMID == "" 

gen parent_cm_interview_flag =1
gen parent_cm_interview_flag_6 =1

save "Working\all_waves_data_files\mcs6_parent_cm_interview_w.dta", replace

*WAVE 7
use "Original_data\UKDA-8682-stata\stata\stata13\mcs7_parent_cm_interview", clear

tab G_OUT_PARQUEST, m
codebook G_OUT_PARQUEST

*1  Parent CAWI and Parent-reported SDQ (paper)                                      
*2  Parent CAWI only
*3  Parent-reported SDQ (paper)

drop if G_OUT_PARQUEST ==2

*ID variables
tab GCNUM00, m 
misstable summarize MCSID

*generating person specific ID 
egen CMID = concat (MCSID GCNUM00)  if GCNUM00 >0

duplicates report CMID

codebook CMID
count if CMID != "" 
count if CMID == "" 

gen parent_cm_interview_flag =1
gen parent_cm_interview_flag_7 =1

save "Working\all_waves_data_files\mcs7_parent_cm_interview_w.dta", replace


*MERGING

use "Working\all_waves_data_files\mcs5_parent_cm_interview_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\mcs6_parent_cm_interview_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs7_parent_cm_interview_w.dta"


save "Working\all_waves_data_files\all_parent_cm_interview_w.dta"

