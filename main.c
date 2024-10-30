#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

// Déclarations des fonctions en assembleur
size_t  ft_strlen(const char *str);
char    *ft_strcpy(char *dest, const char *src);
int     ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char    *ft_strdup(const char *s);

int main() {
    // Test de ft_strlen
    const char *test_str = "Hello, world!";
    printf("ft_strlen('%s') = %zu\n", test_str, ft_strlen(test_str));

    // Test de ft_strcpy
    char dest[50];
    ft_strcpy(dest, test_str);
    printf("ft_strcpy(dest, '%s') -> dest = '%s'\n", test_str, dest);

    // Test de ft_strcmp
    const char *str1 = "Hello";
    const char *str2 = "Hello";
    const char *str3 = "Hello, world!";
    printf("ft_strcmp('%s', '%s') = %d\n", str1, str2, ft_strcmp(str1, str2));
    printf("ft_strcmp('%s', '%s') = %d\n", str1, str3, ft_strcmp(str1, str3));
    printf("ft_strcmp('%s', '%s') = %d\n", str3, str1, ft_strcmp(str3, str1));

    // Test de ft_write
    const char *write_str = "This is a test for ft_write.\n";
    printf("ft_write(1, '%s', %zu) = %zd\n", write_str, strlen(write_str), ft_write(1, write_str, strlen(write_str)));

    // Test de ft_read
    int fd = open("test.txt", O_CREAT | O_RDWR, 0644);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    ft_write(fd, "Sample text for ft_read test.", 29);
    lseek(fd, 0, SEEK_SET);  // Revenir au début du fichier
    char buf[30];
    ssize_t read_bytes = ft_read(fd, buf, 29);
    if (read_bytes < 0) {
        perror("ft_read");
    } else {
        buf[read_bytes] = '\0';
        printf("ft_read(fd, buf, 29) -> buf = '%s'\n", buf);
    }
    close(fd);

    // Test de ft_strdup
    const char *dup_str = "Duplicate this string.";
    char *dup = ft_strdup(dup_str);
    printf("ft_strdup('%s') = '%s'\n", dup_str, dup);
    free(dup);

    return 0;
}

