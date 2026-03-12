<?php
session_start();
require_once('db_config.php');
$page_title = 'Paiement sécurisé';

if (empty($_SESSION['panier'])) {
    header("Location: tout_parcourir.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$sql  = "SELECT * FROM Paiements WHERE id_utilisateur = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([$user_id]);
$paiement = $stmt->fetch();

$total = 0;
$ids   = implode(',', array_map('intval', $_SESSION['panier']));
$articles = $pdo->query("SELECT * FROM Produits WHERE id_produit IN ($ids)")->fetchAll();
foreach ($articles as $a) { $total += $a['prix_initial']; }

include('header.php');
?>

<div class="container page-section">
    <div class="paiement-box">

        <div class="paiement-header">
            <h2>Validation de commande</h2>
            <p><?php echo count($articles); ?> article<?php echo count($articles) !== 1 ? 's' : ''; ?></p>
            <p class="paiement-prix"><?php echo number_format($total, 2, ',', ' '); ?> €</p>
        </div>

        <div class="paiement-body">

            <!-- Récap articles -->
            <p class="form-section-title">Récapitulatif</p>
            <?php foreach ($articles as $a): ?>
                <div class="d-flex justify-between align-center mb-1" style="font-size:0.875rem;">
                    <span><?php echo htmlspecialchars($a['nom']); ?></span>
                    <span class="text-or"><?php echo number_format($a['prix_initial'], 2, ',', ' '); ?> €</span>
                </div>
            <?php endforeach; ?>
            <hr class="separator">

            <!-- Aperçu carte -->
            <?php if ($paiement): ?>
            <div class="carte-preview">
                <p class="carte-num">**** **** **** <?php echo substr($paiement['numero_carte'], -4); ?></p>
                <p class="carte-exp"><?php echo htmlspecialchars($paiement['nom_carte']); ?> &mdash; Expire <?php echo htmlspecialchars($paiement['date_expiration']); ?></p>
            </div>
            <?php endif; ?>

            <!-- Formulaire CVV -->
            <form action="valider_achat.php" method="POST">
                <div class="form-group">
                    <label class="form-label">Code de sécurité (CVV)</label>
                    <input class="form-control" type="password" name="cvv_verif"
                           maxlength="4" placeholder="•••" required
                           style="letter-spacing:0.2em;font-size:1.1rem;">
                </div>
                <button type="submit" class="btn btn-primary btn-full btn-lg">
                    Payer <?php echo number_format($total, 2, ',', ' '); ?> €
                </button>
            </form>

            <a href="panier.php" class="back-link mt-2" style="display:block;text-align:center;">&#8592; Retour au panier</a>
        </div>
    </div>
</div>

<?php include('footer.php'); ?>
