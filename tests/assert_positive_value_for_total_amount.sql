-- Test for checking there aren't negative results in amount in payments table
select  orderid,
        sum(amount) as total_amount
from {{ref("stg_payments")}}
group by orderid
having total_amount < 0

/* Extra Credit
Add a relationships test to your stg_orders model for the customer_id in stg_customers.
Add tests throughout the rest of your models.
Write your own singular tests.
*/
