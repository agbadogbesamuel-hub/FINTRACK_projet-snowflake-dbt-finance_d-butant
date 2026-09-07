
    
    

with all_values as (

    select
        type_compte as value_field,
        count(*) as n_records

    from fintrack_db.STAGING.stg_comptes
    group by type_compte

)

select *
from all_values
where value_field not in (
    'courant','epargne','joint'
)


