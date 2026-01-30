*merging 

cd 


mcs5_family_derived.sav	
mcs6_family_derived.sav	

mcs5_hhgrid.sav
mcs6_hhgrid.sav
mcs7_hhgrid.sav

mcs5_cm_interview.sav
mcs6_cm_interview.sav
mcs7_cm_interview.sav

mcs5_cm_derived.sav
mcs6_cm_derived.sav
mcs7_cm_derived.sav

mcs5_parent_cm_interview.sav
mcs6_parent_cm_interview.sav
mcs7_parent_cm_interview.sav
 

*CM INTERVIEW
*(1 row per individual, merged using CMID)
use "Working\all_waves_data_files\all_cm_interview_w.dta", clear

*HHGRID
*(1 row per individual, merged using CMID)
merge 1:1 CMID using "Working\all_waves_data_files\all_hhgrid_w.dta" 

drop _merge

*CM DERIVED 
*(1 row per individual, merged using CMID)
merge 1:1 CMID using "Working\all_waves_data_files\all_cm_derived_w.dta"

drop _merge

*PARENT CM INTERVIEW
*(1 row per individual, merged using CMID)
merge 1:1 CMID using "Working\all_waves_data_files\all_parent_cm_interview_w.dta"

drop _merge


*FAMILY DERIVED
*inteviewed in england waves 5 and 6 - only ID is MCSID (one row per family)
merge m:1 MCSID using "Working\all_waves_data_files\mcs5and6_family_derived_w.dta"

tab EACTRY00, m
tab FACTRY00, m
 

drop _merge

save "Working\all_waves_data_files\waves_5to7_merged_w.dta", replace

keep if FACTRY00 ==1 |  EACTRY00 ==1

save "Working\all_waves_data_files\waves_5to7_merged_england_w.dta", replace


