<?php
session_start();

// Si le panier n'existe pas encore dans la session, on le crée (un tableau vide)
if (!isset($_SESSION['panier'])) {
    $_SESSION['panier'] = array();
}

// On récupère l'ID de l'article envoyé par le bouton "Ajouter au Panier"
if (isset($_POST['id_article'])) {
    $id = $_POST['id_article'];

    // On ajoute l'ID dans le tableau du panier s'il n'y est pas déjà
    if (!in_array($id, $_SESSION['panier'])) {
        $_SESSION['panier'][] = $id;
    }
}

// On renvoie l'utilisateur vers la page du panier
header("Location: panier.php");
exit();
?>