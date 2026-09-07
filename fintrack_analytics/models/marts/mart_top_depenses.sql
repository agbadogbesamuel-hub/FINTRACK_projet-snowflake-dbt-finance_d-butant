-- Bonus 8.2 : top 3 des catégories de dépenses par compte.
with depenses_categorie as (

    select
        compte_id,
        nom_client,
        categorie_id,
        nom_categorie,
        sum(montant) as total_depense

    from {{ ref('fct_transactions') }}
    where type_operation = 'debit'
    group by compte_id, nom_client, categorie_id, nom_categorie

),

classement as (

    select
        *,
        row_number() over (partition by compte_id order by total_depense desc) as rang

    from depenses_categorie

)

select *
from classement
where rang <= 3
