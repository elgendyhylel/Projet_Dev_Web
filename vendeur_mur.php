<?php
session_start();
require_once('db_config.php');

// 1. Déterminer l'ID du vendeur à afficher
// Priorité à l'ID dans l'URL (ex: ?id=5), sinon l'utilisateur connecté
$id_vendeur_url = isset($_GET['id']) ? (int)$_GET['id'] : (isset($_SESSION['user_id']) ? (int)$_SESSION['user_id'] : 0);

if ($id_vendeur_url === 0) {
    header("Location: login.php");
    exit();
}

$page_title = 'Mur vendeur';

// 2. Récupérer les infos du vendeur (nom, photos)
$sql_vendeur = "SELECT U.nom, U.prenom, V.photo_profil, V.image_fond
                FROM Utilisateurs U
                LEFT JOIN Vendeurs V ON U.id_utilisateur = V.id_utilisateur
                WHERE U.id_utilisateur = ?";
$stmt_v = $pdo->prepare($sql_vendeur);
$stmt_v->execute([$id_vendeur_url]);
$vendeur = $stmt_v->fetch();

// 3. Récupérer les articles en vente de ce vendeur
$sql_articles = "SELECT * FROM Produits WHERE id_vendeur = ? AND statut != 'vendu' ORDER BY id_produit DESC";
$stmt_a = $pdo->prepare($sql_articles);
$stmt_a->execute([$id_vendeur_url]);
$mes_articles = $stmt_a->fetchAll();

// 4. RÉCUPÉRER LES NÉGOCIATIONS (Uniquement si c'est MON mur)
$negociations = [];
if (isset($_SESSION['user_id']) && $_SESSION['user_id'] == $id_vendeur_url) {
    $sql_negos = "SELECT N.*, P.nom as nom_produit, U.nom as nom_acheteur, U.prenom as prenom_acheteur 
                  FROM negociations N
                  JOIN Produits P ON N.id_produit = P.id_produit
                  JOIN Utilisateurs U ON N.id_acheteur = U.id_utilisateur
                  WHERE P.id_vendeur = ? AND N.statut_nego = 'en_cours'";
    $stmt_n = $pdo->prepare($sql_negos);
    $stmt_n->execute([$id_vendeur_url]);
    $negociations = $stmt_n->fetchAll();
}

include('header.php');
?>

<div class="vendeur-hero">
    <?php if (!empty($vendeur['image_fond'])): ?>
        <img class="vendeur-banner" src="uploads/<?php echo htmlspecialchars($vendeur['image_fond']); ?>" alt="Bannière">
    <?php else: ?>
        <div style="height:220px;background:linear-gradient(135deg,#0d1117 0%,#374151 100%);"></div>
    <?php endif; ?>

    <div class="container">
        <div class="vendeur-profile-header">
            <div class="vendeur-avatar-container">
                <?php if (!empty($vendeur['photo_profil'])): ?>
                    <img class="vendeur-avatar" src="uploads/<?php echo htmlspecialchars($vendeur['photo_profil']); ?>" alt="Avatar">
                <?php else: ?>
                    <div class="vendeur-avatar" style="background:#e5e7eb;display:flex;align-items:center;justify-content:center;font-size:2rem;font-weight:bold;color:#9ca3af;">
                        <?php echo strtoupper(substr($vendeur['prenom'], 0, 1)); ?>
                    </div>
                <?php endif; ?>
            </div>
            <div class="vendeur-info">
                <h1><?php echo htmlspecialchars($vendeur['prenom'] . ' ' . $vendeur['nom']); ?></h1>
                <p class="text-gris">Vendeur certifié Omnes MarketPlace</p>
            </div>
        </div>
    </div>
</div>

<div class="container page-section">

    <?php if (isset($_SESSION['user_id']) && $_SESSION['user_id'] == $id_vendeur_url && !empty($negociations)): ?>
    <div class="nego-section mb-4">
        <h3 class="mb-2">🤝 Offres de négociation reçues</h3>
        <div class="table-container">
            <table class="panier-table">
                <thead>
                    <tr>
                        <th>Article</th>
                        <th>Acheteur</th>
                        <th>Offre</th>
                        <th>Tour</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($negociations as $n): ?>
                    <tr>
                        <td><strong><?php echo htmlspecialchars($n['nom_produit']); ?></strong></td>
                        <td><?php echo htmlspecialchars($n['prenom_acheteur'] . ' ' . $n['nom_acheteur']); ?></td>
                        <td class="text-or"><strong><?php echo number_format($n['dernier_prix_propose'], 2, ',', ' '); ?> €</strong></td>
                        <td><?php echo $n['compteur_tours']; ?>/5</td>
                        <td>
                            <a href="traiter_nego.php?id=<?php echo $n['id_nego']; ?>&action=accepter" class="btn btn-nav-primary btn-sm">Accepter</a>
                            <a href="traiter_nego.php?id=<?php echo $n['id_nego']; ?>&action=refuser" class="btn btn-danger-soft btn-sm" style="margin-left:5px;">Refuser</a>
                        </td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
    <hr class="separator mb-4">
    <?php endif; ?>

    <div class="d-flex justify-between align-center mb-3">
        <h3>Articles en vente</h3>
        <?php if (isset($_SESSION['user_id']) && $_SESSION['user_id'] == $id_vendeur_url): ?>
            <a href="ajouter_article.php" class="btn btn-primary btn-sm">+ Publier un article</a>
        <?php endif; ?>
    </div>

    <?php if (empty($mes_articles)): ?>
        <div class="empty-state">
            <span class="empty-icon">—</span>
            <p>Aucun article en vente pour le moment.</p>
        </div>
    <?php else: ?>
        <div class="grid-produits">
            <?php foreach ($mes_articles as $item): ?>
                <div class="card-produit"> <a href="article_details.php?id=<?php echo $item['id_produit']; ?>">
                        <img class="card-produit-img" src="uploads/<?php echo htmlspecialchars($item['photo']); ?>" alt="">
                    </a>
                    
                    <div class="card-produit-body">
                        <h3 class="card-produit-title"><?php echo htmlspecialchars($item['nom']); ?></h3>
                        <p class="card-produit-prix"><?php echo number_format($item['prix_initial'], 2, ',', ' '); ?> €</p>
                        
                        <?php if (isset($_SESSION['user_id']) && $_SESSION['user_id'] == $id_vendeur_url): ?>
                            <div class="mt-2">
                                <a href="modifier_article.php?id=<?php echo $item['id_produit']; ?>" 
                                class="btn btn-outline btn-sm btn-full" 
                                style="font-size: 0.75rem; padding: 5px;">
                                ⚙️ Modifier / Photo
                                </a>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

<?php include('footer.php'); ?>