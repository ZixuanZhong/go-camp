# usage

```cmd
echo -e "\x00\x00\x00\x12\x00\x10\x00\x01\x00\x00\x00\x02\x00\x00\x00\x03\xff\xff" | nc 127.0.0.1 8080
```

```txt
hdr: pckLen=18, hdrLen=16, proto=1, op=2, seq=3; body: [255 255]
```