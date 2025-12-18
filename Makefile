# ══ Names ═══════════════════════════════════════════════════════════════════ #
#    -----                                                                     #

NAME 				= libasm.a

# ══ Colors ══════════════════════════════════════════════════════════════════ #
#    ------                                                                    #

DEL_LINE 			= \033[2K
ITALIC 				= \033[3m
BOLD 				= \033[1m
DEF_COLOR 			= \033[0;39m
GRAY 				= \033[0;90m
RED 				= \033[0;91m
GREEN 				= \033[0;92m
YELLOW 				= \033[0;93m
BLUE 				= \033[0;94m
MAGENTA 			= \033[0;95m
CYAN 				= \033[0;96m
WHITE 				= \033[0;97m
BLACK 				= \033[0;99m
ORANGE 				= \033[38;5;209m
BROWN 				= \033[38;2;184;143;29m
DARK_GRAY 			= \033[38;5;234m
MID_GRAY 			= \033[38;5;245m
DARK_GREEN 			= \033[38;2;75;179;82m
DARK_YELLOW 		= \033[38;5;143m

# ══ Compilation══════════════════════════════════════════════════════════════ #
#    -----------                                                               #

CC					= gcc
AR					= ar rcs
NASM				= nasm
RM					= rm -f
MKD					= mkdir -p

# ══ Directories ═════════════════════════════════════════════════════════════ #
#    -----------                                                               #

LIBASM_DIR			=libasm
OBJ_DIR				=obj
SRC_DIR				=src
INC_DIR				=includes

# ══ Bonus Directories ═══════════════════════════════════════════════════════ #
#    -----------------                                                         #

LIBASM_BONUS_DIR	=libasm_bonus

# ══ Flags ═══════════════════════════════════════════════════════════════════ #
#    -----                                                                     #

CFLAGS 				= -Wall -Werror -Wextra
IFLAGS				= -I${INC_DIR}

# ══ Flags Bonus══════════════════════════════════════════════════════════════ #
#    -----------                                                               #


# ══ Sources ═════════════════════════════════════════════════════════════════ #
#    -------                                                                   #

ASM_SRC 			= $(LIBASM_DIR)/ft_strlen.s \
						$(LIBASM_DIR)/ft_strcpy.s \
						$(LIBASM_DIR)/ft_strcmp.s \
						$(LIBASM_DIR)/ft_write.s \
						$(LIBASM_DIR)/ft_read.s \
						$(LIBASM_DIR)/ft_strdup.s

# ══ Sources Bonus ═══════════════════════════════════════════════════════════ #
#    -------------                                                             #

ASM_BONUS_SRC 		= $(LIBASM_BONUS_DIR)/ft_atoi_base.s \
						$(LIBASM_BONUS_DIR)/ft_list_push_front.s \
						$(LIBASM_BONUS_DIR)/ft_list_size.s \
						$(LIBASM_BONUS_DIR)/ft_list_sort.s \
						$(LIBASM_BONUS_DIR)/ft_list_remove_if.s

# ══ Objects ═════════════════════════════════════════════════════════════════ #
#    -------	                                                               #ç
OBJ_SRC				= $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
OBJ_ASM				= $(OBJ_DIR)/ft_strlen.o \
						$(OBJ_DIR)/ft_strcpy.o \
						$(OBJ_DIR)/ft_strcmp.o \
						$(OBJ_DIR)/ft_write.o \
						$(OBJ_DIR)/ft_read.o \
						$(OBJ_DIR)/ft_strdup.o
OBJ_BONUS			= $(patsubst $(LIBASM_BONUS_DIR)/%.s,$(OBJ_DIR)/%.o,$(ASM_BONUS_SRC))

# ═══ Rules ══════════════════════════════════════════════════════════════════ #
#     -----                                                                    #

all: ${NAME}

${NAME}: $(OBJ_DIR) pre_build $(OBJ_ASM)
	@echo ""
	@echo "$(YELLOW)Creating static library ${NAME}...$(DEF_COLOR)"
	@${AR} ${NAME} $(OBJ_ASM)
	@echo ""
	@echo "$(GREEN)${NAME} created successfully ✓$(DEF_COLOR)"
	@echo ""

pre_build:
	@echo ""

bonus_separator:
	@echo ""

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(OBJ_DIR)
	@echo "$(CYAN)Compiling $<...$(DEF_COLOR)"
	@$(CC) $(CFLAGS) $(IFLAGS) -c $< -o $@
$(OBJ_DIR)/%.o: $(LIBASM_DIR)/%.s $(OBJ_DIR)
	@echo "$(CYAN)Assembling $<...$(DEF_COLOR)"
	@sed 's/^#/;/g' $< > $<.tmp
	@$(NASM) -f elf64 $<.tmp -o $@
	@rm $<.tmp
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s $(OBJ_DIR)
	@echo "$(CYAN)Assembling $<...$(DEF_COLOR)"
	@sed 's/^#/;/g' $< > $<.tmp
	@$(NASM) -f elf64 $<.tmp -o $@
	@rm $<.tmp
$(OBJ_DIR)/malloc_wrapper.o: $(SRC_DIR)/malloc_wrapper.S $(OBJ_DIR)
	@echo "$(CYAN)Compiling GAS assembly $<...$(DEF_COLOR)"
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/errno_helper.o: $(SRC_DIR)/errno_helper.S $(OBJ_DIR)
	@echo "$(CYAN)Compiling GAS assembly $<...$(DEF_COLOR)"
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S $(OBJ_DIR)
	@echo "$(CYAN)Compiling assembly $<...$(DEF_COLOR)"
	@$(CC) $(CFLAGS) -c $< -o $@
$(OBJ_DIR)/%.o: $(LIBASM_BONUS_DIR)/%.s $(OBJ_DIR)
	@echo "$(CYAN)Assembling $<...$(DEF_COLOR)"
	@sed 's/^#/;/g' $< > $<.tmp
	@$(NASM) -f elf64 $<.tmp -o $@
	@rm $<.tmp
$(OBJ_DIR):
	@$(MKD) $(OBJ_DIR)

# ══ Rules Bonus ═════════════════════════════════════════════════════════════ #
#    -----------                                                               #

bonus: ${NAME} $(OBJ_BONUS)
	@echo ""
	@echo "$(YELLOW)Adding bonus objects to ${NAME}...$(DEF_COLOR)"
	@${AR} ${NAME} $(OBJ_ASM) $(OBJ_BONUS)
	@echo "$(GREEN)${NAME} updated with bonus ✓$(DEF_COLOR)"
	@echo ""
	
# ══ Rules Test ══════════════════════════════════════════════════════════════ #
#    -----------                                                               #

test: ${NAME} $(OBJ_BONUS) $(OBJ_DIR)/malloc_wrapper.o $(OBJ_DIR)/errno_helper.o
	@${RM} test
	@echo "$(YELLOW)Linking test binary (mandatory + bonus objects)...$(DEF_COLOR)"
	@${CC} ${CFLAGS} ${IFLAGS} -o test $(SRC_DIR)/main.c ${NAME} $(OBJ_BONUS) $(OBJ_DIR)/malloc_wrapper.o $(OBJ_DIR)/errno_helper.o
	@echo "$(GREEN)test binary created! $(DEF_COLOR)"
	@echo ""

# ══ Cleaning rules ══════════════════════════════════════════════════════════════ #
#    -----------                                                               #

clean:
	@echo ""
	@echo "$(YELLOW)Removing object files ...$(DEF_COLOR)"
	@${RM} -r ${OBJ_DIR}
	@echo "$(RED)Object files removed $(DEF_COLOR)"
	@echo ""

fclean:	clean
	@echo "$(YELLOW)Removing binaries ...$(DEF_COLOR)"
	@${RM} ${NAME}
	@echo "$(RED)Binaries removed $(DEF_COLOR)"
	@echo ""

re:	fclean all

.PHONY : all clean fclean bonus re test pre_build bonus_separator
