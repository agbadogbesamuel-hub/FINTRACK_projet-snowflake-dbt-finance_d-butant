# Rapport — FinTrack Analytics (Projet débutant)

**Différence vue / table / éphémère dans dbt ?**
Une **vue** (`view`) ne stocke aucune donnée : dbt crée un objet `CREATE VIEW`
et la requête est ré-exécutée à chaque lecture. C'est peu coûteux à
construire, adapté aux modèles staging qui changent souvent et ne sont pas
trop volumineux. Une **table** (`table`) matérialise physiquement le résultat
via `CREATE TABLE AS SELECT` : plus rapide à lire ensuite, mais il faut
reconstruire toute la table à chaque `dbt run`, donc plus coûteux en warehouse
sur de gros volumes. C'est le bon choix pour les marts, consommés fréquemment
par la BI. Un modèle **éphémère** (`ephemeral`) ne crée aucun objet en base :
dbt l'injecte directement comme sous-requête (CTE) dans les modèles qui le
référencent. Idéal pour une étape de transformation intermédiaire qui ne
présente aucun intérêt à être interrogée seule (`int_transactions_enrichies`).

**Pourquoi séparer staging, intermediate et marts ?**
Cette séparation en couches limite la portée de chaque modèle : staging fait
un travail unique (renommer/typer/nettoyer une source, un modèle par table
source), intermediate assemble ces briques propres (jointures, enrichissements)
sans encore porter de logique métier finale, et marts applique les règles
métier et l'agrégation pour produire des tables prêtes à consommer. Cela rend
chaque modèle plus facile à tester, déboguer et réutiliser, évite de dupliquer
la logique de nettoyage dans plusieurs marts, et rend le lineage lisible dans
`dbt docs`.

**Quel avantage du test `relationships` ?**
Il vérifie l'intégrité référentielle directement dans le pipeline : chaque
valeur de la colonne enfant (ex. `compte_id` dans `stg_transactions`) doit
exister dans la colonne parente référencée (`compte_id` dans `stg_comptes`).
Sans ce test, une transaction orpheline (compte supprimé ou mal chargé)
passerait inaperçue et fausserait silencieusement les agrégats des marts. Le
test échoue automatiquement à chaque `dbt test`, ce qui permet de détecter le
problème avant qu'il n'atteigne les tableaux de bord.
