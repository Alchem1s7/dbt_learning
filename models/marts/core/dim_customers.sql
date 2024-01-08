-- dbt creates the view by simply running the next query:
-- If we want to materialize the query into a table, we need to add the next code:
/*
{{
    config (
    materialized='table'
    )
}}
*/
-- We remove the code above because we're working with the YML file...

-- In the next lines I'm referencing another models 
-- Using best practices, this is called modularity

with customers as (
    select * from {{ ref("stg_customers")}}
),


orders as (
    select * from {{ ref("stg_orders")}}
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

spend_by_customer as (

    select  customer_id,
            sum(amount) as amount
    from {{ref("fct_orders")}}
    group by customer_id

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        spend_by_customer.amount as lifetime_value

    from customers

    left join customer_orders using (customer_id)
    left join spend_by_customer on spend_by_customer.customer_id = customers.customer_id


)

select * from final
