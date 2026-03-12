<?php
session_start();
require_once('db_config.php');
$page_title = 'Mon panier';
include('header.php');

$articles_panier = [];
$total = 0;

if (!empty($_SESSION['panier'])) {
    $ids  = implode(',', array_map('intval', $_SESSION['panier']));
    $sql  = "SELECT * FROM Produits WHERE id_produit IN ($ids)";
    $stmt = $pdo->query($sql);
    $articles_panier = $stmt->fetchAll();
}
?>

<div class="container page-section">
    <div class="page-header">
        <h1>Votre panier</h1>
    </div>

    <?php if (empty($articles_panier)): ?>
        <div class="empty-state">
            <span class="empty-icon">—</span>
            <p>Votre panier est vide.</p>
            <a href="tout_parcourir.php" class="btn btn-primary">Parcourir les articles</a>
        </div>

    <?php else: ?>
        <table class="panier-table">
            <thead>
                <tr>
                    <th>Article</th>
                    <th>Prix</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($articles_panier as $item):
                    $total += $item['prix_initial'];
                ?>
                <tr>
                    <td>
                        <div class="d-flex align-center gap-2">
                            <img src="uploads/<?php echo htmlspecialchars($item['photo']); ?>"
                                 style="width:54px;height:54px;object-fit:cover;border-radius:6px;background:var(--gris-clair);"
                                 alt="">
                            <div>
                                <strong><?php echo htmlspecialchars($item['nom']); ?></strong>
                                <br><span class="text-gris" style="font-size:0.8rem;"><?php echo ucfirst($item['categorie']); ?></span>
                            </div>
                        </div>
                    </td>
                    <td><span style="font-family:'Cormorant Garamond',serif;font-size:1.15rem;color:var(--or);"><?php echo number_format($item['prix_initial'], 2, ',', ' '); ?> €</span></td>
                    <td>
                        <a href="supprimer_panier.php?id=<?php echo $item['id_produit']; ?>"
                           class="btn btn-danger-soft btn-sm">Supprimer</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <div class="panier-total-box">
            <p class="panier-total-label">Total</p>
            <p class="panier-total-prix"><?php echo number_format($total, 2, ',', ' '); ?> €</p>
            <a href="confirmation_paiement.php" class="btn btn-primary btn-lg mt-2">Procéder au paiement</a>
        </div>
    <?php endif; ?>
</div>

<?php include('footer.php'); ?>
