<?php
$page_title = 'Accueil';
include('header.php');
?>

<section class="hero">
    <div class="container">
        <h1>Bienvenue sur Omnes MarketPlace</h1>
        <p>Achetez, vendez et enchérissez sur des articles rares, haut de gamme et réguliers au sein de la communauté Omnes.</p>
        <a href="tout_parcourir.php" class="btn btn-or btn-lg">Découvrir les articles</a>
    </div>
</section>

<div class="container">
    <div class="features-grid">
        <a href="tout_parcourir.php?type=immediat" class="feature-card" style="text-decoration:none;">
            <span class="feature-icon">—</span>
            <h3>Achat immédiat</h3>
            <p>Trouvez l'article qui vous plaît et achetez-le directement au prix affiché, sans attendre.</p>
        </a>

        <a href="tout_parcourir.php?type=enchere" class="feature-card" style="text-decoration:none;">
            <span class="feature-icon">—</span>
            <h3>Enchères</h3>
            <p>Participez à des enchères sur des objets rares. Fixez votre prix maximum et laissez la plateforme enchérir pour vous.</p>
        </a>

        <a href="tout_parcourir.php?type=negociation" class="feature-card" style="text-decoration:none;">
            <span class="feature-icon">—</span>
            <h3>Négociation</h3>
            <p>Négociez directement avec le vendeur en jusqu'à 5 échanges pour trouver le meilleur prix.</p>
        </a>
    </div>

    <div class="page-section text-center">
        <h2 class="mb-2">Prêt à commencer ?</h2>
        <p class="text-gris mb-3">Des centaines d'articles vous attendent sur Omnes MarketPlace.</p>
        <a href="tout_parcourir.php" class="btn btn-primary btn-lg">Voir tous les articles</a>
    </div>
</div>

<?php include('footer.php'); ?>