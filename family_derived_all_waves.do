*family derived 

cd 

*family derived 5

use "Original_data\UKDA-7464-stata\stata\stata13\mcs5_family_derived.dta", clear

gen mcs5_family_derived_flag =1

keep MCSID EACTRY00 mcs5_family_derived_flag

save "Working\all_waves_data_files\mcs5_family_derived_w.dta", replace


*family derived 6
use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_family_derived.dta", clear

gen mcs6_family_derived_flag =1

keep MCSID FACTRY00 mcs6_family_derived_flag

save "Working\all_waves_data_files\mcs6_family_derived_w.dta", replace

*merging waves 5 and 6


use "Working\all_waves_data_files\mcs6_family_derived_w.dta", clear

merge 1:1 MCSID using "Working\all_waves_data_files\mcs5_family_derived_w.dta"


tab FACTRY00 EACTRY00, m
codebook EACTRY00


drop _merge

		   save "Working\all_waves_data_files\mcs5and6_family_derived_w.dta", replace
		   
		   keep if FACTRY00 ==1 |  EACTRY00 ==1
		   
gen england_5and6 = 1 if FACTRY00 ==1 & EACTRY00 ==1
tab england_5and6, m

tab FACTRY00, m
tab EACTRY00, m


*inteviewed in england waves 5 and 6 - only ID is MCSID (one row per family)so need to merge with other datasets which are 1 row per individual
save "Working\all_waves_data_files\mcs5and6_family_derived_england_w.dta"


