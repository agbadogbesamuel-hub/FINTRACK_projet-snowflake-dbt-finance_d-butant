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
    {{ dbt_utils.generate_surrogate_key(['compte_id']) }} as compte_sk

from {{ ref('stg_comptes') }}
