<?php 
session_start(); 
if(!isset($_SESSION['jeton'])) {
	$_SESSION['jeton'] = bin2hex(openssl_random_pseudo_bytes(6));
}
echo "jeton = " . $_SESSION['jeton']; //temporaire
?>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSRF - Mise en situation</title>
</head>
<body>
<center>

Voici une commande disponible pour l'administrateur:</br>
<form method="get" name="frmban" onsubmit="return confirm('voulez-vous continuer ?');">
	<input type="hidden" name="nom" value="toto"/></br>
	<input type="submit" name="submitb" value="Bannir Toto" />
<input type="hidden" name="jeton" value="<?php echo htmlspecialchars($_SESSION['jeton']); ?>"/>
</form></br>

Et voici la liste des membres fictifs : 
<ul>
  <?php 

if(isset($_GET['submitb']) and isset($_GET['nom']) and ($_GET['nom']=='toto') and isset($_GET['jeton']) and ($_GET['jeton'] == $_SESSION['jeton'])) {
          echo "<font color='red'>Toto a été banni.</font>";
        } else echo "<li>Toto</li><li>Titi</li><li>NomInnovant</li>"; ?>
              
</ul>
</br>

</center>
</body>
</html>
