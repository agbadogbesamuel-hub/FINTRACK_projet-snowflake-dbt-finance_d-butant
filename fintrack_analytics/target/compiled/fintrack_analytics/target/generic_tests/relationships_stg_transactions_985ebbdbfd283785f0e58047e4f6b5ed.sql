
    
    

with child as (
    select compte_id as from_field
    from fintrack_db.STAGING.stg_transactions
    where compte_id is not null
),

parent as (
    select compte_id as to_field
    from fintrack_db.STAGING.stg_comptes
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


