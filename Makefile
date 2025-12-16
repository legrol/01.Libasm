# ══ Names & Directories ═════════════════════════════════════════════════════
NAME 		= libasm.out
OBJ_DIR		= obj
SRC_DIR		= src
INC_DIR		= includes
LIBASM_DIR	= libasm

# ══ Colors ══════════════════════════════════════════════════════════════════
YELLOW 		= \033[0;93m
GREEN 		= \033[0;92m
RED 		= \033[0;91m
CYAN 		= \033[0;96m
DEF_COLOR 	= \033[0;39m

# ══ Compiler & Flags ════════════════════════════════════════════════════════
CC 			= gcc
NASM 		= C:/Users/Usuario/AppData/Local/bin/NASM/nasm.exe
RM 			= rm -f
MKD			= mkdir -p
CFLAGS 		= -Wall -Werror -Wextra
IFLAGS		= -I$(INC_DIR)
NASMFLAGS	= -f win64

# ══ Sources ═════════════════════════════════════════════════════════════════
SRC 		= $(SRC_DIR)/main.c

ASM_SRC 	= $(LIBASM_DIR)/ft_strlen.s \
			  $(LIBASM_DIR)/ft_strcpy.s \
			  $(LIBASM_DIR)/ft_strcmp.s \
			  $(LIBASM_DIR)/ft_write.s \
			  $(LIBASM_DIR)/ft_read.s \
			  $(LIBASM_DIR)/ft_strdup.s

# ══ Objects ═════════════════════════════════════════════════════════════════
OBJ_SRC		= $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
OBJ_ASM		= $(ASM_SRC:$(LIBASM_DIR)/%.s=$(OBJ_DIR)/%.o)

# ══ Rules ═══════════════════════════════════════════════════════════════════
all: $(NAME)

$(NAME): $(OBJ_SRC) $(OBJ_ASM)
	@echo "$(YELLOW)Linking $(NAME)...$(DEF_COLOR)"
	@$(CC) $(CFLAGS) $(IFLAGS) -o $(NAME) $(OBJ_SRC) $(OBJ_ASM)
	@echo "$(GREEN)✓ $(NAME) created successfully!$(DEF_COLOR)"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "$(CYAN)Compiling $<...$(DEF_COLOR)"
	@$(CC) $(CFLAGS) $(IFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(LIBASM_DIR)/%.s | $(OBJ_DIR)
	@echo "$(CYAN)Assembling $<...$(DEF_COLOR)"
	@$(NASM) $(NASMFLAGS) $< -o $@

$(OBJ_DIR):
	@$(MKD) $(OBJ_DIR)

clean:
	@echo "$(YELLOW)Removing object files...$(DEF_COLOR)"
	@$(RM) -r $(OBJ_DIR)
	@echo "$(RED)Object files removed$(DEF_COLOR)"

fclean: clean
	@echo "$(YELLOW)Removing binaries...$(DEF_COLOR)"
	@$(RM) $(NAME)
	@echo "$(RED)Binaries removed$(DEF_COLOR)"

re: fclean all

.PHONY: all clean fclean re
