*updated_for_paper_120624

cd 

use "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w.dta", clear


*need to limit to cohort of interest - currently has all MCS and all NPD and lots of missing data in each 

codebook GENDER_SPR16 // 1= female 2 = male


*************variables********************
tab GENDER_SPR16, m 
tab SEN_bin_2016, m 
tab FSMELIGIBLE_SPR16, m 
tab exclusion_mcs6, m 
tab summer_birth, m 

tab absence_rate_16_5ht, m 
tab absence_bin_16_5ht, m 
tab authabsence_rate_16_5ht, m 
tab unauthabsence_rate_16_5ht, m 

tab sdq_parent_sw6_bin, m 
tab sdq_self_sw7_bin, m 




*************cohort***************

*fill in gaps for gender and summer_birth 

*gender from wave 6 MCS
tab FCCSEX00, m 
codebook  FCCSEX00 //need to swap as 1 is male her and 1 is female in NPD 

gen gender =.
replace gender = GENDER_SPR16
replace gender = 1 if FCCSEX00 ==2 & gender ==.
replace gender = 2 if FCCSEX00 ==1 & gender ==.
tab gender, m

*DOB from wave 6 MCS 
FCCDBM00	CM DOB (month)  
FCCDBY00	CM DOB (year)   

gen dob_mcs_6 = mdy(FCCDBM00, firstofmonth,  FCCDBY00) 
tab dob_mcs_6, m
format dob_mcs_6 %td
tab dob_mcs_6,m
label variable dob_mcs_6 "From MCS 6"

gen summer_birth_mcs_6 =.
replace summer_birth_mcs_6 =1 if dob_mcs_6 == td(01may2001) | dob_mcs_6 == td(01jun2001)  | dob_mcs_6 == td(01jul2001)  |dob_mcs_6 == td(01aug2001) 
replace summer_birth_mcs_6 =0 if dob_mcs_6 == td(01sep2001) | dob_mcs_6 == td(01oct2001)  | dob_mcs_6 == td(01nov2001)  | dob_mcs_6 == td(01dec2001) | dob_mcs_6 == td(01jan2001) | dob_mcs_6 == td(01feb2001) | dob_mcs_6 == td(01mar2001) | dob_mcs_6 == td(01apr2001) | dob_mcs_6 == td(01sep2000) | dob_mcs_6 == td(01oct2000)  | dob_mcs_6 == td(01nov2000)  | dob_mcs_6 == td(01dec2000) | dob_mcs_6 == td(01jan2002) 
tab summer_birth_mcs_6, m

replace summer_birth = summer_birth_mcs_6 if summer_birth ==.
tab summer_birth, m



keep if sdq_self_sw7_bin !=. 


keep if FACTRY00 ==1



* cohort is everyone in england in wave 6 MCS and who has self-report outcome data in wave 7 MCS  

save "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort.dta", replace

tab NCYEARACTUAL_AB16, m 

***note on summer birth***

tab dob_mcs_6 if summer_birth == 1, m

 


tab NCYEARACTUAL_AB16 if summer_birth == 1, m
  

**************************DESRIPTIVE STATISTICS****************************

use "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort.dta", clear


tab age_years_1sept_2015, m

tab age_years_31may_2016, m

tab exposure_outcome_lag, m 

summ exposure_outcome_lag, detail

tab GCMCS7AG, m
summ GCMCS7AG 
codebook GCMCS7AG 
replace GCMCS7AG =. if GCMCS7AG ==-1


*N for both genders 
dis (/)*100 

tab gender, m 
tab SEN_bin_2016, m 
tab SEN_bin_2016 if  gender ==1, m
tab SEN_bin_2016 if  gender ==2, m

tab FSMELIGIBLE_SPR16, m 
tab exclusion_mcs6, m  
tab exclusion_mcs6 if  gender ==1, m
tab exclusion_mcs6 if  gender ==2, m

tab summer_birth, m  

tab absence_rate_16_5ht, m 
tab absence_rate_16_5ht if  gender ==1, m
tab absence_rate_16_5ht if  gender ==2, m

tab absence_bin_16_5ht if  gender ==1, m 
tab absence_bin_16_5ht if  gender ==2, m 
tab absence_bin_16_5ht, m 

tab authabsence_rate_16_5ht, m 
tab unauthabsence_rate_16_5ht, m 

tab sdq_parent_sw6_bin, m 
tab sdq_self_sw7_bin, m 

count if gender ==1 
count if gender ==2 


********adding other variables ***************

drop _merge 

***maternal MH****
merge m:1 MCSID using "Working\all_waves_data_files\mcs6_maternal_kessler_w.dta" 

tab FDKESSL, m 
tab FDKESSL if gender ==1, m 
tab FDKESSL if gender ==2, m 



drop _merge

****SES*****
merge m:1 MCSID using "Working\all_waves_data_files\mcs6_oecd_ses_w.dta" 

tab FOECDSC0, m //quintles by country 
tab FOECDSC0 if gender ==1, m 
tab FOECDSC0 if gender ==2, m 


tab FOEDP000, m //binary above or below 60% median 


