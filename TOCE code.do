/*
----------------------------------------
TOCE (Total Observed Caries Experience)
  : To calculate, requires tooth level indicators for either caries at deciduous or permanent (or both)
  : Mixed dentition is supported
  : Also needs indicators for presence of filling. Code can be changed to accommodate other structures with ease
  : Assumes longitudinal data in long form
----------------------------------------
*/

set more off
sort patientid visit
forvalues i=1/32 {
	generate cariesfill_a`i'=0
	generate cariesfill_d`i'=0
	bysort patientid: replace cariesfill_a`i'=cariesfill_a`i' + (caries_wholetooth`i'==1|fillpresent_wholetooth`i'==1) ///
		if toothadult`i'==1
	bysort patientid: replace cariesfill_a`i'=cariesfill_a`i'[_n-1] if cariesfill_a`i'[_n]==0 & cariesfill_a`i'[_n-1] & visit>1
	bysort patientid: replace cariesfill_d`i'=cariesfill_d`i' + (caries_wholetooth`i'==1|fillpresent_wholetooth`i'==1) ///
		if toothdecid`i'==1
	bysort patientid: replace cariesfill_d`i'=cariesfill_d`i'[_n-1] if cariesfill_d`i'[_n]==0 & cariesfill_d`i'[_n-1] & visit>1
}
egen TOCE = rowtotal(cariesfill_a1-cariesfill_d32)
