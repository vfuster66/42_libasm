#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <errno.h>

// Déclarations des fonctions assembleur
size_t ft_strlen(const char *str);
char *ft_strcpy(char *dest, const char *src);
int ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char *ft_strdup(const char *s);

int main(void)
{
    char buffer[100];
    char *str_dup;
    int fd;
    ssize_t ret;

    // Test ft_strlen
    printf("\n=== Test ft_strlen ===\n");
    printf("ft_strlen(\"Hello\"): %zu\n", ft_strlen("Hello"));
    printf("strlen(\"Hello\"): %zu\n", strlen("Hello"));
    printf("ft_strlen(\"\"): %zu\n", ft_strlen(""));
    printf("strlen(\"\"): %zu\n", strlen(""));

    // Test ft_strcpy
    printf("\n=== Test ft_strcpy ===\n");
    ft_strcpy(buffer, "Test string");
    printf("ft_strcpy result: %s\n", buffer);
    strcpy(buffer, "Test string");
    printf("strcpy result: %s\n", buffer);

    // Test ft_strcmp
    printf("\n=== Test ft_strcmp ===\n");
    printf("ft_strcmp(\"abc\", \"abc\"): %d\n", ft_strcmp("abc", "abc"));
    printf("strcmp(\"abc\", \"abc\"): %d\n", strcmp("abc", "abc"));
    printf("ft_strcmp(\"abc\", \"abd\"): %d\n", ft_strcmp("abc", "abd"));
    printf("strcmp(\"abc\", \"abd\"): %d\n", strcmp("abc", "abd"));

    // Test ft_write
    printf("\n=== Test ft_write ===\n");
    printf("ft_write test to stdout: ");
    ret = ft_write(1, "Hello\n", 6);
    printf("ft_write return: %zd\n", ret);
    
    // Test ft_write avec erreur
    printf("Testing ft_write with invalid fd: ");
    ret = ft_write(-1, "Hello\n", 6);
    printf("ft_write return: %zd, errno: %d\n", ret, errno);

    // Test ft_read
    printf("\n=== Test ft_read ===\n");
    fd = open("test.txt", O_RDWR | O_CREAT | O_TRUNC, 0644);
    if (fd != -1) {
        write(fd, "Test read\n", 10);
        lseek(fd, 0, SEEK_SET);
        
        memset(buffer, 0, sizeof(buffer));
        ret = ft_read(fd, buffer, 10);
        printf("ft_read result: %s", buffer);
        printf("ft_read return: %zd\n", ret);
        
        close(fd);
    }

    // Test ft_read avec erreur
    printf("Testing ft_read with invalid fd: ");
    ret = ft_read(-1, buffer, 10);
    printf("ft_read return: %zd, errno: %d\n", ret, errno);

    // Test ft_strdup
    printf("\n=== Test ft_strdup ===\n");
    str_dup = ft_strdup("Test strdup");
    if (str_dup) {
        printf("ft_strdup result: %s\n", str_dup);
        free(str_dup);
    }

    return 0;
}