<?php
session_start();
require_once('db_config.php');

// Sécurité : Seul un vendeur ou un admin peut ajouter un article
// On vérifie 'type' car c'est ce que tu as défini dans ton login.php
if (!isset($_SESSION['type']) || ($_SESSION['type'] !== 'vendeur' && $_SESSION['type'] !== 'admin')) {
    header("Location: login.php");
    exit();
}

$succes = false;
$erreur = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nom         = $_POST['nom'] ?? '';
    $description = $_POST['description'] ?? '';
    $prix        = $_POST['prix'] ?? '';
    $categorie   = $_POST['categorie'] ?? '';
    $type_vente  = $_POST['type_vente'] ?? '';
    $id_vendeur  = $_SESSION['user_id'];

    // Gestion de l'upload de la photo
    $photo_name = $_FILES['photo']['name'] ?? '';
    $photo_bdd  = "";

    if ($photo_name) {
        // Sécurité : on ajoute un timestamp au nom du fichier pour éviter les doublons
        $extension = pathinfo($photo_name, PATHINFO_EXTENSION);
        $photo_bdd = time() . "_" . bin2hex(random_bytes(4)) . "." . $extension;
        
        if (!is_dir('uploads')) {
            mkdir('uploads', 0777, true);
        }
        move_uploaded_file($_FILES['photo']['tmp_name'], "uploads/" . $photo_bdd);
    }

    try {
        // Correction : table 'Produits' et colonne 'prix_initial'
        $sql = "INSERT INTO Produits (nom, description, photo, prix_initial, categorie, type_vente, id_vendeur, statut)
                VALUES (?, ?, ?, ?, ?, ?, ?, 'en_vente')";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$nom, $description, $photo_bdd, $prix, $categorie, $type_vente, $id_vendeur]);
        $succes = true;
    } catch (Exception $e) {
        $erreur = "Erreur BDD : " . $e->getMessage();
    }
}

$page_title = 'Publier un article';
include('header.php');
?>

<div class="container page-section">
    <div class="form-section-wide">
        <h2 class="form-title">Mettre un article en vente</h2>
        <p class="form-subtitle">Remplissez les informations de votre annonce de prestige</p>

        <?php if ($succes): ?>
            <div class="alert alert-success">
                ✨ Article publié avec succès ! 
                <a href="tout_parcourir.php" style="font-weight:600; text-decoration:underline; margin-left:10px;">Voir le catalogue</a>
            </div>
        <?php endif; ?>

        <?php if ($erreur): ?>
            <div class="alert alert-error"><?php echo htmlspecialchars($erreur); ?></div>
        <?php endif; ?>

        <form method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label class="form-label">Nom de l'article</label>
                <input class="form-control" type="text" name="nom" placeholder="ex : Montre vintage Omega" required>
            </div>

            <div class="form-group">
                <label class="form-label">Description (qualité, défauts...)</label>
                <textarea class="form-control" name="description" rows="4" placeholder="Décrivez l'état, les caractéristiques..." required></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Prix de départ (€)</label>
                    <input class="form-control" type="number" step="0.01" name="prix" placeholder="0,00" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Catégorie</label>
                    <select class="form-control" name="categorie">
                        <option value="rare">Articles rares</option>
                        <option value="haut_de_gamme">Haut de gamme</option>
                        <option value="regulier">Articles réguliers</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Type de vente</label>
                <select class="form-control" name="type_vente">
                    <option value="immediat">Achat immédiat</option>
                    <option value="negociation">Négociation client–vendeur</option>
                    <option value="enchere">Enchères (meilleure offre)</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Photo de l'article</label>
                <input class="form-control" type="file" name="photo" accept="image/*" required>
            </div>

            <button type="submit" class="btn btn-primary btn-full mt-2">Publier l'annonce</button>
        </form>
    </div>
</div>

<?php include('footer.php'); ?>