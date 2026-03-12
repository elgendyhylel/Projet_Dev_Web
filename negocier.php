<?php
session_start();
require_once('db_config.php');

// Sécurité : Utilisateur connecté ?
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_produit = (int)$_POST['id_produit'];
    $offre_prix = (float)$_POST['offre'];
    $id_acheteur = $_SESSION['user_id'];

    try {
        // 1. Vérifier si une négociation existe déjà pour ce couple acheteur/produit
        $check = $pdo->prepare("SELECT id_nego, compteur_tours FROM negociations WHERE id_produit = ? AND id_acheteur = ?");
        $check->execute([$id_produit, $id_acheteur]);
        $nego_existante = $check->fetch();

        if ($nego_existante) {
            // 2. Vérifier la limite des 5 tours
            if ($nego_existante['compteur_tours'] < 5) {
                $update = $pdo->prepare("UPDATE negociations 
                                         SET dernier_prix_propose = ?, compteur_tours = compteur_tours + 1 
                                         WHERE id_nego = ?");
                $update->execute([$offre_prix, $nego_existante['id_nego']]);
            } else {
                die("Nombre maximum de tentatives atteint pour cet article.");
            }
        } else {
            // 3. Première offre : Créer la ligne
            $insert = $pdo->prepare("INSERT INTO negociations (id_produit, id_acheteur, dernier_prix_propose, compteur_tours, statut_nego) 
                                     VALUES (?, ?, ?, 1, 'en_cours')");
            $insert->execute([$id_produit, $id_acheteur, $offre_prix]);
        }

        header("Location: article_details.php?id=$id_produit&success=1");
        exit();

    } catch (Exception $e) {
        die("Erreur : " . $e->getMessage());
    }
} else {
    header("Location: tout_parcourir.php");
    exit();
}