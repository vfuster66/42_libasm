NAME = libasm.a

# Sources obligatoires
SRCS = src/ft_strlen.s \
       src/ft_strcpy.s \
       src/ft_strcmp.s \
       src/ft_write.s \
       src/ft_read.s \
       src/ft_strdup.s

# Sources bonus
BONUS_SRCS = bonus_src/ft_atoi_base.s \
             bonus_src/ft_list_push_front.s \
             bonus_src/ft_list_size.s \
             bonus_src/ft_list_sort.s \
             bonus_src/ft_list_remove_if.s

# Objets
OBJS = $(SRCS:.s=.o)
BONUS_OBJS = $(BONUS_SRCS:.s=.o)

# Compilateurs et flags
NASM = nasm
NASMFLAGS = -f elf64
CC = gcc
CFLAGS = -no-pie -L. -lasm -Wl,--no-as-needed

# Compilation de la bibliothèque
all: bonus   # Compile tout (obligatoire + bonus)

$(NAME): $(OBJS)
	ar rcs $(NAME) $(OBJS)
	ranlib $(NAME)

bonus: $(NAME) $(BONUS_OBJS)
	ar rcs $(NAME) $(OBJS) $(BONUS_OBJS)
	ranlib $(NAME)

# Règles pour les tests
test_main: all
	$(CC) $(CFLAGS) -o test_main main.c -L. -lasm

bonus_main: bonus
	$(CC) $(CFLAGS) -o bonus_main bonus_main.c -L. -lasm

test: test_main bonus_main  # Compile tout pour les tests

# Compilation des fichiers .s en objets
%.o: %.s
	$(NASM) $(NASMFLAGS) $< -o $@

# Nettoyage
clean:
	$(RM) $(OBJS) $(BONUS_OBJS)

fclean: clean
	$(RM) $(NAME) bonus_main test_main test.txt

re: fclean all

# Indiquer que ces cibles ne sont pas des fichiers réels
.PHONY: all bonus bonus_main test_main test clean fclean re
