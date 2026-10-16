# Supported Features and Commands

## 1. Six ways a command can be handled

| Handling | Description |
|---|---|
| **Single-key routing** | Compute `CRC16(key)` to find the slot, forward to that node, streaming the raw bytes through unparsed |
| **Multi-key (same-slot check)** | Extract every key in the command; if they don't all hash to the same slot, return `-CROSSSLOT` immediately, otherwise forward like a single-key command |
| **Multi-key fan-out** | Split the command per key into several sub-commands sent to their respective nodes, then merge the replies |
| **No-key broadcast** | Broadcast to every primary node and merge the replies |
| **Single-node forward** | Pick one master node, forward the command, and relay its reply verbatim (no broadcast, no merging) |
| **Local reply** | The proxy builds the reply itself, with no backend request at all |

The list below covers every supported command.

## 2. Supported command list 

### 2.1 Bitmap

| Command | Notes |
|---|---|
| `BITCOUNT` | |
| `BITFIELD` | |
| `BITFIELD_RO` | |
| `BITOP` | The destkey and every srckey must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend|
| `BITPOS` | |
| `GETBIT` | |
| `SETBIT` | |

### 2.2 Connection

| Command | Notes |
|---|---|
| `AUTH` | |
| `CLIENT GETNAME` | Answered by proxy |
| `CLIENT HELP` | Answered by proxy |
| `CLIENT ID` | Answered by proxy |
| `CLIENT INFO` | Answered by proxy |
| `CLIENT KILL` | Planned |
| `CLIENT LIST` | Planned |
| `CLIENT SETNAME` | Stored on the proxy only, never sent to a backend |
| `ECHO` | Answered by proxy |
| `HELLO` | |
| `PING` | Answered by proxy |
| `RESET` | Planned |

### 2.3 Generic

| Command | Notes |
|---|---|
| `COPY` | The source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `DEL` | Fanned out per key to each owning node |
| `DUMP` | |
| `EXISTS` | Fanned out per key to each owning node |
| `EXPIRE` | |
| `EXPIREAT` | |
| `EXPIRETIME` | |
| `KEYS` | Broadcast to every primary node; results concatenated |
| `OBJECT ENCODING` | |
| `OBJECT FREQ` | |
| `OBJECT HELP` | Forwarded to a single primary node |
| `OBJECT IDLETIME` | |
| `OBJECT REFCOUNT` | |
| `PERSIST` | |
| `PEXPIRE` | |
| `PEXPIREAT` | |
| `PEXPIRETIME` | |
| `PTTL` | |
| `RANDOMKEY` | Forwarded to a single primary node |
| `RENAME` | The source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `RENAMENX` | The source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `RESTORE` | |
| `SCAN` | Broadcast to every primary node; each node's cursor is encoded into the returned cursor |
| `SORT` | |
| `SORT_RO` | |
| `TOUCH` | Fanned out per key to each owning node |
| `TTL` | |
| `TYPE` | |
| `UNLINK` | Fanned out per key to each owning node |

### 2.4 Geospatial Index

| Command | Notes |
|---|---|
| `GEOADD` | |
| `GEODIST` | |
| `GEOHASH` | |
| `GEOPOS` | |
| `GEORADIUS` | With `STORE`/`STOREDIST`, the source key and the store key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `GEORADIUSBYMEMBER` | With `STORE`/`STOREDIST`, the source key and the store key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `GEORADIUSBYMEMBER_RO` | |
| `GEORADIUS_RO` | |
| `GEOSEARCH` | |
| `GEOSEARCHSTORE` | The destination and source keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |

### 2.5 Hash

