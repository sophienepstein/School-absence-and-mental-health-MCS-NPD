*cm_interview_all_waves

cd 


*WAVE 5
use "Original_data\UKDA-7464-stata\stata\stata13\mcs5_cm_interview.dta", clear

*ID variables
tab ECNUM00, m 
misstable summarize MCSID 

*generating person specific ID 
egen CMID = concat (MCSID ECNUM00)  if ECNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == ""  

gen interview_flag =1
gen interview_flag_5 =1

save "Working\all_waves_data_files\mcs5_cm_interview_w.dta"


*WAVE 6
use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_cm_interview.dta", clear

*ID variables
tab FCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 
egen CMID = concat (MCSID FCNUM00)  if FCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == ""

gen interview_flag =1
gen interview_flag_6 =1

save "Working\all_waves_data_files\mcs6_cm_interview_w.dta"



*WAVE 7
use "Original_data\UKDA-8682-stata\stata\stata13\mcs7_cm_interview.dta", clear

*ID variables
tab GCNUM00, m  
misstable summarize MCSID 

*generating person specific ID 
egen CMID = concat (MCSID GCNUM00)  if GCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

gen interview_flag =1
gen interview_flag_7 =1




save "Working\all_waves_data_files\mcs7_cm_interview_w.dta", replace

*MERGING 

use "Working\all_waves_data_files\mcs5_cm_interview_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\mcs6_cm_interview_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs7_cm_interview_w.dta"



save "Working\all_waves_data_files\all_cm_interview_w.dta"
