<?php
require_once('db_config.php');
$page_title = 'Inscription';
$succes = false;
$erreur = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nom        = $_POST['nom'] ?? '';
    $prenom     = $_POST['prenom'] ?? '';
    $email      = $_POST['email'] ?? '';
    $password   = password_hash($_POST['password'], PASSWORD_DEFAULT);
    $type_compte = $_POST['type_compte'] ?? 'acheteur'; // On récupère le choix du rôle
    $adresse1   = $_POST['adresse1'] ?? '';
    $ville      = $_POST['ville'] ?? '';
    $cp         = $_POST['cp'] ?? '';
    $pays       = $_POST['pays'] ?? '';
    $tel        = $_POST['tel'] ?? '';
    $type_carte = $_POST['type_carte'] ?? '';
    $num_carte  = $_POST['num_carte'] ?? '';
    $nom_carte  = $_POST['nom_carte'] ?? '';
    $exp_carte  = $_POST['exp_carte'] ?? '';
    $code_secu  = $_POST['code_secu'] ?? '';

    try {
        $pdo->beginTransaction(); // Sécurisation de l'opération

        // 1. Insertion de l'utilisateur avec le type choisi
        $sql_user = "INSERT INTO Utilisateurs (nom, prenom, email, mot_de_passe, type_compte, adresse_ligne1, ville, code_postal, pays, telephone)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $pdo->prepare($sql_user);
        $stmt->execute([$nom, $prenom, $email, $password, $type_compte, $adresse1, $ville, $cp, $pays, $tel]);
        $id_user = $pdo->lastInsertId();

        // 2. Insertion des infos de paiement
        $sql_pay = "INSERT INTO Paiements (id_utilisateur, type_carte, numero_carte, nom_carte, date_expiration, code_securite)
                    VALUES (?, ?, ?, ?, ?, ?)";
        $stmt_pay = $pdo->prepare($sql_pay);
        $stmt_pay->execute([$id_user, $type_carte, $num_carte, $nom_carte, $exp_carte, $code_secu]);

        // 3. Si c'est un VENDEUR, on crée son profil dans la table Vendeurs
        if ($type_compte === 'vendeur') {
            $sql_vendeur = "INSERT INTO Vendeurs (id_utilisateur, pseudo, photo_profil, image_fond) 
                            VALUES (?, ?, 'default_profil.png', 'default_fond.jpg')";
            $stmt_v = $pdo->prepare($sql_vendeur);
            // On utilise le prénom comme pseudo par défaut
            $stmt_v->execute([$id_user, $prenom]);
        }

        $pdo->commit(); // Validation finale
        $succes = true;
    } catch (Exception $e) {
        $pdo->rollBack(); // Annulation en cas d'erreur
        $erreur = "Erreur lors de l'inscription : " . $e->getMessage();
    }
}

include('header.php');
?>

<div class="container page-section">
    <div class="form-section-wide">

        <?php if ($succes): ?>
            <div class="alert alert-success">
                Compte créé avec succès ! <a href="login.php" style="font-weight:500;">Connectez-vous ici</a>
            </div>
        <?php else: ?>

        <h2 class="form-title">Créer un compte</h2>
        <p class="form-subtitle">Rejoignez Omnes MarketPlace gratuitement</p>

        <?php if ($erreur): ?>
            <div class="alert alert-error"><?php echo htmlspecialchars($erreur); ?></div>
        <?php endif; ?>

        <form method="POST">
            <p class="form-section-title">Type de compte</p>
            <div class="form-group">
                <label class="form-label">Je souhaite m'inscrire en tant que :</label>
                <select class="form-control" name="type_compte" required>
                    <option value="acheteur">Acheteur (pour faire des offres et enchérir)</option>
                    <option value="vendeur">Vendeur (pour proposer des articles)</option>
                </select>
            </div>
            <hr class="form-divider">

            <p class="form-section-title">Identité &amp; livraison</p>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Nom</label>
                    <input class="form-control" type="text" name="nom" placeholder="Dupont" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Prénom</label>
                    <input class="form-control" type="text" name="prenom" placeholder="Jean" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Email (identifiant)</label>
                <input class="form-control" type="email" name="email" placeholder="votre@email.com" required>
            </div>

            <div class="form-group">
                <label class="form-label">Mot de passe</label>
                <input class="form-control" type="password" name="password" placeholder="••••••••" required>
            </div>

            <div class="form-group">
                <label class="form-label">Adresse</label>
                <input class="form-control" type="text" name="adresse1" placeholder="12 rue de la Paix" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Ville</label>
                    <input class="form-control" type="text" name="ville" placeholder="Paris" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Code postal</label>
                    <input class="form-control" type="text" name="cp" placeholder="75001" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Pays</label>
                    <input class="form-control" type="text" name="pays" placeholder="France" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Téléphone</label>
                    <input class="form-control" type="text" name="tel" placeholder="+33 6 00 00 00 00" required>
                </div>
            </div>

            <hr class="form-divider">
            <p class="form-section-title">Informations de paiement</p>

            <div class="form-group">
                <label class="form-label">Type de carte</label>
                <select class="form-control" name="type_carte">
                    <option value="Visa">Visa</option>
                    <option value="MasterCard">MasterCard</option>
                    <option value="American Express">American Express</option>
                    <option value="PayPal">PayPal</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Numéro de carte</label>
                <input class="form-control" type="text" name="num_carte" placeholder="0000 0000 0000 0000" required>
            </div>

            <div class="form-group">
                <label class="form-label">Nom sur la carte</label>
                <input class="form-control" type="text" name="nom_carte" placeholder="JEAN DUPONT" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Date d'expiration</label>
                    <input class="form-control" type="text" name="exp_carte" placeholder="MM/AAAA" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Code CVV</label>
                    <input class="form-control" type="text" name="code_secu" placeholder="123" maxlength="4" required>
                </div>
            </div>

            <hr class="form-divider">

            <div class="form-checkbox">
                <input type="checkbox" id="clause" required>
                <label for="clause">J'accepte la clause légale : toute offre acceptée par un vendeur m'engage contractuellement à finaliser l'achat.</label>
            </div>

            <button type="submit" class="btn btn-primary btn-full">Créer mon compte</button>
        </form>

        <p class="form-link mt-2">Déjà inscrit ? <a href="login.php">Se connecter</a></p>

        <?php endif; ?>
    </div>
</div>

<?php include('footer.php'); ?>