| Command | Notes |
|---|---|
| `HDEL` | |
| `HEXISTS` | |
| `HEXPIRE` | |
| `HEXPIREAT` | |
| `HEXPIRETIME` | |
| `HGET` | |
| `HGETALL` | |
| `HGETDEL` | |
| `HGETEX` | |
| `HINCRBY` | |
| `HINCRBYFLOAT` | |
| `HKEYS` | |
| `HLEN` | |
| `HMGET` | |
| `HMSET` | |
| `HPERSIST` | |
| `HPEXPIRE` | |
| `HPEXPIREAT` | |
| `HPEXPIRETIME` | |
| `HPTTL` | |
| `HRANDFIELD` | |
| `HSCAN` | |
| `HSET` | |
| `HSETEX` | |
| `HSETNX` | |
| `HSTRLEN` | |
| `HTTL` | |
| `HVALS` | |

### 2.6 HyperLogLog

| Command | Notes |
|---|---|
| `PFADD` | |
| `PFCOUNT` | With multiple keys, every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `PFMERGE` | The destkey and every sourcekey must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |

### 2.7 List

| Command | Notes |
|---|---|
| `BLMOVE` | the source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `BLMPOP` | every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `BLPOP` | every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `BRPOP` | every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `BRPOPLPUSH` | the source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `LINDEX` | |
| `LINSERT` | |
| `LLEN` | |
| `LMOVE` | The source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `LMPOP` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `LPOP` | |
| `LPOS` | |
| `LPUSH` | |
| `LPUSHX` | |
| `LRANGE` | |
| `LREM` | |
| `LSET` | |
| `LTRIM` | |
| `RPOP` | |
| `RPOPLPUSH` | The source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `RPUSH` | |
| `RPUSHX` | |

### 2.8 Pub/Sub

| Command | Notes |
|---|---|
| `PSUBSCRIBE` | |
| `PUBLISH` | |
| `PUBSUB CHANNELS` | Broadcast to every primary node |
| `PUBSUB HELP` | |
| `PUBSUB NUMPAT` | Broadcast to every primary node |
| `PUBSUB NUMSUB` | Broadcast to every primary node |
| `PUBSUB SHARDCHANNELS` | Broadcast to every primary node; Plan not to support later |
| `PUBSUB SHARDNUMSUB` | Broadcast to every primary node; Plan not to support later |
| `PUNSUBSCRIBE` | |
| `SPUBLISH` | Plan not to support later |
| `SSUBSCRIBE` | Plan not to support later |
| `SUBSCRIBE` | |
| `SUNSUBSCRIBE` | |
| `UNSUBSCRIBE` | |

### 2.9 Sorted Set

| Command | Notes |
|---|---|
| `BZMPOP` | every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `BZPOPMAX` | every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `BZPOPMIN` | every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZADD` | |
| `ZCARD` | |
| `ZCOUNT` | |
| `ZDIFF` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZDIFFSTORE` | The destination and every source key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZINCRBY` | |
| `ZINTER` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZINTERCARD` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZINTERSTORE` | The destination and every source key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZLEXCOUNT` | |
| `ZMPOP` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZMSCORE` | |
| `ZPOPMAX` | |
| `ZPOPMIN` | |
| `ZRANDMEMBER` | |
| `ZRANGE` | |
| `ZRANGEBYLEX` | |
| `ZRANGEBYSCORE` | |
| `ZRANGESTORE` | The destination and source keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZRANK` | |
| `ZREM` | |
| `ZREMRANGEBYLEX` | |
| `ZREMRANGEBYRANK` | |
| `ZREMRANGEBYSCORE` | |
| `ZREVRANGE` | |
| `ZREVRANGEBYLEX` | |
| `ZREVRANGEBYSCORE` | |
| `ZREVRANK` | |
| `ZSCAN` | |
| `ZSCORE` | |
| `ZUNION` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `ZUNIONSTORE` | The destination and every source key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |

### 2.10 Set

