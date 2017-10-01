################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../file/elf/architecture/x32/elf_32.cpp \
../file/elf/architecture/x32/elf_header_32.cpp \
../file/elf/architecture/x32/elf_program_header_32.cpp 

OBJS += \
./file/elf/architecture/x32/elf_32.o \
./file/elf/architecture/x32/elf_header_32.o \
./file/elf/architecture/x32/elf_program_header_32.o 

CPP_DEPS += \
./file/elf/architecture/x32/elf_32.d \
./file/elf/architecture/x32/elf_header_32.d \
./file/elf/architecture/x32/elf_program_header_32.d 


# Each subdirectory must supply rules for building sources it contributes
file/elf/architecture/x32/%.o: ../file/elf/architecture/x32/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


