/*
Building a fct_orders Model
This part is designed to be an open ended exercise - see the exemplar on the next page to check your work.

Use a statement tab or Snowflake to inspect raw.stripe.payment
Create a stg_payments.sql model in models/staging/stripe
Create a fct_orders.sql (not stg_orders) model with the following fields.  Place this in the marts/core directory.
order_id
customer_id
amount (hint: this has to come from payments)


Refactor your dim_customers Model
Add a new field called lifetime_value to the dim_customers model:
lifetime_value: the total amount a customer has spent at jaffle_shop
Hint: The sum of lifetime_value is $1,672
*/

-- We have to ref to three tables to get the correct fct_orders:
with stg_orders as (
    
    select  order_id,
            customer_id
    from {{ref("stg_orders")}}
),

payments as (

    select  orderid, 
            sum(amount) as amount 
    from {{ref("stg_payments")}}
    where status = 'success'
    group by orderid
),

fact_orders as (
    
    select  stg_orders.order_id,
            stg_orders.customer_id,
            payments.amount
    from stg_orders
    left join payments on payments.orderid = stg_orders.order_id

)

select * from fact_orders 