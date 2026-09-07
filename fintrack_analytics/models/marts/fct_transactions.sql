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

from {{ ref('int_transactions_enrichies') }}

-- On ne garde que les transactions confirmées dans les analyses financières
where statut = 'validee'
