-- Test singulier : aucun compte epargne ne doit avoir un solde cumulé négatif.
-- Un test dbt réussit quand cette requête ne retourne AUCUNE ligne.

select
    m.compte_id,
    c.nom_client,
    m.mois,
    m.solde_cumule

from {{ ref('mart_solde_mensuel') }} m
inner join {{ ref('dim_comptes') }} c on m.compte_id = c.compte_id
where c.type_compte = 'epargne'
  and m.solde_cumule < 0
