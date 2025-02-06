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

// Fonctions utilitaires
void print_list(t_list *list, const char *msg) {
    printf("%s:\n", msg);
    if (!list) {
        printf("  Liste vide\n");
        return;
    }
    while (list) {
        printf("  %s\n", (char*)list->data ? (char*)list->data : "NULL");
        list = list->next;
    }
}

int compare_str(void *s1, void *s2) {
    if (!s1 && !s2) return 0;
    if (!s1) return -1;
    if (!s2) return 1;
    return strcmp((char*)s1, (char*)s2);
}

void free_data(void *data) {
    if (data)
        free(data);
}

void test_atoi_base_advanced() {
    printf("\n=== Tests avancés ft_atoi_base ===\n");
    
    // Tests de base invalide
    printf("\nTests de base invalide:\n");
    printf("Base vide -> %d\n", ft_atoi_base("123", ""));
    printf("Base un caractère -> %d\n", ft_atoi_base("1", "1"));
    printf("Base avec caractères répétés -> %d\n", ft_atoi_base("123", "11234"));
    printf("Base avec + -> %d\n", ft_atoi_base("123", "012+3"));
    printf("Base avec - -> %d\n", ft_atoi_base("123", "012-3"));
    printf("Base avec espace -> %d\n", ft_atoi_base("123", "012 3"));
    printf("Base avec tab -> %d\n", ft_atoi_base("123", "012\t3"));

    // Tests de chaîne invalide
    printf("\nTests de chaîne invalide:\n");
    printf("Chaîne vide -> %d\n", ft_atoi_base("", "0123456789"));
    printf("Chaîne avec caractères invalides -> %d\n", ft_atoi_base("12X3", "0123456789"));
    printf("Uniquement espaces -> %d\n", ft_atoi_base("   ", "0123456789"));
    printf("Uniquement signes -> %d\n", ft_atoi_base("+++", "0123456789"));

    // Tests avec différentes bases valides
    printf("\nTests avec différentes bases valides:\n");
    printf("Base binaire '1111' -> %d\n", ft_atoi_base("1111", "01"));
    printf("Base octal '777' -> %d\n", ft_atoi_base("777", "01234567"));
    printf("Base decimal '12345' -> %d\n", ft_atoi_base("12345", "0123456789"));
    printf("Base hex 'FFF' -> %d\n", ft_atoi_base("FFF", "0123456789ABCDEF"));
    printf("Base 36 'ZZ' -> %d\n", ft_atoi_base("ZZ", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"));
    printf("Base symboles '123' -> %d\n", ft_atoi_base("123", "@#$%^&*"));

    // Tests de cas extrêmes
    printf("\nTests de cas extrêmes:\n");
    printf("INT_MAX en hex -> %d\n", ft_atoi_base("7FFFFFFF", "0123456789ABCDEF"));
    printf("INT_MIN en hex -> %d\n", ft_atoi_base("-80000000", "0123456789ABCDEF"));
    printf("Longue séquence de chiffres -> %d\n", ft_atoi_base("111111111111111", "01"));
    printf("Longue séquence d'espaces -> %d\n", ft_atoi_base("     42", "0123456789"));
    printf("Multiple signes -> %d\n", ft_atoi_base("+-+-42", "0123456789"));
}

void test_list_push_front() {
    printf("\n=== Tests ft_list_push_front ===\n");
    t_list *list = NULL;

    // Test liste vide
    ft_list_push_front(&list, strdup("Premier"));
    print_list(list, "Après premier ajout");

    // Test ajout normal
    ft_list_push_front(&list, strdup("Deuxième"));
    print_list(list, "Après deuxième ajout");

    // Test avec NULL
    ft_list_push_front(&list, NULL);
    print_list(list, "Après ajout NULL");

    // Test avec pointeur liste NULL
    ft_list_push_front(NULL, strdup("Test"));
    
    // Nettoyage
    while (list) {
        t_list *temp = list->next;
        free_data(list->data);
        free(list);
        list = temp;
    }
}

void test_list_size() {
    printf("\n=== Tests ft_list_size ===\n");
    t_list *list = NULL;

    // Test liste vide
    printf("Taille liste vide: %d\n", ft_list_size(list));

    // Test un élément
    ft_list_push_front(&list, strdup("Un"));
    printf("Taille liste un élément: %d\n", ft_list_size(list));

    // Test plusieurs éléments
    ft_list_push_front(&list, strdup("Deux"));
    ft_list_push_front(&list, strdup("Trois"));
    printf("Taille liste trois éléments: %d\n", ft_list_size(list));

    // Test avec élément NULL
    ft_list_push_front(&list, NULL);
    printf("Taille liste avec NULL: %d\n", ft_list_size(list));

    // Nettoyage
    while (list) {
        t_list *temp = list->next;
        free_data(list->data);
        free(list);
        list = temp;
    }
}

void test_list_sort() {
    printf("\n=== Tests ft_list_sort ===\n");
    t_list *list = NULL;

    // Test liste vide
    ft_list_sort(&list, compare_str);
    print_list(list, "Liste vide triée");

    // Test un seul élément
    ft_list_push_front(&list, strdup("Unique"));
    ft_list_sort(&list, compare_str);
    print_list(list, "Liste un élément triée");

    // Test éléments déjà triés
    ft_list_push_front(&list, strdup("Alphabet"));
    ft_list_push_front(&list, strdup("Beta"));
    ft_list_push_front(&list, strdup("Charlie"));
    print_list(list, "Avant tri (déjà trié)");
    ft_list_sort(&list, compare_str);
    print_list(list, "Après tri");

    // Test éléments inversés
    while (list) {
        t_list *temp = list->next;
        free_data(list->data);
        free(list);
        list = temp;
    }
    ft_list_push_front(&list, strdup("A"));
    ft_list_push_front(&list, strdup("B"));
    ft_list_push_front(&list, strdup("C"));
    print_list(list, "Avant tri (inversé)");
    ft_list_sort(&list, compare_str);
    print_list(list, "Après tri");

    // Test avec éléments NULL
    ft_list_push_front(&list, NULL);
    ft_list_push_front(&list, strdup("Z"));
    ft_list_push_front(&list, NULL);
    print_list(list, "Avant tri avec NULL");
    ft_list_sort(&list, compare_str);
    print_list(list, "Après tri avec NULL");

    // Test avec comparateur NULL
    ft_list_sort(&list, NULL);
    print_list(list, "Après tri avec comparateur NULL");

    // Nettoyage
    while (list) {
        t_list *temp = list->next;
        free_data(list->data);
        free(list);
        list = temp;
    }
}

void test_list_remove_if() {
    printf("\n=== Tests ft_list_remove_if ===\n");
    t_list *list = NULL;

    // Préparation de la liste
    ft_list_push_front(&list, strdup("Keep1"));
    ft_list_push_front(&list, strdup("Remove"));
    ft_list_push_front(&list, strdup("Keep2"));
    ft_list_push_front(&list, strdup("Remove"));
    ft_list_push_front(&list, strdup("Keep3"));
    ft_list_push_front(&list, NULL);

    // Test basique
    print_list(list, "Liste initiale");
    ft_list_remove_if(&list, "Remove", compare_str, free_data);
    print_list(list, "Après suppression de 'Remove'");

    // Test avec data_ref NULL
    ft_list_remove_if(&list, NULL, compare_str, free_data);
    print_list(list, "Après suppression des NULL");

    // Test avec comparateur NULL
    ft_list_remove_if(&list, "Keep1", NULL, free_data);
    print_list(list, "Après remove_if avec comparateur NULL");

    // Test avec free_fct NULL
    ft_list_remove_if(&list, "Keep2", compare_str, NULL);
    print_list(list, "Après remove_if avec free NULL");

    // Test suppression de tous les éléments
    ft_list_remove_if(&list, "Keep3", compare_str, free_data);
    print_list(list, "Après suppression du dernier élément");

    // Nettoyage final
    while (list) {
        t_list *temp = list->next;
        free_data(list->data);
        free(list);
        list = temp;
    }
}

int main() {
    test_atoi_base_advanced();
    test_list_push_front();
    test_list_size();
    test_list_sort();
    test_list_remove_if();
    printf("\nTous les tests avancés sont terminés !\n");
    return 0;
}