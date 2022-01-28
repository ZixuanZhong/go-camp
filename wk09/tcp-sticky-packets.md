# 粘包的解包方式

## fix length

### 总结

发送者和接受者约定好单个 TCP 包长度，比如1024个字节大小。发送者在发送 TCP 数据包的时候，每个包都固定 1024 字节，如果客户端发送的数据长度不足1024个字节，则通过补充 NULL 字节 `0x00` 的方式补全到指定长度。

### 应用

Golang 中可以固定buffer大小进行io的读取。

HTTP 中的Content-Length就起了类似的作用，当接收端收到的消息长度小于 Content-Length 时，说明还有些消息没收到。那接收端会一直等，直到拿够了消息或超时。

## delimiter based

### 总结

发送者在每个包的末尾使用固定的分隔符，例如\r\n，如果一个包被拆分了，接受者等待下一个包发送过来之后找到其中的\r\n，然后对其拆分后的头部部分与前一个包的剩余部分进行合并，这样就得到了一个完整的包。

### 应用

Golang 中，我们可以自定义一种特殊标记，比如 `0xfffffe`作为 TCP 包结束的 delimiter。

HTTP 协议里当使用 chunked 编码 传输时，使用若干个 chunk 组成消息，最后由一个标明长度为 0 的 chunk 结束。

## length field based frame decoder

类似于使用一个比 TCP 更高层的私有协议。将单个 TCP 包的 body 分为头部和消息体，在头部中保存有当前整个消息的长度，只有在读取到足够长度的消息之后才算是读到了一个完整的消息。

### 应用

```txt
 BEFORE DECODE (14 bytes)         AFTER DECODE (12 bytes)
 +--------+----------------+      +----------------+
 | Length | Actual Content |----->| Actual Content |
 | 0x000C | "HELLO, WORLD" |      | "HELLO, WORLD" |
 +--------+----------------+      +----------------+
```

如上图所示，每个 TCP body的前两个字节，存储此 body 实际消息长度，接受者解析时，先解析长度信息，再根据长度判断 TCP 包在哪里结束。

实际上，任何基于 TCP 之上的协议，比如 HTTP、FTP，SMTP等，只要包含header和body，都利用了这种类似的思想。