| Command | Notes |
|---|---|
| `SADD` | |
| `SCARD` | |
| `SDIFF` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SDIFFSTORE` | The destination and every source key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SINTER` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SINTERCARD` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SINTERSTORE` | The destination and every source key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SISMEMBER` | |
| `SMEMBERS` | |
| `SMISMEMBER` | |
| `SMOVE` | The source and destination keys must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SPOP` | |
| `SRANDMEMBER` | |
| `SREM` | |
| `SSCAN` | |
| `SUNION` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `SUNIONSTORE` | The destination and every source key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |

### 2.11 Stream

| Command | Notes |
|---|---|
| `XACK` | |
| `XADD` | |
| `XAUTOCLAIM` | |
| `XCLAIM` | |
| `XDEL` | |
| `XGROUP CREATE` | |
| `XGROUP CREATECONSUMER` | |
| `XGROUP DELCONSUMER` | |
| `XGROUP DESTROY` | |
| `XGROUP HELP` | |
| `XGROUP SETID` | |
| `XINFO CONSUMERS` | |
| `XINFO GROUPS` | |
| `XINFO HELP` | |
| `XINFO STREAM` | |
| `XLEN` | |
| `XPENDING` | |
| `XRANGE` | |
| `XREAD` | Every stream key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `XREADGROUP` | Every stream key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `XREVRANGE` | |
| `XTRIM` | |

### 2.12 String

| Command | Notes |
|---|---|
| `APPEND` | |
| `DECR` | |
| `DECRBY` | |
| `DELEX` | Planned |
| `DELIFEQ` | |
| `GET` | |
| `GETDEL` | |
| `GETEX` | |
| `GETRANGE` | |
| `GETSET` | |
| `INCR` | |
| `INCRBY` | |
| `INCRBYFLOAT` | |
| `LCS` | Fanned out per key to each owning node |
| `MGET` | Fanned out per key to each owning node |
| `MSET` | Fanned out per key to each owning node |
| `MSETEX` | Fanned out per key to each owning node |
| `MSETNX` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `PSETEX` | |
| `SET` | |
| `SETEX` | |
| `SETNX` | |
| `SETRANGE` | |
| `STRLEN` | |
| `SUBSTR` | |

### 2.13 Transaction

| Command | Notes |
|---|---|
| `DISCARD` | Planned |
| `EXEC` | Planned |
| `MULTI` | Planned |
| `UNWATCH` | Planned |
| `WATCH` | Planned |

### 2.14 Scripting and Functions

| Command | Notes |
|---|---|
| `EVAL` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `EVALSHA` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `EVALSHA_RO` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `EVAL_RO` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `FCALL` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `FCALL_RO` | Every key must hash to the same slot, otherwise the proxy returns `-CROSSSLOT` without contacting a backend |
| `FUNCTION DELETE` | Broadcast to every primary node; succeeds only if every node succeeds |
| `FUNCTION FLUSH` | Broadcast to every primary node; the `ASYNC`/`SYNC` argument is ignored (always `ASYNC`), always replies `+OK` |
| `FUNCTION HELP` | Answered by proxy |
| `FUNCTION KILL` | Broadcast to every primary node; succeeds if any node succeeds |
| `FUNCTION LIST` |  |
| `FUNCTION LOAD` | Broadcast to every primary node; succeeds only if every node succeeds |
| `FUNCTION STATS` | Broadcast to every primary node; each node's execution state is reported separately |
| `SCRIPT EXISTS` | Forwarded to one primary node |
| `SCRIPT FLUSH` | Broadcast to every primary node; the `ASYNC`/`SYNC` argument is ignored (always `ASYNC`), always replies `+OK` |
| `SCRIPT HELP` | Answered by proxy |
| `SCRIPT KILL` | Broadcast to every primary node; succeeds if any node succeeds |
| `SCRIPT LOAD` | Broadcast to every primary node so any shard can run the script; only one sha1 is relayed back |
| `SCRIPT SHOW` | Forwarded to one primary node |

### 2.15 Server Management

