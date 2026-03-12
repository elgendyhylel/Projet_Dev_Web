<?php
session_start();
require_once('db_config.php');

// 1. Sécurité : Vérifier que l'utilisateur est connecté
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_produit = (int)$_POST['id_produit'];
    $nouvelle_mise = (float)$_POST['mise'];
    $id_acheteur = $_SESSION['user_id'];

    try {
        $pdo->beginTransaction();

        // 2. Récupérer les infos actuelles du produit
        $stmt = $pdo->prepare("SELECT prix_initial, nom FROM Produits WHERE id_produit = ?");
        $stmt->execute([$id_produit]);
        $produit = $stmt->fetch();

        if (!$produit) {
            die("Produit introuvable.");
        }

        // 3. Vérifier si la mise est plus haute que le prix actuel
        if ($nouvelle_mise > $produit['prix_initial']) {
            
            // 4. Mettre à jour le prix dans la table Produits
            $update = $pdo->prepare("UPDATE Produits SET prix_initial = ? WHERE id_produit = ?");
            $update->execute([$nouvelle_mise, $id_produit]);

            // 5. Enregistrer l'enchère dans la table 'encheres'
            // Note : On utilise les noms de colonnes de ton script SQL initial
            $sql_enchere = "INSERT INTO encheres (id_produit, prix_actuel_enchere, id_meilleur_encherisseur, date_fin) 
                            VALUES (?, ?, ?, NOW() + INTERVAL 7 DAY)
                            ON DUPLICATE KEY UPDATE 
                            prix_actuel_enchere = VALUES(prix_actuel_enchere), 
                            id_meilleur_encherisseur = VALUES(id_meilleur_encherisseur)";
            
            $stmt_e = $pdo->prepare($sql_enchere);
            $stmt_e->execute([$id_produit, $nouvelle_mise, $id_acheteur]);

            $pdo->commit();
            header("Location: article_details.php?id=$id_produit&success=1");
            exit();

        } else {
            // Mise insuffisante
            header("Location: article_details.php?id=$id_produit&error=low_bid");
            exit();
        }

    } catch (Exception $e) {
        $pdo->rollBack();
        die("Erreur : " . $e->getMessage());
    }
} else {
    header("Location: tout_parcourir.php");
    exit();
}