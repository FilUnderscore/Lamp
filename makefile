dd = dd
asm = nasm
gcc = x86_64-elf-gcc

BUILD_DIR = bin
SRC_DIR = src

TARGET_DIST = lamp.bin

OBJ_DIR = obj
OBJ_DIR_LIST = $(shell find $(SRC_DIR) -maxdepth 100 -type d)

OBJ_DL = $(OBJ_DIR_LIST:%=$(OBJ_DIR)/%)

SRC = $(shell find $(SRC_DIR) -iname '*.c' -o -iname '*.cpp' -o -iname '*.asm')
#OBJ = $(patsubst $(SRC_DIR)/%.asm, $(OBJ_DIR)/%.o, $(SRC))
#OBJ += $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))
OBJ := $(SRC:%=$(OBJ_DIR)/%.o)

DEP = $(OBJ:.o=.d)

INC_DIRS = include
INC_FLAGS = $(addprefix -I,$(INC_DIRS))

RM=rm

MKDIR_P=mkdir -p

all: $(OBJ_DL) $(BUILD_DIR)/$(TARGET_DIST)

$(BUILD_DIR)/$(TARGET_DIST): $(OBJ)
	$(MKDIR_P) $(BUILD_DIR)

	$(gcc) -lgcc -Tlinker.ld -nostdlib -ffreestanding $^ -o kernel.bin

	$(asm) -f bin boot.asm -o boot.bin

	$(dd) if=/dev/zero of=$@ bs=512 count=32
	$(dd) if="boot.bin" of=$@ seek=0 conv=notrunc
	$(dd) if="kernel.bin" of=$@ seek=1 conv=notrunc

$(OBJ_DIR)/%.o: %
	@if [ $(suffix $<) = '.c' ]; then $(gcc) -c $< -o $@ -ffreestanding -nostdlib -nostdinc -fno-builtin -fno-stack-protector -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Wall -Wextra -Werror; fi;
	@if [ $(suffix $<) = '.asm' ]; then $(asm) -f elf64 $< -o $@; fi;
#ifeq ($(suffix $<), .cpp)
#	$(gcc) -c $< -o $@ -ffreestanding -nostdlib -nostdinc -fno-builtin -fno-stack-protector -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Wall -Wextra -Werror
#endif
#ifeq ($(suffix $<), .asm)
#	$(asm) -f elf64 $< -o $@
#endif

$(OBJ_DL):
	$(MKDIR_P) $@

clean:
	$(RM) -r $(OBJ_DIR)
	$(RM) -r $(BUILD_DIR)

-include $(DEP)