| Command | Notes |
|---|---|
| `ACL CAT` | Planned |
| `ACL DRYRUN` | Forwarded to one primary node |
| `ACL GETUSER` | Forwarded to one primary node |
| `ACL HELP` | Answered by proxy |
| `ACL LIST` | Forwarded to one primary node |
| `ACL USERS` | Forwarded to one primary node |
| `ACL WHOAMI` | Forwarded to one primary node |
| `COMMAND` | |
| `COMMAND COUNT` | Counts only the commands this proxy supports |
| `COMMAND DOCS` | Forwarded to one primary node; reply filtered to only the commands this proxy supports |
| `COMMAND GETKEYS` | Forwarded to one primary node |
| `COMMAND GETKEYSANDFLAGS` | Forwarded to one primary node |
| `COMMAND HELP` | Forwarded to one primary node |
| `COMMAND INFO` | Forwarded to one primary node; reply filtered to only the commands this proxy supports |
| `COMMAND LIST` | Forwarded to one primary node; reply filtered to only the commands this proxy supports |
| `COMMANDLOG GET` | Broadcast to every primary node |
| `COMMANDLOG HELP` | Forwarded to one primary node |
| `COMMANDLOG LEN` | Broadcast to every primary node |
| `COMMANDLOG RESET` | Broadcast to every primary node |
| `DBSIZE` | Broadcast to every primary node |
| `FLUSHALL` | Broadcast to every primary node |
| `FLUSHDB` | Broadcast to every primary node |
| `INFO` | Planned |
| `LOLWUT` | Forwarded to one primary node |
| `MEMORY USAGE` | |
| `MODULE LIST` | Forwarded to one primary node |
| `MONITOR` | Planned |
| `SLOWLOG GET` | Broadcast to every primary node |
| `SLOWLOG HELP` | Forwarded to one primary node |
| `SLOWLOG LEN` | Broadcast to every primary node |
| `SLOWLOG RESET` | Broadcast to every primary node |
| `TIME` | Answered by proxy |

### 2.16 Bloom Filter

These commands require the Bloom Filter module (valkey-bloom) to be loaded on every backend node; otherwise the backend's "unknown command" error is relayed to the client.

| Command | Notes |
|---|---|
| `BF.ADD` | |
| `BF.CARD` | |
| `BF.EXISTS` | |
| `BF.INFO` | |
| `BF.INSERT` | |
| `BF.MADD` | |
| `BF.MEXISTS` | |
| `BF.RESERVE` | |

### 2.17 JSON

These commands require the JSON module (valkey-json) to be loaded on every backend node; otherwise the backend's "unknown command" error is relayed to the client.

| Command | Notes |
|---|---|
| `JSON.ARRAPPEND` | |
| `JSON.ARRINDEX` | |
| `JSON.ARRINSERT` | |
| `JSON.ARRLEN` | |
| `JSON.ARRPOP` | |
| `JSON.ARRTRIM` | |
| `JSON.CLEAR` | |
| `JSON.DEL` | |
| `JSON.FORGET` | |
| `JSON.GET` | |
| `JSON.MGET` | Fanned out per key to each owning node |
| `JSON.MSET` | Fanned out per key to each owning node |
| `JSON.NUMINCRBY` | |
| `JSON.NUMMULTBY` | |
| `JSON.OBJKEYS` | |
| `JSON.OBJLEN` | |
| `JSON.RESP` | |
| `JSON.SET` | |
| `JSON.STRAPPEND` | |
| `JSON.STRLEN` | |
| `JSON.TOGGLE` | |
| `JSON.TYPE` | |

### 2.18 Search

These commands require the Search module (valkey-search) to be loaded on every backend node; otherwise the backend's "unknown command" error is relayed to the client.

