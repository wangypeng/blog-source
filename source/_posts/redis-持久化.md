---
title: redis-持久化
date: 2018-11-13 16:14:31
type: "categories"
categories: redis
tags: redis
---

![](img/index-page-img/redis.jpg)

redis两种持久化的方式，**rdb**(redis database)和**aof**(append of only)

<!-- more -->

### 介绍

redis 是一个键值对存储数据库,基于内存存储,相对于传统基于磁盘做持久化的数据库,操作内存速度更快。所以也用来做缓存服务器。相对于memcache,redis提供了持久化的解决方案，数据安全性更高。
redis提供的两种持久化方案，一个rdb(redis database)，一个是aof(append of only),本文将详细介绍这两种持久化。

### SNAPSHOTTING rdb(redis database)

#### 介绍

rdb就是将redis内存中的数据做一个**快照**，经过**压缩**，以**二进制**文件的形式，保存到磁盘中。

默认情况下，Redis以**异步方式**将数据集转储到磁盘上

#### 相关命令

* SAVE：阻塞redis的服务器进程，直到RDB文件被创建完毕。
* BGSAVE：派生(fork)一个子进程来创建新的RDB文件，记录接收到BGSAVE当时的数据库状态，父进程继续处理接收到的命令，子进程完成文件的创建之后，会发送信号给父进程，而与此同时，父进程处理命令的同时，通过轮询来接收子进程的信号。

#### 恢复

在redis启动的时候，会检查是否rdb的二进制文件。有二进制文件，直接将文件拉取到内存中。恢复速度很快。

#### 配置

{% codeblock %}
################################ SNAPSHOTTING  ################################
#
# Save the DB on disk:
#
#   save <seconds> <changes>
#
#   Will save the DB if both the given number of seconds and the given
#   number of write operations against the DB occurred.
#
#   如果同时发生了给定的秒数和针对DB的给定写入操作数，则将保存数据库。
#
#   In the example below the behaviour will be to save:
#   after 900 sec (15 min) if at least 1 key changed
#   after 300 sec (5 min) if at least 10 keys changed
#   after 60 sec if at least 10000 keys changed
#
#   在下面的示例中，行为将是保存：
#           900秒后（15分钟）1个key改变
#           300秒后 (5分钟) 10个key改变
#           60秒后 10000 个key改变
#           
#
#   Note: you can disable saving completely by commenting out all "save" lines.
#
#   注意：您可以通过注释掉所有“保存”行来完全禁用保存。
#
#   It is also possible to remove all the previously configured save
#   points by adding a save directive with a single empty string argument
#   like in the following example:
#
#   save ""
#
#   也可以通过添加带有单个空字符串参数的save指令来删除所有先前配置的保存点

save 900 1
save 300 10
save 60 10000

# By default Redis will stop accepting writes if RDB snapshots are enabled
# (at least one save point) and the latest background save failed.
# This will make the user aware (in a hard way) that data is not persisting
# on disk properly, otherwise chances are that no one will notice and some
# disaster will happen.
#
# 默认情况下，如果启用了RDB快照（至少一个保存点）并且最新的后台保存失败，Redis将停止接受写入。
# 这将使用户意识到（以一种困难的方式）数据没有正确地保存在磁盘上，
# 否则很可能没有人会注意到并且会发生一些灾难。
#
# If the background saving process will start working again Redis will
# automatically allow writes again.
#
# 如果后台保存过程将再次开始工作，Redis将自动再次允许写入。
#
# However if you have setup your proper monitoring of the Redis server
# and persistence, you may want to disable this feature so that Redis will
# continue to work as usual even if there are problems with disk,
# permissions, and so forth.
#
# 但是，如果您已设置对Redis服务器和持久性的正确监视，则可能需要禁用此功能
# 以便即使磁盘，权限等存在问题，Redis也将继续正常工作。

stop-writes-on-bgsave-error yes