******Bullying*********
tab FPSDPB00, m 
tab FPSDPB00 if gender ==1, m 
tab FPSDPB00 if gender ==2, m 

codebook FPSDPB00
replace FPSDPB00 =. if FPSDPB00 <0

*******ethnicity*********
tab FDCE0600, m 
tab FDCE0600 if gender ==1, m 
tab FDCE0600 if gender ==2, m 

codebook FDCE0600
replace FDCE0600 =. if FDCE0600 <0


*merging in the additional variables has created missing data for the previously complete variables given that it has extended the dataset to beyond the cohort - need to get it back down to the cohort so dropping any with missing data for the complete variables 
drop if gender ==.

tab gender, m
**ALL OF THE MISSING DATA ABOVE IS BASED ON HAVING ALREADY DROPPED THOSE WHERE GENDER ==.



histogram absence_rate_16_5ht, bin(20) title ("Distribution of overall absence rates") percent
histogram authabsence_rate_16_5ht, bin(20) title ("Distribution of authorised absence rates") percent
histogram unauthabsence_rate_16_5ht, bin(20) title ("Distribution of unauthorised absence rates") percent

count if absence_rate_16_5ht < 5
count if absence_rate_16_5ht >4 & absence_rate_16_5ht < 10
count if absence_rate_16_5ht >9 & absence_rate_16_5ht < 15
count if absence_rate_16_5ht >14 & absence_rate_16_5ht < 20
count if absence_rate_16_5ht >19 & absence_rate_16_5ht < 25
count if absence_rate_16_5ht >24 & absence_rate_16_5ht < 30
count if absence_rate_16_5ht >29 & absence_rate_16_5ht < 35
count if absence_rate_16_5ht >34 & absence_rate_16_5ht < 40
count if absence_rate_16_5ht >39 & absence_rate_16_5ht < 45
count if absence_rate_16_5ht >44 & absence_rate_16_5ht < 50


*********age of cohort**********
tab age_years_1sept_2015, m

*age at interview to nearest 10th of a year 
tab GCMCS7AG, m

tab NCYEARACTUAL_AB16, m




*********descriptives table**********
summ absence_rate_16_5ht, detail

summ absence_rate_16_5ht if  gender ==1, detail
summ absence_rate_16_5ht if  gender ==2, detail

tab absence_bin_16_5ht if gender ==1 
tab absence_bin_16_5ht if gender ==2 


*SEN
summ absence_rate_16_5ht if SEN_bin_2016 ==1 & gender ==1 , detail
summ absence_rate_16_5ht if SEN_bin_2016 ==0 & gender ==1 , detail

summ absence_rate_16_5ht if SEN_bin_2016 ==1 & gender ==2 , detail
summ absence_rate_16_5ht if SEN_bin_2016 ==0 & gender ==2 , detail

tab absence_bin_16_5ht if SEN_bin_2016 ==1 & gender ==1
tab absence_bin_16_5ht if SEN_bin_2016 ==0 & gender ==1

tab absence_bin_16_5ht if SEN_bin_2016 ==1 & gender ==2
tab absence_bin_16_5ht if SEN_bin_2016 ==0 & gender ==2

*FSM 
summ absence_rate_16_5ht if FSMELIGIBLE_SPR16 ==1 & gender ==1 , detail
summ absence_rate_16_5ht if FSMELIGIBLE_SPR16 ==0 & gender ==1 , detail

summ absence_rate_16_5ht if FSMELIGIBLE_SPR16 ==1 & gender ==2 , detail
summ absence_rate_16_5ht if FSMELIGIBLE_SPR16 ==0 & gender ==2 , detail

tab absence_bin_16_5ht if FSMELIGIBLE_SPR16 ==1 & gender ==1
tab absence_bin_16_5ht if FSMELIGIBLE_SPR16 ==0 & gender ==1

tab absence_bin_16_5ht if FSMELIGIBLE_SPR16 ==1 & gender ==2
tab absence_bin_16_5ht if FSMELIGIBLE_SPR16 ==0 & gender ==2

*exclusion 
summ absence_rate_16_5ht if exclusion_mcs6 ==1 & gender ==1 , detail
summ absence_rate_16_5ht if exclusion_mcs6 ==0 & gender ==1 , detail

summ absence_rate_16_5ht if exclusion_mcs6 ==1 & gender ==2 , detail
summ absence_rate_16_5ht if exclusion_mcs6 ==0 & gender ==2 , detail

tab absence_bin_16_5ht if exclusion_mcs6 ==1 & gender ==1
tab absence_bin_16_5ht if exclusion_mcs6 ==0 & gender ==1

tab absence_bin_16_5ht if exclusion_mcs6 ==1 & gender ==2
tab absence_bin_16_5ht if exclusion_mcs6 ==0 & gender ==2


*summer birth 
summ absence_rate_16_5ht if summer_birth ==1 & gender ==1 , detail
summ absence_rate_16_5ht if summer_birth ==0 & gender ==1 , detail

summ absence_rate_16_5ht if summer_birth ==1 & gender ==2 , detail
summ absence_rate_16_5ht if summer_birth ==0 & gender ==2 , detail

tab absence_bin_16_5ht if summer_birth ==1 & gender ==1
tab absence_bin_16_5ht if summer_birth ==0 & gender ==1

