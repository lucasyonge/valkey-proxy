CC      = gcc
CFLAGS  = -O2 -Wall -Wextra -Isrc -pthread
LDFLAGS = -pthread
TARGET  = valkey_cluster_proxy
SRC     = src
OBJS    = $(SRC)/valkey_proxy.o $(SRC)/fanout_handlers.o $(SRC)/ae.o $(SRC)/allowed_cmds.o

# TLS support (client ↔ proxy). Disable with: make NO_TLS=1
ifeq ($(NO_TLS),)
OPENSSL_PREFIX ?= $(shell brew --prefix openssl 2>/dev/null || echo /usr)
CFLAGS  += -DUSE_TLS -I$(OPENSSL_PREFIX)/include
LDFLAGS += -L$(OPENSSL_PREFIX)/lib -lssl -lcrypto
endif

POOL_CC      = gcc
POOL_CFLAGS  = -O2 -Wall -Wextra -Isrc -pthread
POOL_LDFLAGS = -pthread

# TLS support for client connections (disable with: make valkey-proxy NO_TLS=1)
ifeq ($(NO_TLS),)
OPENSSL_PREFIX ?= $(shell brew --prefix openssl 2>/dev/null || echo /usr)
POOL_CFLAGS  += -DUSE_TLS -I$(OPENSSL_PREFIX)/include
POOL_LDFLAGS += -L$(OPENSSL_PREFIX)/lib -lssl -lcrypto
endif

POOL_TARGET = valkey-proxy
POOL_SRCS   = src/valkey-proxy.c src/config.c src/cluster.c src/resp.c \
              src/pool.c src/cmd.c src/fanout.c src/pubsub.c src/acl.c src/client.c \
              src/hello.c src/event_loop.c
POOL_HDEPS  = src/proxy.h src/event_loop.h src/el_epoll.c src/el_kqueue.c \
              src/el_evport.c src/el_select.c

$(POOL_TARGET): $(POOL_SRCS) $(POOL_HDEPS)
	$(POOL_CC) $(POOL_CFLAGS) -o $@ $(POOL_SRCS) $(POOL_LDFLAGS)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)

$(SRC)/valkey_proxy.o: $(SRC)/valkey_proxy.c $(SRC)/valkey_proxy.h $(SRC)/fanout_handlers.h $(SRC)/ae.h
	$(CC) $(CFLAGS) -c $(SRC)/valkey_proxy.c -o $@

$(SRC)/allowed_cmds.o: $(SRC)/allowed_cmds.c $(SRC)/allowed_cmds.h
	$(CC) $(CFLAGS) -c $(SRC)/allowed_cmds.c -o $@

$(SRC)/fanout_handlers.o: $(SRC)/fanout_handlers.c $(SRC)/fanout_handlers.h $(SRC)/valkey_proxy.h
	$(CC) $(CFLAGS) -c $(SRC)/fanout_handlers.c -o $@

# ae.c #include's ae_epoll.c (Linux) or ae_kqueue.c (macOS/BSD) at compile time
$(SRC)/ae.o: $(SRC)/ae.c $(SRC)/ae.h $(SRC)/ae_epoll.c $(SRC)/ae_kqueue.c $(SRC)/valkey_proxy.h
	$(CC) $(CFLAGS) -c $(SRC)/ae.c -o $@

# ── integration tests ────────────────────────────────────────────────────
TEST_CC     = gcc
TEST_CFLAGS = -O0 -g -Wall -Wextra -Itest -pthread

TEST_SRCS = test/run-test.c test/acl/test_acl.c test/acl/acl_fixture.c test/bitmap/test_bitmap.c \
            test/blocking/test_blocking.c \
            test/general/test_general.c test/hash/test_hash.c \
            test/geospatial/test_geospatial.c \
            test/hyperloglog/test_hyperloglog.c \
            test/list/test_list.c \
            test/pubsub/test_pubsub.c \
            test/script/test_script.c \
            test/function/test_function.c \
            test/set/test_set.c \
            test/stream/test_stream.c \
            test/string/test_string.c \
            test/zset/test_zset.c \
            test/resp3/test_resp3.c \
            test/modules/bloomfilter/test_bloomfilter.c \
            test/modules/json/test_json.c \
            test/modules/search/test_search.c

run-test: $(TEST_SRCS) test/test_common.h
	$(TEST_CC) $(TEST_CFLAGS) -o run-test $(TEST_SRCS)

# Usage: make test && ./run-test -h=<host> -p=<port>
test: run-test

clean:
	rm -f $(OBJS) $(TARGET) $(POOL_TARGET) run-test

# ── formatting ───────────────────────────────────────────────────────────
FORMAT_SRCS = $(shell find src test -name '*.[ch]')

format:
	clang-format -i $(FORMAT_SRCS)

format-check:
	clang-format --dry-run --Werror $(FORMAT_SRCS)

.PHONY: clean test format format-check

