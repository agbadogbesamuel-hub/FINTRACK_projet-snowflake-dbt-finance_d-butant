
    
    

select
    compte_id as unique_field,
    count(*) as n_records

from fintrack_db.STAGING.stg_comptes
where compte_id is not null
group by compte_id
having count(*) > 1


