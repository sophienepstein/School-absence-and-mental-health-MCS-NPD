*cm_derived all waves


cd 

*WAVE 5
use "Original_data\UKDA-7464-stata\stata\stata13\mcs5_cm_derived.dta", clear

*ID variables
tab ECNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID ECNUM00) if ECNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == ""  

gen derived_flag =1
gen derived_flag_5 =1


save "Working\all_waves_data_files\mcs5_cm_derived_w.dta" 

*WAVE 6
use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_cm_derived.dta", clear


*ID variables
tab FCNUM00, m 
misstable summarize MCSID 
*generating person specific ID 

egen CMID = concat (MCSID FCNUM00) if FCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

gen derived_flag =1
gen derived_flag_6 =1


save "Working\all_waves_data_files\mcs6_cm_derived_w.dta" 



*WAVE 7
use "Original_data\UKDA-8682-stata\stata\stata13\mcs7_cm_derived.dta", clear

*ID variables
tab GCNUM00, m 

misstable summarize MCSID //no missing 

*generating person specific ID 

egen CMID = concat (MCSID GCNUM00) if GCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 


gen derived_flag =1
gen derived_flag_7 =1


save "Working\all_waves_data_files\mcs7_cm_derived_w.dta", replace


*age at interview to nearest 10th of a year 
codebook GCMCS7AG
sort GCMCS7AG
tab GCMCS7AG, m 
tab GCMCS7AG if GCMCS7AG >=17 & GCMCS7AG <18 
tab GCMCS7AG if GCMCS7AG >=18 & GCMCS7AG !=. 
tab GCMCS7AG if GCMCS7AG <17 & GCMCS7AG !=-1 


*MERGING 
use "Working\all_waves_data_files\mcs5_cm_derived_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\mcs6_cm_derived_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs7_cm_derived_w.dta"

save "Working\all_waves_data_files\all_cm_derived_w.dta"

