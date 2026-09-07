select
    compte_id,
    nom_client,
    email,
    type_compte,
    date_ouverture,
    solde_initial,
    statut,
    datediff('day', date_ouverture, current_date()) as anciennete_jours,

    -- Bonus 8.1 : clé de substitution via dbt-utils (nécessite `dbt deps`)
    md5(cast(coalesce(cast(compte_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as compte_sk

from fintrack_db.STAGING.stg_comptes