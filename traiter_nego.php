<?php
session_start();
require_once('db_config.php');

if (!isset($_SESSION['user_id']) || !isset($_GET['id']) || !isset($_GET['action'])) {
    header("Location: login.php");
    exit();
}

$id_nego = (int)$_GET['id'];
$action = $_GET['action'];

try {
    $pdo->beginTransaction();

    // 1. Récupérer les infos de la négo
    $stmt = $pdo->prepare("SELECT id_produit, dernier_prix_propose FROM negociations WHERE id_nego = ?");
    $stmt->execute([$id_nego]);
    $nego = $stmt->fetch();

    if ($action === 'accepter') {
        // Mettre à jour le produit : changer le prix et marquer comme vendu
        $update_prod = $pdo->prepare("UPDATE produits SET prix_initial = ?, statut = 'vendu' WHERE id_produit = ?");
        $update_prod->execute([$nego['dernier_prix_propose'], $nego['id_produit']]);

        // Valider la négo
        $update_nego = $pdo->prepare("UPDATE negociations SET statut_nego = 'accepte' WHERE id_nego = ?");
        $update_nego->execute([$id_nego]);
    } else {
        // Refuser la négo
        $update_nego = $pdo->prepare("UPDATE negociations SET statut_nego = 'refuse' WHERE id_nego = ?");
        $update_nego->execute([$id_nego]);
    }

    $pdo->commit();
    header("Location: vendeur_mur.php?success=1");
} catch (Exception $e) {
    $pdo->rollBack();
    die("Erreur : " . $e->getMessage());
}