tab absence_bin_16_5ht if summer_birth ==1 & gender ==2
tab absence_bin_16_5ht if summer_birth ==0 & gender ==2


*MH problems pre 2016 
summ absence_rate_16_5ht if sdq_parent_sw6_bin ==1 & gender ==1 , detail
summ absence_rate_16_5ht if sdq_parent_sw6_bin ==0 & gender ==1 , detail

summ absence_rate_16_5ht if sdq_parent_sw6_bin ==1 & gender ==2 , detail
summ absence_rate_16_5ht if sdq_parent_sw6_bin ==0 & gender ==2 , detail

tab absence_bin_16_5ht if sdq_parent_sw6_bin ==1 & gender ==1
tab absence_bin_16_5ht if sdq_parent_sw6_bin ==0 & gender ==1

tab absence_bin_16_5ht if sdq_parent_sw6_bin ==1 & gender ==2
tab absence_bin_16_5ht if sdq_parent_sw6_bin ==0 & gender ==2

***maternal MH****
tab FDKESSL, m

codebook FDKESSL

gen FDKESSL_bin =.
replace FDKESSL_bin = 0 if FDKESSL <6
replace FDKESSL_bin = 1 if FDKESSL >5 & FDKESSL !=.
tab FDKESSL_bin, m

tab FDKESSL_bin if gender ==1, m 
tab FDKESSL_bin if gender ==2, m 

summ absence_rate_16_5ht if FDKESSL_bin ==1 & gender ==1 , detail
summ absence_rate_16_5ht if FDKESSL_bin ==0 & gender ==1 , detail

summ absence_rate_16_5ht if FDKESSL_bin ==1 & gender ==2 , detail
summ absence_rate_16_5ht if FDKESSL_bin ==0 & gender ==2 , detail

tab absence_bin_16_5ht if FDKESSL_bin ==1 & gender ==1
tab absence_bin_16_5ht if FDKESSL_bin ==0 & gender ==1

tab absence_bin_16_5ht if FDKESSL_bin ==1 & gender ==2
tab absence_bin_16_5ht if FDKESSL_bin ==0 & gender ==2


****SES*****T

tab FOECDSC0, m //quintles by country
codebook FOECDSC0, m 


*make baseline =5 

summ absence_rate_16_5ht if FOECDSC0 ==5 & gender ==1 , detail
summ absence_rate_16_5ht if FOECDSC0 ==4 & gender ==1 , detail
summ absence_rate_16_5ht if FOECDSC0 ==3 & gender ==1 , detail
summ absence_rate_16_5ht if FOECDSC0 ==2 & gender ==1 , detail
summ absence_rate_16_5ht if FOECDSC0 ==1 & gender ==1 , detail

summ absence_rate_16_5ht if FOECDSC0 ==5 & gender ==2 , detail
summ absence_rate_16_5ht if FOECDSC0 ==4 & gender ==2 , detail
summ absence_rate_16_5ht if FOECDSC0 ==5 & gender ==2 , detail
summ absence_rate_16_5ht if FOECDSC0 ==2 & gender ==2 , detail
summ absence_rate_16_5ht if FOECDSC0 ==1 & gender ==2 , detail

tab absence_bin_16_5ht if FOECDSC0 ==5 & gender ==1
tab absence_bin_16_5ht if FOECDSC0 ==4 & gender ==1
tab absence_bin_16_5ht if FOECDSC0 ==3 & gender ==1
tab absence_bin_16_5ht if FOECDSC0 ==2 & gender ==1
tab absence_bin_16_5ht if FOECDSC0 ==1 & gender ==1

tab absence_bin_16_5ht if FOECDSC0 ==5 & gender ==2
tab absence_bin_16_5ht if FOECDSC0 ==4 & gender ==2
tab absence_bin_16_5ht if FOECDSC0 ==3 & gender ==2
tab absence_bin_16_5ht if FOECDSC0 ==2 & gender ==2
tab absence_bin_16_5ht if FOECDSC0 ==1 & gender ==2


******Bullying*********
tab FPSDPB00, m

codebook FPSDPB00

gen bullying_bin =.
replace bullying_bin = 0 if FPSDPB00 ==1
replace bullying_bin = 1 if FPSDPB00 ==2 | FPSDPB00 ==3
tab bullying_bin, m

tab bullying_bin if gender ==1, m
tab bullying_bin if gender ==2, m


summ absence_rate_16_5ht if bullying_bin ==1 & gender ==1 , detail
summ absence_rate_16_5ht if bullying_bin ==0 & gender ==1 , detail

summ absence_rate_16_5ht if bullying_bin ==1 & gender ==2 , detail
summ absence_rate_16_5ht if bullying_bin ==0 & gender ==2 , detail

tab absence_bin_16_5ht if bullying_bin ==1 & gender ==1
tab absence_bin_16_5ht if bullying_bin ==0 & gender ==1

tab absence_bin_16_5ht if bullying_bin ==1 & gender ==2
tab absence_bin_16_5ht if bullying_bin ==0 & gender ==2


*******ethnicity*********

tab FDCE0600, m

