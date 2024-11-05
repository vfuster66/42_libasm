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
CFLAGS = -fPIE -pie

# Compilation de la bibliothèque
all: $(NAME)

$(NAME): $(OBJS)
	ar rcs $(NAME) $(OBJS)
	ranlib $(NAME)

bonus: $(NAME) $(BONUS_OBJS)
	ar rcs $(NAME) $(OBJS) $(BONUS_OBJS)
	ranlib $(NAME)

# Règles pour les tests
test_main: all
	$(CC) $(CFLAGS) main.c -L. -lasm -o test_main

bonus_main: bonus
	$(CC) $(CFLAGS) bonus_main.c -L. -lasm -o bonus_main

test: test_main bonus_main

# Compilation des fichiers .s en objets
%.o: %.s
	$(NASM) $(NASMFLAGS) $< -o $@

# Nettoyage
clean:
	$(RM) $(OBJS) $(BONUS_OBJS)

fclean: clean
	$(RM) $(NAME) bonus_main test_main test.txt

re: fclean all

.PHONY: all bonus bonus_main test_main test clean fclean re