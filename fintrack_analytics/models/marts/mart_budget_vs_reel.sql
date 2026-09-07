with budgets_agreges as (

    select
        compte_id,
        categorie_id,
        mois,
        sum(montant_prevu) as montant_prevu

    from {{ ref('stg_budgets') }}
    group by compte_id, categorie_id, mois

),

depenses_agregees as (

    select
        compte_id,
        categorie_id,
        mois_transaction as mois,
        sum(montant) as montant_reel

    from {{ ref('fct_transactions') }}
    where type_operation = 'debit'
    group by compte_id, categorie_id, mois_transaction

),

rapproche as (

    select
        coalesce(b.compte_id, d.compte_id)       as compte_id,
        coalesce(b.categorie_id, d.categorie_id) as categorie_id,
        coalesce(b.mois, d.mois)                 as mois,
        coalesce(b.montant_prevu, 0)             as montant_prevu,
        coalesce(d.montant_reel, 0)              as montant_reel

    from budgets_agreges b
    full outer join depenses_agregees d
        on  b.compte_id    = d.compte_id
        and b.categorie_id = d.categorie_id
        and b.mois          = d.mois

)

select
    r.compte_id,
    c.nom_client,
    r.categorie_id,
    cat.nom_categorie,
    r.mois,
    r.montant_prevu,
    r.montant_reel,
    r.montant_reel - r.montant_prevu as ecart,
    r.montant_reel > r.montant_prevu as depassement

from rapproche r
left join {{ ref('dim_comptes') }}    c   on r.compte_id    = c.compte_id
left join {{ ref('dim_categories') }} cat on r.categorie_id = cat.categorie_id