| Command | Notes |
|---|---|
| `FT.AGGREGATE` | Planned |
| `FT.CREATE` | Broadcast to every primary node |
| `FT.CURSOR` | Planned |
| `FT.DROPINDEX` | Broadcast to every primary node |
| `FT.HYBRID` | Planned |
| `FT.INFO` | Forwarded to one primary node |
| `FT.SEARCH` | Broadcast to every primary node |
| `FT._LIST` | Forwarded to one primary node |

## 3. Fan-out command details

These commands are split per key into several sub-commands sent to each key's owning node, then
merged into one reply (`FANOUT_CMDS` in `src/fanout.c`):

| Command | Merge strategy |
|---|---|
| `MGET` `JSON.MGET` | Results reassembled in original key order |
| `MSET` `JSON.MSET` | Broadcast write; returns `+OK` only if every node succeeds |
| `MSETEX key seconds value [...]` | **A proxy-specific extension** (not a native Valkey command); each triplet is translated into its own `SETEX` and dispatched individually |
| `DEL` `EXISTS` `TOUCH` `UNLINK` | Integer results summed across nodes |
| `LCS` | Dispatched per key pair; the proxy recomputes the LCS result itself (not a simple forward) |

> `MSETNX` is **not** a fan-out command — it's a multi-key, same-slot command (all keys must
> share a slot, otherwise `-CROSSSLOT`).

## 4. No-key broadcast / single-node forward command details

### 4.1 Local direct reply (no backend request)
`PING` (replies `+PONG` with no argument, echoes a bulk string with one), `ECHO`, `TIME`, `CLIENT
ID/GETNAME/SETNAME/INFO/HELP`, `SCRIPT HELP`, `FUNCTION HELP`, and the help-text portion of
`ACL HELP`.

### 4.2 Single-node forward (pick one master, relay its reply verbatim)
`RANDOMKEY` `LOLWUT` `FT._LIST` `FT.INFO` `OBJECT HELP` `XGROUP HELP` `XINFO HELP`
`SCRIPT EXISTS/SHOW` `FUNCTION LIST` `MODULE LIST` `COMMAND HELP/GETKEYS/GETKEYSANDFLAGS`
`SLOWLOG HELP` `COMMANDLOG HELP` `PUBSUB HELP` `ACL LIST/USERS/WHOAMI/GETUSER/DRYRUN` (uses the
shared connection while unauthenticated / authenticated as the default user; once a client has
`AUTH`'d as a non-default user, it switches to that client's own dedicated authenticated
connection — see §8)

`COMMAND` (the bare command is equivalent to `COMMAND INFO` with no arguments); the reply to
`COMMAND INFO/DOCS/LIST` is forwarded and then **filtered** down to only the subset of commands
this proxy itself supports before being relayed to the client; `COMMAND COUNT` forwards
`COMMAND LIST` and counts the filtered result; `COMMAND GETKEYS/GETKEYSANDFLAGS` first checks
whether the target command is on the supported list and rejects it outright (without forwarding
anything) if it isn't.

