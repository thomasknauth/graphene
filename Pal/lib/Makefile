include ../../Makefile.configs
include ../../Makefile.rules
include ../src/Makefile.Host

CFLAGS	= -Wall -fPIC -O2 -std=gnu99 -fgnu89-inline -U_FORTIFY_SOURCE \
	  $(call cc-option,-Wnull-dereference) \
	  -fno-omit-frame-pointer \
	  -fno-stack-protector -fno-builtin
ARFLAGS	=

include ../src/host/$(PAL_HOST)/Makefile.am

CFLAGS += -I. -I../include -I../src

# Include host_endian.h from either the host-specific directory,
# or directly under the target directory.
ifeq ($(target),)
CFLAGS += -I../src/host/$(PAL_HOST)
else
CFLAGS += -I$(target)
endif

subdirs = string stdlib network graphene util crypto

# Choose Crypto provider among (mbedtls|wolfssl)
CRYPTO_PROVIDER ?= mbedtls

# Select which crypto adpater you want to use here. This has to match
# the #define in pal_crypto.h.
#
# Unfortunately, we cannot use just one .c file for the adapter. The LibOS
# shim links against the crypto library, but it doesn't use Diffie-Hellman.
# If the Diffie-Hellman stubs are in the same .o file as the SHA1 stubs,
# this pulls Diffie-Hellman code into LibOS shim, resulting in unsatisfied
# symbols.
ifeq ($(CRYPTO_PROVIDER),mbedtls)
subdirs += crypto/mbedtls
endif
ifeq ($(CRYPTO_PROVIDER),wolfssl)
subdirs += crypto/wolfssl
endif

objs	= $(foreach dir,$(subdirs),$(patsubst %.c,%.o,$(wildcard $(dir)/*.c)))

ifeq ($(CRYPTO_PROVIDER),mbedtls)
CFLAGS += -DCRYPTO_USE_MBEDTLS
objs += crypto/adapters/mbedtls_adapter.o
objs += crypto/adapters/mbedtls_dh.o
endif
ifeq ($(CRYPTO_PROVIDER),wolfssl)
CFLAGS += -DCRYPTO_USE_WOLFSSL
objs += crypto/adapters/wolfssl_adapter.o
objs += crypto/adapters/wolfssl_dh.o
endif

.PHONY: all
all: $(target)graphene-lib.a

ifeq ($(DEBUG),1)
CC += -g
CFLAGS += -DDEBUG
endif

$(target)graphene-lib.a: $(addprefix $(target),$(objs))
	@mkdir -p $(dir $@)
	$(call cmd,ar_a_o)

$(target)%.o: %.c
	@mkdir -p $(dir $@)
	$(call cmd,cc_o_c)

-include $(patsubst %.o,%.d,$(addprefix $(target),$(objs)))

.PHONY: clean
clean:
	rm -f $(objs) graphene-lib.a
