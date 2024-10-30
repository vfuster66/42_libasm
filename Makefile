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

# Compilateur assembleur
NASM = nasm
NASMFLAGS = -f elf64

# Compilation de la bibliothèque
all: $(NAME)

$(NAME): $(OBJS)
	ar rcs $(NAME) $(OBJS)
	ranlib $(NAME)

bonus: $(NAME) $(BONUS_OBJS)
	ar rcs $(NAME) $(OBJS) $(BONUS_OBJS)
	ranlib $(NAME)

bonus_main: bonus
	gcc -no-pie -o bonus_main bonus_main.c -L. -lasm

# Compilation des fichiers .s en objets
%.o: %.s
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f $(OBJS) $(BONUS_OBJS)

fclean: clean
	rm -f $(NAME) bonus_main

re: fclean all
