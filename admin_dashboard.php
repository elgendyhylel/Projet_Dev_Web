<?php
session_start();
require_once('db_config.php');

// Sécurité : Seul l'admin peut accéder à cette page
if (!isset($_SESSION['type']) || $_SESSION['type'] !== 'admin') {
    header("Location: login.php");
    exit();
}

$page_title = 'Tableau de bord Admin';
include('header.php');

// 1. Récupération de tous les utilisateurs
$users = $pdo->query("SELECT * FROM Utilisateurs ORDER BY type_compte ASC")->fetchAll();

// 2. Récupération de tous les produits (avec le nom du vendeur)
$sql_prod = "SELECT P.*, U.nom as nom_vendeur 
             FROM Produits P 
             JOIN Utilisateurs U ON P.id_vendeur = U.id_utilisateur 
             ORDER BY P.statut ASC, P.id_produit DESC";
$products = $pdo->query($sql_prod)->fetchAll();

// 3. Logique de suppression (si on clique sur un bouton supprimer)
if (isset($_GET['delete_user'])) {
    $id = (int)$_GET['delete_user'];
    $pdo->prepare("DELETE FROM Utilisateurs WHERE id_utilisateur = ?")->execute([$id]);
    header("Location: admin_dashboard.php");
    exit();
}

if (isset($_GET['delete_prod'])) {
    $id = (int)$_GET['delete_prod'];
    $pdo->prepare("DELETE FROM Produits WHERE id_produit = ?")->execute([$id]);
    header("Location: admin_dashboard.php");
    exit();
}
?>

<div class="container page-section">
    <div class="page-header">
        <h1>Console d'administration</h1>
        <p class="text-gris">Gestion des utilisateurs et du catalogue Omnes MarketPlace</p>
    </div>

    <section class="mb-5">
        <h2 class="mb-3">👤 Utilisateurs inscrits</h2>
        <table class="panier-table">
            <thead>
                <tr>
                    <th>Nom / Prénom</th>
                    <th>Email</th>
                    <th>Rôle</th>
                    <th>Ville</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($users as $u): ?>
                <tr>
                    <td><strong><?php echo htmlspecialchars($u['nom'] . ' ' . $u['prenom']); ?></strong></td>
                    <td><?php echo htmlspecialchars($u['email']); ?></td>
                    <td>
                        <span class="badge-vente <?php echo ($u['type_compte'] == 'admin') ? 'badge-enchere' : 'badge-immediat'; ?>">
                            <?php echo ucfirst($u['type_compte']); ?>
                        </span>
                    </td>
                    <td><?php echo htmlspecialchars($u['ville']); ?></td>
                    <td>
                        <?php if ($u['id_utilisateur'] != $_SESSION['user_id']): ?>
                            <a href="admin_dashboard.php?delete_user=<?php echo $u['id_utilisateur']; ?>" 
                               class="btn btn-danger-soft btn-sm" 
                               onclick="return confirm('Supprimer cet utilisateur ?');">Supprimer</a>
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </section>

    <hr class="separator mb-5">

    <section>
        <h2 class="mb-3">📦 Gestion du catalogue</h2>
        <div class="grid-produits">
            <?php foreach ($products as $p): ?>
            <div class="card-produit">
                <img class="card-produit-img" src="uploads/<?php echo htmlspecialchars($p['photo']); ?>" alt="">
                <div class="card-produit-body">
                    <p class="card-produit-meta"><?php echo ucfirst($p['categorie']); ?> &bull; Vendu par <?php echo htmlspecialchars($p['nom_vendeur']); ?></p>
                    <h3 class="card-produit-title"><?php echo htmlspecialchars($p['nom']); ?></h3>
                    
                    <div class="d-flex justify-between align-center mt-2">
                        <span class="card-produit-prix"><?php echo number_format($p['prix_initial'], 2, ',', ' '); ?> €</span>
                        <span class="badge-vente <?php echo ($p['statut'] == 'vendu') ? 'badge-negociation' : 'badge-immediat'; ?>">
                            <?php echo ($p['statut'] == 'vendu') ? 'Vendu' : 'En vente'; ?>
                        </span>
                    </div>

                    <div class="mt-3">
                        <a href="admin_dashboard.php?delete_prod=<?php echo $p['id_produit']; ?>" 
                           class="btn btn-danger-soft btn-full" 
                           onclick="return confirm('Supprimer cet article ?');">Retirer de la vente</a>
                    </div>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </section>
</div>

<?php include('footer.php'); ?>