codebook FDCE0600, m




summ absence_rate_16_5ht if FDCE0600 ==6 & gender ==1 , detail
summ absence_rate_16_5ht if FDCE0600 ==5 & gender ==1 , detail
summ absence_rate_16_5ht if FDCE0600 ==4 & gender ==1 , detail
summ absence_rate_16_5ht if FDCE0600 ==3 & gender ==1 , detail
summ absence_rate_16_5ht if FDCE0600 ==2 & gender ==1 , detail
summ absence_rate_16_5ht if FDCE0600 ==1 & gender ==1 , detail

summ absence_rate_16_5ht if FDCE0600 ==6 & gender ==2 , detail
summ absence_rate_16_5ht if FDCE0600 ==5 & gender ==2 , detail
summ absence_rate_16_5ht if FDCE0600 ==4 & gender ==2 , detail
summ absence_rate_16_5ht if FDCE0600 ==5 & gender ==2 , detail
summ absence_rate_16_5ht if FDCE0600 ==2 & gender ==2 , detail
summ absence_rate_16_5ht if FDCE0600 ==1 & gender ==2 , detail

tab absence_bin_16_5ht if FDCE0600 ==6 & gender ==1
tab absence_bin_16_5ht if FDCE0600 ==5 & gender ==1
tab absence_bin_16_5ht if FDCE0600 ==4 & gender ==1
tab absence_bin_16_5ht if FDCE0600 ==3 & gender ==1
tab absence_bin_16_5ht if FDCE0600 ==2 & gender ==1
tab absence_bin_16_5ht if FDCE0600 ==1 & gender ==1

tab absence_bin_16_5ht if FDCE0600 ==6 & gender ==2
tab absence_bin_16_5ht if FDCE0600 ==5 & gender ==2
tab absence_bin_16_5ht if FDCE0600 ==4 & gender ==2
tab absence_bin_16_5ht if FDCE0600 ==3 & gender ==2
tab absence_bin_16_5ht if FDCE0600 ==2 & gender ==2
tab absence_bin_16_5ht if FDCE0600 ==1 & gender ==2

*OUTCOMES

*self report SDQ total score 
summ absence_rate_16_5ht if sdq_self_sw7_bin ==1 & gender ==1  , detail
summ absence_rate_16_5ht if sdq_self_sw7_bin ==0 & gender ==1  , detail

summ absence_rate_16_5ht if sdq_self_sw7_bin ==1 & gender ==2 , detail
summ absence_rate_16_5ht if sdq_self_sw7_bin ==0 & gender ==2  , detail

tab absence_bin_16_5ht if sdq_self_sw7_bin ==1 & gender ==1 
tab absence_bin_16_5ht if sdq_self_sw7_bin ==0 & gender ==1 

tab absence_bin_16_5ht if sdq_self_sw7_bin ==1 & gender ==2
tab absence_bin_16_5ht if sdq_self_sw7_bin ==0 & gender ==2 




************creating binary variables using top quintile****** 

*overall
summ absence_rate_16_5ht, detail
misstable summarize absence_rate_16_5ht 
xtile absence_quint_16_5ht = absence_rate_16_5ht if absence_rate_16_5ht !=., n(5)
tab absence_quint_16_5ht, m
tab absence_quint_16_5ht

gen absence_bin_quint_16_5ht =.
replace absence_bin_quint_16_5ht =1 if absence_quint_16_5ht == 5
replace absence_bin_quint_16 =0 if absence_quint == 1 | absence_quint == 2 | absence_quint == 3 | absence_quint == 4 
label variable absence_bin_quint_16_5ht "Top quintile cutoff"
tab absence_bin_quint_16, m

summ absence_rate_16_5ht if absence_bin_quint_16 ==1, detail 




************************sensitivity and specificity*****************

tab  absence_bin_16_1per sdq_self_sw7_bin, col // sensitivity and specificity (% bottom right and top left respectively) 
tab  absence_bin_16_1per sdq_self_sw7_bin, row // PPV and NPV (% bottom right and top left respectively)

tab  absence_bin_16_5per sdq_self_sw7_bin, col 
tab  absence_bin_16_5per sdq_self_sw7_bin, row 

tab  absence_bin_16_5ht  sdq_self_sw7_bin, col 
tab  absence_bin_16_5ht  sdq_self_sw7_bin, row 

tab  absence_bin_16_20per sdq_self_sw7_bin, col 
tab  absence_bin_16_20per sdq_self_sw7_bin, row 

tab  absence_bin_16_30per sdq_self_sw7_bin, col 
tab  absence_bin_16_30per sdq_self_sw7_bin, row  

tab  absence_bin_16_40per sdq_self_sw7_bin, col 
tab  absence_bin_16_40per sdq_self_sw7_bin, row 

tab  absence_bin_16_50per sdq_self_sw7_bin, col 
tab  absence_bin_16_50per sdq_self_sw7_bin, row 

tab  absence_bin_quint_16 sdq_self_sw7_bin, col 
tab  absence_bin_quint_16 sdq_self_sw7_bin, row 



*again but excluding those with previous camhs contact 

tab sdq_parent_sw6_bin, m