### 4.3 Broadcast to all masters, results merged
`DBSIZE` (summed), `KEYS` (concatenated), `SCAN` (each node's cursor is encoded into the returned
cursor value; scanning proceeds per node and results are reassembled), `FLUSHALL`/`FLUSHDB`
(`+OK` only if every node succeeds), `FT.CREATE`/`FT.DROPINDEX` (`+OK` only if every node
succeeds), `FT.SEARCH` (result sets merged), `PUBSUB CHANNELS`/`SHARDCHANNELS` (deduplicated and
merged), `PUBSUB NUMSUB`/`SHARDNUMSUB` (per-channel counts summed), `PUBSUB NUMPAT` (summed),
`SLOWLOG GET [count]` (each node's entries merged newest first by timestamp and truncated to
`count` — default 10, `-1` = all; entry ids are per-node and so not unique across the merged
reply), `SLOWLOG LEN` (summed), `SLOWLOG RESET` (`+OK` only if every node succeeds), `COMMANDLOG GET <count> <type>`
(merged newest first and truncated to `count`, same as `SLOWLOG GET`; `-1` = all), `COMMANDLOG LEN`
(summed), `COMMANDLOG RESET` (`+OK` only if every node succeeds), `SCRIPT KILL` (succeeds if
**any** node succeeds), `SCRIPT FLUSH [ASYNC|SYNC]` (**the argument is ignored** — always
rewritten as `SCRIPT FLUSH ASYNC` and broadcast, always replies `+OK`), `SCRIPT LOAD` (broadcast
to every node so any shard's subsequent `EVALSHA` can find it; only one sha1 is relayed back),
`FUNCTION KILL` (succeeds if **any** node succeeds), `FUNCTION FLUSH [ASYNC|SYNC]` (same
treatment as `SCRIPT FLUSH` — always `ASYNC`, always `+OK`), `FUNCTION DELETE` (succeeds only if
every node succeeds), `FUNCTION LOAD` (succeeds only if every node succeeds), `FUNCTION STATS`
(each node's execution state is reported separately, not merged).

## 5. Blocking commands

Blocking commands use a separate `POOL_BLOCKING` connection pool (long-lived, kept in blocking
mode) so they don't stall the non-blocking event loop.

| Command | Notes |
|---|---|
| `BLPOP` `BRPOP` | Block until an element is available in any of the listed lists |
| `BLMOVE` `BRPOPLPUSH` | Block until a source list is non-empty, then pop and move one element |
| `BLMPOP` | Block until any of the listed lists is non-empty, then pop one or more elements |
| `BZPOPMIN` `BZPOPMAX` | Block until a member is available in any of the listed sorted sets |
| `BZMPOP` | Block until any of the listed sorted sets is non-empty, then pop one or more members |
| `XREAD ... BLOCK ...` | Block until new entries arrive on the listed streams (only uses the blocking pool when `BLOCK` is present, otherwise takes the ordinary multi-key path) |
| `XREADGROUP ... BLOCK ...` | Same, for a consumer-group read |

## 6. Pub/Sub

`(P|S)SUBSCRIBE` pins the client connection to a dedicated `POOL_SUBSCRIPTION` backend connection
until it unsubscribes; subsequent subscribe/unsubscribe calls on the same client connection reuse
that same pinned connection. `PUBLISH`/`SPUBLISH` need no dedicated connection — they're routed by
channel like an ordinary single-key command.

## 7. Key configuration knobs (`proxy.conf`) at a glance

See the comments in `proxy.conf` at the repo root for the full picture; only the settings that
directly affect command behavior are listed here:

| Setting | Default | Effect |
|---|---|---|
| `min_normal_connection` / `max_normal_connection` | 2 / 20 | Pool used by the vast majority of read/write commands |
| `min_blocking_connection` / `max_blocking_connection` | 2 / 10 | `BLPOP` and other blocking commands |
| `min_subscription_connection` / `max_subscription_connection` | 0 / 10 | Pub/Sub |
| `min_transaction_connection` / `max_transaction_connection` | 0 / 10 | Capacity settings exist for the transaction pool |
| `min_acl_connection` / `max_acl_connection` | 0 / 10 | `ACL`/`AUTH`, plus each authenticated client's dedicated per-node connections |
| `cluster_refresh_interval_ms` | 0 (disabled) | Whether/how often the cluster topology is refreshed in the background |
| `max_connection` | 4000 | Per-worker-thread fd budget (client sockets + backend connections + listener fd(s)) |

## 8. Unsupported commands

| Command | Notes |
|---|---|
| `ASKING` | |
| `CLUSTER ADDSLOTS` | |
| `CLUSTER ADDSLOTSRANGE` | |
| `CLUSTER BUMPEPOCH` | |
| `CLUSTER CANCELSLOTMIGRATIONS` | |
| `CLUSTER COUNT-FAILURE-REPORTS` | |
| `CLUSTER COUNTKEYSINSLOT` | |
| `CLUSTER DELSLOTS` | |
| `CLUSTER DELSLOTSRANGE` | |
| `CLUSTER FAILOVER` | |
| `CLUSTER FLUSHSLOTS` | |
| `CLUSTER FORGET` | |
| `CLUSTER GETKEYSINSLOT` | |
| `CLUSTER GETSLOTMIGRATIONS` | |
| `CLUSTER HELP` | |
| `CLUSTER INFO` | |
| `CLUSTER KEYSLOT` | |
| `CLUSTER LINKS` | |
| `CLUSTER MEET` | |
| `CLUSTER MIGRATESLOTS` | |
| `CLUSTER MYID` | |
| `CLUSTER MYSHARDID` | |
| `CLUSTER NODES` | |
| `CLUSTER REPLICAS` | |
| `CLUSTER REPLICATE` | |
| `CLUSTER RESET` | |
| `CLUSTER SAVECONFIG` | |
| `CLUSTER SET-CONFIG-EPOCH` | |
| `CLUSTER SETSLOT` | |
| `CLUSTER SHARDS` | |
| `CLUSTER SLAVES` | |
| `CLUSTER SLOT-STATS` | |
| `CLUSTER SLOTS` | |
| `CLUSTER SYNCSLOTS` | |
| `CLUSTERSCAN` | |
| `READONLY` | |
| `READWRITE` | |
| `CLIENT CACHING` | |
| `CLIENT CAPA` | |
| `CLIENT GETREDIR` | |
| `CLIENT IMPORT-SOURCE` | |
| `CLIENT NO-EVICT` | |
| `CLIENT NO-TOUCH` | |
| `CLIENT PAUSE` | |
| `CLIENT REPLY` | |
| `CLIENT SETINFO` | |
| `CLIENT TRACKING` | |
| `CLIENT TRACKINGINFO` | |
| `CLIENT UNBLOCK` | |
| `CLIENT UNPAUSE` | |
| `QUIT` | |
| `SELECT` | |
| `MIGRATE` | |
| `MOVE` | |
| `WAIT` | |
| `WAITAOF` | |
| `PFDEBUG` | |
| `PFSELFTEST` | |
| `XSETID` | |
| `FUNCTION DUMP` | |
| `FUNCTION RESTORE` | |
| `SCRIPT DEBUG` | |
| `ACL DELUSER` | |
| `ACL GENPASS` | |
| `ACL LOAD` | |
| `ACL LOG` | |
| `ACL SAVE` | |
| `ACL SETUSER` | |
| `BGREWRITEAOF` | |
| `BGSAVE` | |
| `CONFIG GET` | |
| `CONFIG HELP` | |
| `CONFIG RESETSTAT` | |
| `CONFIG REWRITE` | |
| `CONFIG SET` | |
| `FAILOVER` | |
| `LASTSAVE` | |
| `LATENCY DOCTOR` | |
| `LATENCY GRAPH` | |
| `LATENCY HELP` | |
| `LATENCY HISTOGRAM` | |
| `LATENCY HISTORY` | |
| `LATENCY LATEST` | |
| `LATENCY RESET` | |
| `MEMORY DOCTOR` | |
| `MEMORY HELP` | |
| `MEMORY MALLOC-STATS` | |
| `MEMORY PURGE` | |
| `MEMORY STATS` | |
| `MODULE HELP` | |
| `MODULE LOAD` | |
| `MODULE LOADEX` | |
| `MODULE UNLOAD` | |
| `PSYNC` | |
| `REPLCONF` | |
| `REPLICAOF` | |
| `RESTORE-ASKING` | |
| `ROLE` | |
| `SAVE` | |
| `SHUTDOWN` | |
| `SLAVEOF` | |
| `SWAPDB` | |
| `SYNC` | |
| `BF.LOAD` | |
| `JSON.DEBUG` | |
