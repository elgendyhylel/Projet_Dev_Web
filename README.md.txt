🛒 Omnes MarketPlace - Projet Web ING3
Bienvenue sur Omnes MarketPlace, une plateforme e-commerce complète développée pour la communauté Omnes Education. Ce site permet l'achat immédiat, les enchères en temps réel et la négociation directe entre acheteurs et vendeurs.
🚀 Installation
1.	Serveur Local : Placez le dossier Projet_Dev_Web dans votre répertoire htdocs (XAMPP) ou www (WAMP).
2.	Base de données :
o	Ouvrez phpMyAdmin.
o	Créez une base de données nommée omnes_marketplace.
o	Importez le fichier omnes_marketplace.sql situé à la racine du projet.
3.	Configuration : Le fichier db_config.php est configuré par défaut pour un accès root sans mot de passe sur localhost.
🔑 Comptes de Test
Rôle	Email	Mot de passe
Administrateur	admin@test.fr	(celui créé lors de vos tests)
Vendeur	vendeur1@test.fr	hash (ou votre test)
Acheteur	acheteur1@test.fr	hash (ou votre test)
✨ Fonctionnalités Clés
•	Système d'Enchères : Mise à jour dynamique du prix et enregistrement du meilleur enchérisseur.
•	Négociation Directe : Interface d'échange limitée à 5 tours entre l'acheteur et le vendeur.
•	Filtrage Intelligent : Depuis l'accueil, filtrez le catalogue par type de vente (Enchère, Achat immédiat, Négociation).
•	Espace Vendeur : Mur personnalisé avec gestion des offres de négociation reçues (Accepter/Refuser).
•	Dashboard Admin : Contrôle total sur les utilisateurs et les articles du catalogue.
•	Panier Persistant : Gestion des articles via les sessions PHP avant validation finale.
📁 Structure du Projet
•	/uploads : Contient les images des produits et les photos de profil.
•	tout_parcourir.php : Catalogue dynamique avec système de badges colorés.
•	article_details.php : Fiche produit avec formulaires contextuels selon le type de vente.
•	valider_achat.php : Simulation de paiement sécurisé avec vérification du code C

