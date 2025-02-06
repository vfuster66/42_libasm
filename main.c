#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <errno.h>

// Déclarations des fonctions
size_t ft_strlen(const char *str);
char *ft_strcpy(char *dest, const char *src);
int ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char *ft_strdup(const char *s);

#define LONG_STR "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor."

int main(void)
{
   char buffer[100];
   char buffer2[100];
   char overlap[20];
   char *str_dup;
   int fd;
   ssize_t ret, ret2;

   // Test ft_strlen
   printf("\n=== Test ft_strlen ===\n");
   printf("Test basique:\n");
   printf("ft_strlen(\"Hello\"): %zu\n", ft_strlen("Hello"));
   printf("strlen(\"Hello\"): %zu\n", strlen("Hello"));
   
   printf("\nTest chaîne vide:\n");
   printf("ft_strlen(\"\"): %zu\n", ft_strlen(""));
   printf("strlen(\"\"): %zu\n", strlen(""));
   
   printf("\nTest longue chaîne:\n");
   printf("ft_strlen(long_str): %zu\n", ft_strlen(LONG_STR));
   printf("strlen(long_str): %zu\n", strlen(LONG_STR));
   
   printf("\nTest avec \\0:\n");
   printf("ft_strlen(\"Hello\\0World\"): %zu\n", ft_strlen("Hello\0World"));
   printf("strlen(\"Hello\\0World\"): %zu\n", strlen("Hello\0World"));

   // Test ft_strcpy
   printf("\n=== Test ft_strcpy ===\n");
   printf("Test basique:\n");
   ft_strcpy(buffer, "Test string");
   printf("ft_strcpy result: %s\n", buffer);
   strcpy(buffer2, "Test string");
   printf("strcpy result: %s\n", buffer2);

   printf("\nTest chevauchement:\n");
   strcpy(overlap, "TestOverlap");
   ft_strcpy(overlap, overlap+1);
   printf("ft_strcpy overlap: %s\n", overlap);
   strcpy(overlap, "TestOverlap");
   strcpy(overlap, overlap+1);
   printf("strcpy overlap: %s\n", overlap);

   printf("\nTest chaîne vide:\n");
   ft_strcpy(buffer, "");
   printf("ft_strcpy empty: '%s'\n", buffer);
   strcpy(buffer2, "");
   printf("strcpy empty: '%s'\n", buffer2);

   // Test ft_strcmp
   printf("\n=== Test ft_strcmp ===\n");
   printf("Test égalité:\n");
   printf("ft_strcmp(\"abc\", \"abc\"): %d\n", ft_strcmp("abc", "abc"));
   printf("strcmp(\"abc\", \"abc\"): %d\n", strcmp("abc", "abc"));
   
   printf("\nTest différence:\n");
   printf("ft_strcmp(\"abc\", \"abd\"): %d\n", ft_strcmp("abc", "abd"));
   printf("strcmp(\"abc\", \"abd\"): %d\n", strcmp("abc", "abd"));
   
   printf("\nTest avec \\0:\n");
   printf("ft_strcmp(\"abc\\0def\", \"abc\\0def\"): %d\n", ft_strcmp("abc\0def", "abc\0def"));
   printf("strcmp(\"abc\\0def\", \"abc\\0def\"): %d\n", strcmp("abc\0def", "abc\0def"));
   
   printf("\nTest longueurs différentes:\n");
   printf("ft_strcmp(\"abc\", \"abcd\"): %d\n", ft_strcmp("abc", "abcd"));
   printf("strcmp(\"abc\", \"abcd\"): %d\n", strcmp("abc", "abcd"));

   // Test ft_write
   printf("\n=== Test ft_write ===\n");
   printf("Test basique:\n");
   printf("ft_write test: ");
   ret = ft_write(1, "Hello\n", 6);
   printf("ft_write return: %zd\n", ret);
   printf("write test: ");
   ret2 = write(1, "Hello\n", 6);
   printf("write return: %zd\n", ret2);

   printf("\nTest count 0:\n");
   ret = ft_write(1, "Test", 0);
   printf("ft_write count 0: %zd\n", ret);
   ret2 = write(1, "Test", 0);
   printf("write count 0: %zd\n", ret2);

   printf("\nTest erreur:\n");
   ret = ft_write(-1, "Hello\n", 6);
   printf("ft_write return: %zd, errno: %d\n", ret, errno);
   errno = 0;
   ret2 = write(-1, "Hello\n", 6);
   printf("write return: %zd, errno: %d\n", ret2, errno);

   // Test ft_read
   printf("\n=== Test ft_read ===\n");
   fd = open("test.txt", O_RDWR | O_CREAT | O_TRUNC, 0644);
   if (fd != -1) {
       printf("Test basique:\n");
       write(fd, "Test read\n", 10);
       lseek(fd, 0, SEEK_SET);
       
       memset(buffer, 0, sizeof(buffer));
       ret = ft_read(fd, buffer, 10);
       printf("ft_read result: %s", buffer);
       printf("ft_read return: %zd\n", ret);

       lseek(fd, 0, SEEK_SET);
       memset(buffer2, 0, sizeof(buffer2));
       ret2 = read(fd, buffer2, 10);
       printf("read result: %s", buffer2);
       printf("read return: %zd\n", ret2);

       printf("\nTest count 0:\n");
       ret = ft_read(fd, buffer, 0);
       printf("ft_read count 0: %zd\n", ret);
       ret2 = read(fd, buffer2, 0);
       printf("read count 0: %zd\n", ret2);

       close(fd);
   }

   printf("\nTest erreur:\n");
   ret = ft_read(-1, buffer, 10);
   printf("ft_read return: %zd, errno: %d\n", ret, errno);
   errno = 0;
   ret2 = read(-1, buffer2, 10);
   printf("read return: %zd, errno: %d\n", ret2, errno);

   // Test ft_strdup
   printf("\n=== Test ft_strdup ===\n");
   printf("Test basique:\n");
   str_dup = ft_strdup("Test strdup");
   if (str_dup) {
       printf("ft_strdup result: %s\n", str_dup);
       free(str_dup);
   }
   char *str_dup2 = strdup("Test strdup");
   if (str_dup2) {
       printf("strdup result: %s\n", str_dup2);
       free(str_dup2);
   }

   printf("\nTest chaîne vide:\n");
   str_dup = ft_strdup("");
   if (str_dup) {
       printf("ft_strdup empty: '%s'\n", str_dup);
       free(str_dup);
   }
   str_dup2 = strdup("");
   if (str_dup2) {
       printf("strdup empty: '%s'\n", str_dup2);
       free(str_dup2);
   }

   return 0;
}