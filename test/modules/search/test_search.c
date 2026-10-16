#include "test_common.h"

void run_search_tests(const char *host, int port, int *pass, int *fail) {
    printf("\n=== Search (FT.*) Tests ===\n");

    int fd = proxy_connect(host, port);
    if (fd < 0) {
        printf("  [FAIL] Cannot connect to proxy at %s:%d\n", host, port);
        (*fail)++;
        return;
    }

    char r[512];
    const char *idx = "tc:ft:idx";

    proxy_cmd(fd, r, sizeof(r), 1, "FLUSHDB");
    /* clean up a stale index left over from a previous failed run; result
     * (+OK or -ERR no such index) is irrelevant, just don't assert on it */
    proxy_cmd(fd, r, sizeof(r), 2, "FT.DROPINDEX", idx);

    /* ── FT._LIST (before creation) ─────────────────────────────────────── */

    proxy_cmd(fd, r, sizeof(r), 1, "FT._LIST");
    CHECK(r[0] == '*', "FT._LIST: returns an array", pass, fail);
    {
        int n = (r[0] == '*') ? atoi(r + 1) : 0;
        int had = (n > 0) ? resp_array_contains(fd, n, idx) : 0;
        CHECK(!had, "FT._LIST: index not present before FT.CREATE", pass, fail);
    }

    /* ── FT.CREATE ───────────────────────────────────────────────────────── */

    proxy_cmd(fd, r, sizeof(r), 10, "FT.CREATE", idx, "ON", "HASH", "PREFIX", "1", "doc:", "SCHEMA", "title", "TEXT");
    CHECK(strcmp(r, "+OK") == 0, "FT.CREATE: creates index on HASH docs with a TEXT field", pass, fail);

    /* every master must report OK for the aggregation to say OK; recreating
     * the same index name must surface as an error, not be swallowed */
    proxy_cmd(fd, r, sizeof(r), 10, "FT.CREATE", idx, "ON", "HASH", "PREFIX", "1", "doc:", "SCHEMA", "title", "TEXT");
    CHECK(r[0] == '-', "FT.CREATE: duplicate index name returns an error", pass, fail);

    /* ── FT._LIST (after creation) ──────────────────────────────────────── */

    proxy_cmd(fd, r, sizeof(r), 1, "FT._LIST");
    CHECK(r[0] == '*', "FT._LIST: returns an array", pass, fail);
    {
        int n = (r[0] == '*') ? atoi(r + 1) : 0;
        int had = (n > 0) ? resp_array_contains(fd, n, idx) : 0;
        CHECK(had, "FT._LIST: index present after FT.CREATE", pass, fail);
    }

    /* ── FT.INFO ─────────────────────────────────────────────────────────── */

    resp_send(fd, 2, "FT.INFO", idx);
    {
        char line[256];
        read_line(fd, line, sizeof(line));
        if (line[0] == '*') {
            int n = atoi(line + 1);
            for (int i = 0; i < n; i++) resp_skip_reply(fd);
            CHECK(1, "FT.INFO: returns an array reply for an existing index", pass, fail);
        } else {
            if (line[0] == '$') {
                int n = atoi(line + 1);
                if (n > 0) {
                    char tmp[1024];
                    read_exact(fd, tmp, n + 2);
                }
            }
            CHECK(0, "FT.INFO: returns an array reply for an existing index", pass, fail);
        }
    }

    /* ── seed data, then FT.SEARCH ──────────────────────────────────────── */

    proxy_cmd(fd, r, sizeof(r), 4, "HSET", "doc:1", "title", "hello world");
    proxy_cmd(fd, r, sizeof(r), 4, "HSET", "doc:2", "title", "hello there");

    resp_send(fd, 3, "FT.SEARCH", idx, "hello");
    {
        char line[256];
        read_line(fd, line, sizeof(line));
        long long total_results = -1;
        if (line[0] == '*') {
            int n = atoi(line + 1);
            if (n >= 1) {
                char cline[64];
                read_line(fd, cline, sizeof(cline));
                if (cline[0] == ':') total_results = atoll(cline + 1);
                for (int i = 1; i < n; i++) resp_skip_reply(fd);
            }
        }
        CHECK(total_results >= 1, "FT.SEARCH: finds at least one matching document across the cluster", pass, fail);
    }

    /* ── FT.DROPINDEX ────────────────────────────────────────────────────── */

    proxy_cmd(fd, r, sizeof(r), 2, "FT.DROPINDEX", idx);
    CHECK(strcmp(r, "+OK") == 0, "FT.DROPINDEX: drops an existing index", pass, fail);

    proxy_cmd(fd, r, sizeof(r), 2, "FT.DROPINDEX", idx);
    CHECK(r[0] == '-', "FT.DROPINDEX: dropping an already-dropped index returns an error", pass, fail);

    close(fd);
}