tab  absence_bin_16_1per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col // sensitivity and specificity (% bottom right and top left respectively) 
tab  absence_bin_16_1per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row // PPV and NPV (% bottom right and top left respectively)

tab  absence_bin_16_5per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_16_5per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 

tab  absence_bin_16_5ht sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_16_5ht sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 

tab  absence_bin_16_20per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_16_20per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 

tab  absence_bin_16_30per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_16_30per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 

tab  absence_bin_16_40per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_16_40per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 

tab  absence_bin_16_50per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_16_50per sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 

tab  absence_bin_quint_16 sdq_self_sw7_bin if sdq_parent_sw6_bin==0, col 
tab  absence_bin_quint_16 sdq_self_sw7_bin if sdq_parent_sw6_bin==0, row 



************** percentages of CAMHS referral in high vs low absence********************

*overall 
tab sdq_self_sw7_bin if absence_bin_16_5ht ==1 & gender   ==1 
tab sdq_self_sw7_bin if absence_bin_16_5ht ==0 & gender   ==1 

tab sdq_self_sw7_bin if absence_bin_16_5ht ==1 & gender   ==2 
tab sdq_self_sw7_bin if absence_bin_16_5ht ==0 & gender   ==2 



********************************REGRESSIONS******************************************************

*OVERALL ABSENCE WHOLE SAMPLE 
*unadjusted 
logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==1
logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==2

logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==1
logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==2

logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==1
logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==2

logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==1
logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==2

logistic sdq_self_sw7_bin summer_birth if gender   ==1
logistic sdq_self_sw7_bin summer_birth if gender   ==2

*white as baseline
logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==1
logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==2

logistic sdq_self_sw7_bin bullying_bin if gender   ==1
logistic sdq_self_sw7_bin bullying_bin if gender   ==2

*family income quintiles - basline is highest quintile - 5
logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==1
logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==2

*maternal MH
logistic sdq_self_sw7_bin FDKESSL if gender   ==1
logistic sdq_self_sw7_bin FDKESSL if gender   ==2



*absence rate associated with MH adjusting for fsm and sen, exclusion, summer birth and ethnicity for each gender separately 
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==1
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==2


**adding in second block of variables - maternal MH, family income quintile, bullying 
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==2



save"Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort_updated.dta"

use "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort_updated.dta", clear



************WEIGHTS**************************



use "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort_updated.dta", clear 

gen complete_case =1 

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\1to6_cm_derived_ethnicity_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\1to4_sex_w.dta"

drop _merge

tab complete_case, m
replace complete_case =0 if complete_case ==.

tab sex_1to4, m
tab ethnicity_1to6, m

*probablity of being in the dataset 'complete case' as a function of ethnicity and gender 
logistic complete_case sex_1to4 ethnicity_1to6

*create weight variable 
predict pr, pr
gen wt=1/pr

tab wt, m 


*merging in the above variables has created missing data for the previously complete variables given that it has extended the dataset to beyond the cohort - need to get it back down to the cohort so dropping any with missing data for the complete variables 
drop if gender ==.

tab gender, m

******imputation of missing data ******************

*cd 


*use "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort.dta", clear


tab gender ,m
tab summer_birth ,m
tab GEBDTOT_C ,m
tab FEBDTOT ,m
tab wt, m

******************IMPUTATION MODEL: WITH AUXILLIARY VARIABLES BUT ONLY OVERALL ABSENCE***************
*auxilliary variables - ethnicity, maternal MH, family SES, bullying - all from MCS6 

mi set flong 
mi register imputed FSMELIGIBLE_SPR16 SEN_bin_2016 exclusion_mcs6 absence_rate_16_5ht  GEBDTOT FDKESSL FDCE0600 FOECDSC0 FPSDPB00
mi register passive gender summer_birth GEBDTOT_C FEBDTOT wt

mi impute chained (logit) FSMELIGIBLE_SPR16 exclusion_mcs6 SEN_bin_2016 (mlogit) FDCE0600 (ologit) FOECDSC0 FPSDPB00 (pmm, knn(10)) absence_rate_16_5ht FDKESSL   GEBDTOT =  gender summer_birth GEBDTOT_C  FEBDTOT , add(10) rseed(234) force


**then derive binary variables**

replace bullying_bin = 0 if FPSDPB00 ==1
replace bullying_bin = 1 if FPSDPB00 ==2 | FPSDPB00 ==3
tab bullying_bin, m

tab bullying_bin if gender ==1, m
tab bullying_bin if gender ==2, m

***different absence cutoffs***

misstable summarize absence_rate_16_5ht

tab absence_rate_16_5ht, m
tab FPSDPB00, m
tab exclusion, m


*overall 


replace absence_bin_16_5ht =1 if absence_rate_16_5ht >=10 & absence_rate_16_5ht !=.
replace absence_bin_16_5ht =0 if absence_rate_16_5ht <10
tab absence_bin_16_5ht, m  //10 percent 



*analyses with imputed data 

*OVERALL ABSENCE WHOLE SAMPLE 
*unadjusted 
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==2 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==2 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==2 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==2 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin summer_birth if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin summer_birth if gender   ==2 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin bullying_bin if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin bullying_bin if gender   ==2 [pweight=wt]

