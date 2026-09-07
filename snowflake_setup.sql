-- =========================================================
-- FinTrack Analytics — Partie 1 (Débutant)
-- Étape 1.1 — Configuration de l'environnement Snowflake
-- =========================================================

-- 1. Rôle dédié au projet
use role securityadmin;

create role if not exists fintrack_role;
grant role fintrack_role to role sysadmin;
grant role fintrack_role to user FELIXDUBOIS;

-- 2. Base de données dédiée au projet
use role sysadmin;

create database if not exists fintrack_db
    comment = 'FinTrack Analytics - projet debutant Snowflake + dbt';

-- 3. Trois schémas : données brutes, transformations dbt, modèles analytiques finaux
create schema if not exists fintrack_db.raw
    comment = 'Donnees brutes non transformees';
create schema if not exists fintrack_db.staging
    comment = 'Modeles staging et intermediate dbt';
create schema if not exists fintrack_db.marts
    comment = 'Modeles analytiques finaux (dimensions et faits)';

-- 4. Entrepôt de calcul de taille XS
create warehouse if not exists fintrack_wh
    warehouse_size = 'XSMALL'
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true
    comment = 'Warehouse dedie au projet FinTrack Analytics';

-- 5. Droits : accorder l'usage de la base, du warehouse et de chaque schéma au rôle
grant usage on database fintrack_db to role fintrack_role;
grant usage on warehouse fintrack_wh to role fintrack_role;
grant operate on warehouse fintrack_wh to role fintrack_role;

grant usage, create table, create view on schema fintrack_db.raw to role fintrack_role;
grant usage, create table, create view on schema fintrack_db.staging to role fintrack_role;
grant usage, create table, create view on schema fintrack_db.marts to role fintrack_role;

-- dbt doit pouvoir créer le schéma suffixé pour les marts (ex: STAGING_MARTS)
-- et le schéma des snapshots (bonus 8.3)
grant create schema on database fintrack_db to role fintrack_role;

-- Vérification rapide
use role fintrack_role;
use warehouse fintrack_wh;
use database fintrack_db;
show schemas in database fintrack_db;
