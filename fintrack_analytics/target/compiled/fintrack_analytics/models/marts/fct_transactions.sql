with __dbt__cte__int_transactions_enrichies as (
-- Modèle éphémère : injecté comme CTE dans fct_transactions, ne crée pas d'objet en base.
with transactions as (

    select * from fintrack_db.STAGING.stg_transactions

),

comptes as (

    select * from fintrack_db.STAGING.stg_comptes

),

categories as (

    select * from fintrack_db.STAGING.stg_categories

),

enrichi as (

    select
        t.transaction_id,
        t.compte_id,
        c.nom_client,
        c.type_compte,
        t.date_transaction,
        date_trunc('month', t.date_transaction)::date as mois_transaction,
        t.montant,
        t.montant_signe,
        t.type_operation,
        t.categorie_id,
        cat.nom_categorie,
        cat.type_categorie,
        cat.groupe,
        t.description,
        t.statut

    from transactions t
    left join comptes    c   on t.compte_id    = c.compte_id
    left join categories cat on t.categorie_id = cat.categorie_id

)

select * from enrichi
)
--EPHEMERAL-SELECT-WRAPPER-START
select * from (
select
    transaction_id,
    compte_id,
    categorie_id,
    date_transaction,
    mois_transaction,
    montant,
    montant_signe,
    type_operation,
    nom_client,
    type_compte,
    nom_categorie,
    type_categorie,
    groupe,
    description,
    statut

from __dbt__cte__int_transactions_enrichies

-- On ne garde que les transactions confirmées dans les analyses financières
where statut = 'validee'
--EPHEMERAL-SELECT-WRAPPER-END
)