*ethnicity
mi estimate, or: logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==2 [pweight=wt]

*income quintiles 
mi estimate, or: logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==2 [pweight=wt]

*maternal MH
mi estimate, or: logistic sdq_self_sw7_bin FDKESSL if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin FDKESSL if gender   ==2 [pweight=wt]
 

*absence rate associated with MH adjusting for fsm and sen, for each gender separately 
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600  if gender   ==2 [pweight=wt]

*then with other variables added
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0  FDKESSL if gender   ==1 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0  FDKESSL  if gender   ==2 [pweight=wt]




************creating binary variables using top quintile****** 

*overall
summ absence_rate_16_5ht, detail
misstable summarize absence_rate_16_5ht 
xtile absence_quint_16_5ht = absence_rate_16_5ht if absence_rate_16_5ht !=., n(5)
tab absence_quint_16_5ht, m
tab absence_quint_16_5ht

gen absence_bin_quint_16_5ht =.
replace absence_bin_quint_16_5ht =1 if absence_quint_16_5ht == 5
replace absence_bin_quint_16 =0 if absence_quint == 1 | absence_quint == 2 | absence_quint == 3 | absence_quint == 4 
label variable absence_bin_quint_16_5ht "Top quintile cutoff"
tab absence_bin_quint_16, m

summ absence_rate_16_5ht if absence_bin_quint_16 ==1, detail 

*regression with weights 


*OVERALL ABSENCE WHOLE SAMPLE 
*unadjusted 
logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==2 [pweight=wt]

logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==2 [pweight=wt]

logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==2 [pweight=wt]

logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==2 [pweight=wt]

logistic sdq_self_sw7_bin summer_birth if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin summer_birth if gender   ==2 [pweight=wt]

*white as baseline
logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==2 [pweight=wt]

logistic sdq_self_sw7_bin bullying_bin if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin bullying_bin if gender   ==2 [pweight=wt]

*family income quintiles - basline is highest quintile - 5
logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==2 [pweight=wt]

*maternal MH
logistic sdq_self_sw7_bin FDKESSL if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin FDKESSL if gender   ==2 [pweight=wt]


*absence rate associated with MH adjusting for fsm and sen, exclusion, summer birth and ethnicity for each gender separately 
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==2 [pweight=wt]


**adding in second block of variables - maternal MH, family income quintile, bullying 
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 [pweight=wt]
logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==2 [pweight=wt]



*OVERALL ABSENCE SENSITIVITY ANALYSIS 1  exluding thos with MH problems at baseline 

tab gender if sdq_parent_sw6_bin ==0, m

tab absence_bin_16_5ht if gender   ==1 & sdq_parent_sw6_bin ==0, m
tab absence_bin_16_5ht if gender   ==2 & sdq_parent_sw6_bin ==0, m

tab SEN_bin_2016 if gender   ==1 & sdq_parent_sw6_bin ==0, m
tab SEN_bin_2016 if gender   ==2 & sdq_parent_sw6_bin ==0, m

tab FSMELIGIBLE_SPR16 if gender   ==1 & sdq_parent_sw6_bin ==0, m
tab FSMELIGIBLE_SPR16 if gender   ==2 & sdq_parent_sw6_bin ==0, m

tab exclusion_mcs6  if gender   ==1 & sdq_parent_sw6_bin ==0, m
tab exclusion_mcs6  if gender   ==2 & sdq_parent_sw6_bin ==0, m

tab summer_birth  if gender   ==1 & sdq_parent_sw6_bin ==0, m
tab summer_birth  if gender   ==2 & sdq_parent_sw6_bin ==0, m

tab sdq_parent_sw6_bin if gender   ==1, m
tab sdq_parent_sw6_bin if gender   ==2, m


*unadjusted 
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]
 
mi estimate, or: logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin summer_birth if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin summer_birth if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

*white as baseline
mi estimate, or: logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin bullying_bin if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin bullying_bin if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

*family income quintiles - basline is highest quintile - 5
mi estimate, or: logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]

*maternal MH
mi estimate, or: logistic sdq_self_sw7_bin FDKESSL if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin FDKESSL if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]


*aOR1
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]


**adding in second block of variables - maternal MH, family income quintile, bullying 
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 & sdq_parent_sw6_bin ==0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==2 & sdq_parent_sw6_bin ==0 [pweight=wt]




*OVERALL ABSENCE SENSITIVITY ANALYSIS 2  exluding those with more than one school enrollment 

tab one_school, m


tab gender if one_school !=0, m

tab SEN_bin_2016 if gender   ==1 & one_school !=0, m
tab SEN_bin_2016 if gender   ==2 & one_school !=0, m

tab FSMELIGIBLE_SPR16 if gender   ==1 & one_school !=0, m
tab FSMELIGIBLE_SPR16 if gender   ==2 & one_school !=0, m

tab exclusion_mcs6  if gender   ==1 & one_school !=0, m
tab exclusion_mcs6  if gender   ==2 & one_school !=0, m

tab summer_birth  if gender   ==1 & one_school !=0, m
tab summer_birth  if gender   ==2 & one_school !=0, m

