<?php
session_start();
require_once('db_config.php');
$page_title = 'Confirmation';
include('header.php');

if ($_SERVER["REQUEST_METHOD"] == "POST" && !empty($_SESSION['panier'])) {
    $cvv_saisi = $_POST['cvv_verif'] ?? '';
    $user_id   = $_SESSION['user_id'];

    $sql  = "SELECT code_securite FROM Paiements WHERE id_utilisateur = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$user_id]);
    $pay  = $stmt->fetch();

    if ($pay && $cvv_saisi === $pay['code_securite']) {
        $ids = implode(',', array_map('intval', $_SESSION['panier']));
        $pdo->query("UPDATE Produits SET statut = 'vendu' WHERE id_produit IN ($ids)");
        unset($_SESSION['panier']);
        $succes = true;
    } else {
        $erreur = true;
    }
} else {
    header("Location: panier.php");
    exit();
}
?>

<div class="container page-section">
    <div style="max-width:480px;margin:0 auto;text-align:center;padding:3rem 1.5rem;">

        <?php if (isset($succes)): ?>
            <div style="font-size:2rem;font-weight:600;color:#16a34a;margin-bottom:1rem;">Commande validee</div>
            <h2 class="mb-2">Commande confirmée !</h2>
            <p class="text-gris mb-4">Merci pour votre achat. Un email de confirmation vous sera envoyé.</p>
            <a href="index.php" class="btn btn-primary">Retour à l'accueil</a>
        <?php else: ?>
            <div style="font-size:2rem;font-weight:600;color:#dc2626;margin-bottom:1rem;">Echec</div>
            <h2 class="mb-2">Code CVV incorrect</h2>
            <p class="text-gris mb-4">Veuillez vérifier votre code de sécurité et réessayer.</p>
            <a href="confirmation_paiement.php" class="btn btn-primary">Réessayer</a>
        <?php endif; ?>

    </div>
</div>

<?php include('footer.php'); ?>
