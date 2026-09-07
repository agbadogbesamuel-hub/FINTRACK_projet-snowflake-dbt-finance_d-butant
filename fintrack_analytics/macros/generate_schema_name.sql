{% macro generate_schema_name(custom_schema_name, node) %}
{#-
    Schéma cible = dossier de premier niveau sous models/ (staging, intermediate, marts),
    sans jamais suffixer le schéma du profil (comportement par défaut de dbt, qui donnerait
    par ex. "STAGING_MARTS" pour les marts — voir README.md).

    Priorité :
      1. +schema configuré explicitement sur le noeud (ex: models.marts: +schema: marts)
      2. dossier de premier niveau du modèle (models/<dossier>/...), quel que soit le
         préfixe du nom (stg_, int_, dim_, fct_, mart_, ...) — plus robuste qu'un test
         sur node.name qui doit être mis à jour à chaque nouveau préfixe.
      3. schéma du profil, pour tout le reste (seeds, snapshots, modèles hors staging/
         intermediate/marts).
-#}

    {%- if custom_schema_name is not none -%}
        {{ custom_schema_name | upper }}

    {%- elif node.resource_type == 'model' and node.fqn | length >= 3 and node.fqn[1] in ('staging', 'intermediate', 'marts') -%}
        {{ node.fqn[1] | upper }}

    {%- else -%}
        {{ target.schema | upper }}

    {%- endif -%}

{% endmacro %}
