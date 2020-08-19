/*
R.002897

----------

Name: GHW - Overdue items by check-out branch
Created by: George H Williams

----------

Group: Circulation
     Overdues

Created on: 2017-02-01 16:54:32
Modified on: 2019-05-07 11:29:59
Date last run: 2020-08-10 11:03:54

----------

Public: 0
Expiry: 0

----------

<div id=reportinfo>
<p>Generates a list of items checked out at a branch that were due before a certain date</p>
<ul><li>Shows currently overdue items due before the date you specify</li>
<li>shows items checked out at the library you specify regardless of who owns the item</li>
<li>grouped by item barcode number</li>
<li>sorted by NExpress standard classification scheme</li>
</ul><br />
<p></p>
<p><a href="/cgi-bin/koha/reports/guided_reports.pl?reports=2897&phase=Run%20this%20report"  target="_blank">Click here to run in a new window</a></p>
</div>

----------
*/

SELECT
  items.holdingbranch AS CKO_BRANCH,
  items.itemnumber,
  items.barcode AS BARCODE,
  items.homebranch AS ITEM_HOME,
  items.location AS LOCATION,
  items.itype AS ITYPE,
  ccodes.lib AS CCODE,
  items.itemcallnumber AS CALL_NUMBER,
  biblio.author,
  Concat_Ws(' ', biblio.title, ExtractValue(biblio_metadata.metadata, '//datafield[@tag="245"]/subfield[@code="b"]'), ExtractValue(biblio_metadata.metadata, '//datafield[@tag="245"]/subfield[@code="p"]'), ExtractValue(biblio_metadata.metadata, '//datafield[@tag="245"]/subfield[@code="n"]')) AS FULL_TITLE,
  borrowers.cardnumber AS PATRON_BARCODE,
  borrowers.surname AS PATRON_LASTNAME,
  borrowers.categorycode AS PATRON_CATEGORY,
  items.onloan AS ITEM_DUE_DATE,
  DateDiff(CurDate(), items.onloan) AS DAYS_OVERDUE
FROM
  items JOIN
  biblio
    ON items.biblionumber = biblio.biblionumber LEFT JOIN
  (SELECT
    authorised_values.authorised_value,
    authorised_values.lib
  FROM
    authorised_values
  WHERE
    authorised_values.category = "CCODE") ccodes
    ON items.ccode = ccodes.authorised_value JOIN
  biblio_metadata
    ON biblio.biblionumber = biblio_metadata.biblionumber JOIN
  issues
    ON issues.itemnumber = items.itemnumber JOIN
  borrowers
    ON issues.borrowernumber = borrowers.borrowernumber
WHERE
  items.holdingbranch LIKE <<Check out branch|ZBRAN>> AND
  items.onloan <= <<Items due on or before|date>>
GROUP BY
  items.barcode
ORDER BY
  ITEM_HOME,
  LOCATION,
  ITYPE,
  CCODE,
  CALL_NUMBER,
  FULL_TITLE,
  biblio.author



