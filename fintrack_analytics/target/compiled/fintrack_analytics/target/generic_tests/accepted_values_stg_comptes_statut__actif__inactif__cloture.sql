
    
    

with all_values as (

    select
        statut as value_field,
        count(*) as n_records

    from fintrack_db.STAGING.stg_comptes
    group by statut

)

select *
from all_values
where value_field not in (
    'actif','inactif','cloture'
)