# Compress string objects using LZF when dump .rdb databases?
# For default that's set to 'yes' as it's almost always a win.
# If you want to save some CPU in the saving child set it to 'no' but
# the dataset will likely be bigger if you have compressible values or keys.
#
# 当备份.rdb数据库时使用LZF压缩字符串对象？默认设置为“是”，因为它几乎总是一个胜利。
# 如果要在保存子项中保存一些CPU，请将其设置为“否”，但如果您具有可压缩值或键，则数据集可能会更大。

rdbcompression yes

# Since version 5 of RDB a CRC64 checksum is placed at the end of the file.
# This makes the format more resistant to corruption but there is a performance
# hit to pay (around 10%) when saving and loading RDB files, so you can disable it
# for maximum performances.
#
# 从RDB的第5版开始，CRC64校验和被放置在文件的末尾。这使得格式更能抵抗损坏，
# 但在保存和加载RDB文件时需要支付性能（大约10％），因此您可以禁用它以获得最佳性能。
#
# RDB files created with checksum disabled have a checksum of zero that will
# tell the loading code to skip the check.
#
# 禁用校验和创建的RDB文件的校验和为零，将告诉加载代码跳过检查。

rdbchecksum yes

# The filename where to dump the DB
#
#rdb dump 文件名

dbfilename dump.rdb

# The working directory.
#
# The DB will be written inside this directory, with the filename specified
# above using the 'dbfilename' configuration directive.
#
# The Append Only File will also be created inside this directory.
#
# Note that you must specify a directory here, not a file name.
#
# 文件位置

dir ./
{% endcodeblock %}



### APPEND ONLY MODE aof(append of only)

#### 介绍


如果rdb过程中，机器出了问题，可能会丢失几分钟的数据。

aof功能类似于日志，会对每一条记录做记录，三种持久化的方案：

* 每条记录都记录，但是会占用大量io，会把服务器拖慢
* 每秒钟的数据写入磁盘，将一秒钟的数据写入磁盘，可能会丢失一秒钟的数据（官方默认的方案）
* 不写入，只有命令执行的时候，才写入，会有很好的性能，但是丢失数据的风险非常大。

aof每条都记录，随着一直写入request，会导致aof文件会越来越大，并且在恢复的时候，每条都会执行
可以使用aof重写，可以多条记录逆为一条命令，减小文件大小

例子：
{% codeblock %}
// 重写前
set wang 100
incr wang   
incr wnag

// 重写后,逆为key最后的状态值
set wang 102bg

{% endcodeblock %}

#### 相关命令

* bgrewriteao：重写aof文件

#### 恢复

在开启aof持久化的时候，会监测是否有aof文件，优先加载aof文件，然后在监测rdb文件。

重写后的aof文件更便于恢复，不用每条都写入，直接写入最后的状态值。

#### 配置

{% codeblock %}
############################## APPEND ONLY MODE ###############################
#
# By default Redis asynchronously dumps the dataset on disk. This mode is
# good enough in many applications, but an issue with the Redis process or
# a power outage may result into a few minutes of writes lost (depending on
# the configured save points).
#
# 默认情况下，Redis以异步方式将数据集转储到磁盘上。
# 此模式在许多应用程序中都足够好，
# 但Redis进程或停电的问题可能导致几分钟的写入丢失（取决于配置的保存点）。
#
# The Append Only File is an alternative persistence mode that provides
# much better durability. For instance using the default data fsync policy
# (see later in the config file) Redis can lose just one second of writes in a
# dramatic event like a server power outage, or a single write if something
# wrong with the Redis process itself happens, but the operating system is
# still running correctly.
#
# 仅附加文件是一种备用持久性模式，可提供更好的持久性。
# 例如，使用默认数据fsync策略（请参阅配置文件中的后面部分）
# Redis在服务器断电等戏剧性事件中只会丢失一秒写入，
# 如果Redis进程本身出现问题，则会丢失一次，但是操作系统仍然正常运行。
#
# AOF and RDB persistence can be enabled at the same time without problems.
# If the AOF is enabled on startup Redis will load the AOF, that is the file
# with the better durability guarantees.
#
# 可以同时启用AOF和RDB持久性而不会出现问题。
# 如果在启动时启用AOF，Redis将加载AOF，即具有更好耐久性保证的文件。
#
# Please check http://redis.io/topics/persistence for more information.

