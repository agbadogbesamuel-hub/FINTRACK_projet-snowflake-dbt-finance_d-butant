-- Bonus 8.3 : suivi historique des comptes (SCD Type 2, stratégie "check").
{% snapshot snapshot_comptes %}

{{
    config(
        target_schema='snapshots',
        unique_key='id',
        strategy='check',
        check_cols=['statut', 'email', 'type_compte'],
    )
}}

select * from {{ source('raw', 'raw_comptes') }}

{% endsnapshot %}
