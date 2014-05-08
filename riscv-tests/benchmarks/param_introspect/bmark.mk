#=======================================================================
# UCB CS250 Makefile fragment for benchmarks
#-----------------------------------------------------------------------
#
# Each benchmark directory should have its own fragment which
# essentially lists what the source files are and how to link them
# into an riscv and/or host executable. All variables should include
# the benchmark name as a prefix so that they are unique.
#

param_introspect_c_src = \
	param_introspect.c \
	syscalls.c \

param_introspect_riscv_src = \
	crt.S \

param_introspect_c_objs     = $(patsubst %.c, %.o, $(param_introspect_c_src))
param_introspect_riscv_objs = $(patsubst %.S, %.o, $(param_introspect_riscv_src))

param_introspect_host_bin = param_introspect.host
$(param_introspect_host_bin): $(param_introspect_c_src)
	$(HOST_COMP) $^ -o $(param_introspect_host_bin)

param_introspect_riscv_bin = param_introspect.riscv
$(param_introspect_riscv_bin): $(param_introspect_c_objs) $(param_introspect_riscv_objs)
	$(RISCV_LINK) $(param_introspect_c_objs) $(param_introspect_riscv_objs) -o $(param_introspect_riscv_bin) $(RISCV_LINK_OPTS)

junk += $(param_introspect_c_objs) $(param_introspect_riscv_objs) \
        $(param_introspect_host_bin) $(param_introspect_riscv_bin)
