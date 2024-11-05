#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

typedef struct s_list {
    void *data;
    struct s_list *next;
} t_list;

// Déclarations des fonctions
int ft_atoi_base(char *str, char *base);
void ft_list_push_front(t_list **begin_list, void *data);
int ft_list_size(t_list *begin_list);
void ft_list_sort(t_list **begin_list, int (*cmp)());
void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void*));

void print_list(t_list *list) {
    if (!list) {
        printf("Liste vide\n");
        return;
    }
    while (list) {
        printf("Nœud: %s\n", (char*)list->data);
        list = list->next;
    }
}

int compare_str(void *s1, void *s2) {
    return strcmp((char*)s1, (char*)s2);
}

void free_data(void *data) {
    free(data);
}

void test_atoi_base_advanced() {
    printf("\n=== Tests avancés ft_atoi_base ===\n");
    
    // Tests avec différentes bases
    printf("\nTests avec différentes bases:\n");
    printf("Base binaire '1111' -> %d\n", ft_atoi_base("1111", "01"));
    printf("Base octal '777' -> %d\n", ft_atoi_base("777", "01234567"));
    printf("Base hex 'FFF' -> %d\n", ft_atoi_base("FFF", "0123456789ABCDEF"));
    printf("Base 36 'ZZ' -> %d\n", ft_atoi_base("ZZ", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"));

    // Tests avec caractères spéciaux
    printf("\nTests avec caractères spéciaux:\n");
    printf("Base avec symboles '123' en '@#$' -> %d\n", ft_atoi_base("123", "@#$"));
    printf("Base avec espace '12 3' en '0123456789' -> %d\n", ft_atoi_base("12 3", "0123456789"));
    
    // Tests de cas extrêmes
    printf("\nTests de cas extrêmes:\n");
    printf("Très grand nombre '7FFFFFFF' en base hex -> %d\n", ft_atoi_base("7FFFFFFF", "0123456789ABCDEF"));
    printf("Nombre négatif max '-7FFFFFFF' en base hex -> %d\n", ft_atoi_base("-7FFFFFFF", "0123456789ABCDEF"));
    
    // Tests d'erreur
    printf("\nTests d'erreur:\n");
    printf("Caractère invalide 'G' en base '0123456789' -> %d\n", ft_atoi_base("G", "0123456789"));
    printf("Base avec caractère de contrôle -> %d\n", ft_atoi_base("123", "012\t3"));
    printf("Base avec espace -> %d\n", ft_atoi_base("123", "012 3"));
}

void test_list_advanced() {
    printf("\n=== Tests avancés des opérations sur les listes ===\n");
    t_list *list = NULL;
    
    // Test avec une grande liste
    printf("\nTest avec une grande liste:\n");
    char numbers[20][4];
    for (int i = 0; i < 20; i++) {
        sprintf(numbers[i], "%d", i);
        ft_list_push_front(&list, strdup(numbers[i]));
    }
    printf("Liste de 20 éléments créée\n");
    printf("Taille de la liste: %d\n", ft_list_size(list));
    
    // Test de tri avec éléments égaux
    printf("\nTest de tri avec éléments égaux:\n");
    ft_list_push_front(&list, strdup("10"));
    ft_list_push_front(&list, strdup("10"));
    ft_list_push_front(&list, strdup("10"));
    printf("Ajout de trois '10' supplémentaires\n");
    printf("Avant tri:\n");
    print_list(list);
    ft_list_sort(&list, compare_str);
    printf("Après tri:\n");
    print_list(list);

    // Test de remove_if avec éléments égaux
    printf("\nTest de remove_if avec éléments égaux:\n");
    ft_list_remove_if(&list, "10", compare_str, free_data);
    printf("Après suppression de tous les '10':\n");
    print_list(list);

    // Test de tri avec chaînes de différentes longueurs
    printf("\nTest de tri avec chaînes de différentes longueurs:\n");
    ft_list_push_front(&list, strdup("Test"));
    ft_list_push_front(&list, strdup("A"));
    ft_list_push_front(&list, strdup("Très long texte"));
    ft_list_push_front(&list, strdup(""));
    ft_list_sort(&list, compare_str);
    printf("Après tri:\n");
    print_list(list);

    // Test de remove_if sur des cas particuliers
    printf("\nTest de remove_if sur cas particuliers:\n");
    ft_list_remove_if(&list, "", compare_str, free_data);  // Chaîne vide
    printf("Après suppression chaîne vide:\n");
    print_list(list);

    // Test de manipulation intensive
    printf("\nTest de manipulation intensive:\n");
    for (int i = 0; i < 100; i++) {
        char tmp[8];
        sprintf(tmp, "Test%d", i % 10);
        ft_list_push_front(&list, strdup(tmp));
    }
    printf("Ajout de 100 éléments supplémentaires\n");
    ft_list_sort(&list, compare_str);
    printf("Tri effectué\n");
    printf("Taille finale: %d\n", ft_list_size(list));

    // Nettoyage
    while (list) {
        t_list *temp = list->next;
        free(list->data);
        free(list);
        list = temp;
    }
}

int main() {
    test_atoi_base_advanced();
    test_list_advanced();
    printf("\nTous les tests avancés sont terminés !\n");
    return 0;
}