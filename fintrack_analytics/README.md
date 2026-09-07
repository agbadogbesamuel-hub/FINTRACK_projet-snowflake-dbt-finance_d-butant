# FinTrack Analytics — Projet débutant (Snowflake + dbt)

## 1. Provisionner Snowflake

Dans Snowsight (rôle SECURITYADMIN/SYSADMIN) :

```sql
!source ../snowflake_setup.sql
```

Puis charger les données d'exemple :

```sql
!source ../seed_data.sql
```

## 2. Configurer dbt

```bash
pip install dbt-snowflake
cp profiles.yml.example ~/.dbt/profiles.yml
# éditer ~/.dbt/profiles.yml avec vos identifiants
dbt debug
dbt deps        # installe dbt-utils (utilisé par dim_comptes)
```

## 3. Construire le projet

```bash
dbt run
dbt test
dbt seed        # aucun seed dans ce projet débutant, no-op
dbt snapshot    # bonus 8.3 — historise raw_comptes
dbt docs generate
dbt docs serve
```

## Structure

```
models/
├── staging/        (view)      — nettoyage 1:1 des 4 tables raw
├── intermediate/   (ephemeral) — jointure transactions + comptes + catégories
└── marts/          (table)     — dim_comptes, dim_categories, fct_transactions,
                                   mart_solde_mensuel, mart_budget_vs_reel,
                                   mart_top_depenses (bonus)
snapshots/          — snapshot_comptes (bonus, SCD2 sur le statut du compte)
tests/              — assert_solde_mensuel_positif (test singulier)
```

## Note sur le schéma des marts

`dbt_project.yml` définit `+schema: marts` pour la couche marts. Par défaut,
dbt **suffixe** le schéma cible du profil plutôt que de le remplacer : avec
`schema: staging` dans `profiles.yml`, les modèles marts atterriraient dans
`STAGING_MARTS` et non `MARTS`. Ce comportement est réécrit ici par la macro
`macros/generate_schema_name.sql`, qui fait atterrir chaque modèle dans le
schéma correspondant à son dossier de premier niveau sous `models/`
(`STAGING`, `INTERMEDIATE`, `MARTS`), quel que soit le préfixe du nom du
modèle.

## Vérifications avant de rendre le livrable

- [ ] `dbt run` : tous les modèles passent (staging → intermediate → marts)
- [ ] `dbt test` : tous les tests génériques et le test singulier passent
- [ ] `dbt docs generate` + capture d'écran du lineage complet (sources → staging → intermediate → marts)
- [ ] Rapport de 10-15 lignes (voir `../RAPPORT.md`)
