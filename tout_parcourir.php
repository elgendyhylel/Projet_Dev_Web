<?php
session_start();
require_once('db_config.php');

// 1. Récupération du filtre depuis l'URL
$filtre_type = $_GET['type'] ?? '';

// 2. Requête SQL dynamique
if ($filtre_type != '') {
    $query = 'SELECT * FROM Produits WHERE statut = "en_vente" AND type_vente = ? ORDER BY id_produit DESC';
    $stmt = $pdo->prepare($query);
    $stmt->execute([$filtre_type]);
} else {
    $query = 'SELECT * FROM Produits WHERE statut = "en_vente" ORDER BY id_produit DESC';
    $stmt = $pdo->prepare($query);
    $stmt->execute();
}

$articles = $stmt->fetchAll();

$page_title = 'Catalogue';
include('header.php');
?>

<div class="container">
    <div class="page-header">
        <h1>Catalogue des articles</h1>
        <p class="text-gris mt-1"><?php echo count($articles); ?> articles disponibles</p>
    </div>

    <?php if (empty($articles)): ?>
        <div class="empty-state">
            <span class="empty-icon">—</span>
            <p>Aucun article trouvé pour le moment.</p>
        </div>
    <?php else: ?>
        <div class="grid-produits">
            <?php foreach ($articles as $item): 
                // --- LOGIQUE DE BADGE ROBUSTE ---
                $type_raw = strtolower($item['type_vente']);
                
                if (strpos($type_raw, 'imm') !== false) {
                    $badge_texte = "Achat immédiat";
                    $badge_classe = "badge-immediat";
                } elseif (strpos($type_raw, 'ench') !== false) {
                    $badge_texte = "Enchère";
                    $badge_classe = "badge-enchere";
                } else {
                    // Par défaut, traite tout le reste (nego, négociation, etc.) comme Négociation
                    $badge_texte = "Négociation";
                    $badge_classe = "badge-negociation";
                }
                
                // --- VÉRIFICATION IMAGE ---
                $image_path = "uploads/" . $item['photo'];
                // Si l'image n'existe pas physiquement, on met l'image par défaut
                if (empty($item['photo']) || !file_exists($image_path)) {
                    $image_path = "uploads/default_article.jpg";
                }
            ?>
            <a href="article_details.php?id=<?php echo $item['id_produit']; ?>" class="card-produit" style="text-decoration:none;">
                <img class="card-produit-img" 
                     src="<?php echo $image_path; ?>" 
                     alt="<?php echo htmlspecialchars($item['nom']); ?>">
                
                <div class="card-produit-body">
                    <p class="card-produit-meta"><?php echo ucfirst(str_replace('_', ' ', $item['categorie'])); ?></p>
                    <h3 class="card-produit-title"><?php echo htmlspecialchars($item['nom']); ?></h3>
                    
                    <div style="margin-bottom: 8px;">
                        <span class="badge-vente <?php echo $badge_classe; ?>">
                            <?php echo $badge_texte; ?>
                        </span>
                    </div>

                    <p class="card-produit-prix"><?php echo number_format($item['prix_initial'], 2, ',', ' '); ?> €</p>
                </div>
            </a>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

<?php include('footer.php'); ?>