/*
R.002845

----------

Name: test
Created by: George H Williams

----------

Group: Administrative Reports
     Testing

Created on: 2016-12-04 23:01:05
Modified on: 2016-12-04 23:01:05
Date last run: 2020-04-01 08:46:27

----------

Public: 0
Expiry: 300

----------



----------
*/

SELECT itemtypes.itemtype,branches.branchname,IFNULL(TotalIssues,'0') AS 'Issues/Renews' FROM itemtypes
JOIN branches
LEFT JOIN
(SELECT t.branchcode, coalesce(statistics.count,0) AS TotalIssues,statistics.itemtype FROM branches t
LEFT JOIN (SELECT s.branch, count(s.datetime) AS count,itemtype FROM statistics s WHERE s.type IN ('issue','renew') AND s.datetime BETWEEN <<between (date)|date>> AND <<and|date>>
GROUP BY s.branch,s.itemtype)statistics ON t.branchcode = statistics.branch)issuestats ON issuestats.itemtype = itemtypes.itemtype AND issuestats.branchcode = branches.branchcode



