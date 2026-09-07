select
    categorie_id,
    nom_categorie,
    type_categorie,
    groupe
from {{ ref('stg_categories') }}
