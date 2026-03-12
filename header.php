<?php
// Démarrage de session si nécessaire
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
$page_title = isset($page_title) ? $page_title . ' — Omnes MarketPlace' : 'Omnes MarketPlace';
$panier_count = isset($_SESSION['panier']) ? count($_SESSION['panier']) : 0;
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($page_title); ?></title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="navbar-omnes">
    <div class="container">
        <a class="navbar-brand" href="index.php">Omnes MarketPlace</a>
        <button class="navbar-toggle" onclick="document.getElementById('nav-menu').classList.toggle('open');" aria-label="Menu">&#9776;</button>
        
        <ul class="navbar-nav" id="nav-menu">
            <li>
                <a class="nav-link <?php echo basename($_SERVER['PHP_SELF']) === 'tout_parcourir.php' ? 'active' : ''; ?>"
                   href="tout_parcourir.php">Tout parcourir</a>
            </li>

            <?php if (isset($_SESSION['user_id'])): ?>
                <li>
                    <a class="nav-link <?php echo basename($_SERVER['PHP_SELF']) === 'mes_offres.php' ? 'active' : ''; ?>" 
                       href="mes_offres.php">Mes Offres</a>
                </li>

                <li>
                    <a class="nav-link <?php echo basename($_SERVER['PHP_SELF']) === 'panier.php' ? 'active' : ''; ?>" href="panier.php">
                        Panier<?php if ($panier_count > 0): ?><span class="nav-badge"><?php echo $panier_count; ?></span><?php endif; ?>
                    </a>
                </li>

                <?php 
                // Liens réservés aux Vendeurs et Admins
                if (isset($_SESSION['type']) && ($_SESSION['type'] === 'vendeur' || $_SESSION['type'] === 'admin')): 
                ?>
                    <li><a class="nav-link nav-link-vendeur" href="vendeur_mur.php?id=<?php echo $_SESSION['user_id']; ?>">Mon mur</a></li>
                    <li><a class="nav-link nav-link-vendeur" href="ajouter_article.php">Vendre</a></li>
                <?php endif; ?>

                <li><span class="nav-link user-name" style="color:var(--or); font-weight:bold; cursor:default;"><?php echo htmlspecialchars($_SESSION['nom']); ?></span></li>
                <li><a class="nav-link nav-link-danger" href="logout.php">Déconnexion</a></li>
            
            <?php else: ?>
                <li><a class="nav-link" href="login.php">Connexion</a></li>
                <li><a class="btn btn-nav-primary" href="inscription.php">S'inscrire</a></li>
            <?php endif; ?>
        </ul>
    </div>
</nav>

<main>