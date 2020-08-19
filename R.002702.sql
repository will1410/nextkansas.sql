/*
R.002702

----------

Name: Ottawa Patron count
Created by: Heather Braum

----------

Group: Library-Specific
     Ottawa

Created on: 2016-06-29 09:13:45
Modified on: 2016-06-30 11:45:39
Date last run: 2020-05-14 14:11:03

----------

Public: 0
Expiry: 0

----------



----------
*/

SELECT b.categorycode, (SELECT ba.attribute FROM borrower_attributes ba WHERE ba.borrowernumber=b.borrowernumber AND ba.code='Location') as location, count(DISTINCT borrowernumber) FROM borrowers b WHERE b.branchcode='OTTAWA' GROUP BY b.categorycode, location



