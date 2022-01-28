package main

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"log"
	"net"
)

const (
	PackageLengthOffset   = 0
	PackageLength         = 4
	HeaderLengthOffset    = PackageLengthOffset + PackageLength
	HeaderLength          = 2
	ProtocolVersionOffset = HeaderLengthOffset + HeaderLength
	ProtocolVersion       = 2
	OperationOffset       = ProtocolVersionOffset + ProtocolVersion
	Operation             = 4
	SequenceIDOffset      = OperationOffset + Operation
	SequenceID            = 4
	BodyOffset            = SequenceIDOffset + SequenceID
)

type GOIMPacketHeader struct {
	PackageLength   uint32
	HeaderLength    uint16
	ProtocolVersion uint16
	Operation       uint32
	SequenceID      uint32
}

type GOIMPacket struct {
	Header GOIMPacketHeader
	Body   []byte
}

// Read message from a net.Conn
func Read(conn net.Conn) ([]byte, error) {
	reader := bufio.NewReader(conn)
	var buffer bytes.Buffer
	for {
		ba, isPrefix, err := reader.ReadLine()
		if err != nil {
			// if the error is an End Of File this is still good
			if err == io.EOF {
				break
			}
			return nil, err
		}
		buffer.Write(ba)
		if !isPrefix {
			break
		}
	}
	return buffer.Bytes(), nil
}

// Write message to a net.Conn
// Return the number of bytes returned
func Write(conn net.Conn, encoded string) (int, error) {
	writer := bufio.NewWriter(conn)
	number, err := writer.WriteString(encoded)
	if err == nil {
		err = writer.Flush()
	}
	return number, err
}

func GOIMPacketDecode(content []byte) (*GOIMPacket, error) {
	if len(content) < BodyOffset {
		return nil, errors.New("invalid goim packet: incomplete header")
	}

	header := GOIMPacketHeader{
		PackageLength:   BytesToUint32(content[PackageLengthOffset : PackageLengthOffset+PackageLength]),
		HeaderLength:    BytesToUint16(content[HeaderLengthOffset : HeaderLengthOffset+HeaderLength]),
		ProtocolVersion: BytesToUint16(content[ProtocolVersionOffset : ProtocolVersionOffset+ProtocolVersion]),
		Operation:       BytesToUint32(content[OperationOffset : OperationOffset+Operation]),
		SequenceID:      BytesToUint32(content[SequenceIDOffset : SequenceIDOffset+SequenceID]),
	}

	// fmt.Printf("header: %v\n", header)
	bodyLength := int(header.PackageLength) - int(header.HeaderLength)
	// fmt.Printf("body len: %d\n", bodyLength)
	if len(content) < BodyOffset+bodyLength {
		return nil, errors.New("invalid goim packet: incomplete body")
	}

	body := content[BodyOffset : BodyOffset+bodyLength]

	return &GOIMPacket{
		Header: header,
		Body:   body,
	}, nil
}

func handle(conn net.Conn) {
	defer conn.Close()
	// log.Printf("Now listnen: %s \n", conn.RemoteAddr().String())
	content, err := Read(conn)
	if err != nil {
		log.Printf("Listener: Read error: %s", err)
		return
	}
	// fmt.Printf("content: %v \n", content)
	var packet *GOIMPacket
	packet, err = GOIMPacketDecode(content)
	if err != nil {
		log.Printf("Listener: Decode GOIMPacket error: %s", err)
		return
	}
	log.Printf("Listener: Received packet: %v\n", packet)
	response := fmt.Sprintf("hdr: pckLen=%d, hdrLen=%d, proto=%d, op=%d, seq=%d; body: %v \n", packet.Header.PackageLength, packet.Header.HeaderLength, packet.Header.ProtocolVersion, packet.Header.Operation, packet.Header.SequenceID, packet.Body)
	log.Printf("Listener: Response: %s\n", response)
	_, err = Write(conn, response)
	if err != nil {
		log.Printf("Listener: Write Error: %s\n", err)
		return
	}
	// log.Printf("Listener: Wrote %d byte(s) to %s \n", num, conn.RemoteAddr().String())
}

func BytesToUint32(n []byte) uint32 {

	bytesbuffer := bytes.NewBuffer(n)
	var x uint32
	binary.Read(bytesbuffer, binary.BigEndian, &x)
	return x
}

func BytesToUint16(n []byte) uint16 {
	bytesbuffer := bytes.NewBuffer(n)
	var x uint16
	binary.Read(bytesbuffer, binary.BigEndian, &x)
	return x
}

func main() {
	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		// Use fatal to exit if the listener fails to start
		log.Fatal(err)
	}
	defer listener.Close()

	for {
		conn, err := listener.Accept()
		if err != nil {
			// Print the error using a log.Fatal would exit the server
			log.Println(err)
		}
		// Using a go routine to handle the connection
		go handle(conn)
	}
}
