# ══ Names ═══════════════════════════════════════════════════════════════════ #
#    -----                                                                     #

NAME 				= libasm

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

CC 					= clang
AR 					= ar rcs
RM 					= rm -f
MK 					= make -C
MKD					= mkdir -p
MCL 				= make clean -C
MFCL 				= make fclean -C
MK_					= && make

# ══ Directories ═════════════════════════════════════════════════════════════ #
#    -----------                                                               #

LIBASM_DIR			= ./libasm
OBJ_DIR				= ./obj 
SRC_DIR				= ./src
INC_DIR				= ./includes
UTILS_DIR			= ./utils

# ══ Bonus Directories ═══════════════════════════════════════════════════════ #
#    -----------------                                                         #

SRC_BONUS_DIR		= ./src_bonus
INCLUDES_BONUS_DIR	= ./includes_bonus

# ══ Flags ═══════════════════════════════════════════════════════════════════ #
#    -----                                                                     #

CFLAGS 				= -Wall -Werror -Wextra
IFLAGS				= -I${INCLUDES_DIR}

# ══ Flags Bonus══════════════════════════════════════════════════════════════ #
#    -----------                                                               #

IFLAGS_BONUS		= -I${INCLUDES_BONUS_DIR}


# ══ Sources ═════════════════════════════════════════════════════════════════ #
#    -------                                                                   #

SRC 				= ${SRC_DIR}/main.c









OBJ_SRC				= $(patsubst ${SRC_DIR}/%.c, ${OBJ_DIR}/%.o, ${SRC})
OBJ_ERR				= $(patsubst ${ERRORS_DIR}/%.c, ${OBJ_DIR}/%.o, ${ERR})
OBJ_INT				= $(patsubst ${INIT_DIR}/%.c, ${OBJ_DIR}/%.o, ${INT})
OBJ_MOV				= $(patsubst ${MOVES_DIR}/%.c, ${OBJ_DIR}/%.o, ${MOV})
OBJ_SRT				= $(patsubst ${SORTS_DIR}/%.c, ${OBJ_DIR}/%.o, ${SRT})
OBJ_UTL				= $(patsubst ${UTILS_DIR}/%.c, ${OBJ_DIR}/%.o, ${UTL})

# ══ Sources Bonus ═══════════════════════════════════════════════════════════ #
#    -------------                                                             #

SRC_BONUS			= ${SRC_BONUS_DIR}/checker_bonus.c
GNL_BONUS			= ${GNL_BONUS_DIR}/get_next_line_bonus.c \
						${GNL_BONUS_DIR}/get_next_line_utils_bonus.c

OBJ_SRC_BONUS		= $(patsubst ${SRC_BONUS_DIR}/%.c, ${OBJ_DIR}/%.o, \
						${SRC_BONUS})
OBJ_GNL_BONUS		= $(patsubst ${GNL_BONUS_DIR}/%.c, ${OBJ_DIR}/%.o, \
						${GNL_BONUS})

# ═══ Rules ══════════════════════════════════════════════════════════════════ #
#     -----                                                                    #

all: ${NAME}

${NAME}: ftlibft ftprintf ftexamft ${OBJ_SRC} ${OBJ_ERR} ${OBJ_INT} \
									${OBJ_MOV} ${OBJ_SRT} ${OBJ_UTL}
	@echo "$(YELLOW)Compiling root ...$(DEF_COLOR)"
	@${CC} ${CFLAGS} ${IFLAGS} -o ${NAME} ${OBJ_SRC} ${OBJ_ERR} ${OBJ_INT} \
									${OBJ_MOV} ${OBJ_SRT} ${OBJ_UTL} ${LFLAGS}
	@echo "$(GREEN) $(NAME) all created ✓$(DEF_COLOR)"

${OBJ_DIR}/%.o: ${SRC_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

${OBJ_DIR}/%.o: ${ERRORS_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

${OBJ_DIR}/%.o: ${INIT_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

${OBJ_DIR}/%.o: ${MOVES_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

${OBJ_DIR}/%.o: ${SORTS_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

${OBJ_DIR}/%.o: ${UTILS_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

ftlibft:
	@cd ${LIBFT_DIR} ${MK_} all

ftprintf:
	@cd ${PRINTFT_DIR} ${MK_} all

ftexamft:
	@cd ${EXAMFT_DIR} ${MK_} all

bonus: ${NAME_BONUS}

${NAME_BONUS}: ftlibft ftprintf ftexamft ${OBJ_ERR} ${OBJ_INT} \
											${OBJ_MOV} ${OBJ_SRT} ${OBJ_UTL} \
											${OBJ_SRC_BONUS} ${OBJ_GNL_BONUS}
	@echo "$(YELLOW)Compiling root ...$(DEF_COLOR)"
	@${CC} ${CFLAGS} ${IFLAGS} ${IFLAGS_BONUS} -o ${NAME_BONUS} \
			${OBJ_ERR} ${OBJ_INT} ${OBJ_MOV} ${OBJ_SRT} ${OBJ_UTL} \
			${OBJ_SRC_BONUS} ${OBJ_GNL_BONUS} ${LFLAGS} ${IFLAGS_BONUS}
	@echo "$(GREEN) $(NAME_BONUS) all created ✓$(DEF_COLOR)"

${OBJ_DIR}/%.o: ${SRC_BONUS_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

${OBJ_DIR}/%.o: ${GNL_BONUS_DIR}/%.c
	@${MKD} $(dir $@)
	@$(CC) ${CFLAGS} ${IFLAGS} -c $< -o $@

clean:
	@echo "$(YELLOW)Removing object files ...$(DEF_COLOR)"

	@cd ${LIBFT_DIR} ${MK_} clean
	@cd ${PRINTFT_DIR} ${MK_} clean
	@cd ${EXAMFT_DIR} ${MK_} clean
	@$(RM) ${OBJ_DIR}/*.o

	@echo "$(RED)Object files removed $(DEF_COLOR)"

fclean:	clean
	@echo "$(YELLOW)Removing binaries ...$(DEF_COLOR)"

	@cd ${LIBFT_DIR} ${MK_} fclean
	@cd ${PRINTFT_DIR} ${MK_} fclean
	@cd ${EXAMFT_DIR} ${MK_} fclean
	@${RM} ${NAME} ${NAME_BONUS}

	@echo "$(RED)Binaries removed $(DEF_COLOR)"

re:	fclean all

.PHONY : all ftlibft ftprintf ftexamft clean fclean bonus re