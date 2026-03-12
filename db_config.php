<?php
// 1. Définition des variables d'accès
$host = 'localhost';      // Le serveur est sur ta machine (XAMPP/WAMP).
$db   = 'omnes_marketplace'; // Le nom exact de la base qu'on a créée.
$user = 'root';           // L'identifiant par défaut de MySQL.
$pass = '';               // Le mot de passe (souvent vide par défaut).
$charset = 'utf8mb4';     // Pour gérer les accents et les emojis sans bug.

// 2. Création du DSN (Data Source Name)
// C'est une chaîne de caractères qui résume l'adresse de la base.
$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

// 3. Options de sécurité et de performance
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, 
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

// 4. Tentative de connexion (Bloc Try/Catch)
try {
     // On crée l'objet $pdo qui sera utilisé pour toutes les requêtes.
     $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
     // Si la connexion échoue (mauvais mdp, serveur éteint), on arrête tout et on affiche l'erreur.
     throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
?>