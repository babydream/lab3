#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

bubble_c_src = \
	bubble.c \
	syscalls.c \

bubble_riscv_src = \
	crt.S \

bubble_c_objs     = $(patsubst %.c, %.o, $(bubble_c_src))
bubble_riscv_objs = $(patsubst %.S, %.o, $(bubble_riscv_src))

bubble_host_bin = bubble.host
$(bubble_host_bin): $(bubble_c_src)
	$(HOST_COMP) $^ -o $(bubble_host_bin)

bubble_riscv_bin = bubble.riscv
$(bubble_riscv_bin): $(bubble_c_objs) $(bubble_riscv_objs)
	$(RISCV_LINK) $(bubble_c_objs) $(bubble_riscv_objs) \
    -o $(bubble_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(bubble_c_objs) $(bubble_riscv_objs) \
        $(bubble_host_bin) $(bubble_riscv_bin)
