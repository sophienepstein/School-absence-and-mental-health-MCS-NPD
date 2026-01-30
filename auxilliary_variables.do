*auxilliary variables 

*ETHNICITY
tab FDCE0600, m //ethnicity 6 cat sweep 6 

*MATERNAL MH
tab FDKESSL, m //kessler wave 6 - parent derived 

mcs6_parent_interview.sav	EUL mcs6 survey	1015	FPPHDE00	How often respondent felt depressed in last 30 days 
mcs6_parent_interview.sav	EUL mcs6 survey	1016	FPPHHO00	How often felt hopeless in last 30 days 
mcs6_parent_interview.sav	EUL mcs6 survey	1017	FPPHRF00	How often felt restless/fidgety in last 30 days 
mcs6_parent_interview.sav	EUL mcs6 survey	1018	FPPHEE00	How often felt everything an effort in last 30 days 
mcs6_parent_interview.sav	EUL mcs6 survey	1019	FPPHWO00	How often felt worthless in last 30 days
mcs6_parent_interview.sav	EUL mcs6 survey	1020	FPPHNE00	How often felt nervous in last 30 days  

*SES
tab FOECDSC0, m // OECD Equivalised income quintiles - by country (need to get from family derived)
tab FOEDP000, m	// OECD Below 60% median indicator (or this -family derived)

FOEDP000
FOECDSC0


*BULLYING
mcs6_parent_cm_interview.sav	EUL mcs6 survey	400	FPSDPB00	Picked on or bullied by other children  



*****************ETHNICITY*************** 
tab FDCE0600, m 


*********************BULLYING********************	
tab FPSDPB00, m
codebook FPSDPB00


		

******************SES**************************
use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_family_derived", clear

duplicates report MCSID //no duplicates 


tab FOECDSC0, m
tab FOEDP000, m
codebook FOECDSC0
codebook FOEDP000

replace FOECDSC0 =. if FOECDSC0 ==-1
replace FOEDP000 =. if FOEDP000 ==-1

keep MCSID FOECDSC0 FOEDP000

save "Working\all_waves_data_files\mcs6_oecd_ses_w.dta" 

		 
		 
**************MATERNAL MH**************************


use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_parent_derived", clear

duplicates report MCSID //max 2 per MCSID 

*generating person specific ID 
egen PMID = concat (MCSID FPNUM00)  if FPNUM00 >0

duplicates report PMID

codebook PMID
count if PMID != "" 
count if PMID == ""

tab FELIG00, m


tab FDKESSL, m

save "Working\all_waves_data_files\mcs6_parent_derived_w.dta"


use "Original_data\UKDA-8156-stata\stata\stata13\mcs6_parent_interview", clear

tab FPPHDE00, m //kessler Q
tab FPPSEX00, m //sex of respondent 
codebook FPPSEX00 // 1-male, 2-female
tab FELIG00, m //main or partner interview 
tab FPPSEX00 FELIG00

MCSID 

FPNUM00

*ID variables
tab FPNUM00, m 
misstable summarize MCSID 

duplicates report MCSID 

*generating person specific ID 
egen PMID = concat (MCSID FPNUM00)  if FPNUM00 >0

duplicates report PMID 

codebook PMID
count if PMID != "" 
count if PMID == "" 

duplicates report MCSID

*maternal kessler
tab FPPHDE00 if FPPSEX00 ==1, m 

*paternal kessler 
tab FPPHDE00 if FPPSEX00 ==2, m 

save "Working\all_waves_data_files\mcs6_parent_interview_w.dta", replace

merge 1:1 PMID using "Working\all_waves_data_files\mcs6_parent_derived_w.dta"

codebook FPPSEX00 //male 1 female 2
codebook FDKESSL
replace FDKESSL =. if FDKESSL == -1
tab FDKESSL, m
tab FDKESSL if FPPSEX00 ==2 , m 

keep if FPPSEX00 ==2

duplicates report MCSID 
duplicates list MCSID


*keep main interview in these cases 
drop if PMID == 
*etc for duplicate cases

duplicates list MCSID 
tab FPPSEX00, m

keep MCSID PMID FDKESSL

save "Working\all_waves_data_files\mcs6_maternal_kessler_w.dta" 



