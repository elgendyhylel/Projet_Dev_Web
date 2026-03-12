<?php
session_start();
require_once('db_config.php');

// 1. Récupération et sécurisation de l'ID
if (isset($_GET['id']) && is_numeric($_GET['id'])) {
    $id_article = (int)$_GET['id'];
    
    $sql  = "SELECT * FROM Produits WHERE id_produit = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$id_article]);
    $item = $stmt->fetch();
    
    if (!$item) { 
        header("Location: tout_parcourir.php"); 
        exit(); 
    }
} else {
    header("Location: tout_parcourir.php"); 
    exit();
}

// --- LOGIQUE DE BADGE ROBUSTE ---
$type_raw = strtolower($item['type_vente']);
if (strpos($type_raw, 'imm') !== false) {
    $badge_texte = "Achat immédiat";
    $badge_classe = "badge-immediat";
} elseif (strpos($type_raw, 'ench') !== false) {
    $badge_texte = "Enchère";
    $badge_classe = "badge-enchere";
} else {
    $badge_texte = "Négociation";
    $badge_classe = "badge-negociation";
}

// --- VÉRIFICATION IMAGE ---
$image_path = "uploads/" . $item['photo'];
if (empty($item['photo']) || !file_exists($image_path)) {
    $image_path = "uploads/default_article.jpg";
}

$page_title = htmlspecialchars($item['nom']);
include('header.php');
?>

<div class="container">
    <a href="tout_parcourir.php" class="back-link mt-3" style="display:inline-flex;margin-top:1.5rem; text-decoration:none; color:var(--or);">
        &#8592; Retour au catalogue
    </a>

    <?php if (isset($_GET['success'])): ?>
        <div class="alert alert-success" style="margin-top:20px;">Action effectuée avec succès !</div>
    <?php endif; ?>

    <?php if (isset($_GET['error']) && $_GET['error'] == 'low_bid'): ?>
        <div class="alert alert-error" style="margin-top:20px;">Votre mise doit être supérieure au prix actuel.</div>
    <?php endif; ?>

    <div class="article-detail" style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-top: 20px;">

        <div class="image-container">
            <img class="article-img" 
                 src="<?php echo $image_path; ?>" 
                 alt="<?php echo htmlspecialchars($item['nom']); ?>"
                 style="width: 100%; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
        </div>

        <div class="info-container">
            <p class="article-categorie" style="color: var(--or); font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px;">
                <?php echo ucfirst(str_replace('_', ' ', $item['categorie'])); ?>
            </p>
            
            <h1 style="font-family: 'Cormorant Garamond', serif; font-size: 2.5rem; margin-bottom: 10px;">
                <?php echo htmlspecialchars($item['nom']); ?>
            </h1>

            <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 25px;">
                <span class="article-prix-badge" style="font-size: 1.5rem; font-weight: 700; color: var(--gris-fonce);">
                    <?php echo number_format($item['prix_initial'], 2, ',', ' '); ?> €
                </span>
                <span class="badge-vente <?php echo $badge_classe; ?>" style="padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">
                    <?php echo $badge_texte; ?>
                </span>
            </div>

            <div class="article-description" style="line-height: 1.6; color: var(--gris-fonce); margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #eee;">
                <p><?php echo nl2br(htmlspecialchars($item['description'])); ?></p>
            </div>

            <div class="achat-box" style="background: #f9f9f9; padding: 25px; border-radius: 12px;">

                <?php if (strpos($type_raw, 'imm') !== false): ?>
                    <p style="font-weight: 600; margin-bottom: 15px;">🛍️ Achat immédiat</p>
                    <?php if (isset($_SESSION['user_id'])): ?>
                        <form action="ajouter_panier.php" method="POST">
                            <input type="hidden" name="id_article" value="<?php echo $item['id_produit']; ?>">
                            <button type="submit" class="btn btn-primary btn-full" style="width: 100%;">Ajouter au panier</button>
                        </form>
                    <?php else: ?>
                        <a href="login.php" class="btn btn-outline btn-full" style="display: block; text-align: center;">Connectez-vous pour acheter</a>
                    <?php endif; ?>

                <?php elseif (strpos($type_raw, 'ench') !== false): ?>
                    <p style="font-weight: 600; margin-bottom: 15px;">🔨 Vente aux enchères</p>
                    <?php if (isset($_SESSION['user_id'])): ?>
                        <form action="miser.php" method="POST">
                            <input type="hidden" name="id_produit" value="<?php echo $item['id_produit']; ?>">
                            <div class="form-group" style="margin-bottom: 15px;">
                                <label class="form-label">Votre mise (€)</label>
                                <input class="form-control" type="number" name="mise" min="<?php echo $item['prix_initial'] + 0.01; ?>" step="0.01" required>
                            </div>
                            <button type="submit" class="btn btn-or btn-full" style="width: 100%;">Enchérir</button>
                        </form>
                    <?php else: ?>
                        <a href="login.php" class="btn btn-outline btn-full" style="display: block; text-align: center;">Connectez-vous pour enchérir</a>
                    <?php endif; ?>

                <?php else: ?>
                    <p style="font-weight: 600; margin-bottom: 15px;">🤝 Négociation directe</p>
                    <?php if (isset($_SESSION['user_id'])): ?>
                        <form action="negocier.php" method="POST">
                            <input type="hidden" name="id_produit" value="<?php echo $item['id_produit']; ?>">
                            <div class="form-group" style="margin-bottom: 15px;">
                                <label class="form-label">Votre proposition (€)</label>
                                <input class="form-control" type="number" name="offre" step="0.01" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-full" style="width: 100%;">Envoyer l'offre</button>
                        </form>
                    <?php else: ?>
                        <a href="login.php" class="btn btn-outline btn-full" style="display: block; text-align: center;">Connectez-vous pour négocier</a>
                    <?php endif; ?>
                <?php endif; ?>

            </div>
        </div>
    </div>
</div>

<?php include('footer.php'); ?>