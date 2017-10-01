################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../file/elf/architecture/x64/elf_64.cpp \
../file/elf/architecture/x64/elf_header_64.cpp \
../file/elf/architecture/x64/elf_program_header_64.cpp 

OBJS += \
./file/elf/architecture/x64/elf_64.o \
./file/elf/architecture/x64/elf_header_64.o \
./file/elf/architecture/x64/elf_program_header_64.o 

CPP_DEPS += \
./file/elf/architecture/x64/elf_64.d \
./file/elf/architecture/x64/elf_header_64.d \
./file/elf/architecture/x64/elf_program_header_64.d 


# Each subdirectory must supply rules for building sources it contributes
file/elf/architecture/x64/%.o: ../file/elf/architecture/x64/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


