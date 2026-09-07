with mensuel as (

    select
        compte_id,
        mois_transaction as mois,
        sum(case when type_operation = 'credit' then montant else 0 end) as total_credits,
        sum(case when type_operation = 'debit'  then montant else 0 end) as total_debits,
        sum(montant_signe) as solde_net_mois

    from fintrack_db.MARTS.fct_transactions
    group by compte_id, mois_transaction

),

avec_solde_initial as (

    select
        m.*,
        c.solde_initial

    from mensuel m
    left join fintrack_db.MARTS.dim_comptes c on m.compte_id = c.compte_id

)

select
    compte_id,
    mois,
    total_credits,
    total_debits,
    solde_net_mois,

    -- Solde cumulé depuis l'ouverture : solde initial + somme des soldes nets mensuels
    -- de tous les mois précédents (inclus) pour ce compte.
    solde_initial + sum(solde_net_mois) over (
        partition by compte_id
        order by mois
        rows between unbounded preceding and current row
    ) as solde_cumule

from avec_solde_initial