tab absence_bin_16_5ht if gender   ==1 & one_school !=0, m
tab absence_bin_16_5ht if gender   ==2 & one_school !=0, m

tab one_school if gender   ==1, m
tab one_school if gender   ==2, m


*unadjusted 
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht if gender   ==2 & one_school !=0 [pweight=wt]
 
mi estimate, or: logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin SEN_bin_2016 if gender   ==2 & one_school !=0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin FSMELIGIBLE_SPR16 if gender   ==2 & one_school !=0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin exclusion_mcs6 if gender   ==2 & one_school !=0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin summer_birth if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin summer_birth if gender   ==2 & one_school !=0 [pweight=wt]

*white as baseline
mi estimate, or: logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin ib1.FDCE0600 if gender   ==2 & one_school !=0 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin bullying_bin if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin bullying_bin if gender   ==2 & one_school !=0 [pweight=wt]

*family income quintiles - basline is highest quintile - 5
mi estimate, or: logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin ib5.FOECDSC0 if gender   ==2 & one_school !=0 [pweight=wt]

*maternal MH
mi estimate, or: logistic sdq_self_sw7_bin FDKESSL if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin FDKESSL if gender   ==2 & one_school !=0 [pweight=wt]



*aOR1
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==2 & one_school !=0 [pweight=wt]

*adding in second block of variables
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 & one_school !=0 [pweight=wt]
mi estimate, or: logistic sdq_self_sw7_bin absence_bin_16_5ht  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==2 & one_school !=0 [pweight=wt]


************ADDING IN ABSENCE DATA FOR 2015/14/13**********

use "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort_updated.dta", clear 


*overall 

*10% absence variable
replace absence_bin_16_5ht =1 if absence_rate_16_5ht >=10 & absence_rate_16_5ht !=.
replace absence_bin_16_5ht =0 if absence_rate_16_5ht <10
tab absence_bin_16_5ht, m  

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\npd_2015_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\npd_2014_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\npd_2013_w.dta"

count if sdq_self_sw7_bin ==. 
keep if sdq_self_sw7_bin !=. 

count if FACTRY00 !=1
keep if FACTRY00 ==1

tab absence_bin_16_5ht, m
tab absence_bin_15_5ht, m 
tab absence_bin_14_5ht, m 
tab absence_bin_13_5ht, m 


tab SEN_bin_2016 if gender   ==1 , m 
tab SEN_bin_2016 if gender   ==2 , m 

tab FSMELIGIBLE_SPR16 if gender   ==1 , m 
tab FSMELIGIBLE_SPR16 if gender   ==2 , m 

tab exclusion_mcs6  if gender   ==1 , m 
tab exclusion_mcs6  if gender   ==2 , m 

tab summer_birth  if gender   ==1, m 
tab summer_birth  if gender   ==2 , m 

tab absence_13to16_cat if gender   ==1 , m 
tab absence_13to16_cat if gender   ==2 , m 




tab absence_bin_16_5ht absence_bin_15_5ht, m 
count if absence_bin_16_5ht ==. & absence_bin_15_5ht ==. & absence_bin_14_5ht ==. & absence_bin_13_5ht ==. 
count if absence_bin_16_5ht !=. & absence_bin_15_5ht !=. & absence_bin_14_5ht !=. & absence_bin_13_5ht !=.  
count if absence_bin_16_5ht !=. 




*generating categotical variable - chronicity and recency (0, 1 = high absence 2016, 2 = high absence 2016 and 15, 3  = high absence 2016, 15 and 14 and 4 = high absence 2016, 15, 14 and 13)


gen absence_13to16_cat =0 
replace absence_13to16_cat = 1 if absence_bin_16_5ht ==1
replace absence_13to16_cat = 2 if absence_bin_16_5ht ==1 &  absence_bin_15_5ht ==1
replace absence_13to16_cat = 3 if absence_bin_16_5ht ==1 &  absence_bin_15_5ht ==1 &  absence_bin_14_5ht ==1
replace absence_13to16_cat = 4 if absence_bin_16_5ht ==1 &  absence_bin_15_5ht ==1 &  absence_bin_14_5ht ==1 &  absence_bin_13_5ht ==1
replace  absence_13to16_cat =. if absence_bin_16_5ht ==. | absence_bin_15_5ht ==. | absence_bin_14_5ht ==. | absence_bin_13_5ht ==. //considered missing if absence data missing for any one or more of the years 13-16 ie can't be considered 0 if has data for for 13 but no others as maybe all the missing years would be 1s 
tab absence_13to16_cat, m

count if absence_bin_16_5ht ==. | absence_bin_15_5ht ==. | absence_bin_14_5ht ==. | absence_bin_13_5ht ==. 


*generating second version of categorical variable for absence 'count' - ie 0, 1, 2, 3 or 4 out of 4 years high absence) 

tab absence_bin_16_5ht, m

gen absence_years_count = .
replace absence_years_count  = absence_bin_16_5ht + absence_bin_15_5ht + absence_bin_14_5ht + absence_bin_13_5ht 
tab absence_years_count, m


save "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort2_npd13to16_updated.dta", replace


********************************REGRESSIONS******************************************************

