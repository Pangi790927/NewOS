
NAME := bootloader

all: $(NAME)

$(NAME):%:%.asm video.asm
	dd if=/dev/zero of=$(NAME).tmp bs=64M count=1	
	nasm -f bin $< -o $@
	dd conv=notrunc if=$(NAME) of=$(NAME).tmp
	mv $(NAME).tmp $(NAME)

clean:
	rm -f $(NAME)
