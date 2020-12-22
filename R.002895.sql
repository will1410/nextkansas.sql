/*
R.002895

----------

Name: GHW - Lost statuses by check-out branch with last patron data
Created by: George H Williams

----------

Group: Circulation
     Overdues

Created on: 2017-02-01 15:28:38
Modified on: 2020-02-24 12:26:15
Date last run: 2020-12-22 10:05:02

----------

Public: 0
Expiry: 0

----------

<div id=reportinfo>
<p>Lists items with any "Lost" status that were checked out at your library</p>
<ul><li>Shows items that currently have the "Lost" status you specify</li>
<li>shows items that were checked out at your library - regardless of which library owns the item</li>
<li>grouped by itemnumber</li>
<li>sorted by the default Next sort order (home library, location, item type, collection code, call number, title, author, barcode number) + patron borrowernumber<br /><br />
OR<br /><br />
date marked lost, borrowers cardnumber, and then the normal sort order</li>
</ul><br />
<p><ins>Notes:</ins></p>
<p></p>
<p>Monthly cleanup</p>
<p></p>
<p>Replaces report 888</p>
<p></p>
<p><a href="/cgi-bin/koha/reports/guided_reports.pl?reports=2895&phase=Run%20this%20report"  target="_blank">Click here to run in a new window</a></p>
</div>

----------
*/

SELECT
  items.holdingbranch AS CKO_BRANCH,
  CONCAT('<a href=\"/cgi-bin/koha/catalogue/moredetail.pl?itemnumber=', items.itemnumber, '&biblionumber=', items.biblionumber, '/" target="_blank">Link to item</a>') AS LINK_I,
  items.barcode AS ITEM_BARCODE,
  items.homebranch AS ITEM_HOME,
  items.location AS LOCATION,
  items.itype AS ITYPE,
  ccodes.lib AS CCODE,
  items.itemcallnumber AS CALL_NUMBER,
  biblio.author,
  Concat_Ws(' ', biblio.title,
    ExtractValue(biblio_metadata.metadata, '//datafield[@tag="245"]/subfield[@code="b"]'),
    ExtractValue(biblio_metadata.metadata, '//datafield[@tag="245"]/subfield[@code="p"]'),
    ExtractValue(biblio_metadata.metadata, '//datafield[@tag="245"]/subfield[@code="n"]')) AS TITLE,
  losts.lib AS LOST_STATUS,
  Date_Format(old_issues.returndate, '%m/%d/%Y') AS LOST_ON,
                 borrowers.branchcode,
  borrowers.cardnumber AS LAST_PATRON_CARD,
  borrowers.surname AS LAST_PATRON_NAME,
  items.replacementprice,
  CONCAT('<a href=\"/cgi-bin/koha/members/pay.pl?borrowernumber=', borrowers.borrowernumber, '/" target="_blank">Link to patron</a>') AS LINK_P,
  @SortOrder := <<Sort by|XS_DATE>> AS SORTING
FROM
  items
  JOIN biblio ON items.biblionumber = biblio.biblionumber
  LEFT JOIN (SELECT
        authorised_values.authorised_value,
        authorised_values.lib
      FROM
        authorised_values
      WHERE
        authorised_values.category = "CCODE") ccodes ON items.ccode = ccodes.authorised_value
  LEFT JOIN (SELECT
        authorised_values.authorised_value,
        authorised_values.lib
      FROM
        authorised_values
      WHERE
        authorised_values.category = 'LOST') losts ON items.itemlost = losts.authorised_value
  JOIN old_issues ON old_issues.itemnumber = items.itemnumber
  JOIN borrowers ON old_issues.borrowernumber = borrowers.borrowernumber
  JOIN biblio_metadata ON biblio.biblionumber = biblio_metadata.biblionumber
WHERE
  Date_Format(old_issues.returndate, '%m/%d/%Y') = Date_Format(items.itemlost_on, '%m/%d/%Y') AND
  items.holdingbranch LIKE <<Check-out branch|ZBRAN>>  
GROUP BY
  items.itemnumber,
  Date_Format(old_issues.returndate, '%m/%d/%Y'),
  borrowers.cardnumber,
  borrowers.surname
HAVING
  LOST_STATUS LIKE <<Choose lost status|ZLOST_ONLY>>
ORDER BY
  (CASE WHEN @SortOrder= 3 THEN old_issues.returndate END) ASC,
  (CASE WHEN @SortOrder= 2 THEN old_issues.returndate END) DESC,
  (CASE WHEN @SortOrder= 1 THEN CKO_BRANCH END) ASC,
  (CASE WHEN @SortOrder> 1 THEN borrowers.cardnumber END) ASC,
  LOCATION, ITYPE, CCODE, CALL_NUMBER, TITLE, biblio.author, items.barcode, old_issues.borrowernumber, LAST_PATRON_CARD, LAST_PATRON_NAME ASC



