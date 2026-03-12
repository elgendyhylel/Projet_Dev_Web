<?php
session_start();
require_once('db_config.php');

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$page_title = "Mes Offres & Enchères";
include('header.php');

// 1. Récupérer les négociations (où l'utilisateur est l'acheteur)
$sql_nego = "SELECT n.*, p.nom, p.photo, p.prix_initial 
             FROM negociations n 
             JOIN Produits p ON n.id_produit = p.id_produit 
             WHERE n.id_acheteur = ? 
             ORDER BY n.id_nego DESC";
$stmt_nego = $pdo->prepare($sql_nego);
$stmt_nego->execute([$user_id]);
$mes_negos = $stmt_nego->fetchAll();

// 2. Récupérer les enchères (où l'utilisateur est le meilleur enchérisseur)
$sql_enchere = "SELECT e.*, p.nom, p.photo, p.prix_initial 
                FROM encheres e 
                JOIN Produits p ON e.id_produit = p.id_produit 
                WHERE e.id_meilleur_encherisseur = ? 
                ORDER BY e.date_fin ASC";
$stmt_enchere = $pdo->prepare($sql_enchere);
$stmt_enchere->execute([$user_id]);
$mes_encheres = $stmt_encheres = $stmt_enchere->fetchAll();
?>

<div class="container page-section">
    <h1 class="mb-3">Suivi de mes offres</h1>

    <section class="mb-5">
        <h2 class="mb-2">🤝 Mes Négociations</h2>
        <?php if (empty($mes_negos)): ?>
            <p class="text-gris">Aucune négociation en cours.</p>
        <?php else: ?>
            <div class="table-container" style="background:#fff; padding:20px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.05);">
                <table style="width:100%; border-collapse:collapse;">
                    <thead>
                        <tr style="text-align:left; border-bottom:2px solid #eee;">
                            <th style="padding:10px;">Produit</th>
                            <th>Dernière Offre</th>
                            <th>Statut</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($mes_negos as $nego): ?>
                        <tr style="border-bottom:1px solid #f5f5f5;">
                            <td style="padding:15px 0;">
                                <img src="uploads/<?php echo $nego['photo']; ?>" width="40" style="border-radius:4px; vertical-align:middle; margin-right:10px;">
                                <strong><?php echo htmlspecialchars($nego['nom']); ?></strong>
                            </td>
                            <td style="text-align:center;"><?php echo number_format($nego['dernier_prix_propose'], 2, ',', ' '); ?> €</td>
                            <td style="text-align:center;">
                                <span class="badge-vente <?php echo ($nego['statut_nego'] == 'accepte') ? 'badge-immediat' : 'badge-negociation'; ?>">
                                    <?php echo ucfirst($nego['statut_nego']); ?>
                                </span>
                            </td>
                            <td style="text-align:center;">
                                <a href="article_details.php?id=<?php echo $nego['id_produit']; ?>" class="btn btn-outline btn-sm">Voir</a>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </section>

    <section>
        <h2 class="mb-2">🔨 Mes Enchères (Meilleure offre)</h2>
        <?php if (empty($mes_encheres)): ?>
            <p class="text-gris">Vous n'êtes actuellement le meilleur enchérisseur sur aucun article.</p>
        <?php else: ?>
            <div class="table-container" style="background:#fff; padding:20px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.05);">
                <table style="width:100%; border-collapse:collapse;">
                    <thead>
                        <tr style="text-align:left; border-bottom:2px solid #eee;">
                            <th style="padding:10px;">Produit</th>
                            <th>Prix Actuel</th>
                            <th>Fin de l'enchère</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($mes_encheres as $enchere): ?>
                        <tr style="border-bottom:1px solid #f5f5f5;">
                            <td style="padding:15px 0;">
                                <img src="uploads/<?php echo $enchere['photo']; ?>" width="40" style="border-radius:4px; vertical-align:middle; margin-right:10px;">
                                <strong><?php echo htmlspecialchars($enchere['nom']); ?></strong>
                            </td>
                            <td style="text-align:center; font-weight:bold; color:var(--or);">
                                <?php echo number_format($enchere['prix_actuel_enchere'], 2, ',', ' '); ?> €
                            </td>
                            <td style="text-align:center; font-size:0.85rem;">
                                <?php echo date('d/m/Y H:i', strtotime($enchere['date_fin'])); ?>
                            </td>
                            <td style="text-align:center;">
                                <a href="article_details.php?id=<?php echo $enchere['id_produit']; ?>" class="btn btn-outline btn-sm">Détails</a>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </section>
</div>

<?php include('footer.php'); ?>