/*
R.002466

----------

Name: PATRON LIST WITH EMAIL, PHONE, CITY & ZIP
Created by: -

----------

Group: Patrons
     -

Created on: 2015-02-19 14:40:15
Modified on: 2015-02-23 09:29:39
Date last run: 2020-12-07 10:24:32

----------

Public: 0
Expiry: 0

----------



----------
*/

SELECT email, phone, B_phone, cardnumber, surname, firstname, zipcode, city, debarred, dateexpiry FROM borrowers WHERE branchcode=<<branch|branches>> ORDER BY branchcode, surname ASC



