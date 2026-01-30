*all waves hhgrid merge 

cd 

*hhgrid 7
use "Original_data\UKDA-8682-stata\stata\stata13\mcs7_hhgrid.dta", clear

tab GHINTM00, m
tab GHINTY00, m

codebook GHINTM00
codebook GHINTY00

gen firstofmonth =1

gen interview_date = mdy(GHINTM00, firstofmonth,  GHINTY00) 

tab interview_date, m

format interview_date %td

*need to combine with age at interview from another dataset 

keep MCSID GCNUM00 GHCDBM00 GHCDBY00 G_OUT_CMBOOST G_OUT_CMCAPI G_OUT_CMCASI G_OUT_CMCAWI G_OUT_COGASS G_OUT_PHYSMEAS G_OUT_HHQ G_OUT_PARCAWI GHPSEX00 GHCSEX00 GHINTM00 GHINTY00 interview_date

*generating person specific ID 
egen CMID = concat (MCSID GCNUM00) if GCNUM00 >0
drop if CMID ==""
gen hhgrid_flag =1
gen hhgrid_flag_MCS7 =1 

count if CMID != "" 
duplicates report CMID

save "Working\all_waves_data_files\mcs7_hhgrid_w.dta", replace


*hhgrid6 
use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_hhgrid.dta", clear

keep MCSID FCNUM00 FHCDBM00 FHCDBY00 FHPSEX00 FHCSEX00

*generating person specific ID 
egen CMID = concat (MCSID FCNUM00) if FCNUM00 >0
drop if CMID ==""
gen hhgrid_flag =1
gen hhgrid_flag_MCS6 =1 
count if CMID != ""

save "Working\all_waves_data_files\mcs6_hhgrid_w.dta", replace

*hhgrid5
use"Original_data\UKDA-7464-stata\stata\stata13\mcs5_hhgrid.dta", clear

keep MCSID ECNUM00 ECDBY0000 ECDBM0000 EPSEX0000 ECSEX0000

*generating person specific ID 
egen CMID = concat (MCSID ECNUM00) if ECNUM00 !=.
drop if CMID ==""
duplicates list CMID
gen hhgrid_flag_MCS5 =1 
count if CMID != "" 

save "Working\all_waves_data_files\mcs5_hhgrid_w.dta", replace


*MERGING 

use "Working\all_waves_data_files\mcs5_hhgrid_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\mcs6_hhgrid_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs7_hhgrid_w.dta"


**all 3 waves combined 


tab hhgrid_flag_MCS7, m 
tab hhgrid_flag_MCS6, m 
tab hhgrid_flag_MCS5, m  


*creating sex variables combining all the waves 

*the wave7 sex variable has not applicable and [spontaneous] other way, as well as missing - converting these to missing 
tab GHCSEX00, m
tab GHCSEX00 if hhgrid_flag_MCS7 ==1, m
codebook GHCSEX00 

replace GHCSEX00 =. if GHCSEX00 == -1 | GHCSEX00 == 3
tab GHCSEX00 if hhgrid_flag_MCS7 ==1, m

tab FHCSEX00, m
tab FHCSEX00 if hhgrid_flag_MCS6 ==1, m
codebook FHCSEX00

tab ECSEX0000, m
tab ECSEX0000 if hhgrid_flag_MCS5 ==1, m
codebook ECSEX0000


gen CMSEX =.
replace CMSEX = ECSEX0000 
tab CMSEX, m
replace CMSEX = FHCSEX00  if CMSEX ==.
tab CMSEX, m
replace CMSEX = GHCSEX00  if CMSEX ==.
tab CMSEX, m


tab CMSEX if hhgrid_flag_MCS7 ==1, m
tab CMSEX if hhgrid_flag_MCS6 ==1, m
tab CMSEX if hhgrid_flag_MCS5 ==1, m


save "Working\all_waves_data_files\all_hhgrid_w.dta", replace


*hhgrid wave 1 
use "Original_data\UKDA-4683-stata\stata\stata13\mcs1_hhgrid.dta", clear


*generating person specific ID 
egen CMID = concat (MCSID ACNUM00) if ACNUM00 !=.
drop if CMID ==""
duplicates list CMID
gen hhgrid_flag_MCS1 =1 
count if CMID != "" 
count if CMID == "" 

*CM DOB
tab AHCDBM00, m //birth month
replace AHCDBM00 =. if AHCDBM00 ==-1
tab AHCDBY00, m //birth year
replace AHCDBY00 =. if AHCDBY00 ==-1

tab AHCSEX00, m
replace AHCSEX00 =. if AHCSEX00 ==-1

keep AHCDBY00 AHCDBM00 AHCSEX00 CMID

save "Working\all_waves_data_files\mcs1_hhgrid_w.dta", replace 
