#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

lsu_failures_c_src = \
	lsu_failures.c \
	syscalls.c \

lsu_failures_riscv_src = \
	crt.S \

lsu_failures_c_objs     = $(patsubst %.c, %.o, $(lsu_failures_c_src))
lsu_failures_riscv_objs = $(patsubst %.S, %.o, $(lsu_failures_riscv_src))

lsu_failures_host_bin = lsu_failures.host
$(lsu_failures_host_bin): $(lsu_failures_c_src)
	$(HOST_COMP) $^ -o $(lsu_failures_host_bin)

lsu_failures_riscv_bin = lsu_failures.riscv
$(lsu_failures_riscv_bin): $(lsu_failures_c_objs) $(lsu_failures_riscv_objs)
	$(RISCV_LINK) $(lsu_failures_c_objs) $(lsu_failures_riscv_objs) -o $(lsu_failures_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(lsu_failures_c_objs) $(lsu_failures_riscv_objs) \
        $(lsu_failures_host_bin) $(lsu_failures_riscv_bin)
