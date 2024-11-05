# LibASM

Ce projet consiste en une bibliothèque de fonctions basiques écrites en assembleur x86_64 (Intel syntax).

📚 **Table des matières**
- [Introduction à l'Assembleur](#introduction-à-lassembleur)
- [Registres et Conventions](#registres-et-conventions)
- [Instructions Basiques](#instructions-basiques)
- [Fonctions Obligatoires](#fonctions-obligatoires)
- [Fonctions Bonus](#fonctions-bonus)
- [Compilation et Utilisation](#compilation-et-utilisation)

---

## Introduction à l'Assembleur
L'assembleur est un langage de programmation de bas niveau qui permet une communication directe avec le processeur. Chaque instruction assembleur correspond généralement à une instruction machine spécifique.

### Pourquoi l'Assembleur ?
- Performance optimale et contrôle précis du matériel
- Compréhension approfondie de l'architecture machine
- Manipulation directe de la mémoire
- Optimisation des ressources système

---

## Registres et Conventions

### Registres généraux 64 bits
- **rax** : Registre accumulateur, utilisé pour les valeurs de retour
- **rbx** : Base register (préservé)
- **rcx** : Counter register, utilisé pour les compteurs
- **rdx** : Data register, utilisé pour les données
- **rsi** : Source Index, utilisé pour les opérations sur les chaînes
- **rdi** : Destination Index, utilisé pour les opérations sur les chaînes
- **r8-r15** : Registres à usage général

### Convention d'appel System V AMD64 ABI
- **Ordre des paramètres des fonctions** : rdi, rsi, rdx, rcx, r8, r9
- **Registres caller-saved** (peuvent être modifiés) : rax, rdi, rsi, rdx, rcx, r8-r11
- **Registres callee-saved** (doivent être préservés) : rbx, rbp, r12-r15

---

## Instructions Basiques

### Manipulation des données
- **MOV** : Copie des données entre registres ou mémoire
- **LEA** : Charge une adresse effective
- **PUSH/POP** : Manipulation de la pile

### Opérations arithmétiques
- **ADD/SUB** : Addition et soustraction
- **INC/DEC** : Incrémentation et décrémentation
- **MUL/DIV** : Multiplication et division
- **NEG** : Négation

### Contrôle de flux
- **CMP** : Comparaison de valeurs
- **Instructions de saut** (JMP, JE, JNE, JL, JG)
- **CALL/RET** : Appel et retour de fonction
- Gestion des labels et des boucles

---

## Fonctions Obligatoires

### Fonction `ft_strlen`

La fonction `ft_strlen` calcule la longueur d'une chaîne de caractères en comptant le nombre d'octets jusqu'au caractère nul (`\0`) de fin de chaîne. Elle retourne la longueur de la chaîne (nombre de caractères sans le `\0` final).

#### Explication étape par étape :

1. **Initialisation du compteur** :
   - `rax` est mis à zéro pour servir de compteur, qui représentera la longueur de la chaîne.

2. **Boucle de comptage** :
   - **Vérification du caractère** : À chaque itération, l'octet situé à l'adresse `[rdi + rax]` est comparé à `0` (caractère nul).
     - Si un caractère nul est trouvé, la boucle se termine et passe à `.return`.
   - **Incrémentation** : Si le caractère n'est pas nul, le compteur `rax` est incrémenté pour passer au caractère suivant.
   - **Itération** : La boucle continue tant qu'aucun caractère nul n'est rencontré.

3. **Retour** :
   - La fonction retourne la valeur de `rax`, qui contient le nombre total de caractères dans la chaîne.

Cette fonction implémente un comptage simple en boucle, s'arrêtant dès que le caractère nul de fin de chaîne est rencontré.

### Fonction `ft_strcpy`

La fonction `ft_strcpy` copie une chaîne de caractères source dans une chaîne de destination, caractère par caractère, jusqu'à atteindre le caractère nul (`\0`) de fin de chaîne. Elle retourne l'adresse de la chaîne de destination.

#### Explication étape par étape :

1. **Préparation** :
   - L'adresse de la destination (`rdi`) est sauvegardée sur la pile pour être restaurée plus tard comme valeur de retour.
   - Le registre `rcx` est mis à zéro ; il sera utilisé comme stockage temporaire pour chaque caractère.

2. **Boucle de copie** :
   - **Chargement** : Un octet (caractère) est chargé depuis l'adresse source `rsi` et stocké dans `cl` (partie basse de `rcx`).
   - **Stockage** : Ce caractère est copié de `cl` vers l'adresse courante de destination `rdi`.
   - **Vérification de la fin de chaîne** : Si le caractère est nul (`\0`), la fonction passe à `.return` pour terminer la copie.
   - **Incrémentation** : Si le caractère n'est pas nul, les pointeurs `rdi` et `rsi` avancent vers le prochain caractère dans la chaîne source et destination.
   - **Itération** : La boucle continue jusqu'à rencontrer le caractère nul.

3. **Retour** :
   - La fonction restaure l'adresse initiale de la destination en la récupérant depuis la pile et la retourne via `rax` pour indiquer l'adresse de la chaîne de destination.

Cette fonction effectue une copie simple et directe de chaque caractère, garantissant que la chaîne copiée est terminée par un caractère nul dans la destination.

### Fonction `ft_strcmp`

La fonction `ft_strcmp` compare deux chaînes de caractères octet par octet pour déterminer si elles sont identiques. Elle retourne un nombre entier indiquant le résultat de la comparaison :

- `0` si les chaînes sont identiques,
- un nombre positif ou négatif correspondant à la différence entre les premiers caractères différents sinon.

#### Explication étape par étape :

1. **Préparation des registres** :
   - `rbx` est sauvegardé sur la pile, car il sera utilisé temporairement dans la fonction.
   - `rax` et `rbx` sont mis à zéro, car `rax` sera utilisé pour accumuler la valeur de retour.

2. **Boucle de comparaison** :
   - **Chargement des caractères** : Les octets des deux chaînes sont chargés un par un à partir des adresses `rdi` (première chaîne) et `rsi` (deuxième chaîne).
   - **Comparaison** : Les caractères actuels (octets) de chaque chaîne sont comparés.
     - Si les caractères diffèrent, la fonction passe à la partie de code `.not_equal`.
     - Si un caractère nul (`\0`) est trouvé dans les deux chaînes, cela indique la fin des chaînes et qu'elles sont identiques, donc la fonction passe à `.equal`.
   - **Incrémentation des pointeurs** : Si les caractères sont identiques et non nuls, les pointeurs `rdi` et `rsi` avancent pour comparer les caractères suivants.

3. **Cas de non-égalité** :
   - Si une différence est trouvée, la fonction calcule la différence en soustrayant les caractères et place le résultat dans `rax` avant de restaurer `rbx` et de retourner la valeur.

4. **Cas d'égalité** :
   - Si les deux chaînes sont identiques jusqu'au caractère nul, la fonction place `0` dans `rax`, indiquant que les chaînes sont égales, puis restaure `rbx` et retourne.

Cette fonction utilise une comparaison simple et directe, terminant dès qu'une différence est trouvée ou si les chaînes sont identiques.

### Fonction `ft_write`

La fonction `ft_write` réalise une opération d'écriture en utilisant un appel système. Elle tente d'écrire les données sur un descripteur de fichier et gère les erreurs potentielles en définissant `errno` si une erreur se produit.

#### Explication étape par étape :

1. **Appel système `write`** :
   - Le registre `rax` est défini sur `1`, correspondant au numéro de l'appel système `write`.
   - La commande `syscall` est exécutée, ce qui déclenche l'appel système pour écrire les données spécifiées sur le descripteur de fichier donné.

2. **Vérification d'erreur** :
   - Le résultat de l'appel système est vérifié :
     - Si `rax` contient une valeur négative, cela signifie qu'une erreur s'est produite, et la fonction passe au traitement d'erreur.
     - Sinon, elle retourne la valeur de `rax`, correspondant au nombre d'octets écrits avec succès.

3. **Gestion des erreurs** :
   - En cas d'erreur, le code d'erreur (valeur négative dans `rax`) est converti en positif.
   - L'emplacement d'`errno` est récupéré en appelant `__errno_location`, et le code d'erreur est stocké dans `errno`.
   - La fonction retourne `-1` pour indiquer qu'une erreur s'est produite.

4. **Retour** :
   - La fonction renvoie soit le nombre d'octets écrits (si l'appel système a réussi), soit `-1` en cas d'erreur.

Cette fonction utilise des registres pour passer les paramètres à `write` et assure une gestion des erreurs appropriée en configurant `errno` si nécessaire.

### Fonction `ft_read`

La fonction `ft_read` implémente une lecture de données depuis un descripteur de fichier en utilisant l'appel système `read`. Voici les étapes détaillées de la fonction :

1. **Préparation de la pile** : 
   - La fonction sauvegarde le pointeur de base actuel `rbp` sur la pile pour établir un cadre de pile.

2. **Exécution de l'appel système `read`** :
   - Le registre `rax` est mis à zéro pour indiquer l'appel système de lecture (`read`).
   - La commande `syscall` est exécutée, déclenchant l'appel système pour lire les données.

3. **Vérification des erreurs** :
   - La valeur de retour de `syscall` est vérifiée :
     - Si elle est négative (indiquant une erreur), le programme passe à la gestion d'erreur.
     - Sinon, il continue pour retourner la valeur de lecture.

4. **Gestion d'erreur** :
   - Si une erreur est détectée, le code d'erreur est converti en positif (avec `neg rax`).
   - La fonction obtient ensuite l'adresse de `errno` en appelant `__errno_location`, puis stocke le code d'erreur dans `errno`.
   - La fonction renvoie `-1` pour indiquer qu'une erreur s'est produite.

5. **Retour** :
   - La fonction rétablit le cadre de pile initial en restaurant `rbp` et termine en retournant soit le nombre d'octets lus, soit `-1` en cas d'erreur.

Ce code utilise des registres pour passer les paramètres à `read` et exploite des commandes système pour gérer les erreurs. La gestion de la pile et des registres assure que la fonction respecte les conventions d'appel.

### Fonction `ft_strdup`

La fonction `ft_strdup` duplique une chaîne de caractères en allouant dynamiquement la mémoire nécessaire et en y copiant le contenu de la chaîne source. En cas d'erreur d'allocation, elle renvoie `NULL` et définit `errno` à `ENOMEM` pour indiquer l'échec.

#### Explication étape par étape :

1. **Préparation de la pile** :
   - `rbx` et le pointeur de la chaîne source (`rdi`) sont sauvegardés sur la pile pour respecter les conventions d'appel et manipuler le pointeur source sans le perdre.

2. **Calcul de la taille à allouer** :
   - La fonction appelle `ft_strlen` pour obtenir la longueur de la chaîne source.
   - Un octet est ajouté pour le caractère nul (`\0`) de fin de chaîne, et le total est sauvegardé dans `rbx` pour l'utiliser comme taille lors de l'appel à `malloc`.

3. **Allocation de mémoire** :
   - `malloc` est appelé avec la taille calculée. Le pointeur retourné par `malloc` est vérifié :
     - Si `malloc` échoue (renvoie `NULL`), la fonction passe à la gestion d'erreur.
   
4. **Copie de la chaîne** :
   - Si `malloc` réussit, le pointeur de destination (`rdi`) est configuré pour recevoir la chaîne dupliquée, et `ft_strcpy` est appelé pour copier la chaîne source dans l'espace alloué.
   - Le pointeur alloué est restauré depuis la pile pour être renvoyé comme valeur de retour.

5. **Gestion d'erreur (`malloc` échoué)** :
   - Si `malloc` a échoué, la fonction configure `errno` sur `ENOMEM` (12) pour indiquer une erreur de mémoire insuffisante.
   - `rax` est mis à zéro pour retourner `NULL` comme indicateur d'échec de duplication.

6. **Retour** :
   - La fonction nettoie la pile en restaurant les valeurs initiales et retourne soit le pointeur de la chaîne dupliquée (succès), soit `NULL` (échec).

Cette implémentation assure une gestion correcte de la mémoire et une duplication propre de la chaîne de caractères, en tenant compte des erreurs possibles.

---

## Fonctions Bonus

### Fonction `ft_atoi_base`

La fonction `ft_atoi_base` convertit une chaîne de caractères représentant un nombre dans une base donnée en un entier. Cette fonction prend en compte les espaces et signes (`+` ou `-`), et vérifie également la validité de la base.

#### Explication étape par étape

1. **Préparation de la pile** :
   - Les registres nécessaires (`rbx`, `r12`, `r13`, `r14`, et `r15`) sont sauvegardés pour assurer la stabilité des valeurs tout au long de la fonction.

2. **Vérification de la base** :
   - La fonction `check_base` est appelée pour valider la base :
     - La base ne doit contenir aucun caractère interdit (`+`, `-`, ou espace) ni de doublon.
     - Si la base est invalide, la fonction retourne `0`.

3. **Calcul de la longueur de la base** :
   - La fonction `ft_strlen` est appelée sur la base pour obtenir sa longueur, stockée dans `r13`.

4. **Initialisation des variables** :
   - `r12` est initialisé à `0` pour stocker le résultat final.
   - `rbx` est initialisé à `1` et représente le signe du nombre (`1` pour positif et `-1` pour négatif).

5. **Passage des espaces** :
   - Une boucle ignore les espaces en début de chaîne.

6. **Vérification du signe** :
   - La fonction détecte le signe (`+` ou `-`) en début de chaîne, en ajustant `rbx` pour déterminer si le nombre est positif ou négatif.

7. **Conversion de la chaîne** :
   - La boucle `convert_loop` extrait chaque caractère de la chaîne pour déterminer sa valeur dans la base.
   - La fonction `get_digit` est appelée pour convertir chaque caractère en chiffre dans la base.
   - Si un caractère non valide pour la base est trouvé, la conversion s'arrête.
   - Le résultat final (`r12`) est multiplié par la longueur de la base et additionné au chiffre trouvé, permettant de construire progressivement le nombre entier.

8. **Application du signe** :
   - Le résultat est multiplié par `rbx` pour appliquer le signe correct.

9. **Retour** :
   - La fonction restaure les registres sauvegardés et retourne la valeur entière convertie.

#### Sous-fonctions utilisées

- **`get_digit`** : Retourne la valeur numérique d'un caractère dans la base, ou `-1` si le caractère n'est pas dans la base.
- **`check_base`** : Vérifie la validité de la base en s'assurant qu'il n'y a ni doublons ni caractères invalides (`+`, `-`, ou espace).

Cette implémentation assure que la chaîne est correctement convertie en entier en tenant compte des particularités de la base et en gérant les erreurs possibles.

### Fonction `ft_list_push_front`

La fonction `ft_list_push_front` ajoute un nouvel élément au début d'une liste chaînée. Elle prend en paramètre un pointeur vers le début de la liste (`begin_list`) et un pointeur vers les données (`data`) à insérer dans le nouvel élément. En cas de succès, elle renvoie `0`; si une erreur se produit, elle renvoie `-1` et définit `errno`.

#### Explication étape par étape

1. **Préparation de la pile** :
   - Les registres `rbx` et `r12` sont sauvegardés pour conserver leurs valeurs tout au long de l'exécution de la fonction.
   - Le pointeur de la liste `begin_list` (dans `rdi`) est vérifié pour s'assurer qu'il n'est pas nul ; s'il est nul, la fonction retourne immédiatement une erreur (`-1`).

2. **Allocation de mémoire pour le nouveau nœud** :
   - `malloc` est appelé avec une taille de `16` octets (taille de la structure `s_list`, qui comprend un pointeur `data` de 8 octets et un pointeur `next` de 8 octets).
   - Si `malloc` échoue, la fonction passe à une gestion d'erreur où `errno` est configuré à `ENOMEM` pour indiquer un manque de mémoire, et la fonction retourne `-1`.

3. **Initialisation du nouveau nœud** :
   - Le pointeur vers les données (`data`) est stocké dans le champ `data` du nouveau nœud.
   - Le champ `next` du nouveau nœud est configuré pour pointer vers l'ancien premier élément de la liste.
   - Le début de la liste (`*begin_list`) est mis à jour pour pointer vers ce nouveau nœud, faisant de lui le premier élément.

4. **Retour et nettoyage** :
   - Si la fonction réussit, elle retourne `0`.
   - Les registres `r12` et `rbx` sont restaurés avant de sortir de la fonction.

#### Gestion des erreurs

- **Allocation de mémoire échouée** : Si `malloc` renvoie `NULL`, `errno` est défini à `ENOMEM` (code 12), et la fonction retourne `-1`.
- **Liste non initialisée** : Si le pointeur `begin_list` est `NULL`, la fonction retourne immédiatement `-1`.

Cette fonction garantit que le nouvel élément est ajouté en tête de la liste tout en gérant les erreurs de manière appropriée.

### Fonction `ft_list_size`

La fonction `ft_list_size` calcule et retourne le nombre d'éléments dans une liste chaînée. Elle prend en paramètre un pointeur vers le début de la liste (`begin_list`) et retourne le nombre d'éléments via `rax`.

#### Explication étape par étape

1. **Préparation de la pile** :
   - `rbp` est utilisé pour configurer le cadre de pile, et `rbx` est sauvegardé pour être utilisé comme compteur des éléments.

2. **Initialisation du compteur et vérification de l'entrée** :
   - `ebx` est mis à zéro pour servir de compteur d'éléments.
   - Le pointeur de début de la liste (`rdi`) est vérifié :
     - Si `begin_list` est `NULL`, la fonction retourne immédiatement `0`.

3. **Boucle de comptage** :
   - La boucle `count_loop` incrémente `ebx` pour chaque élément de la liste.
   - La fonction avance dans la liste en déplaçant `rdi` vers le nœud suivant, situé à l'adresse `[rdi + 8]` (champ `next` de la structure de liste).
   - Si `rdi` devient `NULL`, cela signifie que la fin de la liste est atteinte, et la boucle se termine.

4. **Retour** :
   - La valeur de `ebx` (nombre d'éléments) est placée dans `eax` pour le retour.
   - Les registres `rbx` et `rbp` sont restaurés avant la fin de la fonction.

Cette fonction parcourt la liste chaînée de manière simple et efficace pour compter le nombre total d'éléments, en retournant `0` si la liste est vide.

### Fonction `ft_list_sort`

La fonction `ft_list_sort` trie une liste chaînée en utilisant un algorithme de tri par bulles (bubble sort) avec une fonction de comparaison fournie en paramètre. Elle prend en paramètre un pointeur vers le début de la liste (`begin_list`) et un pointeur vers une fonction de comparaison (`cmp`). Si l'ordre des éléments dans la liste ne correspond pas au critère de la fonction de comparaison, la fonction effectue des échanges de nœuds pour les trier.

#### Explication étape par étape

1. **Préparation de la pile et validation des entrées** :
   - La fonction sauvegarde les registres nécessaires et vérifie que les deux paramètres (`begin_list` et `cmp`) sont valides. Si l'un d'eux est `NULL`, la fonction quitte sans effectuer d'action.

2. **Initialisation des pointeurs** :
   - `r12` est utilisé pour stocker le pointeur vers le début de la liste.
   - `r13` contient le pointeur vers la fonction de comparaison.

3. **Boucle de tri par bulles** :
   - La variable `r14` est initialisée à `0` et sert de drapeau pour indiquer si un échange a eu lieu pendant le passage actuel. 
   - `rbx` est mis à jour pour parcourir chaque nœud de la liste.

4. **Boucle de comparaison** :
   - Pour chaque paire de nœuds consécutifs, la fonction de comparaison (`cmp`) est appelée avec les données des nœuds actuels et suivants. 
   - Si le résultat de la comparaison est positif (`cmp > 0`), cela signifie que l'ordre est incorrect et que les nœuds doivent être échangés.

5. **Échange de nœuds** :
   - Si un échange est nécessaire, les pointeurs `next` des nœuds actuels et suivants sont ajustés pour réordonner les nœuds.
   - Si l'échange concerne le premier nœud (tête de la liste), le pointeur de la tête est également mis à jour.
   - Le drapeau `r14` est mis à `1` pour indiquer qu'un échange a eu lieu, et le tri continue jusqu'à ce qu'il n'y ait plus d'échanges.

6. **Vérification des échanges** :
   - Après chaque passage, si aucun échange n'a eu lieu (`r14` est `0`), la liste est triée et la boucle principale se termine.

7. **Retour et nettoyage** :
   - Les registres sont restaurés et la fonction se termine.

Cette fonction implémente un tri par bulles simple, en parcourant la liste de nœuds jusqu'à ce qu'ils soient correctement ordonnés selon la fonction de comparaison fournie.

### Fonction `ft_list_remove_if`

La fonction `ft_list_remove_if` supprime les éléments d'une liste chaînée qui correspondent à une référence de données donnée (`data_ref`). Les nœuds correspondants sont libérés de la mémoire en appelant la fonction `free` sur eux. La fonction prend quatre paramètres :
- `begin_list` : pointeur vers le début de la liste.
- `data_ref` : référence de données à comparer.
- `cmp` : pointeur vers une fonction de comparaison.
- `free_fct` : fonction pour libérer la mémoire des données du nœud.

#### Explication étape par étape

1. **Préparation de la pile et sauvegarde des paramètres** :
   - La fonction sauvegarde les registres nécessaires pour préserver les valeurs des paramètres.
   - Elle vérifie ensuite si `begin_list` est `NULL` et, dans ce cas, quitte la fonction.

2. **Boucle de vérification des nœuds** :
   - La boucle principale (`check_current`) parcourt chaque nœud dans la liste.
   - Pour chaque nœud, la fonction de comparaison `cmp` est appelée avec les données du nœud actuel et `data_ref`.
   - Si `cmp` retourne `0`, cela signifie que le nœud actuel doit être supprimé.

3. **Suppression d'un nœud** :
   - Si le nœud actuel correspond à `data_ref`, les étapes suivantes sont effectuées :
     - Si une fonction `free_fct` est fournie, elle est appelée pour libérer la mémoire associée aux données du nœud.
     - Le pointeur du nœud précédent est mis à jour pour sauter le nœud actuel, en le pointant directement vers le nœud suivant.
     - La fonction `free` est appelée pour libérer la mémoire du nœud lui-même.
   - Après la suppression, la boucle continue pour vérifier le prochain nœud.

4. **Avancement dans la liste** :
   - Si le nœud actuel ne correspond pas à `data_ref`, la fonction avance au nœud suivant sans le supprimer.
   
5. **Retour et nettoyage** :
   - Lorsque la liste est entièrement parcourue, les registres sauvegardés sont restaurés, et la fonction retourne.

#### Gestion des erreurs

- Si `begin_list` est `NULL`, la fonction quitte immédiatement.
- Si `free_fct` est `NULL`, la mémoire des données de chaque nœud n'est pas libérée, mais le nœud lui-même est tout de même supprimé.

Cette fonction permet de parcourir et de modifier la liste en fonction d'une condition, assurant que tous les nœuds correspondant à `data_ref` sont correctement supprimés de la liste chaînée.

---

## Compilation et Utilisation

### Prérequis

- **NASM** : Assembleur
- **GCC** : Compilateur
- **Make**
- **Docker** : pour exécuter le projet dans un environnement isolé

### Configuration et Compilation via Docker

Les étapes suivantes permettent de configurer et de compiler le projet `libasm` dans un conteneur Docker. Ces commandes créent un environnement Ubuntu isolé, installent les dépendances nécessaires, compilent le projet et exécutent les tests.

1. **Créer et démarrer le conteneur Docker** :  
   La commande ci-dessous crée et démarre un conteneur Ubuntu avec le dossier local `42_libasm` monté sur `/app` dans le conteneur :
    ```bash
    docker run -it --name libasm-container -v ~/42_libasm:/app ubuntu:latest
    ```

2. **Mettre à jour le système et installer les dépendances** :
Une fois dans le conteneur, exécutez les commandes suivantes pour mettre à jour les paquets et installer les outils de compilation :
```
apt update
apt install -y build-essential nasm make gcc
```

3. **Accéder au répertoire de l'application** :
```
cd /app
```

4. **Compiler et exécuter la partie obligatoire** : Utilisez la commande `make` pour compiler toutes les fonctions obligatoires :
```
make
```

5. **Compiler et exécuter la partie bonus** : Utilisez la commande `make bonus` pour compiler toutes les fonctions bonus :
```
make bonus
```

6. **Compiler et exécuter les tests** : Utilisez la commande make test pour compiler toutes les fonctions, y compris les bonus, et générer les exécutables de test :
```
make test
```

7. **Exécuter les tests*** : Après la compilation, lancez les tests des fonctions obligatoires et bonus :
```
./test_main      # Teste les fonctions obligatoires
./bonus_main     # Teste les fonctions bonus
```

---