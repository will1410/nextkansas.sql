/*
R.001227

----------

Name: Your New Patrons
Created by: -

----------

Group: Patrons
     -

Created on: 2011-11-01 16:10:52
Modified on: 2013-09-21 16:05:42
Date last run: 2019-10-21 12:41:35

----------

Public: 0
Expiry: 0

----------

Enhanced - Run, add numeric month, numeric year and pick your branch. #patrons

----------
*/

SELECT borrowers.dateenrolled, borrowers.surname,borrowers.firstname,borrowers.branchcode,borrowers.categorycode, borrowers.cardnumber,borrowers.address,borrowers.city,borrowers.phone,borrowers.email FROM borrowers WHERE month(dateenrolled) = << numericmonth >> AND year(dateenrolled) = << numericyear >> AND borrowers.branchcode = <<Pick your branch|branches>> ORDER BY borrowers.categorycode ASC



