*variables for weighting 


cd 


*ETHNICITY**
mcs1_cm_derived.sav	8	ADC06E00	DV Cohort Member Ethnic Group - 6 category Census class 
mcs2_cm_derived.sav	5	BDC06E00	DV Cohort Member Ethnic Group - 6 category Census class 
mcs3_cm_derived.sav	4	CDC06E00	DV Cohort Member Ethnic Group - 6 category Census class 
mcs4_cm_derived.sav	3	DDC06E00	DV Cohort Member Ethnic Group - 6 category Census class 
mcs5_cm_derived.sav	3	EDCE0600	S5 DV CM ethnic group classification - 6 categories 
mcs6_cm_derived.sav	9	FDCE0600	S6 DV CM ethnic group classification - 6 categories 

*WAVE 1
use "Original_data\UKDA-4683-stata\stata\stata13\mcs1_cm_derived.dta", clear

*ID variables
tab ACNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID ACNUM00) if ACNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

save "Working\all_waves_data_files\mcs1_cm_derived_w.dta" 

*WAVE 2
use "Original_data\UKDA-5350-stata\stata\stata13\mcs2_cm_derived.dta", clear

*ID variables
tab BCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID BCNUM00) if BCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

save "Working\all_waves_data_files\mcs2_cm_derived_w.dta" 

*WAVE 3
use "Original_data\UKDA-5795-stata\stata\stata13\mcs3_cm_derived.dta", clear

*ID variables
tab CCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID CCNUM00) if CCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == ""

save "Working\all_waves_data_files\mcs3_cm_derived_w.dta" 

*WAVE 4
use "Original_data\UKDA-6411-stata\stata\stata13\mcs4_cm_derived.dta", clear

*ID variables
tab DCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID DCNUM00) if DCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

save "Working\all_waves_data_files\mcs4_cm_derived_w.dta" 


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


save "Working\all_waves_data_files\mcs6_cm_derived_w.dta" 


*MERGING 
use "Working\all_waves_data_files\mcs1_cm_derived_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\mcs2_cm_derived_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs3_cm_derived_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs4_cm_derived_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs5_cm_derived_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs6_cm_derived_w.dta"

drop _merge

keep CMID ADC06E00 BDC06E00 CDC06E00 DDC06E00 EDCE0600 FDCE0600


tab ADC06E00, m
tab BDC06E00, m
tab CDC06E00, m
tab DDC06E00, m
tab EDCE0600, m
tab FDCE0600, m

codebook ADC06E00
codebook BDC06E00
codebook CDC06E00
codebook DDC06E00
codebook EDCE0600
codebook FDCE0600

replace ADC06E00 =. if ADC06E00 <0
replace BDC06E00 =. if BDC06E00 <0
replace CDC06E00 =. if CDC06E00 <0
replace DDC06E00 =. if DDC06E00 <0
replace EDCE0600 =. if EDCE0600 <0
replace FDCE0600 =. if FDCE0600 <0
    

				
*codebook - may need to convert values to missing 

gen ethnicity_1to6 =.
replace ethnicity_1to6 = FDCE0600
replace ethnicity_1to6 = EDCE0600 if ethnicity_1to6 ==.
replace ethnicity_1to6 = DDC06E00 if ethnicity_1to6 ==.
replace ethnicity_1to6 = CDC06E00 if ethnicity_1to6 ==.
replace ethnicity_1to6 = BDC06E00 if ethnicity_1to6 ==.
replace ethnicity_1to6 = ADC06E00 if ethnicity_1to6 ==.

tab ethnicity_1to6, m 





save "Working\all_waves_data_files\1to6_cm_derived_ethnicity_w.dta"


*SEX**
mcs1_hhgrid.sav	8	AHCSEX00	Cohort Member Sex
mcs2_hhgrid.sav	8	BHCSEX00	Cohort Member Sex 
mcs3_cm_interview.sav	106	CHCSEX00	Cohort Member Sex   
mcs4_cm_interview.sav	139	DCCSEX00	Cohort member Sex



*WAVE 1
use "Original_data\UKDA-4683-stata\stata\stata13\mcs1_hhgrid.dta", clear


*ID variables
tab ACNUM00, m 
misstable summarize MCSID 


*generating person specific ID 

egen CMID = concat (MCSID ACNUM00) if ACNUM00 !=.

codebook CMID
count if CMID != "" 
count if CMID == "" 
drop if CMID == ""

duplicates report CMID

save "Working\all_waves_data_files\mcs1_hhgrid_w.dta" , replace

*WAVE 2
use "Original_data\UKDA-5350-stata\stata\stata13\mcs2_hhgrid.dta", clear

*ID variables
tab BCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID BCNUM00) if BCNUM00 !=.

codebook CMID
count if CMID != "" 
count if CMID == "" 
drop if CMID ==""

duplicates report CMID

save "Working\all_waves_data_files\mcs2_hhgrid_w.dta", replace

*WAVE 3
use "Original_data\UKDA-5795-stata\stata\stata13\mcs3_cm_interview.dta", clear

*ID variables
tab CCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID CCNUM00) if CCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

duplicates report CMID

save "Working\all_waves_data_files\mcs3_cm_interview_w.dta" 

*WAVE 4
use "Original_data\UKDA-6411-stata\stata\stata13\mcs4_cm_interview.dta", clear

*ID variables
tab DCNUM00, m 
misstable summarize MCSID 

*generating person specific ID 

egen CMID = concat (MCSID DCNUM00) if DCNUM00 >0

codebook CMID
count if CMID != "" 
count if CMID == "" 

duplicates report CMID

save "Working\all_waves_data_files\mcs4_cm_interview_w.dta" 

*MERGING 
use "Working\all_waves_data_files\mcs1_hhgrid_w.dta", clear

merge 1:1 CMID using "Working\all_waves_data_files\mcs2_hhgrid_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs3_cm_interview_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\mcs4_cm_interview_w.dta"

drop _merge

keep CMID AHCSEX00 BHCSEX00 CHCSEX00 DCCSEX00



tab AHCSEX00, m
tab BHCSEX00, m
tab CHCSEX00, m
tab DCCSEX00, m

codebook DCCSEX00 
codebook CHCSEX00

replace CHCSEX00 =. if CHCSEX00 == -1
replace DCCSEX00 =. if DCCSEX00 == -1


*codebook - may need to convert values to missing 

gen sex_1to4 =.
replace sex_1to4 = DCCSEX00
replace sex_1to4 = CHCSEX00 if sex_1to4 ==.
replace sex_1to4 = BHCSEX00 if sex_1to4 ==.
replace sex_1to4 = AHCSEX00 if sex_1to4 ==.


tab sex_1to4, m 



save "Working\all_waves_data_files\1to4_sex_w.dta"


