<?php
session_start();
require_once('db_config.php');

// 1. Sécurité : Vérifier que l'utilisateur est un vendeur connecté
if (!isset($_SESSION['user_id']) || $_SESSION['type'] !== 'vendeur') {
    header("Location: login.php");
    exit();
}

$id_article = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$user_id = $_SESSION['user_id'];

// 2. Récupérer les infos actuelles du produit (et vérifier qu'il appartient bien au vendeur)
$stmt = $pdo->prepare("SELECT * FROM Produits WHERE id_produit = ? AND id_vendeur = ?");
$stmt->execute([$id_article, $user_id]);
$produit = $stmt->fetch();

if (!$produit) {
    die("Article introuvable ou vous n'avez pas l'autorisation de le modifier.");
}

$erreur = "";
$succes = "";

// 3. Traitement du formulaire de modification
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nom = $_POST['nom'];
    $prix = (float)$_POST['prix'];
    $description = $_POST['description'];
    $photo_nom = $produit['photo']; // Par défaut, on garde l'ancienne photo

    // Gestion de la nouvelle photo (si téléchargée)
    if (!empty($_FILES['nouvelle_photo']['name'])) {
        $target_dir = "uploads/";
        $file_name = time() . "_" . basename($_FILES["nouvelle_photo"]["name"]);
        $target_file = $target_dir . $file_name;
        
        if (move_uploaded_file($_FILES["nouvelle_photo"]["tmp_name"], $target_file)) {
            $photo_nom = $file_name;
        } else {
            $erreur = "Erreur lors du téléchargement de l'image.";
        }
    }

    if (empty($erreur)) {
        $update = $pdo->prepare("UPDATE Produits SET nom = ?, prix_initial = ?, description = ?, photo = ? WHERE id_produit = ?");
        if ($update->execute([$nom, $prix, $description, $photo_nom, $id_article])) {
            $succes = "L'article a été mis à jour avec succès !";
            // Actualiser les données locales pour l'affichage
            $produit['nom'] = $nom;
            $produit['prix_initial'] = $prix;
            $produit['description'] = $description;
            $produit['photo'] = $photo_nom;
        }
    }
}

$page_title = "Modifier l'article";
include('header.php');
?>

<div class="container page-section">
    <div class="form-section-wide">
        <a href="vendeur_mur.php" class="back-link">&#8592; Retour au mur</a>
        <h2 class="form-title mt-2">Modifier mon article</h2>
        <p class="form-subtitle">Mettez à jour les informations de votre produit</p>

        <?php if ($erreur): ?>
            <div class="alert alert-error"><?php echo $erreur; ?></div>
        <?php endif; ?>
        <?php if ($succes): ?>
            <div class="alert alert-success"><?php echo $succes; ?></div>
        <?php endif; ?>

        <form method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label class="form-label">Nom de l'article</label>
                <input type="text" name="nom" class="form-control" value="<?php echo htmlspecialchars($produit['nom']); ?>" required>
            </div>

            <div class="form-group">
                <label class="form-label">Prix (€)</label>
                <input type="number" step="0.01" name="prix" class="form-control" value="<?php echo $produit['prix_initial']; ?>" required>
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control"><?php echo htmlspecialchars($produit['description']); ?></textarea>
            </div>

            <div class="form-group">
                <label class="form-label">Photo actuelle</label>
                <img src="uploads/<?php echo $produit['photo']; ?>" style="width: 120px; border-radius: 8px; margin-bottom: 10px; display: block;">
                <label class="form-label" style="font-size: 0.7rem; color: var(--or);">Remplacer la photo :</label>
                <input type="file" name="nouvelle_photo" class="form-control">
            </div>

            <button type="submit" class="btn btn-primary btn-full">Enregistrer les modifications</button>
        </form>
    </div>
</div>

<?php include('footer.php'); ?>