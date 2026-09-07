with source as (

    select * from {{ source('raw', 'raw_transactions') }}

),

renamed as (

    select
        id                                      as transaction_id,
        compte_id,
        cast(date_transaction as timestamp_ntz) as date_transaction,
        montant,
        type_operation,
        categorie_id,
        description,
        lower(statut)                            as statut,
        case
            when type_operation = 'credit' then montant
            when type_operation = 'debit'  then -montant
        end                                       as montant_signe

    from source

)

select * from renamed
