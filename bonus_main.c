#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Définition de la structure de liste
typedef struct s_list {
    void *data;
    struct s_list *next;
} t_list;

// Déclarations des fonctions en assembleur
int ft_atoi_base(const char *str, const char *base);
void ft_list_push_front(t_list **begin_list, void *data);
int ft_list_size(t_list *begin_list);
void ft_list_sort(t_list **begin_list, int (*cmp)());
void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

// Fonction de comparaison
int cmp(const void *a, const void *b) {
    return strcmp((const char *)a, (const char *)b);
}

int main() {
    // Test de ft_atoi_base
    const char *str = "1A";
    const char *base = "0123456789ABCDEF";
    printf("ft_atoi_base('%s', '%s') = %d\n", str, base, ft_atoi_base(str, base));

    // Création de la liste pour les tests des fonctions de liste
    t_list *list = NULL;
    ft_list_push_front(&list, "Troisième élément");
    ft_list_push_front(&list, "Deuxième élément");
    ft_list_push_front(&list, "Premier élément");
    printf("ft_list_size = %d\n", ft_list_size(list));

    // Tri de la liste
    ft_list_sort(&list, cmp);
    printf("Liste triée:\n");
    for (t_list *temp = list; temp; temp = temp->next) {
        printf("%s\n", (char *)temp->data);
    }

    // Suppression conditionnelle
    ft_list_remove_if(&list, "Deuxième élément", cmp, free);
    printf("Liste après suppression:\n");
    for (t_list *temp = list; temp; temp = temp->next) {
        printf("%s\n", (char *)temp->data);
    }

    return 0;
}