use  "Working\all_waves_data_files\mcs5to7_NPD2016_cleaned_w_cohort2_npd13to16_updated.dta", clear

gen complete_case =1 

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\1to6_cm_derived_ethnicity_w.dta"

drop _merge

merge 1:1 CMID using "Working\all_waves_data_files\1to4_sex_w.dta"

drop _merge

tab complete_case, m
replace complete_case =0 if complete_case ==.

tab sex_1to4, m
tab ethnicity_1to6, m

*probablity of being in the dataset 'complete case' as a function of ethnicity and gender 
logistic complete_case sex_1to4 ethnicity_1to6

*create weight variable 
predict pr, pr
gen wt=1/pr

tab wt, m 


*merging in the above variables has created missing data for the previously complete variables given that it has extended the dataset to beyond the cohort - need to get it back down to the cohort so dropping any with missing data for the complete variables 
drop if gender ==.

tab gender, m


******************IMPUTATION MODEL: WITH AUXILLIARY VARIABLES BUT ONLY OVERALL ABSENCE***************
*auxilliary variables - ethnicity, maternal MH, family SES, bullying - all from MCS6 

mi set flong 
mi register imputed FSMELIGIBLE_SPR16 SEN_bin_2016 exclusion_mcs6 absence_rate_16_5ht  GEBDTOT FDKESSL FDCE0600 FOECDSC0 FPSDPB00 absence_years_count
mi register passive gender summer_birth GEBDTOT_C FEBDTOT 

mi impute chained (logit) FSMELIGIBLE_SPR16 exclusion_mcs6 SEN_bin_2016 (mlogit) FDCE0600 (ologit) FOECDSC0 FPSDPB00 (pmm, knn(10)) absence_rate_16_5ht FDKESSL   GEBDTOT absence_years_count =  gender summer_birth GEBDTOT_C  FEBDTOT , add(10) rseed(234) force


**then derive binary variables**

replace bullying_bin = 0 if FPSDPB00 ==1
replace bullying_bin = 1 if FPSDPB00 ==2 | FPSDPB00 ==3
tab bullying_bin, m

tab bullying_bin if gender ==1, m
tab bullying_bin if gender ==2, m

***different absence cutoffs***

misstable summarize absence_rate_16_5ht

tab absence_rate_16_5ht, m
tab FPSDPB00, m
tab exclusion, m



tab absence_13to16_cat if gender ==1, m 
tab absence_13to16_cat if gender ==2, m

tab absence_years_count if gender ==1, m
tab absence_years_count if gender ==2, m


*OVERALL ABSENCE WHOLE SAMPLE - ADDING IN LONGER DURATIONS OF ABSENCE 

*unadjusted 
logistic  sdq_self_sw7_bin absence_13to16_cat if gender   ==1 [pweight=wt]

logistic sdq_self_sw7_bin absence_13to16_cat if gender   ==2 [pweight=wt]



*absence rate associated with MH adjusting for fsm and sen, and new variables for each gender separately 
logistic sdq_self_sw7_bin absence_13to16_cat  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL  if gender   ==1 [pweight=wt]

logistic sdq_self_sw7_bin absence_13to16_cat  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL  if gender   ==2 [pweight=wt]


tab  NCYEARACTUAL_AB16, m 
tab  NCYEARACTUAL_AB15, m
tab  NCYEARACTUAL_AB14, m
tab  NCYEARACTUAL_AB13, m


logistic sdq_self_sw7_bin i.absence_13to16_cat  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 [pweight=wt]
estimates store A
logistic sdq_self_sw7_bin absence_13to16_cat  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 [pweight=wt]
estimates store B

lrtest A B, force

*again using count version of variable 

tab absence_years_count if gender ==1, m 
tab absence_years_count if gender ==2, m 

*unadjusted 
mi estimate, or: logistic  sdq_self_sw7_bin absence_years_count if gender   ==1 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin absence_years_count if gender   ==2 [pweight=wt]

*absence rate associated with MH adjusting for fsm and sen, exclusion, summer birth, ethnicity for each gender separately 
mi estimate, or: logistic sdq_self_sw7_bin absence_years_count  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 if gender   ==1 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin absence_years_count  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600   if gender   ==2 [pweight=wt]


*absence rate associated with MH adjusting for all covariates
mi estimate, or: logistic sdq_self_sw7_bin absence_years_count  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 [pweight=wt]

mi estimate, or: logistic sdq_self_sw7_bin absence_years_count  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL  if gender   ==2 [pweight=wt]


tab  NCYEARACTUAL_AB16, m 
tab  NCYEARACTUAL_AB15, m
tab  NCYEARACTUAL_AB14, m
tab  NCYEARACTUAL_AB13, m


mi estimate, or: logistic sdq_self_sw7_bin i.absence_years_count  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 [pweight=wt]
estimates store A
mi estimate, or: logistic sdq_self_sw7_bin absence_years_count  SEN_bin_2016 FSMELIGIBLE_SPR16 exclusion_mcs6 summer_birth ib1.FDCE0600 bullying_bin ib5.FOECDSC0 FDKESSL if gender   ==1 [pweight=wt]
estimates store B

lrtest A B, force

