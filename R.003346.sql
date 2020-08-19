/*
R.003346

----------

Name: GHW - Sandbox
Created by: George H Williams

----------

Group: -
     -

Created on: 2020-08-14 15:14:53
Modified on: 2020-08-14 15:14:59
Date last run: 2020-08-14 15:15:01

----------

Public: 0
Expiry: 300

----------



----------
*/

SELECT
  Upper(borrowers.cardnumber) AS CARDNUMBER,
  borrowers.borrowernumber,
  borrowers.surname,
  borrowers.firstname,
  borrowers.address,
  borrowers.city,
  borrowers.state,
  borrowers.zipcode,
  borrowers.phone,
  borrowers.mobile,
  borrowers.phonepro AS ALT_PHONE_ONE,
  borrowers.B_phone AS ALT_PHONE_TWO,
  borrowers.branchcode,
  If(
    categories.category_type = "A", "Adult", If(
      categories.category_type = "C", "Child", If(
        categories.category_type = "S", "Staff", If(
          categories.category_type = "I", "Organization", If(
            categories.category_type = "P", "Professional", If(
              categories.category_type = "X", "Statistical", "-"
            )
          )
        )
      )
    )
  ) AS CATEGORY,
  borrowers.dateofbirth,
  Format(Sum(outstanding_sixty.amountoutstanding), 2) AS AMOUNT_OUTSTANDING_SIXTY, 
  Format(outstanding_total.Sum_amountoutstanding, 2) AS AMOUNT_OUTSTANDING_TOTAL
FROM
  (SELECT
      accountlines.accountlines_id,
      accountlines.borrowernumber,
      accountlines.itemnumber,
      accountlines.date,
      accountlines.amount,
      accountlines.description,
      accountlines.amountoutstanding,
      accountlines.timestamp,
      accountlines.note,
      accountlines.manager_id
    FROM
      accountlines JOIN
      borrowers ON borrowers.borrowernumber = accountlines.manager_id
    WHERE
      accountlines.amountoutstanding > 0 AND
      accountlines.date BETWEEN (Date_Sub(CurDate(), INTERVAL 1 YEAR)) AND (Date_Sub(CurDate(), INTERVAL 60 DAY)) AND
      borrowers.branchcode = @brn := "OTTAWA" COLLATE utf8mb4_unicode_ci
    UNION
    SELECT
      accountlines.accountlines_id,
      accountlines.borrowernumber,
      accountlines.itemnumber,
      accountlines.date,
      accountlines.amount,
      accountlines.description,
      accountlines.amountoutstanding,
      accountlines.timestamp,
      accountlines.note,
      accountlines.manager_id
    FROM
      accountlines JOIN
      old_issues ON old_issues.borrowernumber = accountlines.borrowernumber AND 
      old_issues.itemnumber = accountlines.itemnumber
    WHERE
      accountlines.amountoutstanding > 0 AND
      accountlines.timestamp BETWEEN (Date_Sub(CurDate(), INTERVAL 1 YEAR)) AND (Date_Sub(CurDate(), INTERVAL 60 DAY)) AND old_issues.branchcode = @brn) outstanding_sixty JOIN
      borrowers ON borrowers.borrowernumber = outstanding_sixty.borrowernumber JOIN
      categories ON borrowers.categorycode = categories.categorycode LEFT JOIN
  (SELECT
      borrower_attributes.borrowernumber,
      borrower_attributes.code,
      borrower_attributes.attribute,
      authorised_values.category,
      authorised_values.lib
    FROM
      borrower_attributes JOIN
      authorised_values ON borrower_attributes.attribute = authorised_values.authorised_value
    WHERE
      borrower_attributes.code = 'CAOTTAWA' AND
      authorised_values.category = 'COLLAGEN') collagen ON
      borrowers.borrowernumber = collagen.borrowernumber LEFT JOIN
  (SELECT
      accountlines.borrowernumber,
      Sum(accountlines.amountoutstanding) AS Sum_amountoutstanding
    FROM
      accountlines
    WHERE
      accountlines.amountoutstanding > .01
    GROUP BY
      accountlines.borrowernumber) outstanding_total ON
      outstanding_total.borrowernumber = outstanding_sixty.borrowernumber
WHERE
  collagen.attribute IS NULL
GROUP BY
  borrowers.borrowernumber
HAVING
  AMOUNT_OUTSTANDING_SIXTY > 25
ORDER BY
  borrowers.surname,
  borrowers.firstname