appendonly no

# The name of the append only file (default: "appendonly.aof")

appendfilename "appendonly.aof"

# The fsync() call tells the Operating System to actually write data on disk
# instead of waiting for more data in the output buffer. Some OS will really flush
# data on disk, some other OS will just try to do it ASAP.
#
# aof调用告诉操作系统实际在磁盘上写入数据，
# 而不是等待输出缓冲区中的更多数据。
# 某些操作系统会真正刷新磁盘上的数据，其他一些操作系统会尽快尝试这样做。
#
# Redis supports three different modes:
#
# no: don't fsync, just let the OS flush the data when it wants. Faster.
# always: fsync after every write to the append only log. Slow, Safest.
# everysec: fsync only one time every second. Compromise.
#
# no：不要fsync，只需让操作系统在需要时刷新数据。
# 快点。始终：每次写入仅附加日志后的fsync。慢，最安全。
#  everysec：fsync每秒只有一次。妥协。
#
# The default is "everysec", as that's usually the right compromise between
# speed and data safety. It's up to you to understand if you can relax this to
# "no" that will let the operating system flush the output buffer when
# it wants, for better performances (but if you can live with the idea of
# some data loss consider the default persistence mode that's snapshotting),
# or on the contrary, use "always" that's very slow but a bit safer than
# everysec.
#
# 默认值为“everysec”，因为这通常是速度和数据安全之间的正确折衷。
# 这取决于你是否可以理解你是否可以放松这个“不”，
# 让操作系统在需要时刷新输出缓冲区，以获得更好的性能
# （但如果你能想到一些数据丢失的想法，请考虑默认的持久性模式这是快照），
# 或相反，使用“总是”，这是非常慢但比每秒更安全。
#
# More details please check the following article:
# http://antirez.com/post/redis-persistence-demystified.html
#
# If unsure, use "everysec".

# appendfsync always
appendfsync everysec
# appendfsync no

# When the AOF fsync policy is set to always or everysec, and a background
# saving process (a background save or AOF log background rewriting) is
# performing a lot of I/O against the disk, in some Linux configurations
# Redis may block too long on the fsync() call. Note that there is no fix for
# this currently, as even performing fsync in a different thread will block
# our synchronous write(2) call.
#
# 当AOF fsync策略设置为always或everysec，
# 并且后台保存过程（后台保存或AOF日志后台重写）
# 正在对磁盘执行大量I / O时，在某些Linux配置中，
# Redis可能会阻塞太长时间fsync（）调用。
# 请注意，目前没有对此进行修复，
# 因为即使在不同的线程中执行fsync也会阻止我们的同步write（2）调用。
#
# In order to mitigate this problem it's possible to use the following option
# that will prevent fsync() from being called in the main process while a
# BGSAVE or BGREWRITEAOF is in progress.
#
# 为了缓解此问题，可以使用以下选项，
# 以防止在BGSAVE或BGREWRITEAOF正在进行时在主进程中调用fsync（）。
#
# This means that while another child is saving, the durability of Redis is
# the same as "appendfsync none". In practical terms, this means that it is
# possible to lose up to 30 seconds of log in the worst scenario (with the
# default Linux settings).
#
# 这意味着当另一个孩子正在保存时，Redis的持久性与“appendfsync none”相同。
# 实际上，这意味着在最糟糕的情况下（使用默认的Linux设置）可能会丢失最多30秒的日志。
#
# If you have latency problems turn this to "yes". Otherwise leave it as
# "no" that is the safest pick from the point of view of durability.
#
# 如果您有延迟问题，请将其转为“是”。否则，从耐用性的角度来看，它是最“最安全”的选择。

no-appendfsync-on-rewrite no

# Automatic rewrite of the append only file.
# Redis is able to automatically rewrite the log file implicitly calling
# BGREWRITEAOF when the AOF log size grows by the specified percentage.
#
# 自动重写仅附加文件。当AOF日志大小增长指定的百分比时，
# Redis能够自动重写日志文件，隐式调用BGREWRITEAOF。
#
# This is how it works: Redis remembers the size of the AOF file after the
# latest rewrite (if no rewrite has happened since the restart, the size of
# the AOF at startup is used).
#
# 这是它的工作原理：Redis在最近的重写后记住AOF文件的大小
# （如果重启后没有重写，则使用启动时的AOF大小）。
#
# This base size is compared to the current size. If the current size is
# bigger than the specified percentage, the rewrite is triggered. Also
# you need to specify a minimal size for the AOF file to be rewritten, this
# is useful to avoid rewriting the AOF file even if the percentage increase
# is reached but it is still pretty small.
#
# 将此基本大小与当前大小进行比较。如果当前大小大于指定的百分比，则触发重写。
# 此外，您需要指定要重写的AOF文件的最小大小，
# 这有助于避免重写AOF文件，即使达到百分比增加但仍然非常小。
#
# Specify a percentage of zero in order to disable the automatic AOF
# rewrite feature.
#
# 指定零的百分比以禁用自动AOF重写功能。

auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# An AOF file may be found to be truncated at the end during the Redis
# startup process, when the AOF data gets loaded back into memory.
# This may happen when the system where Redis is running
# crashes, especially when an ext4 filesystem is mounted without the
# data=ordered option (however this can't happen when Redis itself
# crashes or aborts but the operating system still works correctly).
#
# 当AOF数据加载回内存时，可能会在Redis启动过程中发现AOF文件被截断。
# 当Redis运行崩溃的系统时，尤其是在没有data = ordered选项的情况下挂载ext4文件系统时，
# 可能会发生这种情况（但是当Redis本身崩溃或中止但操作系统仍能正常工作时，这种情况不会发生）。
#
# Redis can either exit with an error when this happens, or load as much
# data as possible (the default now) and start if the AOF file is found
# to be truncated at the end. The following option controls this behavior.
#
# 发生这种情况时，Redis可以退出，或者加载尽可能多的数据（现在是默认值），
# 如果发现AOF文件在末尾被截断，则启动。以下选项控制此行为。
#
# If aof-load-truncated is set to yes, a truncated AOF file is loaded and
# the Redis server starts emitting a log to inform the user of the event.
# Otherwise if the option is set to no, the server aborts with an error
# and refuses to start. When the option is set to no, the user requires
# to fix the AOF file using the "redis-check-aof" utility before to restart
# the server.
#
# 如果将aof-load-truncated设置为yes，则会加载截断的AOF文件，
# 并且Redis服务器会开始发出日志以通知用户该事件。
# 否则，如果该选项设置为no，则服务器将中止并显示错误并拒绝启动。
# 当该选项设置为no时，用户需要使用“redis-check-aof”实用程序修复AOF文件，
# 然后才能重新启动服务器。
#
# Note that if the AOF file will be found to be corrupted in the middle
# the server will still exit with an error. This option only applies when
# Redis will try to read more data from the AOF file but not enough bytes
# will be found.
#
# 请注意，如果发现AOF文件在中间被破坏，服务器仍将退出并显示错误。
# 此选项仅在Redis尝试从AOF文件中读取更多数据但不会找到足够的字节时适用。

aof-load-truncated yes

# When rewriting the AOF file, Redis is able to use an RDB preamble in the
# AOF file for faster rewrites and recoveries. When this option is turned
# on the rewritten AOF file is composed of two different stanzas:
#
# 重写AOF文件时，Redis能够使用AOF文件中的RDB前导码来加快重写和恢复速度。
# 启用此选项后，重写的AOF文件由两个不同的节组成：
#
#   [RDB file][AOF tail]
#
# When loading Redis recognizes that the AOF file starts with the "REDIS"
# string and loads the prefixed RDB file, and continues loading the AOF
# tail.
#
# 加载时Redis识别出AOF文件以“REDIS”字符串开头并加载前缀RDB文件，并继续加载AOF尾部。

aof-use-rdb-preamble yes
{% endcodeblock %}



